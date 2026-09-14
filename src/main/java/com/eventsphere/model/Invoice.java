package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents an invoice issued to a customer for an event.
 * Maps to the 'invoices' table in EventSphereDB.
 */
public class Invoice {

    private int invoiceId;
    private int eventId;
    private String eventName;        // populated by JOIN
    private int customerId;
    private String customerName;     // populated by JOIN
    private String invoiceNumber;
    private BigDecimal totalAmount;
    private LocalDate issuedDate;
    private LocalDate dueDate;
    private String status;           // Pending, Partially Paid, Paid
    private String notes;
    private LocalDateTime createdAt;

    // Calculated fields (not stored in DB)
    private BigDecimal totalPaid;    // sum of payments
    private BigDecimal outstanding;  // totalAmount - totalPaid

    public Invoice() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getInvoiceId()                           { return invoiceId; }
    public void setInvoiceId(int invoiceId)             { this.invoiceId = invoiceId; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public int getCustomerId()                          { return customerId; }
    public void setCustomerId(int customerId)           { this.customerId = customerId; }

    public String getCustomerName()                     { return customerName; }
    public void setCustomerName(String customerName)    { this.customerName = customerName; }

    public String getInvoiceNumber()                        { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber)      { this.invoiceNumber = invoiceNumber; }

    public BigDecimal getTotalAmount()                  { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount)  { this.totalAmount = totalAmount; }

    public LocalDate getIssuedDate()                    { return issuedDate; }
    public void setIssuedDate(LocalDate issuedDate)     { this.issuedDate = issuedDate; }

    public LocalDate getDueDate()                       { return dueDate; }
    public void setDueDate(LocalDate dueDate)           { this.dueDate = dueDate; }

    public String getStatus()                           { return status; }
    public void setStatus(String status)                { this.status = status; }

    public String getNotes()                            { return notes; }
    public void setNotes(String notes)                  { this.notes = notes; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }

    public BigDecimal getTotalPaid()                    { return totalPaid; }
    public void setTotalPaid(BigDecimal totalPaid)      { this.totalPaid = totalPaid; }

    public BigDecimal getOutstanding()                  { return outstanding; }
    public void setOutstanding(BigDecimal outstanding)  { this.outstanding = outstanding; }
}
