package com.eventsphere.model;

import java.time.LocalDateTime;

/**
 * Represents a customer of EventSphere.
 * Maps to the 'customers' table in EventSphereDB.
 */
public class Customer {

    private int customerId;
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private LocalDateTime registeredAt;

    public Customer() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getCustomerId()                      { return customerId; }
    public void setCustomerId(int customerId)       { this.customerId = customerId; }

    public int getUserId()                          { return userId; }
    public void setUserId(int userId)               { this.userId = userId; }

    public String getFullName()                     { return fullName; }
    public void setFullName(String fullName)        { this.fullName = fullName; }

    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }

    public String getPhone()                        { return phone; }
    public void setPhone(String phone)              { this.phone = phone; }

    public String getAddress()                      { return address; }
    public void setAddress(String address)          { this.address = address; }

    public LocalDateTime getRegisteredAt()                    { return registeredAt; }
    public void setRegisteredAt(LocalDateTime registeredAt)   { this.registeredAt = registeredAt; }
}
