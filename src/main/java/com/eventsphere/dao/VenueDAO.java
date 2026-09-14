package com.eventsphere.dao;

import com.eventsphere.model.EventVenue;
import com.eventsphere.model.Venue;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * DAO for Venue Management (Module 3).
 * All SQL queries are explicitly written here.
 */
@Repository
public class VenueDAO {

    private final JdbcTemplate jdbcTemplate;

    public VenueDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMappers ─────────────────────────────────────────────

    private final RowMapper<Venue> venueRowMapper = (rs, rowNum) -> {
        Venue v = new Venue();
        v.setVenueId(rs.getInt("venue_id"));
        v.setVenueName(rs.getString("venue_name"));
        v.setLocation(rs.getString("location"));
        v.setCapacity(rs.getInt("capacity"));
        v.setCostPerDay(rs.getBigDecimal("cost_per_day"));
        v.setDescription(rs.getString("description"));
        v.setActive(rs.getBoolean("is_active"));
        v.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return v;
    };

    private final RowMapper<EventVenue> eventVenueRowMapper = (rs, rowNum) -> {
        EventVenue ev = new EventVenue();
        ev.setEventVenueId(rs.getInt("event_venue_id"));
        ev.setEventId(rs.getInt("event_id"));
        ev.setEventName(rs.getString("event_name"));
        ev.setVenueId(rs.getInt("venue_id"));
        ev.setVenueName(rs.getString("venue_name"));
        ev.setAssignedDate(rs.getDate("assigned_date") != null
                ? rs.getDate("assigned_date").toLocalDate() : null);
        ev.setStartTime(rs.getTime("start_time") != null
                ? rs.getTime("start_time").toLocalTime() : null);
        ev.setEndTime(rs.getTime("end_time") != null
                ? rs.getTime("end_time").toLocalTime() : null);
        ev.setNotes(rs.getString("notes"));
        return ev;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new venue into the database.
     */
    public int addVenue(Venue venue) {
        String sql =
            "INSERT INTO venues (venue_name, location, capacity, cost_per_day, description) " +
            "VALUES (?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                venue.getVenueName(),
                venue.getLocation(),
                venue.getCapacity(),
                venue.getCostPerDay(),
                venue.getDescription());
    }

    /**
     * Assigns a venue to an event.
     */
    public int assignVenueToEvent(EventVenue ev) {
        String sql =
            "INSERT INTO event_venues (event_id, venue_id, assigned_date, start_time, end_time, notes) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                ev.getEventId(),
                ev.getVenueId(),
                ev.getAssignedDate(),
                ev.getStartTime(),
                ev.getEndTime(),
                ev.getNotes());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all venues.
     */
    public List<Venue> findAll() {
        String sql =
            "SELECT venue_id, venue_name, location, capacity, cost_per_day, " +
            "       description, is_active, created_at " +
            "FROM venues ORDER BY venue_name";
        return jdbcTemplate.query(sql, venueRowMapper);
    }

    /**
     * Returns only active venues (for assignment dropdowns).
     */
    public List<Venue> findAllActive() {
        String sql =
            "SELECT venue_id, venue_name, location, capacity, cost_per_day, " +
            "       description, is_active, created_at " +
            "FROM venues WHERE is_active = 1 ORDER BY venue_name";
        return jdbcTemplate.query(sql, venueRowMapper);
    }

