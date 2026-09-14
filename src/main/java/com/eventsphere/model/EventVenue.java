package com.eventsphere.model;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * Represents the assignment of a venue to an event.
 * Maps to the 'event_venues' table in EventSphereDB.
 */
public class EventVenue {

    private int eventVenueId;
    private int eventId;
    private String eventName;    // populated by JOIN
    private int venueId;
    private String venueName;    // populated by JOIN
    private LocalDate assignedDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String notes;

    public EventVenue() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getEventVenueId()                        { return eventVenueId; }
    public void setEventVenueId(int eventVenueId)       { this.eventVenueId = eventVenueId; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public int getVenueId()                             { return venueId; }
    public void setVenueId(int venueId)                 { this.venueId = venueId; }

    public String getVenueName()                        { return venueName; }
    public void setVenueName(String venueName)          { this.venueName = venueName; }

    public LocalDate getAssignedDate()                  { return assignedDate; }
    public void setAssignedDate(LocalDate assignedDate) { this.assignedDate = assignedDate; }

    public LocalTime getStartTime()                     { return startTime; }
    public void setStartTime(LocalTime startTime)       { this.startTime = startTime; }

    public LocalTime getEndTime()                       { return endTime; }
    public void setEndTime(LocalTime endTime)           { this.endTime = endTime; }

    public String getNotes()                            { return notes; }
    public void setNotes(String notes)                  { this.notes = notes; }
}
