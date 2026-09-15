<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EventSphere</title>
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/eventsphere.css">
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/login.css">
</head>
<body>
<main class="auth-page login-page">
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
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js"></script>
</body>
</html>

