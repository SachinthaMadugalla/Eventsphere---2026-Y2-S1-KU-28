package com.eventsphere.model;

import java.time.LocalDate;

/**
 * Represents the assignment of a vendor to an event.
 * Maps to the 'event_vendors' table in EventSphereDB.
 */
public class EventVendor {

    private int eventVendorId;
    private int eventId;
    private String eventName;     // populated by JOIN
    private int vendorId;
    private String vendorName;    // populated by JOIN
    private String categoryName;  // populated by JOIN
    private LocalDate serviceDate;
    private String notes;

    public EventVendor() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getEventVendorId()                           { return eventVendorId; }
    public void setEventVendorId(int eventVendorId)         { this.eventVendorId = eventVendorId; }

    public int getEventId()                                 { return eventId; }
    public void setEventId(int eventId)                     { this.eventId = eventId; }

    public String getEventName()                            { return eventName; }
    public void setEventName(String eventName)              { this.eventName = eventName; }

    public int getVendorId()                                { return vendorId; }
    public void setVendorId(int vendorId)                   { this.vendorId = vendorId; }

    public String getVendorName()                           { return vendorName; }
    public void setVendorName(String vendorName)            { this.vendorName = vendorName; }

    public String getCategoryName()                         { return categoryName; }
    public void setCategoryName(String categoryName)        { this.categoryName = categoryName; }

    public LocalDate getServiceDate()                       { return serviceDate; }
    public void setServiceDate(LocalDate serviceDate)       { this.serviceDate = serviceDate; }

    public String getNotes()                                { return notes; }
    public void setNotes(String notes)                      { this.notes = notes; }
}
