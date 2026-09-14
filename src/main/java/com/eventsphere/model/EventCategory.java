package com.eventsphere.model;

/**
 * Represents an event category (Wedding, Birthday, Corporate, etc.).
 * Maps to the 'event_categories' table in EventSphereDB.
 */
public class EventCategory {

    private int categoryId;
    private String categoryName;
    private String description;

    public EventCategory() {}

    public int getCategoryId()                      { return categoryId; }
    public void setCategoryId(int categoryId)       { this.categoryId = categoryId; }

    public String getCategoryName()                 { return categoryName; }
    public void setCategoryName(String categoryName){ this.categoryName = categoryName; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }
}
