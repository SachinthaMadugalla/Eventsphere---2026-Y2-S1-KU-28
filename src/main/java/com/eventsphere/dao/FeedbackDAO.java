package com.eventsphere.dao;

import com.eventsphere.model.Feedback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Feedback Management (Module 7 – Reporting & Feedback).
 * All SQL queries are explicitly written here.
 */
@Repository
public class FeedbackDAO {

    private final JdbcTemplate jdbcTemplate;

    public FeedbackDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Feedback> feedbackRowMapper = (rs, rowNum) -> {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setEventId(rs.getInt("event_id"));
        f.setEventName(rs.getString("event_name"));
        f.setCustomerId(rs.getInt("customer_id"));
        f.setCustomerName(rs.getString("customer_name"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setSubmittedDate(rs.getTimestamp("submitted_date") != null
                ? rs.getTimestamp("submitted_date").toLocalDateTime() : null);
        f.setStatus(rs.getString("status"));
        f.setModReason(rs.getString("mod_reason"));
        return f;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Submits new feedback for a completed event.
     */
    public int addFeedback(Feedback feedback) {
        String sql =
            "INSERT INTO feedback (event_id, customer_id, rating, comment, status) " +
            "VALUES (?, ?, ?, ?, 'Active')";
        return jdbcTemplate.update(sql,
                feedback.getEventId(),
                feedback.getCustomerId(),
                feedback.getRating(),
                feedback.getComment());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all feedback entries.
     */
    public List<Feedback> findAll() {
        String sql =
            "SELECT f.feedback_id, f.event_id, e.event_name, " +
            "       f.customer_id, c.full_name AS customer_name, " +
            "       f.rating, f.comment, f.submitted_date, f.status, f.mod_reason " +
            "FROM feedback f " +
            "JOIN events    e ON f.event_id    = e.event_id " +
            "JOIN customers c ON f.customer_id = c.customer_id " +
            "ORDER BY f.submitted_date DESC";
        return jdbcTemplate.query(sql, feedbackRowMapper);
    }

    /**
     * Finds feedback by its primary key.
     */
    public Optional<Feedback> findById(int feedbackId) {
        String sql =
            "SELECT f.feedback_id, f.event_id, e.event_name, " +
            "       f.customer_id, c.full_name AS customer_name, " +
            "       f.rating, f.comment, f.submitted_date, f.status, f.mod_reason " +
            "FROM feedback f " +
            "JOIN events    e ON f.event_id    = e.event_id " +
            "JOIN customers c ON f.customer_id = c.customer_id " +
            "WHERE f.feedback_id = ?";
        List<Feedback> result = jdbcTemplate.query(sql, feedbackRowMapper, feedbackId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns feedback submitted by a specific customer.
     */
    public List<Feedback> findByCustomerId(int customerId) {
        String sql =
            "SELECT f.feedback_id, f.event_id, e.event_name, " +
            "       f.customer_id, c.full_name AS customer_name, " +
            "       f.rating, f.comment, f.submitted_date, f.status, f.mod_reason " +
            "FROM feedback f " +
            "JOIN events    e ON f.event_id    = e.event_id " +
            "JOIN customers c ON f.customer_id = c.customer_id " +
            "WHERE f.customer_id = ? ORDER BY f.submitted_date DESC";
        return jdbcTemplate.query(sql, feedbackRowMapper, customerId);
    }

    /**
     * Returns feedback for a specific event.
     */
    public List<Feedback> findByEventId(int eventId) {
        String sql =
            "SELECT f.feedback_id, f.event_id, e.event_name, " +
            "       f.customer_id, c.full_name AS customer_name, " +
            "       f.rating, f.comment, f.submitted_date, f.status, f.mod_reason " +
            "FROM feedback f " +
            "JOIN events    e ON f.event_id    = e.event_id " +
            "JOIN customers c ON f.customer_id = c.customer_id " +
            "WHERE f.event_id = ? ORDER BY f.submitted_date DESC";
        return jdbcTemplate.query(sql, feedbackRowMapper, eventId);
    }

    /**
     * Checks if a customer has already submitted feedback for a given event.
     */
    public boolean hasSubmittedFeedback(int customerId, int eventId) {
        String sql =
            "SELECT COUNT(*) FROM feedback WHERE customer_id = ? AND event_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, customerId, eventId);
        return count != null && count > 0;
    }

    /**
     * Returns average rating across all active feedback.
     */
    public double getAverageRating() {
        String sql =
            "SELECT ISNULL(AVG(CAST(rating AS FLOAT)), 0) FROM feedback WHERE status = 'Active'";
        Double avg = jdbcTemplate.queryForObject(sql, Double.class);
        return avg != null ? avg : 0.0;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Moderates feedback (marks it as Moderated with a reason).
     */
    public int moderateFeedback(int feedbackId, String reason) {
        String sql =
            "UPDATE feedback SET status = 'Moderated', mod_reason = ? WHERE feedback_id = ?";
        return jdbcTemplate.update(sql, reason, feedbackId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a feedback entry by ID.
     */
    public int deleteFeedback(int feedbackId) {
        String sql = "DELETE FROM feedback WHERE feedback_id = ?";
        return jdbcTemplate.update(sql, feedbackId);
    }
}
