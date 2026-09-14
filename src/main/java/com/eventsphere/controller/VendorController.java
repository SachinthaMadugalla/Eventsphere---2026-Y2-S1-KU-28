package com.eventsphere.controller;

import com.eventsphere.model.EventVendor;
import com.eventsphere.model.User;
import com.eventsphere.model.Vendor;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import com.eventsphere.service.VendorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

/**
 * Module 3 – Vendor Management.
 */
@Controller
@RequestMapping("/vendor")
public class VendorController {

    private final VendorService       vendorService;
    private final EventService        eventService;
    private final NotificationService notificationService;

    public VendorController(VendorService vendorService,
                            EventService eventService,
                            NotificationService notificationService) {
        this.vendorService       = vendorService;
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
    public String listVendors(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("vendors",    vendorService.getAllVendors());
        model.addAttribute("categories", vendorService.getAllCategories());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/vendor-list";
    }

    // ── DETAIL ─────────────────────────────────────────────────

    @GetMapping("/detail/{vendorId}")
    public String vendorDetail(@PathVariable int vendorId,
                               HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Vendor> opt = vendorService.getVendorById(vendorId);
        if (opt.isEmpty()) return "redirect:/vendor/list";

        model.addAttribute("vendor",      opt.get());
        model.addAttribute("assignments", vendorService.getAssignmentsByVendor(vendorId));
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/vendor-detail";
    }

    // ── CREATE ─────────────────────────────────────────────────

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("vendor",     new Vendor());
        model.addAttribute("categories", vendorService.getAllCategories());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/vendor-form";
    }

    @PostMapping("/create")
    public String createVendor(@RequestParam String vendorName,
                               @RequestParam int vendorCatId,
                               @RequestParam(required = false) String contactPerson,
                               @RequestParam(required = false) String phone,
                               @RequestParam(required = false) String email,
                               @RequestParam(required = false) String serviceDesc,
                               @RequestParam BigDecimal cost,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Vendor vendor = new Vendor();
        vendor.setVendorName(vendorName);
        vendor.setVendorCatId(vendorCatId);
        vendor.setContactPerson(contactPerson);
        vendor.setPhone(phone);
        vendor.setEmail(email);
        vendor.setServiceDesc(serviceDesc);
        vendor.setCost(cost);

        String error = vendorService.addVendor(vendor);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/vendor/create";
        }
        redirectAttributes.addFlashAttribute("success", "Vendor added successfully.");
        return "redirect:/vendor/list";
    }

    // ── EDIT ───────────────────────────────────────────────────

    @GetMapping("/edit/{vendorId}")
    public String editForm(@PathVariable int vendorId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Vendor> opt = vendorService.getVendorById(vendorId);
        if (opt.isEmpty()) return "redirect:/vendor/list";

        model.addAttribute("vendor",     opt.get());
        model.addAttribute("categories", vendorService.getAllCategories());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/vendor-form";
    }

    @PostMapping("/edit/{vendorId}")
    public String updateVendor(@PathVariable int vendorId,
                               @RequestParam String vendorName,
                               @RequestParam int vendorCatId,
                               @RequestParam(required = false) String contactPerson,
                               @RequestParam(required = false) String phone,
                               @RequestParam(required = false) String email,
                               @RequestParam(required = false) String serviceDesc,
                               @RequestParam BigDecimal cost,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Vendor vendor = new Vendor();
        vendor.setVendorId(vendorId);
        vendor.setVendorName(vendorName);
        vendor.setVendorCatId(vendorCatId);
        vendor.setContactPerson(contactPerson);
        vendor.setPhone(phone);
        vendor.setEmail(email);
        vendor.setServiceDesc(serviceDesc);
        vendor.setCost(cost);

        String error = vendorService.updateVendor(vendor);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Vendor updated.");
        }
        return "redirect:/vendor/list";
    }

    // ── TOGGLE ACTIVE ─────────────────────────────────────────

    @PostMapping("/toggle/{vendorId}")
    public String toggleActive(@PathVariable int vendorId,
                               @RequestParam boolean active,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        vendorService.setActiveStatus(vendorId, active);
        redirectAttributes.addFlashAttribute("success",
                "Vendor " + (active ? "activated" : "deactivated") + ".");
        return "redirect:/vendor/list";
    }

    // ── DELETE ─────────────────────────────────────────────────

    @PostMapping("/delete/{vendorId}")
    public String deleteVendor(@PathVariable int vendorId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        vendorService.deleteVendor(vendorId);
        redirectAttributes.addFlashAttribute("success", "Vendor deleted.");
        return "redirect:/vendor/list";
    }

    // ── ASSIGN TO EVENT ───────────────────────────────────────

    @GetMapping("/assign")
    public String assignForm(@RequestParam int eventId,
                             HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("event",      eventService.getEventById(eventId).orElse(null));
        model.addAttribute("vendors",    vendorService.getActiveVendors());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "venue-vendor/vendor-assign";
    }

    @PostMapping("/assign")
    public String assignVendor(@RequestParam int eventId,
                               @RequestParam int vendorId,
                               @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate serviceDate,
                               @RequestParam(required = false) String notes,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        EventVendor ev = new EventVendor();
        ev.setEventId(eventId);
        ev.setVendorId(vendorId);
        ev.setServiceDate(serviceDate);
        ev.setNotes(notes);

        String error = vendorService.assignVendorToEvent(ev);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/vendor/assign?eventId=" + eventId;
        }
        redirectAttributes.addFlashAttribute("success", "Vendor assigned to event.");
        return "redirect:/event/detail/" + eventId;
    }

    @PostMapping("/assign/remove/{eventVendorId}")
    public String removeAssignment(@PathVariable int eventVendorId,
                                   @RequestParam int eventId,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        vendorService.removeAssignment(eventVendorId);
        redirectAttributes.addFlashAttribute("success", "Vendor assignment removed.");
        return "redirect:/event/detail/" + eventId;
    }
}
