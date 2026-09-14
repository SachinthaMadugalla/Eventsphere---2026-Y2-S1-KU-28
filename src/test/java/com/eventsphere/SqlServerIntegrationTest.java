package com.eventsphere;

import com.eventsphere.dao.*;
import com.eventsphere.service.*;
import com.eventsphere.model.*;
import com.eventsphere.dto.RegistrationDTO;
import javax.sql.DataSource;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import static org.junit.jupiter.api.Assertions.*;

/** Explicit opt-in: runs against the configured real SQL Server, never substitutes H2. */
@EnabledIfEnvironmentVariable(named = "EVENTSPHERE_SQLSERVER_TEST", matches = "true")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)
@ActiveProfiles("sqlserver")
class SqlServerIntegrationTest {
    @Autowired DataSource dataSource;
    @Autowired org.springframework.context.ApplicationContext context;
    @Autowired AuthService auth;
    @Autowired CustomerService customers;
    @Autowired EventService events;
    @Autowired ResourceService resources;
    @Autowired VenueService venues;
    @Autowired VendorService vendors;
    @Autowired StaffService staff;
    @Autowired FinanceService finance;
    @Autowired AdminService admin;

    @Test void databaseAndDaoQueriesUseSqlServer() throws Exception {
        try (var connection = dataSource.getConnection()) {
            assertEquals("Microsoft SQL Server", connection.getMetaData().getDatabaseProductName());
            com.eventsphere.config.SqlServerSetup.verifySchema(connection);
        }
        for (Class<?> dao : new Class<?>[]{UserDAO.class, CustomerDAO.class, EventDAO.class,
                VenueDAO.class, VendorDAO.class, StaffDAO.class, ResourceDAO.class, TaskDAO.class,
                BudgetDAO.class, ExpenseDAO.class, InvoiceDAO.class, PaymentDAO.class,
                FeedbackDAO.class, ComplaintDAO.class, ActivityLogDAO.class}) {
            assertNotNull(dao.getMethod("findAll").invoke(context.getBean(dao)), dao.getSimpleName());
        }
        assertNotNull(context.getBean(com.eventsphere.service.DashboardService.class).getStats());
    }

    @Test @Transactional void registrationWritesAndReadsThroughJdbcOnSqlServer() {
        String unique = "sqltest_" + java.util.UUID.randomUUID().toString().substring(0, 8);
        RegistrationDTO dto = new RegistrationDTO();
        dto.setUsername(unique); dto.setEmail(unique + "@example.invalid"); dto.setFullName("SQL Server integration test");
        dto.setPassword("temporary-test-password"); dto.setConfirmPassword("temporary-test-password");
        assertNull(auth.registerCustomer(dto));
        var user = auth.login(unique, "temporary-test-password");
        assertNotNull(user);
        assertTrue(customers.getCustomerByUserId(user.getUserId()).isPresent());
        // Spring rolls back this test's user, customer and notification records.
    }

