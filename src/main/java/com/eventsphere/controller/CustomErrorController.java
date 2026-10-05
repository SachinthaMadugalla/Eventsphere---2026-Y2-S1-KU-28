package com.eventsphere.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Handles container-level errors (such as 404, 500) and displays a clean error page
 * instead of the fallback Whitelabel Error Page.
 */
@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Object message = request.getAttribute(RequestDispatcher.ERROR_MESSAGE);

        if (status != null) {
            try {
                int statusCode = Integer.parseInt(status.toString());
                if (statusCode == 404) {
                    model.addAttribute("errorMessage", "The requested page was not found.");
                } else if (statusCode == 403) {
                    return "redirect:/access-denied";
                } else {
                    model.addAttribute("errorMessage", (message != null && !message.toString().isBlank())
                            ? message.toString()
                            : "An unexpected error occurred (HTTP " + statusCode + "). Please try again.");
                }
            } catch (NumberFormatException ignored) {
                model.addAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            }
        } else {
            model.addAttribute("errorMessage", "An unexpected error occurred. Please try again.");
        }

        return "common/error";
    }
}
