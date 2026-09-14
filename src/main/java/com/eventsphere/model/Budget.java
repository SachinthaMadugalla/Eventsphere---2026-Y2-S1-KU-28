package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Represents the budget record for an event.
 * Maps to the 'budgets' table in EventSphereDB.
 */
public class Budget {

    private int budgetId;
    private int eventId;
    private String eventName;       // populated by JOIN
    private BigDecimal totalBudget;
    private BigDecimal estimatedCost;
    private BigDecimal actualCost;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Budget() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getBudgetId()                        { return budgetId; }
    public void setBudgetId(int budgetId)           { this.budgetId = budgetId; }

    public int getEventId()                         { return eventId; }
    public void setEventId(int eventId)             { this.eventId = eventId; }

    public String getEventName()                    { return eventName; }
    public void setEventName(String eventName)      { this.eventName = eventName; }

    public BigDecimal getTotalBudget()                  { return totalBudget; }
    public void setTotalBudget(BigDecimal totalBudget)  { this.totalBudget = totalBudget; }

    public BigDecimal getEstimatedCost()                    { return estimatedCost; }
    public void setEstimatedCost(BigDecimal estimatedCost)  { this.estimatedCost = estimatedCost; }

    public BigDecimal getActualCost()                   { return actualCost; }
    public void setActualCost(BigDecimal actualCost)    { this.actualCost = actualCost; }

    public String getNotes()                        { return notes; }
    public void setNotes(String notes)              { this.notes = notes; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt()                     { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt)       { this.updatedAt = updatedAt; }

    /** Returns the variance between budget and actual cost */
    public BigDecimal getVariance() {
        if (totalBudget == null || actualCost == null) return BigDecimal.ZERO;
        return totalBudget.subtract(actualCost);
    }
}
