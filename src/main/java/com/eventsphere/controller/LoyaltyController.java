package com.eventsphere.controller;

import com.eventsphere.model.User;
import com.eventsphere.service.CustomerService;
import com.eventsphere.service.LoyaltyService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoyaltyController {
    private final LoyaltyService loyalty;
    private final CustomerService customers;
    public LoyaltyController(LoyaltyService loyalty, CustomerService customers) {
        this.loyalty = loyalty; this.customers = customers;
    }
    @GetMapping("/customer/loyalty")
    public String own(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        if (!"Customer".equals(user.getRoleName())) return "redirect:/access-denied";
        var customer = customers.getCustomerByUserId(user.getUserId());
        if (customer.isEmpty()) return "redirect:/access-denied";
        var c = customer.get();
        var entries = loyalty.history(c.getCustomerId());
        model.addAttribute("loyalty", new LoyaltyService.Summary(c.getCustomerId(), c.getFullName(),
            entries.size() * LoyaltyService.POINTS_PER_EVENT));
        model.addAttribute("entries", entries);
        return "customer/loyalty";
    }
    @GetMapping("/customer/loyalty/manage")
    public String manage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        if (!java.util.Set.of("Customer Relations Officer", "System Administrator").contains(user.getRoleName()))
            return "redirect:/access-denied";
        model.addAttribute("loyaltyCustomers", loyalty.customers());
        model.addAttribute("manageLoyalty", true);
        return "customer/loyalty";
    }
}
