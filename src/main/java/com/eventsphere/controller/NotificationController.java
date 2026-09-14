package com.eventsphere.controller;

import com.eventsphere.model.User;
import com.eventsphere.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Handles notification reads and dismissals.
 * Notifications are a common supporting function.
 */
@Controller
@RequestMapping("/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    private User getUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    @GetMapping
    public String viewAll(HttpSession session, Model model) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        notificationService.markAllAsRead(user.getUserId());
        model.addAttribute("notifications", notificationService.getAllForUser(user.getUserId()));
        model.addAttribute("unreadCount", 0);
        return "common/notifications";
    }

    @PostMapping("/read/{notificationId}")
    public String markRead(@PathVariable int notificationId,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        notificationService.markAsRead(notificationId, user.getUserId());
        return "redirect:/notifications";
    }

    @PostMapping("/read-all")
    public String markAllRead(HttpSession session) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        notificationService.markAllAsRead(user.getUserId());
        return "redirect:/notifications";
    }

    @PostMapping("/delete/{notificationId}")
    public String deleteNotification(@PathVariable int notificationId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (user == null) return "redirect:/login";

        notificationService.deleteNotification(notificationId, user.getUserId());
        redirectAttributes.addFlashAttribute("success", "Notification dismissed.");
        return "redirect:/notifications";
    }
}
