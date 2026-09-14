package com.eventsphere.dao;

import com.eventsphere.model.Complaint;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Complaint Management (Module 7 – Reporting & Feedback).
 * All SQL queries are explicitly written here.
 */
@Repository
public class ComplaintDAO {

    private final JdbcTemplate jdbcTemplate;

    public ComplaintDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Complaint> complaintRowMapper = (rs, rowNum) -> {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        int eventId = rs.getInt("event_id");
        c.setEventId(rs.wasNull() ? null : eventId);
        c.setEventName(rs.getString("event_name"));
        c.setCustomerId(rs.getInt("customer_id"));
        c.setCustomerName(rs.getString("customer_name"));
        c.setSubject(rs.getString("subject"));
        c.setDescription(rs.getString("description"));
        c.setStatus(rs.getString("status"));
        c.setResponse(rs.getString("response"));
        c.setEscalated(rs.getBoolean("is_escalated"));
        c.setSubmittedDate(rs.getTimestamp("submitted_date") != null
                ? rs.getTimestamp("submitted_date").toLocalDateTime() : null);
        c.setUpdatedDate(rs.getTimestamp("updated_date") != null
                ? rs.getTimestamp("updated_date").toLocalDateTime() : null);
        return c;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Submits a new complaint.
     */
    public int addComplaint(Complaint complaint) {
        String sql =
            "INSERT INTO complaints (event_id, customer_id, subject, description, status) " +
            "VALUES (?, ?, ?, ?, 'Submitted')";
        return jdbcTemplate.update(sql,
                complaint.getEventId(),
                complaint.getCustomerId(),
                complaint.getSubject(),
                complaint.getDescription());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all complaints.
     */
    public List<Complaint> findAll() {
        String sql =
            "SELECT co.complaint_id, co.event_id, e.event_name, " +
            "       co.customer_id, c.full_name AS customer_name, " +
            "       co.subject, co.description, co.status, co.response, " +
            "       co.is_escalated, co.submitted_date, co.updated_date " +
            "FROM complaints co " +
            "LEFT JOIN events    e ON co.event_id    = e.event_id " +
            "JOIN customers c ON co.customer_id = c.customer_id " +
            "ORDER BY co.submitted_date DESC";
        return jdbcTemplate.query(sql, complaintRowMapper);
    }

    /**
     * Finds a complaint by its primary key.
     */
    public Optional<Complaint> findById(int complaintId) {
        String sql =
            "SELECT co.complaint_id, co.event_id, e.event_name, " +
            "       co.customer_id, c.full_name AS customer_name, " +
            "       co.subject, co.description, co.status, co.response, " +
            "       co.is_escalated, co.submitted_date, co.updated_date " +
            "FROM complaints co " +
            "LEFT JOIN events    e ON co.event_id    = e.event_id " +
            "JOIN customers c ON co.customer_id = c.customer_id " +
            "WHERE co.complaint_id = ?";
        List<Complaint> result = jdbcTemplate.query(sql, complaintRowMapper, complaintId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns complaints for a specific customer.
     */
    public List<Complaint> findByCustomerId(int customerId) {
        String sql =
            "SELECT co.complaint_id, co.event_id, e.event_name, " +
            "       co.customer_id, c.full_name AS customer_name, " +
            "       co.subject, co.description, co.status, co.response, " +
            "       co.is_escalated, co.submitted_date, co.updated_date " +
            "FROM complaints co " +
            "LEFT JOIN events    e ON co.event_id    = e.event_id " +
            "JOIN customers c ON co.customer_id = c.customer_id " +
            "WHERE co.customer_id = ? ORDER BY co.submitted_date DESC";
        return jdbcTemplate.query(sql, complaintRowMapper, customerId);
    }

    /**
     * Returns only escalated complaints (for Managing Director).
     */
    public List<Complaint> findEscalated() {
        String sql =
            "SELECT co.complaint_id, co.event_id, e.event_name, " +
            "       co.customer_id, c.full_name AS customer_name, " +
            "       co.subject, co.description, co.status, co.response, " +
            "       co.is_escalated, co.submitted_date, co.updated_date " +
            "FROM complaints co " +
            "LEFT JOIN events    e ON co.event_id    = e.event_id " +
            "JOIN customers c ON co.customer_id = c.customer_id " +
            "WHERE co.is_escalated = 1 ORDER BY co.submitted_date DESC";
        return jdbcTemplate.query(sql, complaintRowMapper);
    }

    /**
     * Returns count of open complaints (Submitted or Under Review).
     */
    public int countOpen() {
        String sql =
            "SELECT COUNT(*) FROM complaints WHERE status IN ('Submitted','Under Review')";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates complaint status and response.
     */
    public int updateComplaint(Complaint complaint) {
        String sql =
            "UPDATE complaints SET status = ?, response = ?, is_escalated = ?, " +
            "                      updated_date = GETDATE() " +
            "WHERE complaint_id = ?";
        return jdbcTemplate.update(sql,
                complaint.getStatus(),
                complaint.getResponse(),
                complaint.isEscalated() ? 1 : 0,
                complaint.getComplaintId());
    }

    /**
     * Escalates a complaint to the Managing Director.
     */
    public int escalateComplaint(int complaintId) {
        String sql =
            "UPDATE complaints SET is_escalated = 1, updated_date = GETDATE() " +
            "WHERE complaint_id = ?";
        return jdbcTemplate.update(sql, complaintId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a complaint by ID.
     */
    public int deleteComplaint(int complaintId) {
        String sql = "DELETE FROM complaints WHERE complaint_id = ?";
        return jdbcTemplate.update(sql, complaintId);
    }
}
