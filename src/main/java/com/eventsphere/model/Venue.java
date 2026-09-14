package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Represents a venue available for events.
 * Maps to the 'venues' table in EventSphereDB.
 */
public class Venue {

    private int venueId;
    private String venueName;
    private String location;
    private int capacity;
    private BigDecimal costPerDay;
    private String description;
    private boolean active;
    private LocalDateTime createdAt;

    public Venue() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getVenueId()                         { return venueId; }
    public void setVenueId(int venueId)             { this.venueId = venueId; }

    public String getVenueName()                    { return venueName; }
    public void setVenueName(String venueName)      { this.venueName = venueName; }

    public String getLocation()                     { return location; }
    public void setLocation(String location)        { this.location = location; }

    public int getCapacity()                        { return capacity; }
    public void setCapacity(int capacity)           { this.capacity = capacity; }

    public BigDecimal getCostPerDay()               { return costPerDay; }
    public void setCostPerDay(BigDecimal costPerDay){ this.costPerDay = costPerDay; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }

    public boolean isActive()                       { return active; }
    public void setActive(boolean active)           { this.active = active; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
