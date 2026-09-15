package com.eventsphere.service;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class LoyaltyService {
    public static final int POINTS_PER_EVENT = 100;
    public static final int LOYAL_THRESHOLD = 300;
    private final JdbcTemplate jdbc;
    public LoyaltyService(JdbcTemplate jdbc) { this.jdbc = jdbc; }
    public record Entry(int eventId, String eventName, java.time.LocalDate eventDate, int points) {
        public int getEventId() { return eventId; }
        public String getEventName() { return eventName; }
        public java.time.LocalDate getEventDate() { return eventDate; }
        public int getPoints() { return points; }
    }
    public record Summary(int customerId, String fullName, int points) {
        public int getCustomerId() { return customerId; }
        public String getFullName() { return fullName; }
        public int getPoints() { return points; }
        public String getStatus() { return points >= LOYAL_THRESHOLD ? "Loyal Customer" : "Regular Customer"; }
        public int getRemaining() { return Math.max(0, LOYAL_THRESHOLD - points); }
    }
    private static final String ELIGIBLE = """
        e.status = 'Completed'
        AND EXISTS (SELECT 1 FROM invoices i WHERE i.event_id = e.event_id)
        AND NOT EXISTS (
            SELECT 1 FROM invoices i WHERE i.event_id = e.event_id
            AND (i.customer_id <> e.customer_id OR i.total_amount <= 0 OR
                 COALESCE((SELECT SUM(p.amount) FROM payments p WHERE p.invoice_id = i.invoice_id
                    AND p.customer_id = e.customer_id AND p.event_id = e.event_id), 0) < i.total_amount)
        )
        """;
    public List<Entry> history(int customerId) {
        return jdbc.query("SELECT e.event_id, e.event_name, e.event_date FROM events e WHERE e.customer_id = ? AND "
            + ELIGIBLE + " ORDER BY e.event_date DESC, e.event_id DESC",
            (rs, n) -> new Entry(rs.getInt(1), rs.getString(2), rs.getDate(3).toLocalDate(), POINTS_PER_EVENT), customerId);
    }

    public List<Summary> customers() {
        return jdbc.query("SELECT c.customer_id, c.full_name, (SELECT COUNT(*) FROM events e WHERE e.customer_id=c.customer_id AND "
            + ELIGIBLE + ") AS qualifying FROM customers c ORDER BY c.full_name",
            (rs, n) -> new Summary(rs.getInt(1), rs.getString(2), rs.getInt(3) * POINTS_PER_EVENT));
    }
}
