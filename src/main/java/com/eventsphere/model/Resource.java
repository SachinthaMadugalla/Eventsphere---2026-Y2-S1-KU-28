package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents a physical resource (chairs, tables, projectors, etc.).
 * Maps to the 'resources' table in EventSphereDB.
 */
public class Resource {

    private int resourceId;
    private String resourceName;
    private String category;
    private int totalQuantity;
    private int availableQuantity;
    private String status;
    private String description;
    private boolean active;
    private LocalDateTime createdAt;

    public Resource() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getResourceId()                          { return resourceId; }
    public void setResourceId(int resourceId)           { this.resourceId = resourceId; }

    public String getResourceName()                     { return resourceName; }
    public void setResourceName(String resourceName)    { this.resourceName = resourceName; }

    public String getCategory()                         { return category; }
    public void setCategory(String category)            { this.category = category; }

    public int getTotalQuantity()                           { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity)         { this.totalQuantity = totalQuantity; }

    public int getAvailableQuantity()                           { return availableQuantity; }
    public void setAvailableQuantity(int availableQuantity)     { this.availableQuantity = availableQuantity; }

    public String getStatus()                           { return status; }
    public void setStatus(String status)                { this.status = status; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public boolean isActive()                           { return active; }
    public void setActive(boolean active)               { this.active = active; }

    public LocalDateTime getCreatedAt()                         { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)           { this.createdAt = createdAt; }
}
