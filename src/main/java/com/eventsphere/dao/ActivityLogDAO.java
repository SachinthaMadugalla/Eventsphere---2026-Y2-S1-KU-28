package com.eventsphere.dao;

import com.eventsphere.model.ActivityLog;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * DAO for Activity Logging (common supporting function).
 * Logs important system actions with explicit SQL queries.
 */
@Repository
public class ActivityLogDAO {

    private final JdbcTemplate jdbcTemplate;

    public ActivityLogDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<ActivityLog> logRowMapper = (rs, rowNum) -> {
        ActivityLog log = new ActivityLog();
        log.setLogId(rs.getInt("log_id"));
        int uid = rs.getInt("user_id");
        log.setUserId(rs.wasNull() ? null : uid);
        log.setUserFullName(rs.getString("user_full_name"));
        log.setAction(rs.getString("action"));
        log.setEntityType(rs.getString("entity_type"));
        int eid = rs.getInt("entity_id");
        log.setEntityId(rs.wasNull() ? null : eid);
        log.setLogTime(rs.getTimestamp("log_time") != null
                ? rs.getTimestamp("log_time").toLocalDateTime() : null);
        return log;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Writes a new activity log entry.
     * userId may be null for system-generated entries.
     */
    public int log(Integer userId, String action, String entityType, Integer entityId) {
        String sql =
            "INSERT INTO activity_logs (user_id, action, entity_type, entity_id) " +
            "VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql, userId, action, entityType, entityId);
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns the most recent activity log entries (newest first).
     */
    public List<ActivityLog> findRecent(int limit) {
        String sql =
            "SELECT TOP (?) " +
            "       al.log_id, al.user_id, u.full_name AS user_full_name, " +
            "       al.action, al.entity_type, al.entity_id, al.log_time " +
            "FROM activity_logs al " +
            "LEFT JOIN users u ON al.user_id = u.user_id " +
            "ORDER BY al.log_time DESC";
        return jdbcTemplate.query(sql, logRowMapper, limit);
    }

    /**
     * Returns all log entries for a specific entity type and ID.
     * e.g. findByEntity("Payment", 5) returns all logs for payment_id = 5
     */
    public List<ActivityLog> findByEntity(String entityType, int entityId) {
        String sql =
            "SELECT al.log_id, al.user_id, u.full_name AS user_full_name, " +
            "       al.action, al.entity_type, al.entity_id, al.log_time " +
            "FROM activity_logs al " +
            "LEFT JOIN users u ON al.user_id = u.user_id " +
            "WHERE al.entity_type = ? AND al.entity_id = ? " +
            "ORDER BY al.log_time DESC";
        return jdbcTemplate.query(sql, logRowMapper, entityType, entityId);
    }

    /**
     * Returns all log entries created by a specific user.
     */
    public List<ActivityLog> findByUser(int userId) {
        String sql =
            "SELECT al.log_id, al.user_id, u.full_name AS user_full_name, " +
            "       al.action, al.entity_type, al.entity_id, al.log_time " +
            "FROM activity_logs al " +
            "LEFT JOIN users u ON al.user_id = u.user_id " +
            "WHERE al.user_id = ? " +
            "ORDER BY al.log_time DESC";
        return jdbcTemplate.query(sql, logRowMapper, userId);
    }

    /**
     * Returns all activity log entries (for admin/director view).
     */
    public List<ActivityLog> findAll() {
        String sql =
            "SELECT al.log_id, al.user_id, u.full_name AS user_full_name, " +
            "       al.action, al.entity_type, al.entity_id, al.log_time " +
            "FROM activity_logs al " +
            "LEFT JOIN users u ON al.user_id = u.user_id " +
            "ORDER BY al.log_time DESC";
        return jdbcTemplate.query(sql, logRowMapper);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Clears log entries older than the given number of days.
     * Used for optional housekeeping by System Administrator.
     */
    public int deleteOlderThan(int days) {
        String sql =
            "DELETE FROM activity_logs " +
            "WHERE log_time < DATEADD(DAY, -?, GETDATE())";
        return jdbcTemplate.update(sql, days);
    }
}
