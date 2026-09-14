package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents a simple activity log entry.
 * Maps to the 'activity_logs' table in EventSphereDB.
 * Logs important actions: payments, allocations, status changes.
 */
public class ActivityLog {

    private int logId;
    private Integer userId;       // nullable – system actions have no user
    private String userFullName;  // populated by JOIN
    private String action;        // e.g. "Created event 'Wedding Reception'"
    private String entityType;    // e.g. "Event", "Payment", "Task"
    private Integer entityId;     // PK of the affected record
    private LocalDateTime logTime;

    public ActivityLog() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getLogId()                           { return logId; }
    public void setLogId(int logId)                 { this.logId = logId; }

    public Integer getUserId()                      { return userId; }
    public void setUserId(Integer userId)           { this.userId = userId; }

    public String getUserFullName()                         { return userFullName; }
    public void setUserFullName(String userFullName)        { this.userFullName = userFullName; }

    public String getAction()                       { return action; }
    public void setAction(String action)            { this.action = action; }

    public String getEntityType()                   { return entityType; }
    public void setEntityType(String entityType)    { this.entityType = entityType; }

    public Integer getEntityId()                    { return entityId; }
    public void setEntityId(Integer entityId)       { this.entityId = entityId; }

    public LocalDateTime getLogTime()               { return logTime; }
    public void setLogTime(LocalDateTime logTime)   { this.logTime = logTime; }
}
