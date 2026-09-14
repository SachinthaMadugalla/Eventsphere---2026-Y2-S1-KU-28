package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents customer feedback for a completed event.
 * Maps to the 'feedback' table in EventSphereDB.
 * Belongs to Module 7 – Reporting & Feedback Management.
 */
public class Feedback {

    private int feedbackId;
    private int eventId;
    private String eventName;       // populated by JOIN
    private int customerId;
    private String customerName;    // populated by JOIN
    private int rating;             // 1 to 5
    private String comment;
    private LocalDateTime submittedDate;
    private String status;          // Active, Moderated
    private String modReason;

    public Feedback() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getFeedbackId()                          { return feedbackId; }
    public void setFeedbackId(int feedbackId)           { this.feedbackId = feedbackId; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public int getCustomerId()                          { return customerId; }
    public void setCustomerId(int customerId)           { this.customerId = customerId; }

    public String getCustomerName()                     { return customerName; }
    public void setCustomerName(String customerName)    { this.customerName = customerName; }

    public int getRating()                              { return rating; }
    public void setRating(int rating)                   { this.rating = rating; }

    public String getComment()                          { return comment; }
    public void setComment(String comment)              { this.comment = comment; }

    public LocalDateTime getSubmittedDate()                     { return submittedDate; }
    public void setSubmittedDate(LocalDateTime submittedDate)   { this.submittedDate = submittedDate; }

    public String getStatus()                           { return status; }
    public void setStatus(String status)                { this.status = status; }

    public String getModReason()                        { return modReason; }
    public void setModReason(String modReason)          { this.modReason = modReason; }
}
