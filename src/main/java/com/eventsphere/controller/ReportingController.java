package com.eventsphere.controller;

import com.eventsphere.model.*;
import com.eventsphere.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Optional;

/**
 * Module 7 – Reporting & Feedback Management.
 *
 * Security note: customer identity is ALWAYS resolved from the
 * authenticated session. The browser never supplies a customerId
 * that is trusted for feedback or complaint submissions.
 */
@Controller
@RequestMapping("/reporting")
public class ReportingController {

    private final ReportingService    reportingService;
    private final EventService        eventService;
    private final FinanceService      financeService;
    private final VenueService        venueService;
    private final VendorService       vendorService;
    private final StaffService        staffService;
    private final ResourceService     resourceService;
    private final CustomerService     customerService;
    private final NotificationService notificationService;
    private final ActivityLogService  activityLogService;

    public ReportingController(ReportingService reportingService,
                               EventService eventService,
                               FinanceService financeService,
                               VenueService venueService,
                               VendorService vendorService,
                               StaffService staffService,
                               ResourceService resourceService,
                               CustomerService customerService,
                               NotificationService notificationService,
                               ActivityLogService activityLogService) {
        this.reportingService    = reportingService;
        this.eventService        = eventService;
        this.financeService      = financeService;
        this.venueService        = venueService;
        this.vendorService       = vendorService;
        this.staffService        = staffService;
        this.resourceService     = resourceService;
        this.customerService     = customerService;
        this.notificationService = notificationService;
        this.activityLogService  = activityLogService;
    }

    // ── Helpers ───────────────────────────────────────────────

    private User getUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    private boolean hasStaffAccess(User user) {
        if (user == null) return false;
        String r = user.getRoleName();
        return "Event Manager".equals(r)
            || "Managing Director".equals(r)
            || "Customer Relations Officer".equals(r)
            || "Finance Manager".equals(r)
            || "Operations Coordinator".equals(r)
            || "System Administrator".equals(r);
    }

    /**
     * Resolves the customer_id for the currently logged-in customer.
     * Returns -1 if the session user has no linked customer record.
     */
    private int resolveCustomerId(User user) {
        return customerService.getCustomerByUserId(user.getUserId())
                .map(Customer::getCustomerId)
                .orElse(-1);
    }

    // ── REPORTS INDEX ─────────────────────────────────────────

    @GetMapping("/reports")
    public String reportsIndex(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/reports-index";
    }

    // ── EVENT REPORT ──────────────────────────────────────────

