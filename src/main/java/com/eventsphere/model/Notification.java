package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents an internal system notification for a user.
 * Maps to the 'notifications' table in EventSphereDB.
 */
public class Notification {

    private int notificationId;
    private int userId;
    private String title;
    private String message;
    private boolean read;
    private LocalDateTime createdAt;

    public Notification() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getNotificationId()                          { return notificationId; }
    public void setNotificationId(int notificationId)       { this.notificationId = notificationId; }

    public int getUserId()                                  { return userId; }
    public void setUserId(int userId)                       { this.userId = userId; }

    public String getTitle()                                { return title; }
    public void setTitle(String title)                      { this.title = title; }

    public String getMessage()                              { return message; }
    public void setMessage(String message)                  { this.message = message; }

    public boolean isRead()                                 { return read; }
    public void setRead(boolean read)                       { this.read = read; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
