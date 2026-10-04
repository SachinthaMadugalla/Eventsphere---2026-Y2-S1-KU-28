<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Top navigation bar — included on every authenticated page.
  Expects: pageTitle, unreadCount in model or session.
--%>
<div class="es-topbar">
    <div class="topbar-left">
        <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle navigation" aria-controls="main-navigation" aria-expanded="false">&#9776;</button>
        <div class="topbar-heading">
            <span class="topbar-module" aria-hidden="true"></span>
            <span class="topbar-title">${fn:escapeXml(empty pageTitle ? 'EventSphere' : pageTitle)}</span>
        </div>
    </div>
    <div class="topbar-actions">
        <span class="topbar-date" id="topbar-date" aria-hidden="true"></span>
        <!-- Dark Mode Toggle -->
        <button type="button" id="darkModeToggle" class="btn-icon" title="Toggle Dark Mode" style="margin-right: 8px; background: transparent; color: #4A5568; font-size: 16px;">
            <i class="fa-solid fa-moon"></i>
        </button>
        <!-- Notification bell -->
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="notif-badge" title="Notifications" aria-label="Notifications${unreadCount > 0 ? ' ('.concat(unreadCount).concat(' unread)') : ''}">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" aria-hidden="true"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9Z"/><path d="M10 21h4"/></svg>
            <c:if test="${unreadCount > 0}">
                <span class="badge">${fn:escapeXml(unreadCount)}</span>
            </c:if>
        </a>
        <!-- User info -->
        <span class="topbar-user">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser.profilePicture}">
                    <img src="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(sessionScope.loggedInUser.profilePicture)}" alt="Avatar" class="topbar-avatar" style="object-fit: cover;" aria-hidden="true">
                </c:when>
                <c:otherwise>
                    <span class="topbar-avatar" aria-hidden="true">${fn:escapeXml(fn:toUpperCase(fn:substring(sessionScope.userFullName, 0, 1)))}</span>
                </c:otherwise>
            </c:choose>
            <span class="topbar-user-text">
                <span class="topbar-user-name">${fn:escapeXml(sessionScope.userFullName)}</span>
                <span class="topbar-user-role">${fn:escapeXml(sessionScope.userRole)}</span>
            </span>
        </span>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/logout" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}"><button type="submit" class="btn btn-secondary topbar-logout">
            Logout
        </button></form>
    </div>
</div>
