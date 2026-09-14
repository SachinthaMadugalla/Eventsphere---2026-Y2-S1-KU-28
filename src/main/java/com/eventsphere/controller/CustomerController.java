package com.eventsphere.controller;

import com.eventsphere.model.Customer;
import com.eventsphere.model.Event;
import com.eventsphere.model.User;
import com.eventsphere.service.CustomerService;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Module 1 – Customer Management.
 * Handles customer dashboard, profile, bookings, and booking history.
 */
@Controller
@RequestMapping("/customer")
public class CustomerController {

    private final CustomerService customerService;
    private final EventService eventService;
    private final NotificationService notificationService;

    public CustomerController(CustomerService customerService,
                               EventService eventService,
                               NotificationService notificationService) {
        this.customerService     = customerService;
        this.eventService        = eventService;
        this.notificationService = notificationService;
    }

    // ── SECURITY HELPER ───────────────────────────────────────

    private User getLoggedInUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    private boolean isCustomer(User user) {
        return user != null && "Customer".equals(user.getRoleName());
    }

    // ── DASHBOARD ─────────────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        Optional<Customer> optCustomer = customerService.getCustomerByUserId(user.getUserId());
        if (optCustomer.isEmpty()) return "redirect:/login";

        Customer customer = optCustomer.get();
        model.addAttribute("customer",      customer);
        model.addAttribute("events",        eventService.getEventsByCustomerId(customer.getCustomerId()));
        model.addAttribute("notifications", notificationService.getUnreadForUser(user.getUserId()));
        model.addAttribute("unreadCount",   notificationService.countUnread(user.getUserId()));
        return "customer/dashboard";
    }

    // ── PROFILE ────────────────────────────────────────────────

    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        Optional<Customer> opt = customerService.getCustomerByUserId(user.getUserId());
        if (opt.isEmpty()) return "redirect:/dashboard";

        model.addAttribute("customer", opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "customer/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Customer customer,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        Optional<Customer> ownProfile = customerService.getCustomerByUserId(user.getUserId());
        if (!isCustomer(user) || ownProfile.isEmpty()) return "redirect:/access-denied";
        customer.setCustomerId(ownProfile.get().getCustomerId());
        customer.setUserId(user.getUserId());
        String error = customerService.updateCustomer(customer);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Profile updated successfully.");
        }
        return "redirect:/customer/profile";
    }

    // ── BOOKING (Submit Event Request) ─────────────────────────

    @GetMapping("/booking/new")
    public String newBookingForm(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        model.addAttribute("event",      new Event());
        model.addAttribute("categories", eventService.getAllCategories());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "customer/booking-form";
    }

    @PostMapping("/booking/submit")
    public String submitBooking(@ModelAttribute Event event,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        Optional<Customer> optCustomer = customerService.getCustomerByUserId(user.getUserId());
        if (optCustomer.isEmpty()) return "redirect:/login";

        event.setManagerUserId(null);
        event.setNotes(null);
        event.setCustomerId(optCustomer.get().getCustomerId());
        String error = eventService.createEvent(event);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/customer/booking/new";
        }
        redirectAttributes.addFlashAttribute("success",
                "Your booking request has been submitted successfully!");
        return "redirect:/customer/bookings";
    }

    // ── BOOKING LIST ───────────────────────────────────────────

    @GetMapping("/bookings")
    public String myBookings(HttpSession session, Model model,
                             @RequestParam(required = false) String search) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        Optional<Customer> optCustomer = customerService.getCustomerByUserId(user.getUserId());
        if (optCustomer.isEmpty()) return "redirect:/login";

        int customerId = optCustomer.get().getCustomerId();
        model.addAttribute("events",      eventService.getEventsByCustomerId(customerId));
        model.addAttribute("customer",    optCustomer.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "customer/bookings";
    }

    // ── BOOKING DETAIL ─────────────────────────────────────────

    @GetMapping("/booking/{eventId}")
    public String bookingDetail(@PathVariable int eventId,
                                HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        Optional<Event> opt = eventService.getEventById(eventId);
        if (opt.isEmpty()) return "redirect:/customer/bookings";

        if (!ownsEvent(user, opt.get())) return "redirect:/access-denied";
        model.addAttribute("event",      opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "customer/booking-detail";
    }

    // ── CANCEL BOOKING (customer can cancel if Requested/Pending) ─

    @PostMapping("/booking/cancel/{eventId}")
    public String cancelBooking(@PathVariable int eventId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getLoggedInUser(session);
        if (!isCustomer(user)) return "redirect:/login";

        Optional<Event> opt = eventService.getEventById(eventId);
        if (opt.isPresent()) {
            if (!ownsEvent(user, opt.get())) return "redirect:/access-denied";
            String status = opt.get().getStatus();
            if ("Requested".equals(status) || "Pending".equals(status)) {
                eventService.cancelEvent(eventId, user.getUserId());
                redirectAttributes.addFlashAttribute("success", "Booking cancelled.");
            } else {
                redirectAttributes.addFlashAttribute("error",
                        "This booking cannot be cancelled at its current status: " + status);
            }
        }
        return "redirect:/customer/bookings";
    }

    private boolean ownsEvent(User user, Event event) {
        return customerService.getCustomerByUserId(user.getUserId())
                .map(c -> c.getCustomerId() == event.getCustomerId()).orElse(false);
    }

    // ── NOTIFICATIONS ─────────────────────────────────────────

    @GetMapping("/notifications")
    public String notifications(HttpSession session, Model model) {
        User user = getLoggedInUser(session);
        if (user == null) return "redirect:/login";

        notificationService.markAllAsRead(user.getUserId());
        model.addAttribute("notifications", notificationService.getAllForUser(user.getUserId()));
        model.addAttribute("unreadCount", 0);
        return "customer/notifications";
    }
}
