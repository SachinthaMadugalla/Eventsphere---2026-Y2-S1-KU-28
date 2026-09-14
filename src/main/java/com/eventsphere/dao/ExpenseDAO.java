package com.eventsphere.dao;

import com.eventsphere.model.Expense;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * DAO for Expense Management (Module 6 – Finance).
 * All SQL queries are explicitly written here.
 */
@Repository
public class ExpenseDAO {

    private final JdbcTemplate jdbcTemplate;

    public ExpenseDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Expense> expenseRowMapper = (rs, rowNum) -> {
        Expense e = new Expense();
        e.setExpenseId(rs.getInt("expense_id"));
        e.setEventId(rs.getInt("event_id"));
        e.setEventName(rs.getString("event_name"));
        e.setCategory(rs.getString("category"));
        e.setDescription(rs.getString("description"));
        e.setAmount(rs.getBigDecimal("amount"));
        e.setExpenseDate(rs.getDate("expense_date") != null
                ? rs.getDate("expense_date").toLocalDate() : null);
        int recBy = rs.getInt("recorded_by");
        e.setRecordedBy(rs.wasNull() ? null : recBy);
        e.setRecordedByName(rs.getString("recorded_by_name"));
        e.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return e;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Records a new expense for an event.
     */
    public int addExpense(Expense expense) {
        String sql =
            "INSERT INTO expenses (event_id, category, description, amount, expense_date, recorded_by) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                expense.getEventId(),
                expense.getCategory(),
                expense.getDescription(),
                expense.getAmount(),
                expense.getExpenseDate(),
                expense.getRecordedBy());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all expenses.
     */
    public List<Expense> findAll() {
        String sql =
            "SELECT ex.expense_id, ex.event_id, e.event_name, " +
            "       ex.category, ex.description, ex.amount, ex.expense_date, " +
            "       ex.recorded_by, u.full_name AS recorded_by_name, ex.created_at " +
            "FROM expenses ex " +
            "JOIN events e       ON ex.event_id    = e.event_id " +
            "LEFT JOIN users u   ON ex.recorded_by = u.user_id " +
            "ORDER BY ex.expense_date DESC";
        return jdbcTemplate.query(sql, expenseRowMapper);
    }

    /**
     * Returns all expenses for a specific event.
     */
    public List<Expense> findByEventId(int eventId) {
        String sql =
            "SELECT ex.expense_id, ex.event_id, e.event_name, " +
            "       ex.category, ex.description, ex.amount, ex.expense_date, " +
            "       ex.recorded_by, u.full_name AS recorded_by_name, ex.created_at " +
            "FROM expenses ex " +
            "JOIN events e       ON ex.event_id    = e.event_id " +
            "LEFT JOIN users u   ON ex.recorded_by = u.user_id " +
            "WHERE ex.event_id = ? " +
            "ORDER BY ex.expense_date DESC";
        return jdbcTemplate.query(sql, expenseRowMapper, eventId);
    }

    /**
     * Finds an expense by its primary key.
     */
    public Optional<Expense> findById(int expenseId) {
        String sql =
            "SELECT ex.expense_id, ex.event_id, e.event_name, " +
            "       ex.category, ex.description, ex.amount, ex.expense_date, " +
            "       ex.recorded_by, u.full_name AS recorded_by_name, ex.created_at " +
            "FROM expenses ex " +
            "JOIN events e       ON ex.event_id    = e.event_id " +
            "LEFT JOIN users u   ON ex.recorded_by = u.user_id " +
            "WHERE ex.expense_id = ?";
        List<Expense> result = jdbcTemplate.query(sql, expenseRowMapper, expenseId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Calculates the total expenses for a given event.
     */
    public BigDecimal getTotalByEventId(int eventId) {
        String sql =
            "SELECT ISNULL(SUM(amount), 0) FROM expenses WHERE event_id = ?";
        BigDecimal total = jdbcTemplate.queryForObject(sql, BigDecimal.class, eventId);
        return total != null ? total : BigDecimal.ZERO;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates an expense record.
     */
    public int updateExpense(Expense expense) {
        String sql =
            "UPDATE expenses SET category = ?, description = ?, amount = ?, expense_date = ? " +
            "WHERE expense_id = ?";
        return jdbcTemplate.update(sql,
                expense.getCategory(),
                expense.getDescription(),
                expense.getAmount(),
                expense.getExpenseDate(),
                expense.getExpenseId());
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes an expense by ID.
     */
    public int deleteExpense(int expenseId) {
        String sql = "DELETE FROM expenses WHERE expense_id = ?";
        return jdbcTemplate.update(sql, expenseId);
    }
}
