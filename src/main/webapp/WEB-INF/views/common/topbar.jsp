<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Top navigation bar — included on every authenticated page.
  Expects: pageTitle, unreadCount in model or session.
--%>
<div class="es-topbar">
    <div style="display:flex;align-items:center;">
        <button type="button" class="sidebar-toggle" onclick="toggleSidebar()" aria-label="Toggle navigation" aria-controls="main-navigation" aria-expanded="false">&#9776;</button>
        <span class="topbar-title">${fn:escapeXml(empty pageTitle ? 'EventSphere' : pageTitle)}</span>
    </div>
    <div class="topbar-actions">
        <!-- Notification bell -->
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="notif-badge" title="Notifications">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" aria-hidden="true"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9Z"/><path d="M10 21h4"/></svg>
            <c:if test="${unreadCount > 0}">
                <span class="badge">${fn:escapeXml(unreadCount)}</span>
            </c:if>
        </a>
        <!-- User info -->
        <span class="topbar-user">
            ${fn:escapeXml(sessionScope.userFullName)}
        </span>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/logout" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}"><button type="submit" class="btn btn-secondary">
            Logout
        </button></form>
    </div>
</div>

