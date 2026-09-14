package com.eventsphere.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * Represents an event in EventSphere.
 * Maps to the 'events' table in EventSphereDB.
 */
public class Event {

    private boolean archived;
    public boolean isArchived() { return archived; }
    public void setArchived(boolean archived) { this.archived = archived; }

    private int eventId;
    private String eventName;
    private int categoryId;
    private String categoryName;     // populated by JOIN
    private int customerId;
    private String customerName;     // populated by JOIN
    private Integer managerUserId;
    private String managerName;      // populated by JOIN
    private LocalDate eventDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String location;
    private int guestCount;
    private String requirements;
    private String status;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Event() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getEventId()                         { return eventId; }
    public void setEventId(int eventId)             { this.eventId = eventId; }

    public String getEventName()                    { return eventName; }
    public void setEventName(String eventName)      { this.eventName = eventName; }

    public int getCategoryId()                      { return categoryId; }
    public void setCategoryId(int categoryId)       { this.categoryId = categoryId; }

    public String getCategoryName()                 { return categoryName; }
    public void setCategoryName(String categoryName){ this.categoryName = categoryName; }

    public int getCustomerId()                      { return customerId; }
    public void setCustomerId(int customerId)       { this.customerId = customerId; }

    public String getCustomerName()                 { return customerName; }
    public void setCustomerName(String customerName){ this.customerName = customerName; }

    public Integer getManagerUserId()                       { return managerUserId; }
    public void setManagerUserId(Integer managerUserId)     { this.managerUserId = managerUserId; }

    public String getManagerName()                  { return managerName; }
    public void setManagerName(String managerName)  { this.managerName = managerName; }

    public LocalDate getEventDate()                 { return eventDate; }
    public void setEventDate(LocalDate eventDate)   { this.eventDate = eventDate; }

    public LocalTime getStartTime()                 { return startTime; }
    public void setStartTime(LocalTime startTime)   { this.startTime = startTime; }

    public LocalTime getEndTime()                   { return endTime; }
    public void setEndTime(LocalTime endTime)       { this.endTime = endTime; }

    public String getLocation()                     { return location; }
    public void setLocation(String location)        { this.location = location; }

    public int getGuestCount()                      { return guestCount; }
    public void setGuestCount(int guestCount)       { this.guestCount = guestCount; }

    public String getRequirements()                 { return requirements; }
    public void setRequirements(String requirements){ this.requirements = requirements; }

    public String getStatus()                       { return status; }
    public void setStatus(String status)            { this.status = status; }

    public String getNotes()                        { return notes; }
    public void setNotes(String notes)              { this.notes = notes; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt()                     { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt)       { this.updatedAt = updatedAt; }
}
