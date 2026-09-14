package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents a customer complaint.
 * Maps to the 'complaints' table in EventSphereDB.
 * Belongs to Module 7 – Reporting & Feedback Management.
 */
public class Complaint {

    private int complaintId;
    private Integer eventId;         // nullable
    private String eventName;        // populated by JOIN
    private int customerId;
    private String customerName;     // populated by JOIN
    private String subject;
    private String description;
    private String status;           // Submitted, Under Review, Resolved, Closed
    private String response;
    private boolean escalated;
    private LocalDateTime submittedDate;
    private LocalDateTime updatedDate;

    public Complaint() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getComplaintId()                         { return complaintId; }
    public void setComplaintId(int complaintId)         { this.complaintId = complaintId; }

    public Integer getEventId()                         { return eventId; }
    public void setEventId(Integer eventId)             { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public int getCustomerId()                          { return customerId; }
    public void setCustomerId(int customerId)           { this.customerId = customerId; }

    public String getCustomerName()                     { return customerName; }
    public void setCustomerName(String customerName)    { this.customerName = customerName; }

    public String getSubject()                          { return subject; }
    public void setSubject(String subject)              { this.subject = subject; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public String getStatus()                           { return status; }
    public void setStatus(String status)                { this.status = status; }

    public String getResponse()                         { return response; }
    public void setResponse(String response)            { this.response = response; }

    public boolean isEscalated()                        { return escalated; }
    public void setEscalated(boolean escalated)         { this.escalated = escalated; }

    public LocalDateTime getSubmittedDate()                     { return submittedDate; }
    public void setSubmittedDate(LocalDateTime submittedDate)   { this.submittedDate = submittedDate; }

    public LocalDateTime getUpdatedDate()                   { return updatedDate; }
    public void setUpdatedDate(LocalDateTime updatedDate)   { this.updatedDate = updatedDate; }
}
