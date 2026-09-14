<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register â€“ EventSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/eventsphere.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-box" style="max-width:500px;">
        <div class="auth-logo">
            <h1>Event<span>Sphere</span></h1>
            <p>Create your customer account</p>
        </div>

        <c:if test="${not empty error}">
            <div class="es-alert es-alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="es-alert es-alert-success">${success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="es-validate">
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Full Name</label>
                    <input type="text" name="fullName" class="es-input"
                           value="${registration.fullName}" placeholder="Your full name" required>
                </div>
                <div class="es-form-group">
                    <label class="required">Username</label>
                    <input type="text" name="username" class="es-input"
                           value="${registration.username}" placeholder="Choose a username" required>
                </div>
            </div>

            <div class="es-form-group">
                <label class="required">Email Address</label>
                <input type="email" name="email" class="es-input"
                       value="${registration.email}" placeholder="your@email.com" required>
            </div>

            <div class="es-form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" class="es-input"
                       value="${registration.phone}" placeholder="07XXXXXXXX">
            </div>

            <div class="es-form-group">
                <label>Address</label>
                <input type="text" name="address" class="es-input"
                       value="${registration.address}" placeholder="Your address">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Password</label>
                    <input type="password" name="password" class="es-input"
                           placeholder="Min. 6 characters" required minlength="6">
                </div>
                <div class="es-form-group">
                    <label class="required">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="es-input"
                           placeholder="Re-enter password" required minlength="6">
                </div>
            </div>

            <div style="margin-top:20px;">
                <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">
                    Create Account
                </button>
            </div>
        </form>

        <div style="text-align:center;margin-top:16px;font-size:13px;color:#718096;">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login" style="color:#E8A020;font-weight:600;">
                Sign in
            </a>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js"></script>
</body>
</html>

