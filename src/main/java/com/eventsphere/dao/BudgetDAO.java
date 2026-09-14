package com.eventsphere.dao;

import com.eventsphere.model.Budget;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Budget Management (Module 6 – Finance).
 * All SQL queries are explicitly written here.
 */
@Repository
public class BudgetDAO {

    private final JdbcTemplate jdbcTemplate;

    public BudgetDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Budget> budgetRowMapper = (rs, rowNum) -> {
        Budget b = new Budget();
        b.setBudgetId(rs.getInt("budget_id"));
        b.setEventId(rs.getInt("event_id"));
        b.setEventName(rs.getString("event_name"));
        b.setTotalBudget(rs.getBigDecimal("total_budget"));
        b.setEstimatedCost(rs.getBigDecimal("estimated_cost"));
        b.setActualCost(rs.getBigDecimal("actual_cost"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        b.setUpdatedAt(rs.getTimestamp("updated_at") != null
                ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
        return b;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Creates a new event budget record.
     */
    public int addBudget(Budget budget) {
        String sql =
            "INSERT INTO budgets (event_id, total_budget, estimated_cost, actual_cost, notes) " +
            "VALUES (?, ?, ?, 0, ?)";
        return jdbcTemplate.update(sql,
                budget.getEventId(),
                budget.getTotalBudget(),
                budget.getEstimatedCost(),
                budget.getNotes());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all budgets with their event names.
     */
    public List<Budget> findAll() {
        String sql =
            "SELECT b.budget_id, b.event_id, e.event_name, " +
            "       b.total_budget, b.estimated_cost, b.actual_cost, " +
            "       b.notes, b.created_at, b.updated_at " +
            "FROM budgets b " +
            "JOIN events e ON b.event_id = e.event_id " +
            "ORDER BY b.created_at DESC";
        return jdbcTemplate.query(sql, budgetRowMapper);
    }

    /**
     * Finds the budget for a specific event.
     */
    public Optional<Budget> findByEventId(int eventId) {
        String sql =
            "SELECT b.budget_id, b.event_id, e.event_name, " +
            "       b.total_budget, b.estimated_cost, b.actual_cost, " +
            "       b.notes, b.created_at, b.updated_at " +
            "FROM budgets b " +
            "JOIN events e ON b.event_id = e.event_id " +
            "WHERE b.event_id = ?";
        List<Budget> result = jdbcTemplate.query(sql, budgetRowMapper, eventId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Finds a budget by its primary key.
     */
    public Optional<Budget> findById(int budgetId) {
        String sql =
            "SELECT b.budget_id, b.event_id, e.event_name, " +
            "       b.total_budget, b.estimated_cost, b.actual_cost, " +
            "       b.notes, b.created_at, b.updated_at " +
            "FROM budgets b " +
            "JOIN events e ON b.event_id = e.event_id " +
            "WHERE b.budget_id = ?";
        List<Budget> result = jdbcTemplate.query(sql, budgetRowMapper, budgetId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates budget figures.
     */
    public int updateBudget(Budget budget) {
        String sql =
            "UPDATE budgets SET total_budget = ?, estimated_cost = ?, " +
            "                   actual_cost = ?, notes = ?, updated_at = GETDATE() " +
            "WHERE budget_id = ?";
        return jdbcTemplate.update(sql,
                budget.getTotalBudget(),
                budget.getEstimatedCost(),
                budget.getActualCost(),
                budget.getNotes(),
                budget.getBudgetId());
    }

    /**
     * Recalculates and updates actual_cost as the SUM of all expenses for the event.
     */
    public int recalculateActualCost(int eventId) {
        String sql =
            "UPDATE budgets SET actual_cost = " +
            "    (SELECT ISNULL(SUM(amount), 0) FROM expenses WHERE event_id = ?), " +
            "    updated_at = GETDATE() " +
            "WHERE event_id = ?";
        return jdbcTemplate.update(sql, eventId, eventId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a budget record by ID.
     */
    public int deleteBudget(int budgetId) {
        String sql = "DELETE FROM budgets WHERE budget_id = ?";
        return jdbcTemplate.update(sql, budgetId);
    }
}
