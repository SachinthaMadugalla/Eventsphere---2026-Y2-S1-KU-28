package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Represents an external vendor (caterer, decorator, photographer, etc.).
 * Maps to the 'vendors' table in EventSphereDB.
 */
public class Vendor {

    private int vendorId;
    private String vendorName;
    private int vendorCatId;
    private String categoryName;   // populated by JOIN
    private String contactPerson;
    private String phone;
    private String email;
    private String serviceDesc;
    private BigDecimal cost;
    private boolean active;
    private LocalDateTime createdAt;

    public Vendor() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getVendorId()                        { return vendorId; }
    public void setVendorId(int vendorId)           { this.vendorId = vendorId; }

    public String getVendorName()                   { return vendorName; }
    public void setVendorName(String vendorName)    { this.vendorName = vendorName; }

    public int getVendorCatId()                     { return vendorCatId; }
    public void setVendorCatId(int vendorCatId)     { this.vendorCatId = vendorCatId; }

    public String getCategoryName()                 { return categoryName; }
    public void setCategoryName(String categoryName){ this.categoryName = categoryName; }

    public String getContactPerson()                        { return contactPerson; }
    public void setContactPerson(String contactPerson)      { this.contactPerson = contactPerson; }

    public String getPhone()                        { return phone; }
    public void setPhone(String phone)              { this.phone = phone; }

    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }

    public String getServiceDesc()                  { return serviceDesc; }
    public void setServiceDesc(String serviceDesc)  { this.serviceDesc = serviceDesc; }

    public BigDecimal getCost()                     { return cost; }
    public void setCost(BigDecimal cost)            { this.cost = cost; }

    public boolean isActive()                       { return active; }
    public void setActive(boolean active)           { this.active = active; }

    public LocalDateTime getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt)       { this.createdAt = createdAt; }
}
