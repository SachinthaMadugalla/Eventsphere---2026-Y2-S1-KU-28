package com.eventsphere.controller;

import com.eventsphere.model.EventVenue;
import com.eventsphere.model.User;
import com.eventsphere.model.Venue;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import com.eventsphere.service.VenueService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

/**
 * Module 3 – Venue Management.
 */
@Controller
@RequestMapping("/venue")
public class VenueController {

    private final VenueService        venueService;
    private final EventService        eventService;
    private final NotificationService notificationService;

    public VenueController(VenueService venueService,
                           EventService eventService,
                           NotificationService notificationService) {
        this.venueService        = venueService;
        this.eventService        = eventService;
        this.notificationService = notificationService;
    }

    private User getUser(HttpSession session) { return (User) session.getAttribute("loggedInUser"); }

    private boolean hasAccess(User user) {
        if (user == null) return false;
        String r = user.getRoleName();
        return "Event Manager".equals(r) || "Managing Director".equals(r)
            || "Operations Coordinator".equals(r) || "System Administrator".equals(r);
    }

    // ── LIST ───────────────────────────────────────────────────

    @GetMapping("/list")
    public String listVenues(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("venues",     venueService.getAllVenues());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/venue-list";
    }

    // ── DETAIL ─────────────────────────────────────────────────

    @GetMapping("/detail/{venueId}")
    public String venueDetail(@PathVariable int venueId,
                              HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Venue> opt = venueService.getVenueById(venueId);
        if (opt.isEmpty()) return "redirect:/venue/list";

        model.addAttribute("venue",       opt.get());
        model.addAttribute("assignments", venueService.getAssignmentsByVenue(venueId));
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/venue-detail";
    }

    // ── CREATE ─────────────────────────────────────────────────

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("venue",      new Venue());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/venue-form";
    }

    @PostMapping("/create")
    public String createVenue(@RequestParam String venueName,
                              @RequestParam String location,
                              @RequestParam int capacity,
                              @RequestParam BigDecimal costPerDay,
                              @RequestParam(required = false) String description,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Venue venue = new Venue();
        venue.setVenueName(venueName);
        venue.setLocation(location);
        venue.setCapacity(capacity);
        venue.setCostPerDay(costPerDay);
        venue.setDescription(description);

        String error = venueService.addVenue(venue);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/venue/create";
        }
        redirectAttributes.addFlashAttribute("success", "Venue added successfully.");
        return "redirect:/venue/list";
    }

    // ── EDIT ───────────────────────────────────────────────────

    @GetMapping("/edit/{venueId}")
    public String editForm(@PathVariable int venueId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Venue> opt = venueService.getVenueById(venueId);
        if (opt.isEmpty()) return "redirect:/venue/list";

        model.addAttribute("venue",      opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/venue-form";
    }

    @PostMapping("/edit/{venueId}")
    public String updateVenue(@PathVariable int venueId,
                              @RequestParam String venueName,
                              @RequestParam String location,
                              @RequestParam int capacity,
                              @RequestParam BigDecimal costPerDay,
                              @RequestParam(required = false) String description,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Venue venue = new Venue();
        venue.setVenueId(venueId);
        venue.setVenueName(venueName);
        venue.setLocation(location);
        venue.setCapacity(capacity);
        venue.setCostPerDay(costPerDay);
        venue.setDescription(description);

        String error = venueService.updateVenue(venue);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Venue updated successfully.");
        }
        return "redirect:/venue/list";
    }

    // ── DEACTIVATE / ACTIVATE ─────────────────────────────────

    @PostMapping("/toggle/{venueId}")
    public String toggleStatus(@PathVariable int venueId,
                               @RequestParam boolean active,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        venueService.setActiveStatus(venueId, active);
        redirectAttributes.addFlashAttribute("success",
                "Venue " + (active ? "activated" : "deactivated") + ".");
        return "redirect:/venue/list";
    }

    // ── DELETE ─────────────────────────────────────────────────

    @PostMapping("/delete/{venueId}")
    public String deleteVenue(@PathVariable int venueId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        venueService.deleteVenue(venueId);
        redirectAttributes.addFlashAttribute("success", "Venue deleted.");
        return "redirect:/venue/list";
    }

    // ── ASSIGN TO EVENT ───────────────────────────────────────

    @GetMapping("/assign")
    public String assignForm(@RequestParam int eventId,
                             HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("event",       eventService.getEventById(eventId).orElse(null));
        model.addAttribute("venues",      venueService.getActiveVenues());
        model.addAttribute("eventVenue",  new EventVenue());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/venue-assign";
    }

    @PostMapping("/assign")
    public String assignVenue(@RequestParam int eventId,
                              @RequestParam int venueId,
                              @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate assignedDate,
                              @RequestParam(required = false) String startTime,
                              @RequestParam(required = false) String endTime,
                              @RequestParam(required = false) String notes,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        EventVenue ev = new EventVenue();
        ev.setEventId(eventId);
        ev.setVenueId(venueId);
        ev.setAssignedDate(assignedDate);
        ev.setStartTime(startTime != null && !startTime.isEmpty() ? LocalTime.parse(startTime) : null);
        ev.setEndTime(endTime   != null && !endTime.isEmpty()   ? LocalTime.parse(endTime)   : null);
        ev.setNotes(notes);

        int guestCount = eventService.getEventById(eventId)
                .map(e -> e.getGuestCount()).orElse(0);

        String error = venueService.assignVenueToEvent(ev, guestCount);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/venue/assign?eventId=" + eventId;
        }
        redirectAttributes.addFlashAttribute("success", "Venue assigned to event.");
        return "redirect:/event/detail/" + eventId;
    }

    @PostMapping("/assign/remove/{eventVenueId}")
    public String removeAssignment(@PathVariable int eventVenueId,
                                   @RequestParam int eventId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        venueService.removeAssignment(eventVenueId);
        redirectAttributes.addFlashAttribute("success", "Venue assignment removed.");
        return "redirect:/event/detail/" + eventId;
    }
}
