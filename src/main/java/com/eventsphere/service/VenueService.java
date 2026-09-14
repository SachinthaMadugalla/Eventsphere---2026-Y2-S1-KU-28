package com.eventsphere.service;

import com.eventsphere.dao.VenueDAO;
import com.eventsphere.model.EventVenue;
import com.eventsphere.model.Venue;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Service for Venue Management (Module 3).
 * Contains venue business logic and conflict detection.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class VenueService {

    private final VenueDAO venueDAO;

    public VenueService(VenueDAO venueDAO) {
        this.venueDAO = venueDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Venue> getAllVenues()        { return venueDAO.findAll(); }
    public List<Venue> getActiveVenues()    { return venueDAO.findAllActive(); }

    public Optional<Venue> getVenueById(int venueId) {
        return venueDAO.findById(venueId);
    }

    public List<EventVenue> getAssignmentsByEvent(int eventId) {
        return venueDAO.findAssignmentsByEventId(eventId);
    }

    public List<EventVenue> getAssignmentsByVenue(int venueId) {
        return venueDAO.findAssignmentsByVenueId(venueId);
    }

    public List<EventVenue> getAllAssignments() {
        return venueDAO.findAllAssignments();
    }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Adds a new venue. Returns null on success, error message on failure.
     */
    public String addVenue(Venue venue) {
        String error = validateVenue(venue);
        if (error != null) return error;
        venueDAO.addVenue(venue);
        return null;
    }

    // ── ASSIGN ─────────────────────────────────────────────────

    /**
     * Assigns a venue to an event with conflict checking.
     *
     * Conflict rule: same venue, same date, overlapping time ranges.
     * Time overlap: startA < endB AND startB < endA
     *
     * Also checks that venue capacity >= event guest count.
     *
     * @return null on success, error message if conflict or invalid
     */
    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.SERIALIZABLE)
    public String assignVenueToEvent(EventVenue ev, int eventGuestCount) {
        if (ev.getAssignedDate() == null) return "Assignment date is required.";
        if (ev.getStartTime() == null) ev.setStartTime(java.time.LocalTime.MIN);
        if (ev.getEndTime() == null) ev.setEndTime(java.time.LocalTime.of(23, 59, 59));
        if (!ev.getEndTime().isAfter(ev.getStartTime())) return "End time must be after start time.";

        // Capacity check
        Optional<Venue> optVenue = venueDAO.findById(ev.getVenueId());
        if (optVenue.isEmpty() || !optVenue.get().isActive()) return "Venue is unavailable.";
        if (optVenue.isPresent()) {
            Venue venue = optVenue.get();
            if (venue.getCapacity() < eventGuestCount) {
                return "Venue capacity (" + venue.getCapacity() +
                       ") is less than the event guest count (" + eventGuestCount + ").";
            }
        }

        // Conflict check
        String startStr = ev.getStartTime() != null ? ev.getStartTime().toString() : "00:00";
        String endStr   = ev.getEndTime()   != null ? ev.getEndTime().toString()   : "23:59";

        int conflicts = venueDAO.countVenueConflicts(
                ev.getVenueId(),
                ev.getAssignedDate(),
                startStr,
                endStr,
                0  // 0 = new assignment, no exclusion needed
        );

        if (conflicts > 0) {
            return "Scheduling conflict: this venue is already booked on " +
                   ev.getAssignedDate() + " during the requested time.";
        }

        venueDAO.assignVenueToEvent(ev);
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates an existing venue.
     */
    public String updateVenue(Venue venue) {
        String error = validateVenue(venue);
        if (error != null) return error;
        venueDAO.updateVenue(venue);
        return null;
    }

    public void setActiveStatus(int venueId, boolean active) {
        venueDAO.setActiveStatus(venueId, active);
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteVenue(int venueId) {
        venueDAO.deleteVenue(venueId);
    }

    public void removeAssignment(int eventVenueId) {
        venueDAO.removeAssignment(eventVenueId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateVenue(Venue venue) {
        if (venue.getVenueName() == null || venue.getVenueName().trim().isEmpty()) {
            return "Venue name is required.";
        }
        if (venue.getLocation() == null || venue.getLocation().trim().isEmpty()) {
            return "Venue location is required.";
        }
        if (venue.getCapacity() <= 0) {
            return "Capacity must be greater than zero.";
        }
        if (venue.getCostPerDay() == null || venue.getCostPerDay().compareTo(BigDecimal.ZERO) < 0) {
            return "Cost per day cannot be negative.";
        }
        return null;
    }
}
