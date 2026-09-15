package com.eventsphere.service;

import com.eventsphere.dao.VenueDAO;
import com.eventsphere.model.Event;
import com.eventsphere.model.EventVenue;
import com.eventsphere.model.Venue;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomerBookingService {
    private final VenueDAO venues;

    private final EventService eventService;
    public CustomerBookingService(VenueDAO venues, EventService eventService) {
        this.venues = venues; this.eventService = eventService;
    }
    public List<Venue> available(LocalDate date, LocalTime start, LocalTime end, int guests) {
        validateSlot(date, start, end, guests);
        return venues.findAllActive().stream().filter(v -> v.getCapacity() >= guests)
            .filter(v -> venues.countVenueConflicts(v.getVenueId(), date, start.toString(), end.toString(), 0) == 0)
            .toList();
    }
    private void validateSlot(LocalDate date, LocalTime start, LocalTime end, int guests) {
        if (date == null || date.isBefore(LocalDate.now())) throw new IllegalArgumentException("Choose today or a future date.");
        if (start == null || end == null || !end.isAfter(start)) throw new IllegalArgumentException("Choose a start and end time. End time must be after start time.");
        if (guests < 1 || guests > 5000) throw new IllegalArgumentException("Guest count must be between 1 and 5000.");
    }
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void book(Event event, int venueId) {
        Venue selected = available(event.getEventDate(), event.getStartTime(), event.getEndTime(), event.getGuestCount())
            .stream().filter(v -> v.getVenueId() == venueId).findFirst()
            .orElseThrow(() -> new IllegalArgumentException("This venue is no longer available for your date, time and guest count. Please choose an available venue."));
        event.setManagerUserId(null); event.setNotes(null); event.setStatus(null); event.setArchived(false);
        event.setLocation(selected.getVenueName() + " - " + selected.getLocation());
        String error = eventService.createEvent(event);
        if (error != null) throw new IllegalArgumentException(error);
        EventVenue reservation = new EventVenue();
        reservation.setEventId(event.getEventId()); reservation.setVenueId(venueId);
        reservation.setAssignedDate(event.getEventDate()); reservation.setStartTime(event.getStartTime()); reservation.setEndTime(event.getEndTime());
        reservation.setNotes("Selected by customer at booking request");
        venues.assignVenueToEvent(reservation);
    }
}