    @Test @Transactional void crudRoundTripUsesSqlServerAndPreservesHistory() {
        String unique = "crud_" + java.util.UUID.randomUUID().toString().substring(0, 8);
        RegistrationDTO dto = new RegistrationDTO();
        dto.setUsername(unique); dto.setEmail(unique + "@example.invalid"); dto.setFullName("CRUD integration test");
        dto.setPassword("temporary-test-password"); dto.setConfirmPassword("temporary-test-password");
        assertNull(auth.registerCustomer(dto));
        var user = auth.login(unique, "temporary-test-password");
        int customerId = customers.getCustomerByUserId(user.getUserId()).orElseThrow().getCustomerId();
        admin.setUserActiveStatus(user.getUserId(), false);
        assertFalse(admin.getUserById(user.getUserId()).orElseThrow().isActive());
        admin.setUserActiveStatus(user.getUserId(), true);

        Event event = new Event();
        event.setCustomerId(customerId); event.setCategoryId(1); event.setEventName("CRUD event");
        event.setEventDate(java.time.LocalDate.now().plusDays(45)); event.setGuestCount(10);
        assertNull(events.createEvent(event));
        int eventId = events.getEventsByCustomerId(customerId).stream()
                .filter(e -> "CRUD event".equals(e.getEventName())).findFirst().orElseThrow().getEventId();
        event = events.getEventById(eventId).orElseThrow();
        event.setEventName("CRUD event updated");
        assertNull(events.updateEvent(event));
        events.updateStatus(eventId, "Completed");
        assertNull(events.setArchived(eventId, true));
        assertTrue(events.getArchivedEvents().stream().anyMatch(e -> e.getEventId() == eventId));
        assertNull(events.setArchived(eventId, false));

        Resource resource = new Resource(); resource.setResourceName("CRUD resource"); resource.setTotalQuantity(4);
        assertNull(resources.addResource(resource));
        int resourceId = resources.getAllResources().stream().filter(r -> "CRUD resource".equals(r.getResourceName())).findFirst().orElseThrow().getResourceId();
        resource = resources.getResourceById(resourceId).orElseThrow(); resource.setTotalQuantity(6);
        assertNull(resources.updateResource(resource)); resources.setActiveStatus(resourceId, false);
        assertFalse(resources.getResourceById(resourceId).orElseThrow().isActive()); resources.deleteResource(resourceId);

        Venue venue = new Venue(); venue.setVenueName("CRUD venue"); venue.setLocation("Test location"); venue.setCapacity(20); venue.setCostPerDay(new java.math.BigDecimal("10"));
        assertNull(venues.addVenue(venue));
        int venueId = venues.getAllVenues().stream().filter(v -> "CRUD venue".equals(v.getVenueName())).findFirst().orElseThrow().getVenueId();
        venue = venues.getVenueById(venueId).orElseThrow(); venue.setCapacity(25); assertNull(venues.updateVenue(venue));
        venues.setActiveStatus(venueId, false); assertFalse(venues.getVenueById(venueId).orElseThrow().isActive()); venues.deleteVenue(venueId);

        Vendor vendor = new Vendor(); vendor.setVendorName("CRUD vendor"); vendor.setVendorCatId(1); vendor.setCost(new java.math.BigDecimal("10"));
        assertNull(vendors.addVendor(vendor));
        int vendorId = vendors.getAllVendors().stream().filter(v -> "CRUD vendor".equals(v.getVendorName())).findFirst().orElseThrow().getVendorId();
        vendor = vendors.getVendorById(vendorId).orElseThrow(); vendor.setCost(new java.math.BigDecimal("12")); assertNull(vendors.updateVendor(vendor));
        vendors.setActiveStatus(vendorId, false); assertFalse(vendors.getVendorById(vendorId).orElseThrow().isActive()); vendors.deleteVendor(vendorId);

        Staff member = new Staff(); member.setFullName("CRUD staff"); member.setJobRole("Tester");
        assertNull(staff.addStaff(member));
        int staffId = staff.getAllStaff().stream().filter(s -> "CRUD staff".equals(s.getFullName())).findFirst().orElseThrow().getStaffId();
        member = staff.getStaffById(staffId).orElseThrow(); member.setJobRole("Senior Tester"); assertNull(staff.updateStaff(member));
        staff.setActiveStatus(staffId, false); assertFalse(staff.getStaffById(staffId).orElseThrow().isActive()); staff.deleteStaff(staffId);

        Invoice invoice = new Invoice(); invoice.setEventId(eventId); invoice.setCustomerId(customerId); invoice.setTotalAmount(new java.math.BigDecimal("100"));
        assertNull(finance.createInvoice(invoice));
        int invoiceId = finance.getInvoicesByEvent(eventId).stream().filter(i -> i.getCustomerId() == customerId).findFirst().orElseThrow().getInvoiceId();
        invoice = finance.getInvoiceById(invoiceId).orElseThrow(); invoice.setTotalAmount(new java.math.BigDecimal("120"));
        assertNull(finance.updateInvoice(invoice)); finance.deleteInvoice(invoiceId);
        events.deleteEvent(eventId);
    }
}
