package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents an authenticated user of the EventSphere system.
 * Maps to the 'users' table in EventSphereDB.
 */
public class User {

    private int userId;
    private String username;
    private String passwordHash;
    private String email;
    private String fullName;
    private String phone;
    private int roleId;
    private String roleName;   // populated by JOIN in DAO
    private boolean active;
    private LocalDateTime createdAt;

    public User() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getUserId()                    { return userId; }
    public void setUserId(int userId)         { this.userId = userId; }

    public String getUsername()               { return username; }
    public void setUsername(String username)  { this.username = username; }

    public String getPasswordHash()                       { return passwordHash; }
    public void setPasswordHash(String passwordHash)      { this.passwordHash = passwordHash; }

    public String getEmail()                  { return email; }
    public void setEmail(String email)        { this.email = email; }

    public String getFullName()               { return fullName; }
    public void setFullName(String fullName)  { this.fullName = fullName; }

    public String getPhone()                  { return phone; }
    public void setPhone(String phone)        { this.phone = phone; }

    public int getRoleId()                    { return roleId; }
    public void setRoleId(int roleId)         { this.roleId = roleId; }

    public String getRoleName()               { return roleName; }
    public void setRoleName(String roleName)  { this.roleName = roleName; }

    public boolean isActive()                 { return active; }
    public void setActive(boolean active)     { this.active = active; }

    public LocalDateTime getCreatedAt()                   { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)     { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", username='" + username + "', role='" + roleName + "'}";
    }
}
