package com.eventsphere.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents an operational task for an event.
 * Maps to the 'tasks' table in EventSphereDB.
 */
public class Task {

    private int taskId;
    private int eventId;
    private String eventName;      // populated by JOIN
    private Integer assignedTo;    // staff_id (nullable)
    private String staffName;      // populated by JOIN
    private String title;
    private String description;
    private String priority;       // Low, Medium, High
    private String status;         // Not Started, In Progress, Completed, Cancelled
    private LocalDate startDate;
    private LocalDate dueDate;
    private LocalDateTime completedAt;
    private LocalDateTime createdAt;

    public Task() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getTaskId()                          { return taskId; }
    public void setTaskId(int taskId)               { this.taskId = taskId; }

    public int getEventId()                         { return eventId; }
    public void setEventId(int eventId)             { this.eventId = eventId; }

    public String getEventName()                    { return eventName; }
    public void setEventName(String eventName)      { this.eventName = eventName; }

    public Integer getAssignedTo()                  { return assignedTo; }
    public void setAssignedTo(Integer assignedTo)   { this.assignedTo = assignedTo; }

    public String getStaffName()                    { return staffName; }
    public void setStaffName(String staffName)      { this.staffName = staffName; }

    public String getTitle()                        { return title; }
    public void setTitle(String title)              { this.title = title; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }

    public String getPriority()                     { return priority; }
    public void setPriority(String priority)        { this.priority = priority; }

    public String getStatus()                       { return status; }
    public void setStatus(String status)            { this.status = status; }

    public LocalDate getStartDate()                 { return startDate; }
    public void setStartDate(LocalDate startDate)   { this.startDate = startDate; }

    public LocalDate getDueDate()                   { return dueDate; }
    public void setDueDate(LocalDate dueDate)       { this.dueDate = dueDate; }

    public LocalDateTime getCompletedAt()                   { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt)   { this.completedAt = completedAt; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }

    /**
     * Convenience method: returns true if the task is overdue.
     * A task is overdue if its due date is in the past and
     * it has not been Completed or Cancelled.
     */
    public boolean isOverdue() {
        return dueDate != null
                && dueDate.isBefore(LocalDate.now())
                && !"Completed".equals(status)
                && !"Cancelled".equals(status);
    }
}
