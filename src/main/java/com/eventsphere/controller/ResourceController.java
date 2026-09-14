package com.eventsphere.controller;

import com.eventsphere.model.Resource;
import com.eventsphere.model.ResourceAllocation;
import com.eventsphere.model.User;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import com.eventsphere.service.ResourceService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Module 4 – Resource Management.
 */
@Controller
@RequestMapping("/resource")
public class ResourceController {

    private final ResourceService     resourceService;
    private final EventService        eventService;
    private final NotificationService notificationService;

    public ResourceController(ResourceService resourceService,
                              EventService eventService,
                              NotificationService notificationService) {
        this.resourceService     = resourceService;
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
    public String listResources(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("resources",  resourceService.getAllResources());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/resource-list";
    }

    // ── DETAIL ─────────────────────────────────────────────────

    @GetMapping("/detail/{resourceId}")
    public String resourceDetail(@PathVariable int resourceId,
                                 HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Resource> opt = resourceService.getResourceById(resourceId);
        if (opt.isEmpty()) return "redirect:/resource/list";

        model.addAttribute("resource",   opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/resource-detail";
    }

    // ── CREATE ─────────────────────────────────────────────────

    @GetMapping("/create")
    public String createForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("resource",   new Resource());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/resource-form";
    }

    @PostMapping("/create")
    public String createResource(@ModelAttribute Resource resource,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        if (resource.getStatus() == null || resource.getStatus().isEmpty()) {
            resource.setStatus("Available");
        }
        String error = resourceService.addResource(resource);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/resource/create";
        }
        redirectAttributes.addFlashAttribute("success", "Resource added.");
        return "redirect:/resource/list";
    }

    // ── EDIT ───────────────────────────────────────────────────

    @GetMapping("/edit/{resourceId}")
    public String editForm(@PathVariable int resourceId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Resource> opt = resourceService.getResourceById(resourceId);
        if (opt.isEmpty()) return "redirect:/resource/list";

        model.addAttribute("resource",   opt.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/resource-form";
    }

    @PostMapping("/edit/{resourceId}")
    public String updateResource(@PathVariable int resourceId,
                                 @ModelAttribute Resource resource,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        resource.setResourceId(resourceId);
        String error = resourceService.updateResource(resource);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Resource updated.");
        }
        return "redirect:/resource/list";
    }

    // ── TOGGLE ACTIVE ─────────────────────────────────────────

    @PostMapping("/toggle/{resourceId}")
    public String toggleActive(@PathVariable int resourceId,
                               @RequestParam boolean active,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        resourceService.setActiveStatus(resourceId, active);
        redirectAttributes.addFlashAttribute("success",
                "Resource " + (active ? "activated" : "deactivated") + ".");
        return "redirect:/resource/list";
    }

    // ── DELETE ─────────────────────────────────────────────────

    @PostMapping("/delete/{resourceId}")
    public String deleteResource(@PathVariable int resourceId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        resourceService.deleteResource(resourceId);
        redirectAttributes.addFlashAttribute("success", "Resource deleted.");
        return "redirect:/resource/list";
    }

    // ── ALLOCATE TO EVENT ─────────────────────────────────────

    @GetMapping("/allocate")
    public String allocateForm(@RequestParam int eventId,
                               HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("event",       eventService.getEventById(eventId).orElse(null));
        model.addAttribute("resources",   resourceService.getActiveResources());
        model.addAttribute("allocations", resourceService.getAllocationsByEvent(eventId));
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "staff-resource/resource-allocate";
    }

    @PostMapping("/allocate")
    public String allocateResource(@RequestParam int eventId,
                                   @RequestParam int resourceId,
                                   @RequestParam int quantity,
                                   @RequestParam(required = false) String notes,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        ResourceAllocation allocation = new ResourceAllocation();
        allocation.setEventId(eventId);
        allocation.setResourceId(resourceId);
        allocation.setQuantity(quantity);
        allocation.setNotes(notes);

        String error = resourceService.allocateResource(allocation);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/resource/allocate?eventId=" + eventId;
        }
        redirectAttributes.addFlashAttribute("success", "Resource allocated to event.");
        return "redirect:/resource/allocate?eventId=" + eventId;
    }

    @PostMapping("/allocate/release/{allocationId}")
    public String releaseAllocation(@PathVariable int allocationId,
                                    @RequestParam int eventId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        resourceService.releaseAllocation(allocationId);
        redirectAttributes.addFlashAttribute("success", "Resource allocation released.");
        return "redirect:/resource/allocate?eventId=" + eventId;
    }
}
