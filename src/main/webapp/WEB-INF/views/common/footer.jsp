<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Common footer — included at the bottom of every authenticated page.
  Also closes the .es-main, .es-wrapper divs and includes JS.
--%>
        <!-- GLOBAL FOOTER -->
        <footer class="global-footer" id="contact" style="margin-top: 60px; border-radius: 16px 16px 0 0; margin-left: 20px; margin-right: 20px;">
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
                        <li><a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/customer/bookings">My Bookings</a></li>
                        <li><a href="${pageContext.request.contextPath}/customer/profile">My Profile</a></li>
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
    </div><!-- /.es-main -->
</div><!-- /.es-wrapper -->
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js?v=4"></script>
<script src="${pageContext.request.contextPath}/static/js/charts.js"></script>
</body>
</html>