    @GetMapping("/reports/events")
    public String eventReport(HttpSession session, Model model,
                              @RequestParam(required = false) String status) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        if (status != null && !status.isEmpty()) {
            model.addAttribute("events", eventService.getEventsByStatus(status));
            model.addAttribute("filterStatus", status);
        } else {
            model.addAttribute("events", eventService.getAllEvents());
        }
        model.addAttribute("statusCounts",  eventService.getCountByStatus());
        model.addAttribute("monthlyCounts", eventService.getCountByMonth(LocalDate.now().getYear()));
        model.addAttribute("unreadCount",   notificationService.countUnread(user.getUserId()));
        return "reporting/report-events";
    }

    // ── FINANCE REPORT ────────────────────────────────────────

    @GetMapping("/reports/finance")
    public String financeReport(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        model.addAttribute("invoices",       financeService.getAllInvoices());
        model.addAttribute("payments",       financeService.getAllPayments());
        model.addAttribute("budgets",        financeService.getAllBudgets());
        model.addAttribute("totalRevenue",   financeService.getTotalRevenue());
        model.addAttribute("totalCollected", financeService.getTotalCollected());
        model.addAttribute("outstanding",    financeService.getTotalOutstanding());
        model.addAttribute("unreadCount",    notificationService.countUnread(user.getUserId()));
        return "reporting/report-finance";
    }

    // ── VENUE USAGE REPORT ────────────────────────────────────

    @GetMapping("/reports/venues")
    public String venueReport(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("assignments", venueService.getAllAssignments());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/report-venues";
    }

    // ── VENDOR USAGE REPORT ───────────────────────────────────

    @GetMapping("/reports/vendors")
    public String vendorReport(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("assignments", vendorService.getAllAssignments());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/report-vendors";
    }

    // ── STAFF ALLOCATION REPORT ───────────────────────────────

    @GetMapping("/reports/staff")
    public String staffReport(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("assignments", staffService.getAllAssignments());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/report-staff";
    }

    // ── RESOURCE USAGE REPORT ─────────────────────────────────

    @GetMapping("/reports/resources")
    public String resourceReport(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("allocations", resourceService.getAllAllocations());
        model.addAttribute("resources",   resourceService.getAllResources());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/report-resources";
    }

    // ── FEEDBACK LIST (staff) ─────────────────────────────────

    @GetMapping("/feedback/list")
    public String feedbackList(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("feedbackList",  reportingService.getAllFeedback());
        model.addAttribute("averageRating", reportingService.getAverageRating());
        model.addAttribute("unreadCount",   notificationService.countUnread(user.getUserId()));
        return "reporting/feedback-list";
    }

    @GetMapping("/feedback/detail/{feedbackId}")
    public String feedbackDetail(@PathVariable int feedbackId,
                                 HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        Optional<Feedback> opt = reportingService.getFeedbackById(feedbackId);
        if (opt.isEmpty()) return "redirect:/reporting/feedback/list";

        model.addAttribute("feedback",    opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/feedback-detail";
    }

    @PostMapping("/feedback/moderate/{feedbackId}")
    public String moderateFeedback(@PathVariable int feedbackId,
                                   @RequestParam String reason,
                                   HttpSession session,
                                   RedirectAttributes ra) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        String error = reportingService.moderateFeedback(feedbackId, reason);
        if (error != null) {
            ra.addFlashAttribute("error", error);
        } else {
            ra.addFlashAttribute("success", "Feedback moderated.");
            activityLogService.log(user.getUserId(),
                    "Moderated feedback #" + feedbackId + ": " + reason,
                    "Feedback", feedbackId);
        }
        return "redirect:/reporting/feedback/list";
    }

    @PostMapping("/feedback/delete/{feedbackId}")
    public String deleteFeedback(@PathVariable int feedbackId,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        reportingService.deleteFeedback(feedbackId);
        ra.addFlashAttribute("success", "Feedback deleted.");
        activityLogService.log(user.getUserId(),
                "Deleted feedback #" + feedbackId, "Feedback", feedbackId);
        return "redirect:/reporting/feedback/list";
    }

    // ── CUSTOMER SUBMIT FEEDBACK ──────────────────────────────
    // Customer identity is resolved from session — NOT from form input.

    @GetMapping("/feedback/submit")
    public String submitFeedbackForm(@RequestParam int eventId,
                                     HttpSession session, Model model) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        // Verify the event exists and is Completed
        Optional<Event> optEvent = eventService.getEventById(eventId);
        if (optEvent.isEmpty()) return "redirect:/customer/bookings";

        Event event = optEvent.get();
        if (!"Completed".equals(event.getStatus())) {
            model.addAttribute("error",
                "Feedback can only be submitted for completed events.");
            return "redirect:/customer/bookings";
        }

        model.addAttribute("event",       event);
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/feedback-form";
    }

    @PostMapping("/feedback/submit")
    public String submitFeedback(@RequestParam int eventId,
                                 @RequestParam int rating,
                                 @RequestParam(required = false) String comment,
                                 HttpSession session,
                                 RedirectAttributes ra) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        // ── Resolve customer from session (never trust browser input) ──
        int customerId = resolveCustomerId(user);
        if (customerId == -1) {
            ra.addFlashAttribute("error", "Customer profile not found.");
            return "redirect:/customer/bookings";
        }

        // Server-side event status validation
        Optional<Event> optEvent = eventService.getEventById(eventId);
        if (optEvent.isEmpty() || !"Completed".equals(optEvent.get().getStatus())) {
            ra.addFlashAttribute("error",
                "Feedback can only be submitted for completed events.");
            return "redirect:/customer/bookings";
        }

        Feedback feedback = new Feedback();
        feedback.setEventId(eventId);
        feedback.setCustomerId(customerId);   // ← from session, not form
        feedback.setRating(rating);
        feedback.setComment(comment);

        String error = reportingService.submitFeedback(feedback);
        if (error != null) {
            ra.addFlashAttribute("error", error);
            return "redirect:/reporting/feedback/submit?eventId=" + eventId;
        }

        activityLogService.log(user.getUserId(),
                "Submitted feedback (rating " + rating + ") for event #" + eventId,
                "Feedback", eventId);
        ra.addFlashAttribute("success", "Thank you for your feedback!");
        return "redirect:/customer/bookings";
    }

    // ── COMPLAINT LIST (staff) ────────────────────────────────

    @GetMapping("/complaint/list")
    public String complaintList(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";
        model.addAttribute("complaints",  reportingService.getAllComplaints());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/complaint-list";
    }

    @GetMapping("/complaint/detail/{complaintId}")
    public String complaintDetail(@PathVariable int complaintId,
                                  HttpSession session, Model model) {
        User user = getUser(session);
        // Staff OR the owning customer may view their own complaint
        if (user == null) return "redirect:/login";

        Optional<Complaint> opt = reportingService.getComplaintById(complaintId);
        if (opt.isEmpty()) return "redirect:/reporting/complaint/list";

        Complaint complaint = opt.get();

        // If customer, verify they own this complaint
        if ("Customer".equals(user.getRoleName())) {
            int cid = resolveCustomerId(user);
            if (complaint.getCustomerId() != cid) return "redirect:/access-denied";
        }

        model.addAttribute("complaint",  complaint);
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/complaint-detail";
    }

    @PostMapping("/complaint/update/{complaintId}")
    public String updateComplaint(@PathVariable int complaintId,
                                  @ModelAttribute Complaint complaint,
                                  HttpSession session,
                                  RedirectAttributes ra) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        complaint.setComplaintId(complaintId);
        String error = reportingService.updateComplaint(complaint);
        if (error != null) {
            ra.addFlashAttribute("error", error);
        } else {
            ra.addFlashAttribute("success", "Complaint updated.");
            activityLogService.log(user.getUserId(),
                    "Updated complaint #" + complaintId + " → " + complaint.getStatus(),
                    "Complaint", complaintId);
        }
        return "redirect:/reporting/complaint/detail/" + complaintId;
    }

    @PostMapping("/complaint/escalate/{complaintId}")
    public String escalateComplaint(@PathVariable int complaintId,
                                    HttpSession session,
                                    RedirectAttributes ra) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        reportingService.escalateComplaint(complaintId);
        ra.addFlashAttribute("success", "Complaint escalated to Managing Director.");
        activityLogService.log(user.getUserId(),
                "Escalated complaint #" + complaintId + " to Managing Director",
                "Complaint", complaintId);
        return "redirect:/reporting/complaint/detail/" + complaintId;
    }

    // ── CUSTOMER SUBMIT COMPLAINT ─────────────────────────────
    // Customer identity resolved from session — NOT from browser form.

    @GetMapping("/complaint/submit")
    public String submitComplaintForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        // Load only events belonging to this customer (for Customer role)
        if ("Customer".equals(user.getRoleName())) {
            int cid = resolveCustomerId(user);
            if (cid != -1) {
                model.addAttribute("events",
                        eventService.getEventsByCustomerId(cid));
            }
        } else {
            model.addAttribute("events", eventService.getAllEvents());
        }

        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "reporting/complaint-form";
    }

    @PostMapping("/complaint/submit")
    public String submitComplaint(@ModelAttribute Complaint complaint,
                                  HttpSession session,
                                  RedirectAttributes ra) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        // ── Resolve customer from session (never trust browser input) ──
        int customerId = resolveCustomerId(user);
        if (customerId == -1) {
            ra.addFlashAttribute("error", "Customer profile not found.");
            return "redirect:/customer/dashboard";
        }

        complaint.setCustomerId(customerId);   // ← from session, not form

        String error = reportingService.submitComplaint(complaint);
        if (error != null) {
            ra.addFlashAttribute("error", error);
            return "redirect:/reporting/complaint/submit";
        }

        activityLogService.log(user.getUserId(),
                "Submitted complaint: " + complaint.getSubject(),
                "Complaint", null);

        // Notify CRO users about the new complaint
        notificationService.send(user.getUserId(),
                "Complaint Submitted",
                "Your complaint '" + complaint.getSubject() +
                "' has been received. We will respond shortly.");

        ra.addFlashAttribute("success",
                "Your complaint has been submitted. We will review it shortly.");
        return "redirect:/customer/dashboard";
    }

    @PostMapping("/complaint/delete/{complaintId}")
    public String deleteComplaint(@PathVariable int complaintId,
                                  HttpSession session,
                                  RedirectAttributes ra) {
        User user = getUser(session);
        if (!hasStaffAccess(user)) return "redirect:/access-denied";

        reportingService.deleteComplaint(complaintId);
        ra.addFlashAttribute("success", "Complaint deleted.");
        return "redirect:/reporting/complaint/list";
    }

    // ── CRO DASHBOARD ─────────────────────────────────────────

    @GetMapping("/cro/dashboard")
    public String croDashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("customers",        customerService.getAllCustomers());
        model.addAttribute("recentComplaints", reportingService.getAllComplaints());
        model.addAttribute("feedbackList",     reportingService.getAllFeedback());
        model.addAttribute("averageRating",    reportingService.getAverageRating());
        model.addAttribute("openComplaints",   reportingService.countOpenComplaints());
        model.addAttribute("unreadCount",      notificationService.countUnread(user.getUserId()));
        return "reporting/cro-dashboard";
    }

    // ── MANAGING DIRECTOR DASHBOARD ───────────────────────────

    @GetMapping("/director/dashboard")
    public String directorDashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        model.addAttribute("totalEvents",         eventService.getTotalEvents());
        model.addAttribute("upcomingEvents",       eventService.getUpcomingEvents());
        model.addAttribute("statusCounts",         eventService.getCountByStatus());
        model.addAttribute("totalRevenue",         financeService.getTotalRevenue());
        model.addAttribute("totalCollected",       financeService.getTotalCollected());
        model.addAttribute("outstanding",          financeService.getTotalOutstanding());
        model.addAttribute("escalatedComplaints",  reportingService.getEscalatedComplaints());
        model.addAttribute("openComplaints",       reportingService.countOpenComplaints());
        model.addAttribute("averageRating",        reportingService.getAverageRating());
        model.addAttribute("unreadCount",          notificationService.countUnread(user.getUserId()));
        return "reporting/director-dashboard";
    }
}
