package com.eventsphere.controller;

import com.eventsphere.model.User;
import com.eventsphere.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * System Administrator functions.
 * Simple user management: view, activate/deactivate, role assignment.
 * Security is kept simple as instructed.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService        adminService;
    private final DashboardService    dashboardService;
    private final NotificationService notificationService;
    private final JdbcTemplate        jdbcTemplate;

    public AdminController(AdminService adminService,
                           DashboardService dashboardService,
                           NotificationService notificationService,
                           JdbcTemplate jdbcTemplate) {
        this.adminService        = adminService;
        this.dashboardService    = dashboardService;
        this.notificationService = notificationService;
        this.jdbcTemplate        = jdbcTemplate;
    }

    private User getUser(HttpSession session) { return (User) session.getAttribute("loggedInUser"); }

    private boolean isAdmin(User user) {
        return user != null && "System Administrator".equals(user.getRoleName());
    }

    // ── ADMIN DASHBOARD ───────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (!isAdmin(user)) return "redirect:/access-denied";

        model.addAttribute("stats",      dashboardService.getStats());
        model.addAttribute("users",      adminService.getAllUsers());
        model.addAttribute("totalUsers", adminService.getTotalUsers());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "admin/dashboard";
    }

    // ── USER LIST ─────────────────────────────────────────────

    @GetMapping("/users")
    public String listUsers(HttpSession session, Model model) {
        User user = getUser(session);
        if (!isAdmin(user)) return "redirect:/access-denied";

        // Fetch all roles for the role-change dropdown
        var roles = jdbcTemplate.query(
                "SELECT role_id, role_name FROM roles ORDER BY role_id",
                (rs, row) -> {
                    int id     = rs.getInt("role_id");
                    String name = rs.getString("role_name");
                    return new int[]{id}; // simplified — use array
                });

        model.addAttribute("users",      adminService.getAllUsers());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));

        // Roles for dropdown
        model.addAttribute("roles", jdbcTemplate.queryForList(
                "SELECT role_id, role_name FROM roles ORDER BY role_id"));
        return "admin/user-list";
    }

    // ── ACTIVATE / DEACTIVATE USER ────────────────────────────

    @PostMapping("/users/toggle/{userId}")
    public String toggleUser(@PathVariable int userId,
                             @RequestParam boolean active,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!isAdmin(user)) return "redirect:/access-denied";

        // Prevent admin from deactivating their own account
        if (userId == user.getUserId()) {
            redirectAttributes.addFlashAttribute("error",
                    "You cannot deactivate your own account.");
            return "redirect:/admin/users";
        }

        adminService.setUserActiveStatus(userId, active);
        redirectAttributes.addFlashAttribute("success",
                "User account " + (active ? "activated" : "deactivated") + ".");
        return "redirect:/admin/users";
    }

    // ── CHANGE ROLE ───────────────────────────────────────────

    @PostMapping("/users/role/{userId}")
    public String changeRole(@PathVariable int userId,
                             @RequestParam int roleId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!isAdmin(user)) return "redirect:/access-denied";

        adminService.changeUserRole(userId, roleId);
        redirectAttributes.addFlashAttribute("success", "User role updated.");
        return "redirect:/admin/users";
    }

    // ── DELETE USER ───────────────────────────────────────────

    @PostMapping("/users/delete/{userId}")
    public String deleteUser(@PathVariable int userId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!isAdmin(user)) return "redirect:/access-denied";

        if (userId == user.getUserId()) {
            redirectAttributes.addFlashAttribute("error",
                    "You cannot delete your own account.");
            return "redirect:/admin/users";
        }

        adminService.deleteUser(userId);
        redirectAttributes.addFlashAttribute("success", "User deleted.");
        return "redirect:/admin/users";
    }
}
