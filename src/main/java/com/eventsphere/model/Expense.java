package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents an expense recorded for an event.
 * Maps to the 'expenses' table in EventSphereDB.
 */
public class Expense {

    private int expenseId;
    private int eventId;
    private String eventName;       // populated by JOIN
    private String category;
    private String description;
    private BigDecimal amount;
    private LocalDate expenseDate;
    private Integer recordedBy;     // user_id
    private String recordedByName;  // populated by JOIN
    private LocalDateTime createdAt;

    public Expense() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getExpenseId()                           { return expenseId; }
    public void setExpenseId(int expenseId)             { this.expenseId = expenseId; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public String getCategory()                         { return category; }
    public void setCategory(String category)            { this.category = category; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public BigDecimal getAmount()                       { return amount; }
    public void setAmount(BigDecimal amount)            { this.amount = amount; }

    public LocalDate getExpenseDate()                   { return expenseDate; }
    public void setExpenseDate(LocalDate expenseDate)   { this.expenseDate = expenseDate; }

    public Integer getRecordedBy()                      { return recordedBy; }
    public void setRecordedBy(Integer recordedBy)       { this.recordedBy = recordedBy; }

    public String getRecordedByName()                       { return recordedByName; }
    public void setRecordedByName(String recordedByName)    { this.recordedByName = recordedByName; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