    /**
     * Finds a venue by its primary key.
     */
    public Optional<Venue> findById(int venueId) {
        String sql =
            "SELECT venue_id, venue_name, location, capacity, cost_per_day, " +
            "       description, is_active, created_at " +
            "FROM venues WHERE venue_id = ?";
        List<Venue> result = jdbcTemplate.query(sql, venueRowMapper, venueId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns all event-venue assignments for a specific event.
     */
    public List<EventVenue> findAssignmentsByEventId(int eventId) {
        String sql =
            "SELECT ev.event_venue_id, ev.event_id, e.event_name, " +
            "       ev.venue_id, v.venue_name, " +
            "       ev.assigned_date, ev.start_time, ev.end_time, ev.notes " +
            "FROM event_venues ev " +
            "JOIN events e  ON ev.event_id  = e.event_id " +
            "JOIN venues v  ON ev.venue_id   = v.venue_id " +
            "WHERE ev.event_id = ?";
        return jdbcTemplate.query(sql, eventVenueRowMapper, eventId);
    }

    /**
     * Returns all event-venue assignments for a specific venue.
     */
    public List<EventVenue> findAssignmentsByVenueId(int venueId) {
        String sql =
            "SELECT ev.event_venue_id, ev.event_id, e.event_name, " +
            "       ev.venue_id, v.venue_name, " +
            "       ev.assigned_date, ev.start_time, ev.end_time, ev.notes " +
            "FROM event_venues ev " +
            "JOIN events e  ON ev.event_id = e.event_id " +
            "JOIN venues v  ON ev.venue_id  = v.venue_id " +
            "WHERE ev.venue_id = ? ORDER BY ev.assigned_date DESC";
        return jdbcTemplate.query(sql, eventVenueRowMapper, venueId);
    }

    /**
     * Returns all event-venue assignments (for reports).
     */
    public List<EventVenue> findAllAssignments() {
        String sql =
            "SELECT ev.event_venue_id, ev.event_id, e.event_name, " +
            "       ev.venue_id, v.venue_name, " +
            "       ev.assigned_date, ev.start_time, ev.end_time, ev.notes " +
            "FROM event_venues ev " +
            "JOIN events e  ON ev.event_id = e.event_id " +
            "JOIN venues v  ON ev.venue_id  = v.venue_id " +
            "ORDER BY ev.assigned_date DESC";
        return jdbcTemplate.query(sql, eventVenueRowMapper);
    }

    // ── CONFLICT DETECTION ────────────────────────────────────
    //
    // A venue conflict occurs when the same venue is already booked
    // on the same date and the time ranges overlap.
    //
    // Two time ranges [s1, e1] and [s2, e2] overlap when: s1 < e2 AND s2 < e1
    //

    /**
     * Checks whether a venue is already booked for the given date and time range.
     * Excludes a specific event_venue_id (pass 0 when creating new).
     *
     * @return number of conflicting bookings (0 = no conflict)
     */
    public int countVenueConflicts(int venueId, LocalDate date,
                                   String startTime, String endTime,
                                   int excludeEventVenueId) {
        String sql =
            "SELECT COUNT(*) " +
            "FROM event_venues ev " +
            "JOIN events e ON ev.event_id = e.event_id " +
            "WHERE ev.venue_id = ? " +
            "  AND ev.assigned_date = ? " +
            "  AND ev.event_venue_id <> ? " +
            "  AND e.status NOT IN ('Cancelled') " +
            "  AND (ev.start_time IS NULL OR ev.start_time < ?) " +
            "  AND (ev.end_time IS NULL OR ev.end_time > ?)";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class,
                venueId, date, excludeEventVenueId, endTime, startTime);
        return count != null ? count : 0;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates venue details.
     */
    public int updateVenue(Venue venue) {
        String sql =
            "UPDATE venues SET venue_name = ?, location = ?, capacity = ?, " +
            "                  cost_per_day = ?, description = ? " +
            "WHERE venue_id = ?";
        return jdbcTemplate.update(sql,
                venue.getVenueName(),
                venue.getLocation(),
                venue.getCapacity(),
                venue.getCostPerDay(),
                venue.getDescription(),
                venue.getVenueId());
    }

    /**
     * Activates or deactivates a venue.
     */
    public int setActiveStatus(int venueId, boolean active) {
        String sql = "UPDATE venues SET is_active = ? WHERE venue_id = ?";
        return jdbcTemplate.update(sql, active ? 1 : 0, venueId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a venue by ID.
     */
    public int deleteVenue(int venueId) {
        String sql = "DELETE FROM venues WHERE venue_id = ?";
        return jdbcTemplate.update(sql, venueId);
    }

    /**
     * Removes a venue assignment from an event.
     */
    public int removeAssignment(int eventVenueId) {
        String sql = "DELETE FROM event_venues WHERE event_venue_id = ?";
        return jdbcTemplate.update(sql, eventVenueId);
    }
}
