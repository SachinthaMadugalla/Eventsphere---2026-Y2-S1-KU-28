<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – EventSphere</title>
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/eventsphere.css">
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/login.css">
</head>
<body>
<main class="auth-page login-page register-page">
    <div class="auth-box">
        <div class="auth-logo">
            <h1>Event<span>Sphere</span></h1>
            <p>Every detail. Every moment.</p>
        </div>

        <div class="login-heading">
            <p class="login-eyebrow">MAKE ROOM FOR GREAT MOMENTS</p>
            <h2>Create your account.</h2>
            <p>Start planning something worth celebrating.</p>
        </div>
        <c:if test="${not empty error}">
            <div class="es-alert es-alert-error">${fn:escapeXml(error)}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="es-alert es-alert-success">${fn:escapeXml(success)}</div>
        </c:if>

        <form action="${fn:escapeXml(pageContext.request.contextPath)}/register" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required" for="fullName">Full Name</label>
                    <input type="text" name="fullName" id="fullName" autocomplete="name" class="es-input"
                           value="${fn:escapeXml(registration.fullName)}" placeholder="Your full name" required>
                </div>
                <div class="es-form-group">
                    <label class="required" for="username">Username</label>
                    <input type="text" name="username" id="username" autocomplete="username" class="es-input"
                           value="${fn:escapeXml(registration.username)}" placeholder="Choose a username" required>
                </div>
            </div>

            <div class="es-form-group">
                <label class="required" for="email">Email Address</label>
                <input type="email" name="email" id="email" autocomplete="email" class="es-input"
                       value="${fn:escapeXml(registration.email)}" placeholder="your@email.com" required>
            </div>

            <div class="es-form-group">
                <label for="phone">Phone Number <span class="field-optional">(optional)</span></label>
                <input type="tel" name="phone" id="phone" autocomplete="tel" class="es-input"
                       value="${fn:escapeXml(registration.phone)}" placeholder="07XXXXXXXX">
            </div>

            <div class="es-form-group">
                <label for="address">Address <span class="field-optional">(optional)</span></label>
                <input type="text" name="address" id="address" autocomplete="street-address" class="es-input"
                       value="${fn:escapeXml(registration.address)}" placeholder="Your address">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required" for="password">Password</label>
                    <input type="password" name="password" id="password" autocomplete="new-password" class="es-input"
                           placeholder="Min. 6 characters" required minlength="6">
                </div>
                <div class="es-form-group">
                    <label class="required" for="confirmPassword">Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" autocomplete="new-password" class="es-input"
                           placeholder="Re-enter password" required minlength="6">
                </div>
            </div>

            <div class="login-submit">
                <button type="submit" class="btn btn-primary">
                    Create account <span aria-hidden="true">&rarr;</span>
                </button>
            </div>
        </form>

        <div class="login-register">
            Already have an account?
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/login">
                Log in
            </a>
        </div>
        <div class="login-footer">PLAN SIMPLY. CELEBRATE BEAUTIFULLY.</div>
    </div>
    <section class="login-story" aria-label="EventSphere event planning">
        <p class="login-story-tag"><span aria-hidden="true"></span> MADE FOR MEMORABLE MOMENTS</p>
        <h2>Your ideas.<br>Your people.<br><em>Your moment.</em></h2>
        <p>Bring every detail together.<br>Let the unforgettable begin.</p>
        <div class="login-story-footer">EventSphere <span aria-hidden="true">/</span> Event Planning System</div>
    </section>
</main>
<script src="${pageContext.request.contextPath}/static/js/eventsphere.js"></script>
</body>
</html>

