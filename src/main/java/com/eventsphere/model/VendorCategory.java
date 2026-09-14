package com.eventsphere.model;

/**
 * Represents a vendor category (Catering, Decorators, Photography, etc.).
 * Maps to the 'vendor_categories' table in EventSphereDB.
 */
public class VendorCategory {

    private int vendorCatId;
    private String categoryName;

    public VendorCategory() {}

    public int getVendorCatId()                         { return vendorCatId; }
    public void setVendorCatId(int vendorCatId)         { this.vendorCatId = vendorCatId; }

    public String getCategoryName()                     { return categoryName; }
    public void setCategoryName(String categoryName)    { this.categoryName = categoryName; }
}
