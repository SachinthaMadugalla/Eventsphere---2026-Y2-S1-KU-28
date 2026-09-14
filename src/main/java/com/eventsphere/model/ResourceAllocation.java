package com.eventsphere.model;

import java.time.LocalDate;

/**
 * Represents the allocation of a resource to an event.
 * Maps to the 'resource_allocations' table in EventSphereDB.
 */
public class ResourceAllocation {

    private int allocationId;
    private int eventId;
    private String eventName;      // populated by JOIN
    private int resourceId;
    private String resourceName;   // populated by JOIN
    private int quantity;
    private LocalDate allocatedOn;
    private String notes;

    public ResourceAllocation() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getAllocationId()                        { return allocationId; }
    public void setAllocationId(int allocationId)      { this.allocationId = allocationId; }

    public int getEventId()                            { return eventId; }
    public void setEventId(int eventId)                { this.eventId = eventId; }

    public String getEventName()                       { return eventName; }
    public void setEventName(String eventName)         { this.eventName = eventName; }

    public int getResourceId()                         { return resourceId; }
    public void setResourceId(int resourceId)          { this.resourceId = resourceId; }

    public String getResourceName()                    { return resourceName; }
    public void setResourceName(String resourceName)   { this.resourceName = resourceName; }

    public int getQuantity()                           { return quantity; }
    public void setQuantity(int quantity)              { this.quantity = quantity; }

    public LocalDate getAllocatedOn()                   { return allocatedOn; }
    public void setAllocatedOn(LocalDate allocatedOn)  { this.allocatedOn = allocatedOn; }

    public String getNotes()                           { return notes; }
    public void setNotes(String notes)                 { this.notes = notes; }
}
