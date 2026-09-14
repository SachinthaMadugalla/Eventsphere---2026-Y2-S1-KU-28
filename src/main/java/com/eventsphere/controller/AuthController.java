package com.eventsphere.controller;

import com.eventsphere.dto.RegistrationDTO;
import com.eventsphere.model.User;
import com.eventsphere.service.AuthService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Handles login, logout and registration requests.
 * Authentication is a common supporting function, not a major module.
 */
@Controller
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    // ── HOME → login redirect ──────────────────────────────────

    @GetMapping("/")
    public String home(HttpSession session) {
        if (session.getAttribute("loggedInUser") != null) {
            return "redirect:/dashboard";
        }
        return "redirect:/login";
    }

    // ── LOGIN ──────────────────────────────────────────────────

    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model,
                            @RequestParam(required = false) String error,
                            @RequestParam(required = false) String logout) {
        if (session.getAttribute("loggedInUser") != null) {
            return "redirect:/dashboard";
        }
        if (error != null)  model.addAttribute("error",   "Invalid username or password.");
        if (logout != null) model.addAttribute("message", "You have been logged out.");
        return "auth/login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session,
                               jakarta.servlet.http.HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        User user = authService.login(username, password);
        if (user == null) {
            redirectAttributes.addFlashAttribute("error",
                    "Invalid username or password, or account is inactive.");
            return "redirect:/login?error";
        }
        request.changeSessionId();
        session.setAttribute("loggedInUser", user);
        session.setAttribute("userId",       user.getUserId());
        session.setAttribute("userRole",     user.getRoleName());
        session.setAttribute("userFullName", user.getFullName());
        return "redirect:/dashboard";
    }

    // ── LOGOUT ─────────────────────────────────────────────────

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?logout";
    }

    // ── REGISTRATION ───────────────────────────────────────────

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("registration", new RegistrationDTO());
        return "auth/register";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute RegistrationDTO dto,
                                  Model model) {
        String error = authService.registerCustomer(dto);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("registration", dto);
            return "auth/register";
        }
        model.addAttribute("success",
                "Account created successfully! You can now log in.");
        model.addAttribute("registration", new RegistrationDTO());
        return "auth/register";
    }

    // ── DASHBOARD ROUTER ───────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";

        return switch (user.getRoleName()) {
            case "Customer"                  -> "redirect:/customer/dashboard";
            case "Event Manager"             -> "redirect:/event/dashboard";
            case "Operations Coordinator"    -> "redirect:/operations/dashboard";
            case "Customer Relations Officer"-> "redirect:/reporting/cro/dashboard";
            case "Finance Manager"           -> "redirect:/finance/dashboard";
            case "Managing Director"         -> "redirect:/reporting/director/dashboard";
            case "System Administrator"      -> "redirect:/admin/dashboard";
            default                          -> "redirect:/login";
        };
    }

    // ── ACCESS DENIED ──────────────────────────────────────────

    @GetMapping("/access-denied")
    public String accessDenied() {
        return "common/access-denied";
    }
}
