package com.eventsphere.config;

import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.UUID;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;


@Component
public class SessionSecurityFilter extends OncePerRequestFilter {
    private final UserDAO users;
    public SessionSecurityFilter(UserDAO users) { this.users = users; }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return request.getServletPath().startsWith("/static/");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User current = (User) session.getAttribute("loggedInUser");
        if (current != null) {
            User fresh = users.findById(current.getUserId()).orElse(null);
            if (fresh == null || !fresh.isActive()) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            session.setAttribute("loggedInUser", fresh);
            session.setAttribute("userRole", fresh.getRoleName());
            session.setAttribute("userFullName", fresh.getFullName());
        }
        String token = (String) session.getAttribute("csrfToken");
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", token);
        }
        if (!java.util.Set.of("GET", "HEAD", "OPTIONS").contains(request.getMethod())) {
            String supplied = request.getParameter("_csrf");
            if (supplied == null || !MessageDigest.isEqual(token.getBytes(StandardCharsets.UTF_8), supplied.getBytes(StandardCharsets.UTF_8))) {
                response.sendError(403, "The form expired. Reload the page and try again.");
                return;
            }
        }
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("Cache-Control", "no-store");
        chain.doFilter(request, response);
    }
}
