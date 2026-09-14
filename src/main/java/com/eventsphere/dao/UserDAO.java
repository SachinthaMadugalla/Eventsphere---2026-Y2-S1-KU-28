package com.eventsphere.dao;

import com.eventsphere.model.User;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * DAO for user authentication and account management.
 * All SQL queries are explicitly written here for evaluation visibility.
 */
@Repository
public class UserDAO {

    private final JdbcTemplate jdbcTemplate;

    public UserDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<User> userRowMapper = (rs, rowNum) -> {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(rs.getString("role_name"));
        u.setActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return u;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new user account into the database.
     */
    public int addUser(User user) {
        String sql =
            "INSERT INTO users (username, password_hash, email, full_name, phone, role_id, is_active) " +
            "VALUES (?, ?, ?, ?, ?, ?, 1)";
        return jdbcTemplate.update(sql,
                user.getUsername(),
                user.getPasswordHash(),
                user.getEmail(),
                user.getFullName(),
                user.getPhone(),
                user.getRoleId());
    }

    /**
     * Returns the auto-generated user_id of the most recently inserted user
     * for the given username (used right after addUser).
     */
    public int getLastInsertedUserId(String username) {
        String sql = "SELECT user_id FROM users WHERE username = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, username);
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Finds a user by username for login authentication.
     */
    public Optional<User> findByUsername(String username) {
        String sql =
            "SELECT u.user_id, u.username, u.password_hash, u.email, u.full_name, " +
            "       u.phone, u.role_id, r.role_name, u.is_active, u.created_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id " +
            "WHERE u.username = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, username);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    /**
     * Finds a user by their primary key.
     */
    public Optional<User> findById(int userId) {
        String sql =
            "SELECT u.user_id, u.username, u.password_hash, u.email, u.full_name, " +
            "       u.phone, u.role_id, r.role_name, u.is_active, u.created_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id " +
            "WHERE u.user_id = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, userId);
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    /**
     * Returns all users in the system (used by System Administrator).
     */
    public List<User> findAll() {
        String sql =
            "SELECT u.user_id, u.username, u.password_hash, u.email, u.full_name, " +
            "       u.phone, u.role_id, r.role_name, u.is_active, u.created_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id " +
            "ORDER BY u.created_at DESC";
        return jdbcTemplate.query(sql, userRowMapper);
    }

    /**
     * Returns all active Event Managers (for assigning to events).
     */
    public List<User> findAllManagers() {
        String sql =
            "SELECT u.user_id, u.username, u.password_hash, u.email, u.full_name, " +
            "       u.phone, u.role_id, r.role_name, u.is_active, u.created_at " +
            "FROM users u " +
            "JOIN roles r ON u.role_id = r.role_id " +
            "WHERE r.role_name = 'Event Manager' AND u.is_active = 1 " +
            "ORDER BY u.full_name";
        return jdbcTemplate.query(sql, userRowMapper);
    }

    /**
     * Checks whether a username already exists (for registration).
     */
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, username);
        return count != null && count > 0;
    }

    /**
     * Checks whether an email address already exists (for registration).
     */
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a user's profile information.
     */
    public int updateUser(User user) {
        String sql =
            "UPDATE users SET email = ?, full_name = ?, phone = ? " +
            "WHERE user_id = ?";
        return jdbcTemplate.update(sql,
                user.getEmail(),
                user.getFullName(),
                user.getPhone(),
                user.getUserId());
    }

    /**
     * Updates a user's hashed password.
     */
    public int updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        return jdbcTemplate.update(sql, newPasswordHash, userId);
    }

    /**
     * Activates or deactivates a user account.
     */
    public int setActiveStatus(int userId, boolean active) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        return jdbcTemplate.update(sql, active ? 1 : 0, userId);
    }

    /**
     * Changes the role assigned to a user (System Administrator function).
     */
    public int updateRole(int userId, int roleId) {
        String sql = "UPDATE users SET role_id = ? WHERE user_id = ?";
        return jdbcTemplate.update(sql, roleId, userId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a user by ID (used by System Administrator only).
     */
    public int deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        return jdbcTemplate.update(sql, userId);
    }

    // ── COUNT ──────────────────────────────────────────────────

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
