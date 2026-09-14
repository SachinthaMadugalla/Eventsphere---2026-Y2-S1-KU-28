package com.eventsphere.controller;

import com.eventsphere.model.Staff;
import com.eventsphere.model.StaffAssignment;
import com.eventsphere.model.User;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import com.eventsphere.service.StaffService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Optional;

/**
 * Module 4 – Staff Management.
 */
@Controller
@RequestMapping("/staff")
public class StaffController {

    private final StaffService        staffService;
    private final EventService        eventService;
    private final NotificationService notificationService;

    public StaffController(StaffService staffService,
                           EventService eventService,
                           NotificationService notificationService) {
        this.staffService        = staffService;
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
    public String listStaff(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("staffList",  staffService.getAllStaff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/staff-list";
    }

    // ── DETAIL ─────────────────────────────────────────────────

    @GetMapping("/detail/{staffId}")
    public String staffDetail(@PathVariable int staffId,
                              HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Staff> opt = staffService.getStaffById(staffId);
        if (opt.isEmpty()) return "redirect:/staff/list";

        model.addAttribute("staff",       opt.get());
        model.addAttribute("assignments", staffService.getAssignmentsByStaff(staffId));
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/staff-detail";
    }

    // ── CREATE ─────────────────────────────────────────────────

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("staff",      new Staff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/staff-form";
    }

    @PostMapping("/create")
    public String createStaff(@ModelAttribute Staff staff,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        String error = staffService.addStaff(staff);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/staff/create";
        }
        redirectAttributes.addFlashAttribute("success", "Staff member added.");
        return "redirect:/staff/list";
    }

    // ── EDIT ───────────────────────────────────────────────────

    @GetMapping("/edit/{staffId}")
    public String editForm(@PathVariable int staffId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Staff> opt = staffService.getStaffById(staffId);
        if (opt.isEmpty()) return "redirect:/staff/list";

        model.addAttribute("staff",      opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/staff-form";
    }

    @PostMapping("/edit/{staffId}")
    public String updateStaff(@PathVariable int staffId,
                              @ModelAttribute Staff staff,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        staff.setStaffId(staffId);
        String error = staffService.updateStaff(staff);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Staff member updated.");
        }
        return "redirect:/staff/list";
    }

    // ── TOGGLE ACTIVE ─────────────────────────────────────────

    @PostMapping("/toggle/{staffId}")
    public String toggleActive(@PathVariable int staffId,
                               @RequestParam boolean active,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        staffService.setActiveStatus(staffId, active);
        redirectAttributes.addFlashAttribute("success",
                "Staff member " + (active ? "activated" : "deactivated") + ".");
        return "redirect:/staff/list";
    }

    // ── DELETE ─────────────────────────────────────────────────

    @PostMapping("/delete/{staffId}")
    public String deleteStaff(@PathVariable int staffId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        staffService.deleteStaff(staffId);
        redirectAttributes.addFlashAttribute("success", "Staff member deleted.");
        return "redirect:/staff/list";
    }

    // ── ASSIGN TO EVENT ───────────────────────────────────────

    @GetMapping("/assign")
    public String assignForm(@RequestParam int eventId,
                             HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("event",      eventService.getEventById(eventId).orElse(null));
        model.addAttribute("staffList",  staffService.getActiveStaff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/staff-assign";
    }

    @PostMapping("/assign")
    public String assignStaff(@RequestParam int eventId,
                              @RequestParam int staffId,
                              @RequestParam(required = false) String roleAtEvent,
                              @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate assignedDate,
                              @RequestParam(required = false) String notes,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        StaffAssignment sa = new StaffAssignment();
        sa.setEventId(eventId);
        sa.setStaffId(staffId);
        sa.setRoleAtEvent(roleAtEvent);
        sa.setAssignedDate(assignedDate);
        sa.setNotes(notes);

        String error = staffService.assignStaffToEvent(sa);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/staff/assign?eventId=" + eventId;
        }
        redirectAttributes.addFlashAttribute("success", "Staff assigned to event.");
        return "redirect:/event/detail/" + eventId;
    }

    @PostMapping("/assign/remove/{assignmentId}")
    public String removeAssignment(@PathVariable int assignmentId,
                                   @RequestParam int eventId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        staffService.removeAssignment(assignmentId);
        redirectAttributes.addFlashAttribute("success", "Staff assignment removed.");
        return "redirect:/event/detail/" + eventId;
    }
}
