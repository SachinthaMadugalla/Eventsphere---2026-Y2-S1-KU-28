package com.eventsphere.dao;

import com.eventsphere.model.Task;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Task & Operations Management (Module 5).
 * All SQL queries are explicitly written here.
 */
@Repository
public class TaskDAO {

    private final JdbcTemplate jdbcTemplate;

    public TaskDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Task> taskRowMapper = (rs, rowNum) -> {
        Task t = new Task();
        t.setTaskId(rs.getInt("task_id"));
        t.setEventId(rs.getInt("event_id"));
        t.setEventName(rs.getString("event_name"));
        int assignedTo = rs.getInt("assigned_to");
        t.setAssignedTo(rs.wasNull() ? null : assignedTo);
        t.setStaffName(rs.getString("staff_name"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setPriority(rs.getString("priority"));
        t.setStatus(rs.getString("status"));
        t.setStartDate(rs.getDate("start_date") != null
                ? rs.getDate("start_date").toLocalDate() : null);
        t.setDueDate(rs.getDate("due_date") != null
                ? rs.getDate("due_date").toLocalDate() : null);
        t.setCompletedAt(rs.getTimestamp("completed_at") != null
                ? rs.getTimestamp("completed_at").toLocalDateTime() : null);
        t.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return t;
    };

    // Base SELECT reused in all task queries
    private static final String BASE_SELECT =
        "SELECT t.task_id, t.event_id, e.event_name, " +
        "       t.assigned_to, s.full_name AS staff_name, " +
        "       t.title, t.description, t.priority, t.status, " +
        "       t.start_date, t.due_date, t.completed_at, t.created_at " +
        "FROM tasks t " +
        "JOIN events e       ON t.event_id    = e.event_id " +
        "LEFT JOIN staff s   ON t.assigned_to = s.staff_id ";

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Creates a new operational task.
     */
    public int addTask(Task task) {
        String sql =
            "INSERT INTO tasks (event_id, assigned_to, title, description, " +
            "                   priority, status, start_date, due_date) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                task.getEventId(),
                task.getAssignedTo(),
                task.getTitle(),
                task.getDescription(),
                task.getPriority(),
                task.getStatus(),
                task.getStartDate(),
                task.getDueDate());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all tasks ordered by due date.
     */
    public List<Task> findAll() {
        String sql = BASE_SELECT + "ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper);
    }

    /**
     * Finds a task by its primary key.
     */
    public Optional<Task> findById(int taskId) {
        String sql = BASE_SELECT + "WHERE t.task_id = ?";
        List<Task> result = jdbcTemplate.query(sql, taskRowMapper, taskId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns all tasks for a specific event.
     */
    public List<Task> findByEventId(int eventId) {
        String sql = BASE_SELECT + "WHERE t.event_id = ? ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper, eventId);
    }

    /**
     * Returns all tasks assigned to a specific staff member.
     */
    public List<Task> findByStaffId(int staffId) {
        String sql = BASE_SELECT + "WHERE t.assigned_to = ? ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper, staffId);
    }

    /**
     * Returns tasks filtered by status.
     */
    public List<Task> findByStatus(String status) {
        String sql = BASE_SELECT + "WHERE t.status = ? ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper, status);
    }

    /**
     * Returns all overdue tasks:
     * due_date < today AND status not Completed/Cancelled.
     */
    public List<Task> findOverdue() {
        String sql = BASE_SELECT +
            "WHERE t.due_date < CAST(GETDATE() AS DATE) " +
            "  AND t.status NOT IN ('Completed', 'Cancelled') " +
            "ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper);
    }

    /**
     * Returns tasks filtered by priority.
     */
    public List<Task> findByPriority(String priority) {
        String sql = BASE_SELECT + "WHERE t.priority = ? ORDER BY t.due_date ASC";
        return jdbcTemplate.query(sql, taskRowMapper, priority);
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates all task fields.
     */
    public int updateTask(Task task) {
        String sql =
            "UPDATE tasks SET event_id = ?, assigned_to = ?, title = ?, " +
            "                 description = ?, priority = ?, status = ?, " +
            "                 start_date = ?, due_date = ? " +
            "WHERE task_id = ?";
        return jdbcTemplate.update(sql,
                task.getEventId(),
                task.getAssignedTo(),
                task.getTitle(),
                task.getDescription(),
                task.getPriority(),
                task.getStatus(),
                task.getStartDate(),
                task.getDueDate(),
                task.getTaskId());
    }

    /**
     * Updates only the task status (and records completion timestamp when needed).
     */
    public int updateStatus(int taskId, String status) {
        if ("Completed".equals(status)) {
            String sql =
                "UPDATE tasks SET status = ?, completed_at = GETDATE() WHERE task_id = ?";
            return jdbcTemplate.update(sql, status, taskId);
        } else {
            String sql = "UPDATE tasks SET status = ? WHERE task_id = ?";
            return jdbcTemplate.update(sql, status, taskId);
        }
    }

    /**
     * Reassigns a task to a different staff member.
     */
    public int reassignTask(int taskId, int staffId) {
        String sql = "UPDATE tasks SET assigned_to = ? WHERE task_id = ?";
        return jdbcTemplate.update(sql, staffId, taskId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a task by ID.
     */
    public int deleteTask(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id = ?";
        return jdbcTemplate.update(sql, taskId);
    }

    // ── COUNT ──────────────────────────────────────────────────

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE status = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, status);
    }

    public int countOverdue() {
        String sql =
            "SELECT COUNT(*) FROM tasks " +
            "WHERE due_date < CAST(GETDATE() AS DATE) " +
            "  AND status NOT IN ('Completed','Cancelled')";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
