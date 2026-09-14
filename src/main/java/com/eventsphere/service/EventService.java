package com.eventsphere.service;

import com.eventsphere.dao.EventDAO;
import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.EventCategory;
import com.eventsphere.model.User;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Service for Event Management (Module 2).
 * Handles event lifecycle business logic.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class EventService {

    private final com.eventsphere.dao.CustomerDAO customerDAO;
    private final com.eventsphere.dao.ResourceDAO resourceDAO;
    private final EventDAO eventDAO;
    private final NotificationDAO notificationDAO;
    private final UserDAO userDAO;

    public EventService(com.eventsphere.dao.CustomerDAO customerDAO, com.eventsphere.dao.ResourceDAO resourceDAO, EventDAO eventDAO,
                        NotificationDAO notificationDAO,
                        UserDAO userDAO) {
        this.customerDAO = customerDAO;
        this.resourceDAO = resourceDAO;
        this.eventDAO         = eventDAO;
        this.notificationDAO  = notificationDAO;
        this.userDAO          = userDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Event> getAllEvents() {
        return eventDAO.findAll();
    }

    public Optional<Event> getEventById(int eventId) {
        return eventDAO.findById(eventId);
    }

    public List<Event> getEventsByCustomerId(int customerId) {
        return eventDAO.findByCustomerId(customerId);
    }

    public List<Event> getEventsByManagerId(int managerUserId) {
        return eventDAO.findByManagerId(managerUserId);
    }

    public List<Event> getEventsByStatus(String status) {
        return eventDAO.findByStatus(status);
    }

    public List<Event> getUpcomingEvents() {
        return eventDAO.findUpcoming();
    }

    public List<Event> searchEvents(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return eventDAO.findAll();
        }
        return eventDAO.search(keyword.trim());
    }

    public List<EventCategory> getAllCategories() {
        return eventDAO.findAllCategories();
    }

    public List<User> getAllManagers() {
        return userDAO.findAllManagers();
    }

    public int getTotalEvents()   { return eventDAO.countAll(); }
    public int getUpcomingCount() { return eventDAO.countUpcoming(); }

    public List<Object[]> getCountByStatus()      { return eventDAO.countByStatus(); }
    public List<Object[]> getCountByMonth(int yr) { return eventDAO.countByMonth(yr); }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Creates a new event (booking request from customer).
     * Returns null on success, error message on failure.
     */
    public String createEvent(Event event) {
        String error = validateEvent(event, true);
        if (error != null) return error;

        event.setStatus("Requested");
        eventDAO.addEvent(event);
        return null;
    }

    /**
     * Creates an event directly by staff (Event Manager).
     */
    public String createEventByManager(Event event) {
        String error = validateEvent(event, true);
        if (error != null) return error;

        if (event.getStatus() == null || event.getStatus().trim().isEmpty()) {
            event.setStatus("Pending");
        }
        eventDAO.addEvent(event);
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates an event and optionally notifies relevant users.
     */
    public String updateEvent(Event event) {
        Event existing = requireEditable(event.getEventId());
        if (event.getCustomerId() != existing.getCustomerId()) return "The event customer cannot be changed after creation.";
        String error = validateEvent(event, false);
        if (error != null) return error;

        eventDAO.updateEvent(event);
        releaseResourcesIfFinished(event.getEventId(), event.getStatus());
        return null;
    }

    /**
     * Confirms a customer's booking request.
     * Changes status from Requested → Confirmed and notifies customer.
     */
    public void confirmBooking(int eventId, int customerUserId) {
        Event event = requireEditable(eventId);
        customerUserId = customerDAO.findById(event.getCustomerId()).orElseThrow().getUserId();
        eventDAO.updateStatus(eventId, "Confirmed");
        notificationDAO.addNotification(customerUserId,
                "Booking Confirmed",
                "Your event booking has been confirmed. We will contact you shortly with next steps.");
    }

    /**
     * Cancels an event and notifies the customer.
     */
    public void cancelEvent(int eventId, int customerUserId) {
        Event event = requireEditable(eventId);
        customerUserId = customerDAO.findById(event.getCustomerId()).orElseThrow().getUserId();
        eventDAO.updateStatus(eventId, "Cancelled");
        releaseResourcesIfFinished(eventId, "Cancelled");
        notificationDAO.addNotification(customerUserId,
                "Event Cancelled",
                "Your event has been cancelled. Please contact us if you have any questions.");
    }

    /**
     * Updates only the event status (e.g., move to Planning, In Progress, Completed).
     */
    public void updateStatus(int eventId, String status) {
        requireEditable(eventId);
        if (status == null || !java.util.Set.of("Requested", "Pending", "Confirmed", "Planning", "In Progress", "Completed", "Cancelled").contains(status))
            throw new IllegalArgumentException("Invalid event status");
        eventDAO.updateStatus(eventId, status);
        releaseResourcesIfFinished(eventId, status);
    }

    private void releaseResourcesIfFinished(int eventId, String status) {
        if ("Cancelled".equals(status) || "Completed".equals(status)) {
            for (var allocation : resourceDAO.findAllocationsByEventId(eventId)) {
                resourceDAO.releaseAllocation(allocation.getAllocationId());
            }
        }
    }

    private Event requireEditable(int eventId) {
        Event event = eventDAO.findById(eventId).orElseThrow();
        if (event.isArchived()) throw new IllegalArgumentException("Restore the archived event before editing it.");
        return event;
    }

    public List<Event> getArchivedEvents() { return eventDAO.findArchived(); }

    public String setArchived(int eventId, boolean archived) {
        return eventDAO.setArchived(eventId, archived) == 1 ? null
                : "Only completed or cancelled events can be archived or restored.";
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteEvent(int eventId) {
        eventDAO.deleteEvent(eventId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateEvent(Event event, boolean creating) {
        if (event.getEventName() == null || event.getEventName().trim().isEmpty()) {
            return "Event name is required.";
        }
        if (event.getCategoryId() <= 0) {
            return "Please select an event category.";
        }
        if (event.getEventDate() == null) {
            return "Event date is required.";
        }
        if (creating && event.getEventDate().isBefore(LocalDate.now())) {
            return "Event date cannot be in the past.";
        }
        if (event.getStartTime() != null && event.getEndTime() != null && !event.getEndTime().isAfter(event.getStartTime()))
            return "End time must be after start time.";
        if (event.getStatus() != null && !java.util.Set.of("Requested", "Pending", "Confirmed", "Planning", "In Progress", "Completed", "Cancelled").contains(event.getStatus()))
            return "Invalid event status.";
        if (event.getGuestCount() <= 0) {
            return "Guest count must be greater than zero.";
        }
        return null;
    }
}
