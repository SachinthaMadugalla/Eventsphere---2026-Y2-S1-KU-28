package com.eventsphere.service;

import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.TaskDAO;
import com.eventsphere.model.Task;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Service for Task & Operations Management (Module 5).
 * Handles task lifecycle, assignment and overdue detection.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class TaskService {

    private final TaskDAO taskDAO;
    private final NotificationDAO notificationDAO;

    public TaskService(TaskDAO taskDAO, NotificationDAO notificationDAO) {
        this.taskDAO          = taskDAO;
        this.notificationDAO  = notificationDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Task> getAllTasks()             { return taskDAO.findAll(); }
    public List<Task> getOverdueTasks()        { return taskDAO.findOverdue(); }
    public List<Task> getTasksByEvent(int eid) { return taskDAO.findByEventId(eid); }
    public List<Task> getTasksByStaff(int sid) { return taskDAO.findByStaffId(sid); }

    public List<Task> getTasksByStatus(String status) {
        return taskDAO.findByStatus(status);
    }

    public Optional<Task> getTaskById(int taskId) {
        return taskDAO.findById(taskId);
    }

    public int countByStatus(String status)  { return taskDAO.countByStatus(status); }
    public int countOverdue()                { return taskDAO.countOverdue(); }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Creates a new task. Returns null on success, error message on failure.
     */
    public String addTask(Task task) {
        String error = validateTask(task);
        if (error != null) return error;

        if (task.getStatus() == null || task.getStatus().trim().isEmpty()) {
            task.setStatus("Not Started");
        }
        taskDAO.addTask(task);
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a task's full details.
     */
    public String updateTask(Task task) {
        String error = validateTask(task);
        if (error != null) return error;
        taskDAO.updateTask(task);
        taskDAO.updateStatus(task.getTaskId(), task.getStatus());
        return null;
    }

    /**
     * Updates only a task's status.
     */
    public void updateStatus(int taskId, String status) {
        if (status == null || !java.util.Set.of("Not Started", "In Progress", "Completed", "Cancelled").contains(status)) throw new IllegalArgumentException("Invalid task status");
        taskDAO.updateStatus(taskId, status);
    }

    /**
     * Reassigns a task to a different staff member.
     */
    public void reassignTask(int taskId, int staffId) {
        taskDAO.reassignTask(taskId, staffId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteTask(int taskId) {
        taskDAO.deleteTask(taskId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateTask(Task task) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            return "Task title is required.";
        }
        if (task.getEventId() <= 0) {
            return "Please select an event for this task.";
        }
        if (task.getDueDate() == null) {
            return "Due date is required.";
        }
        if (task.getStartDate() != null && task.getDueDate().isBefore(task.getStartDate())) {
            return "Due date cannot be before the start date.";
        }
        if (task.getStatus() != null && !java.util.Set.of("Not Started", "In Progress", "Completed", "Cancelled").contains(task.getStatus()))
            return "Invalid task status.";
        if (task.getPriority() != null && !task.getPriority().isBlank() && !java.util.Set.of("Low", "Medium", "High").contains(task.getPriority()))
            return "Invalid task priority.";
        if (task.getPriority() == null || task.getPriority().trim().isEmpty()) {
            task.setPriority("Medium");
        }
        return null;
    }
}
