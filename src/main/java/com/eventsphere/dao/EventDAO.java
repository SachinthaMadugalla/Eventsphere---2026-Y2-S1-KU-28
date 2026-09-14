package com.eventsphere.dao;

import com.eventsphere.model.Event;
import com.eventsphere.model.EventCategory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Event Management (Module 2).
 * All SQL queries are explicitly written here.
 */
@Repository
public class EventDAO {

    private final JdbcTemplate jdbcTemplate;

    public EventDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMappers ─────────────────────────────────────────────

    private final RowMapper<Event> eventRowMapper = (rs, rowNum) -> {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setArchived(rs.getBoolean("is_archived"));
        e.setEventName(rs.getString("event_name"));
        e.setCategoryId(rs.getInt("category_id"));
        e.setCategoryName(rs.getString("category_name"));
        e.setCustomerId(rs.getInt("customer_id"));
        e.setCustomerName(rs.getString("customer_name"));
        int mgr = rs.getInt("manager_user_id");
        e.setManagerUserId(rs.wasNull() ? null : mgr);
        e.setManagerName(rs.getString("manager_name"));
        e.setEventDate(rs.getDate("event_date") != null
                ? rs.getDate("event_date").toLocalDate() : null);
        e.setStartTime(rs.getTime("start_time") != null
                ? rs.getTime("start_time").toLocalTime() : null);
        e.setEndTime(rs.getTime("end_time") != null
                ? rs.getTime("end_time").toLocalTime() : null);
        e.setLocation(rs.getString("location"));
        e.setGuestCount(rs.getInt("guest_count"));
        e.setRequirements(rs.getString("requirements"));
        e.setStatus(rs.getString("status"));
        e.setNotes(rs.getString("notes"));
        e.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        e.setUpdatedAt(rs.getTimestamp("updated_at") != null
                ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
        return e;
    };

    private final RowMapper<EventCategory> categoryRowMapper = (rs, rowNum) -> {
        EventCategory c = new EventCategory();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        return c;
    };

    // Base SELECT used in all event queries
    private static final String BASE_SELECT =
        "SELECT e.event_id, e.event_name, e.category_id, ec.category_name, " +
        "       e.customer_id, c.full_name AS customer_name, " +
        "       e.manager_user_id, u.full_name AS manager_name, " +
        "       e.event_date, e.start_time, e.end_time, e.location, " +
        "       e.guest_count, e.requirements, e.status, e.notes, " +
        "       e.created_at, e.updated_at, e.is_archived " +
        "FROM events e " +
        "JOIN event_categories ec ON e.category_id = ec.category_id " +
        "JOIN customers c         ON e.customer_id  = c.customer_id " +
        "LEFT JOIN users u        ON e.manager_user_id = u.user_id ";

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new event record into the database.
     */
    public int addEvent(Event event) {
        String sql =
            "INSERT INTO events " +
            "(event_name, category_id, customer_id, manager_user_id, " +
            " event_date, start_time, end_time, location, guest_count, " +
            " requirements, status, notes) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                event.getEventName(),
                event.getCategoryId(),
                event.getCustomerId(),
                event.getManagerUserId(),
                event.getEventDate(),
                event.getStartTime(),
                event.getEndTime(),
                event.getLocation(),
                event.getGuestCount(),
                event.getRequirements(),
                event.getStatus(),
                event.getNotes());
    }

