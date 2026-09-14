package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents a staff member at EventSphere.
 * Maps to the 'staff' table in EventSphereDB.
 */
public class Staff {

    private int staffId;
    private String fullName;
    private String email;
    private String phone;
    private String jobRole;
    private boolean active;
    private LocalDateTime createdAt;

    public Staff() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getStaffId()                         { return staffId; }
    public void setStaffId(int staffId)             { this.staffId = staffId; }

    public String getFullName()                     { return fullName; }
    public void setFullName(String fullName)        { this.fullName = fullName; }

    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }

    public String getPhone()                        { return phone; }
    public void setPhone(String phone)              { this.phone = phone; }

    public String getJobRole()                      { return jobRole; }
    public void setJobRole(String jobRole)          { this.jobRole = jobRole; }

    public boolean isActive()                       { return active; }
    public void setActive(boolean active)           { this.active = active; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
