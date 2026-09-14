package com.eventsphere.controller;

import com.eventsphere.model.Event;
import com.eventsphere.model.User;
import com.eventsphere.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Optional;

/**
 * Module 2 – Event Management.
 * Accessible by Event Manager, Managing Director and Operations Coordinator.
 */
@Controller
@RequestMapping("/event")
public class EventController {

    private final EventService        eventService;
    private final CustomerService     customerService;
    private final VenueService        venueService;
    private final VendorService       vendorService;
    private final StaffService        staffService;
    private final NotificationService notificationService;

    public EventController(EventService eventService,
                           CustomerService customerService,
                           VenueService venueService,
                           VendorService vendorService,
                           StaffService staffService,
                           NotificationService notificationService) {
        this.eventService        = eventService;
        this.customerService     = customerService;
        this.venueService        = venueService;
        this.vendorService       = vendorService;
        this.staffService        = staffService;
        this.notificationService = notificationService;
    }

    // ── SECURITY HELPER ───────────────────────────────────────

    private User getUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    private boolean hasAccess(User user) {
        if (user == null) return false;
        String role = user.getRoleName();
        return "Event Manager".equals(role)
            || "Managing Director".equals(role)
            || "Operations Coordinator".equals(role)
            || "System Administrator".equals(role);
    }

    // ── DASHBOARD ─────────────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("upcomingEvents", eventService.getUpcomingEvents());
        model.addAttribute("requestedEvents", eventService.getEventsByStatus("Requested"));
        model.addAttribute("confirmedEvents", eventService.getEventsByStatus("Confirmed"));
        model.addAttribute("totalEvents",    eventService.getTotalEvents());
        model.addAttribute("upcomingCount",  eventService.getUpcomingCount());
        model.addAttribute("statusCounts",   eventService.getCountByStatus());
        model.addAttribute("monthlyCounts",  eventService.getCountByMonth(LocalDate.now().getYear()));
        model.addAttribute("unreadCount",    notificationService.countUnread(user.getUserId()));
        return "event/dashboard";
    }

    // ── LIST ───────────────────────────────────────────────────

    @GetMapping("/list")
    public String listEvents(HttpSession session, Model model,
                             @RequestParam(required = false) String search,
                             @RequestParam(required = false) String status) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        if (search != null && !search.trim().isEmpty()) {
            model.addAttribute("events", eventService.searchEvents(search));
            model.addAttribute("search", search);
        } else if (status != null && !status.trim().isEmpty()) {
            model.addAttribute("events", eventService.getEventsByStatus(status));
            model.addAttribute("filterStatus", status);
        } else {
            model.addAttribute("events", eventService.getAllEvents());
        }
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "event/list";
    }

    // ── DETAIL ─────────────────────────────────────────────────

    @GetMapping("/archive")
    public String archivedEvents(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";
        model.addAttribute("events", eventService.getArchivedEvents());
        model.addAttribute("archiveView", true);
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "event/list";
    }

    @PostMapping("/archive/{eventId}")
    public String archiveEvent(@PathVariable int eventId, @RequestParam boolean archived,
                               HttpSession session, RedirectAttributes flash) {
        if (!hasAccess(getUser(session))) return "redirect:/access-denied";
        String error = eventService.setArchived(eventId, archived);
        flash.addFlashAttribute(error == null ? "success" : "error",
                error == null ? (archived ? "Event archived. History is preserved." : "Event restored.") : error);
        return archived ? "redirect:/event/list" : "redirect:/event/archive";
    }

    @GetMapping("/detail/{eventId}")
    public String eventDetail(@PathVariable int eventId,
                              HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Event> opt = eventService.getEventById(eventId);
        if (opt.isEmpty()) return "redirect:/event/list";

        model.addAttribute("event",           opt.get());
        model.addAttribute("venueAssignments", venueService.getAssignmentsByEvent(eventId));
        model.addAttribute("vendorAssignments",vendorService.getAssignmentsByEvent(eventId));
        model.addAttribute("staffAssignments", staffService.getAssignmentsByEvent(eventId));
        model.addAttribute("unreadCount",      notificationService.countUnread(user.getUserId()));
        return "event/detail";
    }

    // ── CREATE ─────────────────────────────────────────────────

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("event",       new Event());
        model.addAttribute("categories",  eventService.getAllCategories());
        model.addAttribute("customers",   customerService.getAllCustomers());
        model.addAttribute("managers",    eventService.getAllManagers());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "event/form";
    }

    @PostMapping("/create")
    public String createEvent(@ModelAttribute Event event,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        String error = eventService.createEventByManager(event);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/event/create";
        }
        redirectAttributes.addFlashAttribute("success", "Event created successfully.");
        return "redirect:/event/list";
    }

    // ── EDIT ───────────────────────────────────────────────────

    @GetMapping("/edit/{eventId}")
    public String editForm(@PathVariable int eventId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Event> opt = eventService.getEventById(eventId);
        if (opt.isEmpty()) return "redirect:/event/list";

        model.addAttribute("event",      opt.get());
        model.addAttribute("categories", eventService.getAllCategories());
        model.addAttribute("customers",  customerService.getAllCustomers());
        model.addAttribute("managers",   eventService.getAllManagers());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "event/form";
    }

    @PostMapping("/edit/{eventId}")
    public String updateEvent(@PathVariable int eventId,
                              @ModelAttribute Event event,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        event.setEventId(eventId);
        String error = eventService.updateEvent(event);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/event/edit/" + eventId;
        }
        redirectAttributes.addFlashAttribute("success", "Event updated successfully.");
        return "redirect:/event/detail/" + eventId;
    }

    // ── STATUS UPDATE ─────────────────────────────────────────

    @PostMapping("/status/{eventId}")
    public String updateStatus(@PathVariable int eventId,
                               @RequestParam String status,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        eventService.updateStatus(eventId, status);
        redirectAttributes.addFlashAttribute("success",
                "Event status updated to: " + status);
        return "redirect:/event/detail/" + eventId;
    }

    // ── CONFIRM BOOKING ───────────────────────────────────────

    @PostMapping("/confirm/{eventId}")
    public String confirmBooking(@PathVariable int eventId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        eventService.confirmBooking(eventId, 0);
        redirectAttributes.addFlashAttribute("success", "Booking confirmed and customer notified.");
        return "redirect:/event/detail/" + eventId;
    }

    // ── DELETE ─────────────────────────────────────────────────

    @PostMapping("/delete/{eventId}")
    public String deleteEvent(@PathVariable int eventId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        eventService.deleteEvent(eventId);
        redirectAttributes.addFlashAttribute("success", "Event deleted.");
        return "redirect:/event/list";
    }
}
