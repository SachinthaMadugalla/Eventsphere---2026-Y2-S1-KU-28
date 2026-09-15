package com.eventsphere;

import com.eventsphere.service.LoyaltyService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import static org.junit.jupiter.api.Assertions.*;

class LoyaltyServiceTest {
    JdbcTemplate jdbc;
    LoyaltyService loyalty;
    @BeforeEach void setup() {
        jdbc = new JdbcTemplate(new DriverManagerDataSource("jdbc:h2:mem:" + java.util.UUID.randomUUID() + ";MODE=MSSQLServer;DB_CLOSE_DELAY=-1", "sa", ""));
        jdbc.execute("CREATE TABLE customers(customer_id INT, full_name VARCHAR(100))");
        jdbc.execute("CREATE TABLE events(event_id INT, customer_id INT, event_name VARCHAR(100), event_date DATE, status VARCHAR(30), is_archived BIT)");
        jdbc.execute("CREATE TABLE invoices(invoice_id INT, event_id INT, customer_id INT, total_amount DECIMAL(12,2))");
        jdbc.execute("CREATE TABLE payments(invoice_id INT, customer_id INT, event_id INT, amount DECIMAL(12,2))");
        jdbc.update("INSERT INTO customers VALUES(1,'Customer One'),(2,'Customer Two')");
        loyalty = new LoyaltyService(jdbc);
    }
    void event(int id, String status) {
        jdbc.update("INSERT INTO events VALUES(?,1,'Celebration',CURRENT_DATE,?,0)", id, status);
        jdbc.update("INSERT INTO invoices VALUES(?,?,1,1000)", id, id);
    }
    void pay(int id, int amount) { jdbc.update("INSERT INTO payments VALUES(?,1,?,?)", id,id,amount); }
    @Test void newCustomerStartsRegularWithZeroPoints() {
        assertEquals(0, loyalty.customers().get(0).getPoints());
        assertEquals("Regular Customer", loyalty.customers().get(0).getStatus());
        assertTrue(loyalty.history(1).isEmpty());
    }
    @Test void onlyCompletedAndFullyPaidEventsQualify() {
        event(1,"Completed"); pay(1,999);
        event(2,"Cancelled"); pay(2,1000);
        event(3,"Confirmed"); pay(3,1000);
        event(4,"Completed"); pay(4,1000);
        jdbc.update("INSERT INTO events VALUES(5,1,'No invoice',CURRENT_DATE,'Completed',0)");
        assertEquals(1,loyalty.history(1).size());
        assertEquals(4,loyalty.history(1).get(0).getEventId());
        assertTrue(loyalty.history(2).isEmpty());
    }
    @Test void thresholdArchiveAndRepeatedReadsAreStable() {
        for(int i=1;i<=3;i++){event(i,"Completed");pay(i,500);pay(i,500);}
        jdbc.update("UPDATE events SET is_archived=1 WHERE event_id=1");
        assertEquals(300,loyalty.customers().get(0).getPoints());
        assertEquals(300,loyalty.customers().get(0).getPoints());
        assertEquals("Loyal Customer",loyalty.customers().get(0).getStatus());
        assertEquals(0,loyalty.customers().get(0).getRemaining());
        jdbc.update("DELETE FROM payments WHERE event_id=1");
        assertEquals(200,loyalty.customers().get(0).getPoints());
        assertEquals("Regular Customer",loyalty.customers().get(0).getStatus());
    }
    @Test void everyInvoiceMustBePaidAndEventCountsOnlyOnce() {
        event(1,"Completed");pay(1,1000);
        jdbc.update("INSERT INTO invoices VALUES(2,1,1,500)");
        assertTrue(loyalty.history(1).isEmpty());
        jdbc.update("INSERT INTO payments VALUES(2,1,1,500)");
        assertEquals(100,loyalty.customers().get(0).getPoints());
        jdbc.update("UPDATE events SET status='Cancelled'");
        assertTrue(loyalty.history(1).isEmpty());
    }
}
