package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents a payment recorded for an invoice/event.
 * Maps to the 'payments' table in EventSphereDB.
 */
public class Payment {

    private int paymentId;
    private int invoiceId;
    private String invoiceNumber;   // populated by JOIN
    private int eventId;
    private String eventName;       // populated by JOIN
    private int customerId;
    private String customerName;    // populated by JOIN
    private BigDecimal amount;
    private LocalDate paymentDate;
    private String paymentType;     // Deposit, Partial Payment, Full Payment
    private String referenceNo;
    private String notes;
    private Integer recordedBy;
    private String recordedByName;  // populated by JOIN
    private LocalDateTime createdAt;

    public Payment() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getPaymentId()                           { return paymentId; }
    public void setPaymentId(int paymentId)             { this.paymentId = paymentId; }

    public int getInvoiceId()                           { return invoiceId; }
    public void setInvoiceId(int invoiceId)             { this.invoiceId = invoiceId; }

    public String getInvoiceNumber()                        { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber)      { this.invoiceNumber = invoiceNumber; }

    public int getEventId()                             { return eventId; }
    public void setEventId(int eventId)                 { this.eventId = eventId; }

    public String getEventName()                        { return eventName; }
    public void setEventName(String eventName)          { this.eventName = eventName; }

    public int getCustomerId()                          { return customerId; }
    public void setCustomerId(int customerId)           { this.customerId = customerId; }

    public String getCustomerName()                     { return customerName; }
    public void setCustomerName(String customerName)    { this.customerName = customerName; }

    public BigDecimal getAmount()                       { return amount; }
    public void setAmount(BigDecimal amount)            { this.amount = amount; }

    public LocalDate getPaymentDate()                   { return paymentDate; }
    public void setPaymentDate(LocalDate paymentDate)   { this.paymentDate = paymentDate; }

    public String getPaymentType()                      { return paymentType; }
    public void setPaymentType(String paymentType)      { this.paymentType = paymentType; }

    public String getReferenceNo()                      { return referenceNo; }
    public void setReferenceNo(String referenceNo)      { this.referenceNo = referenceNo; }

    public String getNotes()                            { return notes; }
    public void setNotes(String notes)                  { this.notes = notes; }

    public Integer getRecordedBy()                      { return recordedBy; }
    public void setRecordedBy(Integer recordedBy)       { this.recordedBy = recordedBy; }

    public String getRecordedByName()                       { return recordedByName; }
    public void setRecordedByName(String recordedByName)    { this.recordedByName = recordedByName; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
