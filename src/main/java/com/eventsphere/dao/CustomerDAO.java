package com.eventsphere.dao;

import com.eventsphere.model.Customer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Customer Management (Module 1).
 * All SQL queries are explicitly written here.
 */
@Repository
public class CustomerDAO {

    private final JdbcTemplate jdbcTemplate;

    public CustomerDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Customer> customerRowMapper = (rs, rowNum) -> {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("customer_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setFullName(rs.getString("full_name"));
        c.setEmail(rs.getString("email"));
        c.setPhone(rs.getString("phone"));
        c.setAddress(rs.getString("address"));
        c.setRegisteredAt(rs.getTimestamp("registered_at") != null
                ? rs.getTimestamp("registered_at").toLocalDateTime() : null);
        return c;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new customer profile linked to a user account.
     */
    public int addCustomer(Customer customer) {
        String sql =
            "INSERT INTO customers (user_id, full_name, email, phone, address) " +
            "VALUES (?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                customer.getUserId(),
                customer.getFullName(),
                customer.getEmail(),
                customer.getPhone(),
                customer.getAddress());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all customers ordered by registration date.
     */
    public List<Customer> findAll() {
        String sql =
            "SELECT customer_id, user_id, full_name, email, phone, address, registered_at " +
            "FROM customers " +
            "ORDER BY registered_at DESC";
        return jdbcTemplate.query(sql, customerRowMapper);
    }

    /**
     * Finds a single customer by their customer_id.
     */
    public Optional<Customer> findById(int customerId) {
        String sql =
            "SELECT customer_id, user_id, full_name, email, phone, address, registered_at " +
            "FROM customers WHERE customer_id = ?";
        List<Customer> result = jdbcTemplate.query(sql, customerRowMapper, customerId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Finds the customer profile linked to a specific user account.
     */
    public Optional<Customer> findByUserId(int userId) {
        String sql =
            "SELECT customer_id, user_id, full_name, email, phone, address, registered_at " +
            "FROM customers WHERE user_id = ?";
        List<Customer> result = jdbcTemplate.query(sql, customerRowMapper, userId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Searches customers by name or email (case-insensitive).
     */
    public List<Customer> search(String keyword) {
        String sql =
            "SELECT customer_id, user_id, full_name, email, phone, address, registered_at " +
            "FROM customers " +
            "WHERE full_name LIKE ? OR email LIKE ? " +
            "ORDER BY full_name";
        String pattern = "%" + keyword + "%";
        return jdbcTemplate.query(sql, customerRowMapper, pattern, pattern);
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a customer's contact details.
     */
    public int updateCustomer(Customer customer) {
        String sql =
            "UPDATE customers SET full_name = ?, email = ?, phone = ?, address = ? " +
            "WHERE customer_id = ?";
        return jdbcTemplate.update(sql,
                customer.getFullName(),
                customer.getEmail(),
                customer.getPhone(),
                customer.getAddress(),
                customer.getCustomerId());
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a customer record by ID.
     */
    public int deleteCustomer(int customerId) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        return jdbcTemplate.update(sql, customerId);
    }

    // ── COUNT ──────────────────────────────────────────────────

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM customers";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
