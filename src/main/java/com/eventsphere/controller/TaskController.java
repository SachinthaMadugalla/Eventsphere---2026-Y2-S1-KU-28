package com.eventsphere.controller;

import com.eventsphere.model.Task;
import com.eventsphere.model.User;
import com.eventsphere.service.EventService;
import com.eventsphere.service.NotificationService;
import com.eventsphere.service.StaffService;
import com.eventsphere.service.TaskService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

/**
 * Module 5 – Task & Operations Management.
 * Also serves the Operations Coordinator dashboard.
 */
@Controller
public class TaskController {

    private final TaskService         taskService;
    private final EventService        eventService;
    private final StaffService        staffService;
    private final NotificationService notificationService;

    public TaskController(TaskService taskService,
                          EventService eventService,
                          StaffService staffService,
                          NotificationService notificationService) {
        this.taskService         = taskService;
        this.eventService        = eventService;
        this.staffService        = staffService;
        this.notificationService = notificationService;
    }

    private User getUser(HttpSession session) { return (User) session.getAttribute("loggedInUser"); }

    private boolean hasAccess(User user) {
        if (user == null) return false;
        String r = user.getRoleName();
        return "Event Manager".equals(r) || "Managing Director".equals(r)
            || "Operations Coordinator".equals(r) || "System Administrator".equals(r);
    }

    // ── OPERATIONS COORDINATOR DASHBOARD ──────────────────────

    @GetMapping("/operations/dashboard")
    public String opsDashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("upcomingEvents",   eventService.getUpcomingEvents());
        model.addAttribute("staffAssignments", staffService.getAllAssignments());
        model.addAttribute("pendingTasks",     taskService.getTasksByStatus("Not Started"));
        model.addAttribute("inProgressTasks",  taskService.getTasksByStatus("In Progress"));
        model.addAttribute("overdueTasks",     taskService.getOverdueTasks());
        model.addAttribute("pendingCount",     taskService.countByStatus("Not Started"));
        model.addAttribute("overdueCount",     taskService.countOverdue());
        model.addAttribute("unreadCount",      notificationService.countUnread(user.getUserId()));
        return "operations/dashboard";
    }

    // ── TASK LIST ─────────────────────────────────────────────

    @GetMapping("/task/list")
    public String listTasks(HttpSession session, Model model,
                            @RequestParam(required = false) String status,
                            @RequestParam(required = false) String priority,
                            @RequestParam(required = false) Integer eventId) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        if (eventId != null) {
            model.addAttribute("tasks", taskService.getTasksByEvent(eventId));
        } else if (status != null && !status.isEmpty()) {
            model.addAttribute("tasks", taskService.getTasksByStatus(status));
            model.addAttribute("filterStatus", status);
        } else {
            model.addAttribute("tasks", taskService.getAllTasks());
        }

        model.addAttribute("events",      eventService.getAllEvents());
        model.addAttribute("overdueTasks", taskService.getOverdueTasks());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "operations/task-list";
    }

    // ── TASK DETAIL ───────────────────────────────────────────

    @GetMapping("/task/detail/{taskId}")
    public String taskDetail(@PathVariable int taskId,
                             HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Task> opt = taskService.getTaskById(taskId);
        if (opt.isEmpty()) return "redirect:/task/list";

        model.addAttribute("task",        opt.get());
        model.addAttribute("staffList",   staffService.getActiveStaff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "operations/task-detail";
    }

    // ── CREATE TASK ───────────────────────────────────────────

    @GetMapping("/task/create")
    public String createForm(HttpSession session, Model model,
                             @RequestParam(required = false) Integer eventId) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Task task = new Task();
        if (eventId != null) task.setEventId(eventId);

        model.addAttribute("task",        task);
        model.addAttribute("events",      eventService.getAllEvents());
        model.addAttribute("staffList",   staffService.getActiveStaff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "operations/task-form";
    }

    @PostMapping("/task/create")
    public String createTask(@ModelAttribute Task task,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        String error = taskService.addTask(task);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/task/create";
        }
        redirectAttributes.addFlashAttribute("success", "Task created.");
        return "redirect:/task/list";
    }

    // ── EDIT TASK ─────────────────────────────────────────────

    @GetMapping("/task/edit/{taskId}")
    public String editForm(@PathVariable int taskId,
                           HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Task> opt = taskService.getTaskById(taskId);
        if (opt.isEmpty()) return "redirect:/task/list";

        model.addAttribute("task",        opt.get());
        model.addAttribute("events",      eventService.getAllEvents());
        model.addAttribute("staffList",   staffService.getActiveStaff());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "operations/task-form";
    }

    @PostMapping("/task/edit/{taskId}")
    public String updateTask(@PathVariable int taskId,
                             @ModelAttribute Task task,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        task.setTaskId(taskId);
        String error = taskService.updateTask(task);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Task updated.");
        }
        return "redirect:/task/list";
    }

    // ── UPDATE STATUS ─────────────────────────────────────────

    @PostMapping("/task/status/{taskId}")
    public String updateStatus(@PathVariable int taskId,
                               @RequestParam String status,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        taskService.updateStatus(taskId, status);
        redirectAttributes.addFlashAttribute("success", "Task status updated to: " + status);
        return "redirect:/task/detail/" + taskId;
    }

    // ── REASSIGN TASK ─────────────────────────────────────────

    @PostMapping("/task/reassign/{taskId}")
    public String reassignTask(@PathVariable int taskId,
                               @RequestParam int staffId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        taskService.reassignTask(taskId, staffId);
        redirectAttributes.addFlashAttribute("success", "Task reassigned.");
        return "redirect:/task/detail/" + taskId;
    }

    // ── DELETE TASK ───────────────────────────────────────────

    @PostMapping("/task/delete/{taskId}")
    public String deleteTask(@PathVariable int taskId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        taskService.deleteTask(taskId);
        redirectAttributes.addFlashAttribute("success", "Task deleted.");
        return "redirect:/task/list";
    }
}
