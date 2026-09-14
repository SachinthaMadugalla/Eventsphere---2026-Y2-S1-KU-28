<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login â€“ EventSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/eventsphere.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-box">
        <div class="auth-logo">
            <h1>Event<span>Sphere</span></h1>
            <p>Web-Based Event Planning System</p>
        </div>

        <h2>Sign In</h2>

        <c:if test="${not empty error}">
            <div class="es-alert es-alert-error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="es-alert es-alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="es-alert es-alert-error">Invalid username or password, or account is inactive.</div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="es-alert es-alert-success">You have been logged out successfully.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Username</label>
                <input type="text" name="username" class="es-input"
                       placeholder="Enter your username" required autofocus>
            </div>
            <div class="es-form-group">
                <label class="required">Password</label>
                <input type="password" name="password" class="es-input"
                       placeholder="Enter your password" required>
            </div>
            <div style="margin-top:20px;">
                <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">
                    Sign In
                </button>
            </div>
        </form>

        <div style="text-align:center;margin-top:18px;font-size:13px;color:#718096;">
            New customer?
            <a href="${pageContext.request.contextPath}/register" style="color:#E8A020;font-weight:600;">
                Create an account
            </a>
        </div>

        <div style="text-align:center;margin-top:24px;padding-top:16px;
                    border-top:1px solid #EEF1F6;font-size:11px;color:#A0AEC0;">
            SE2030 &bull; Group 2026-Y2-S1-KU-28
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js"></script>
</body>
</html>

