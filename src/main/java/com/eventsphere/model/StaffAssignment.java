package com.eventsphere.model;

import java.time.LocalDate;

/**
 * Represents a staff member assigned to an event.
 * Maps to the 'staff_assignments' table in EventSphereDB.
 */
public class StaffAssignment {

    private int assignmentId;
    private int eventId;
    private String eventName;      // populated by JOIN
    private LocalDate eventDate;   // populated by JOIN
    private int staffId;
    private String staffName;      // populated by JOIN
    private String roleAtEvent;
    private LocalDate assignedDate;
    private String notes;

    public StaffAssignment() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getAssignmentId()                        { return assignmentId; }
    public void setAssignmentId(int assignmentId)       { this.assignmentId = assignmentId; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public LocalDate getEventDate()                     { return eventDate; }
    public void setEventDate(LocalDate eventDate)       { this.eventDate = eventDate; }

    public int getStaffId()                             { return staffId; }
    public void setStaffId(int staffId)                 { this.staffId = staffId; }

    public String getStaffName()                        { return staffName; }
    public void setStaffName(String staffName)          { this.staffName = staffName; }

    public String getRoleAtEvent()                      { return roleAtEvent; }
    public void setRoleAtEvent(String roleAtEvent)      { this.roleAtEvent = roleAtEvent; }

    public LocalDate getAssignedDate()                  { return assignedDate; }
    public void setAssignedDate(LocalDate assignedDate) { this.assignedDate = assignedDate; }

    public String getNotes()                            { return notes; }
    public void setNotes(String notes)                  { this.notes = notes; }
}
