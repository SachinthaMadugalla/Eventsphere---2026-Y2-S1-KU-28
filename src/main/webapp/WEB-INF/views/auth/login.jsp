<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EventSphere</title>
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/eventsphere.css?v=10">
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/login.css?v=10">
</head>
<body class="landing-body">
<div class="landing-wrapper">
    <main class="auth-page login-page" id="home">
    <div class="auth-box">
        <div class="auth-logo">
            <h1>Event<span>Sphere</span></h1>
            <p>Every detail. Every moment.</p>
        </div>

        <div class="login-heading">
            <p class="login-eyebrow">YOUR NEXT GREAT EVENT STARTS HERE</p>
            <h2>Welcome back.</h2>
            <p>Log in to bring your next event to life.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="es-alert es-alert-error">${fn:escapeXml(error)}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="es-alert es-alert-success">${fn:escapeXml(message)}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="es-alert es-alert-error">Invalid username or password, or account is inactive.</div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="es-alert es-alert-success">You have been logged out successfully.</div>
        </c:if>

        <form action="${fn:escapeXml(pageContext.request.contextPath)}/login" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="es-input" autocomplete="username"
                       placeholder="Enter your username" required>
            </div>
            <div class="es-form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="es-input" autocomplete="current-password"
                       placeholder="Enter your password" required>
            </div>
            <div class="login-submit">
                <button type="submit" class="btn btn-primary">
                    Log in <span aria-hidden="true">&rarr;</span>
                </button>
            </div>
        </form>

        <div class="login-register">
            New customer?
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/register">
                Create an account
            </a>
        </div>

        <div class="login-footer">
            PLAN SIMPLY. CELEBRATE BEAUTIFULLY.
        </div>
    </div>
    <section class="login-story" aria-label="EventSphere event planning">
        <p class="login-story-tag"><span aria-hidden="true"></span> MADE FOR MEMORABLE MOMENTS</p>
        <h2>Great events.<br>Beautifully<br><em>orchestrated.</em></h2>
        <p>From the first idea to the final applause.<br>Your events, together in one place.</p>
        <div class="login-story-footer">EventSphere <span aria-hidden="true">/</span> Event Planning System</div>
    </section>
</main>

<!-- GALLERY SECTION -->
<section class="landing-section gallery-section alt-bg" id="gallery">
    <div class="landing-container gallery-header">
        <span class="section-tag"><span></span> Our Portfolio</span>
        <h2 class="section-title">Moments We've Crafted</h2>
        <p class="section-subtitle">A glimpse into the unforgettable experiences beautifully orchestrated by EventSphere's premium vendor network.</p>
        
        <div class="gallery-grid">
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/static/images/wedding_event.jpg" alt="Elegant Wedding Event">
                <div class="gallery-overlay">
                    <h3>Elegant Weddings</h3>
                    <p>Creating magical beginnings</p>
                </div>
            </div>
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/static/images/corporate_event.jpg" alt="Corporate Conference">
                <div class="gallery-overlay">
                    <h3>Corporate Summits</h3>
                    <p>Professional tech & business forums</p>
                </div>
            </div>
            <div class="gallery-item">
                <img src="${pageContext.request.contextPath}/static/images/party_event.jpg" alt="Music Festival">
                <div class="gallery-overlay">
                    <h3>Music Festivals</h3>
                    <p>High-energy outdoor celebrations</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ABOUT US SECTION -->
<section class="landing-section about-section" id="about">
    <div class="landing-container">
        <div class="about-grid">
            <div class="about-text">
                <span class="section-tag"><span></span> The Standard</span>
                <h2 class="section-title">About EventSphere</h2>
                <p>Welcome to EventSphere, Sri Lanka's premier event management platform. We believe that every gathering, whether it's an intimate wedding or a massive corporate summit, deserves flawless execution.</p>
                <p>Our comprehensive system brings together the best venues, the most talented vendors, and world-class management tools to ensure your next event is orchestrated beautifully from the first idea to the final applause.</p>
                <ul class="about-features">
                    <li><i class="fa-solid fa-check-circle"></i> 500+ Verified Venues</li>
                    <li><i class="fa-solid fa-check-circle"></i> Premium Vendor Network</li>
                    <li><i class="fa-solid fa-check-circle"></i> Secure Online Payments</li>
                    <li><i class="fa-solid fa-check-circle"></i> Dedicated Event Managers</li>
                </ul>
            </div>
            <div class="about-stats">
                <div class="stat-box">
                    <h3>${stats.totalEvents}+</h3>
                    <p>Events Managed</p>
                </div>
                <div class="stat-box">
                    <h3>${stats.totalGuests}+</h3>
                    <p>Happy Guests</p>
                </div>
                <div class="stat-box">
                    <h3>${String.format("%.1f", stats.averageRating)}/5</h3>
                    <p>Customer Rating</p>
                </div>
                <div class="stat-box">
                    <h3>24/7</h3>
                    <p>Support Team</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CONTACT & FOOTER SECTION -->
<footer class="global-footer" id="contact">
    <div class="global-footer-grid">
        <div class="footer-brand">
            <h2>Event<span>Sphere</span></h2>
            <p>Your ultimate partner in orchestrating unforgettable experiences across Sri Lanka.</p>
            <div class="social-links">
                <a href="#" aria-label="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#" aria-label="Instagram"><i class="fa-brands fa-instagram"></i></a>
                <a href="#" aria-label="Twitter"><i class="fa-brands fa-twitter"></i></a>
                <a href="#" aria-label="LinkedIn"><i class="fa-brands fa-linkedin-in"></i></a>
            </div>
        </div>
        
        <div class="footer-links">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="#home">Home (Login)</a></li>
                <li><a href="#gallery">Gallery</a></li>
                <li><a href="#about">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Create Account</a></li>
            </ul>
        </div>
        
        <div class="footer-contact">
            <h3>Contact Us</h3>
            <ul>
                <li><i class="fa-solid fa-location-dot"></i> 123 Event Avenue, Colombo 03, Sri Lanka</li>
                <li><i class="fa-solid fa-phone"></i> +94 11 234 5678</li>
                <li><i class="fa-solid fa-envelope"></i> contact@eventsphere.lk</li>
            </ul>
        </div>
    </div>
    
    <div class="footer-bottom">
        <p>&copy; 2024 EventSphere. All rights reserved. SE2030 Group 2026-Y2-S1-KU-28.</p>
    </div>
</footer>

</div> <!-- End wrapper -->

<!-- FontAwesome for Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js"></script>
</body>
</html>

