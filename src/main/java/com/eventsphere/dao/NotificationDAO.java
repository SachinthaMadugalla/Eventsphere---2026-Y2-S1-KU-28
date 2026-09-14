package com.eventsphere.dao;

import com.eventsphere.model.Notification;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * DAO for Notification management (common supporting function).
 * All SQL queries are explicitly written here.
 */
@Repository
public class NotificationDAO {

    private final JdbcTemplate jdbcTemplate;

    public NotificationDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Notification> notificationRowMapper = (rs, rowNum) -> {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return n;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Creates a new notification for a user.
     */
    public int addNotification(int userId, String title, String message) {
        String sql =
            "INSERT INTO notifications (user_id, title, message, is_read) " +
            "VALUES (?, ?, ?, 0)";
        return jdbcTemplate.update(sql, userId, title, message);
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all notifications for a user, newest first.
     */
    public List<Notification> findByUserId(int userId) {
        String sql =
            "SELECT notification_id, user_id, title, message, is_read, created_at " +
            "FROM notifications " +
            "WHERE user_id = ? ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, notificationRowMapper, userId);
    }

    /**
     * Returns only unread notifications for a user.
     */
    public List<Notification> findUnreadByUserId(int userId) {
        String sql =
            "SELECT notification_id, user_id, title, message, is_read, created_at " +
            "FROM notifications " +
            "WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, notificationRowMapper, userId);
    }

    /**
     * Returns count of unread notifications for a user (for navbar badge).
     */
    public int countUnread(int userId) {
        String sql =
            "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Marks a single notification as read.
     */
    public int markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ? AND user_id = ?";
        return jdbcTemplate.update(sql, notificationId, userId);
    }

    /**
     * Marks all notifications for a user as read.
     */
    public int markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        return jdbcTemplate.update(sql, userId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a notification by ID.
     */
    public int deleteNotification(int notificationId, int userId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ? AND user_id = ?";
        return jdbcTemplate.update(sql, notificationId, userId);
    }
}