    /**
     * Returns the event_id of the most recently inserted event for this customer.
     */
    public int getLastInsertedEventId(int customerId) {
        String sql =
            "SELECT TOP 1 event_id FROM events " +
            "WHERE customer_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.queryForObject(sql, Integer.class, customerId);
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all events.
     */
    public List<Event> findAll() {
        String sql = BASE_SELECT + "WHERE e.is_archived = 0 ORDER BY e.event_date DESC";
        return jdbcTemplate.query(sql, eventRowMapper);
    }

    /**
     * Finds a single event by its primary key.
     */
    public Optional<Event> findById(int eventId) {
        String sql = BASE_SELECT + "WHERE e.event_id = ?";
        List<Event> result = jdbcTemplate.query(sql, eventRowMapper, eventId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    public List<Event> findArchived() {
        return jdbcTemplate.query(BASE_SELECT + "WHERE e.is_archived = 1 ORDER BY e.event_date DESC", eventRowMapper);
    }

    public int setArchived(int eventId, boolean archived) {
        return jdbcTemplate.update("UPDATE events SET is_archived=?, updated_at=GETDATE() WHERE event_id=? AND status IN ('Completed','Cancelled')", archived, eventId);
    }

    /**
     * Returns all events belonging to a specific customer.
     */
    public List<Event> findByCustomerId(int customerId) {
        String sql = BASE_SELECT +
            "WHERE e.is_archived = 0 AND e.customer_id = ? ORDER BY e.event_date DESC";
        return jdbcTemplate.query(sql, eventRowMapper, customerId);
    }

    /**
     * Returns all events assigned to a specific Event Manager.
     */
    public List<Event> findByManagerId(int managerUserId) {
        String sql = BASE_SELECT +
            "WHERE e.is_archived = 0 AND e.manager_user_id = ? ORDER BY e.event_date DESC";
        return jdbcTemplate.query(sql, eventRowMapper, managerUserId);
    }

    /**
     * Returns events filtered by status.
     */
    public List<Event> findByStatus(String status) {
        String sql = BASE_SELECT +
            "WHERE e.is_archived = 0 AND e.status = ? ORDER BY e.event_date ASC";
        return jdbcTemplate.query(sql, eventRowMapper, status);
    }

    /**
     * Returns upcoming events (event_date >= today) ordered soonest first.
     */
    public List<Event> findUpcoming() {
        String sql = BASE_SELECT +
            "WHERE e.is_archived = 0 AND e.event_date >= CAST(GETDATE() AS DATE) " +
            "  AND e.status NOT IN ('Cancelled', 'Completed') " +
            "ORDER BY e.event_date ASC";
        return jdbcTemplate.query(sql, eventRowMapper);
    }

    /**
     * Searches events by name or customer name.
     */
    public List<Event> search(String keyword) {
        String sql = BASE_SELECT +
            "WHERE e.is_archived = 0 AND (e.event_name LIKE ? OR c.full_name LIKE ?) " +
            "ORDER BY e.event_date DESC";
        String pattern = "%" + keyword + "%";
        return jdbcTemplate.query(sql, eventRowMapper, pattern, pattern);
    }

    /**
     * Returns count of events grouped by status (for dashboard charts).
     * Returns a list of Object[] where [0]=status, [1]=count.
     */
    public List<Object[]> countByStatus() {
        String sql =
            "SELECT status, COUNT(*) AS cnt FROM events WHERE is_archived = 0 GROUP BY status";
        return jdbcTemplate.query(sql,
                (rs, rowNum) -> new Object[]{rs.getString("status"), rs.getInt("cnt")});
    }

    /**
     * Returns event count per month for the current year (for charts).
     */
    public List<Object[]> countByMonth(int year) {
        String sql =
            "SELECT MONTH(event_date) AS month_num, COUNT(*) AS cnt " +
            "FROM events " +
            "WHERE is_archived = 0 AND YEAR(event_date) = ? " +
            "GROUP BY MONTH(event_date) " +
            "ORDER BY MONTH(event_date)";
        return jdbcTemplate.query(sql,
                (rs, rowNum) -> new Object[]{rs.getInt("month_num"), rs.getInt("cnt")},
                year);
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates full event details.
     */
    public int updateEvent(Event event) {
        String sql =
            "UPDATE events SET " +
            "  event_name = ?, category_id = ?, manager_user_id = ?, " +
            "  event_date = ?, start_time = ?, end_time = ?, " +
            "  location = ?, guest_count = ?, requirements = ?, " +
            "  status = ?, notes = ?, updated_at = GETDATE() " +
            "WHERE event_id = ?";
        return jdbcTemplate.update(sql,
                event.getEventName(),
                event.getCategoryId(),
                event.getManagerUserId(),
                event.getEventDate(),
                event.getStartTime(),
                event.getEndTime(),
                event.getLocation(),
                event.getGuestCount(),
                event.getRequirements(),
                event.getStatus(),
                event.getNotes(),
                event.getEventId());
    }

    /**
     * Updates only the event status.
     */
    public int updateStatus(int eventId, String status) {
        String sql =
            "UPDATE events SET status = ?, updated_at = GETDATE() WHERE event_id = ?";
        return jdbcTemplate.update(sql, status, eventId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes an event by its ID.
     */
    public int deleteEvent(int eventId) {
        String sql = "DELETE FROM events WHERE event_id = ?";
        return jdbcTemplate.update(sql, eventId);
    }

    // ── CATEGORIES ─────────────────────────────────────────────

    /**
     * Returns all event categories for dropdown menus.
     */
    public List<EventCategory> findAllCategories() {
        String sql =
            "SELECT category_id, category_name, description " +
            "FROM event_categories ORDER BY category_name";
        return jdbcTemplate.query(sql, categoryRowMapper);
    }

    // ── COUNT ──────────────────────────────────────────────────

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM events WHERE is_archived = 0";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    public int countUpcoming() {
        String sql =
            "SELECT COUNT(*) FROM events " +
            "WHERE is_archived = 0 AND event_date >= CAST(GETDATE() AS DATE) " +
            "  AND status NOT IN ('Cancelled','Completed')";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
