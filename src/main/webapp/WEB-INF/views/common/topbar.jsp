<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Top navigation bar — included on every authenticated page.
  Expects: pageTitle, unreadCount in model or session.
--%>
<div class="es-topbar">
    <div style="display:flex;align-items:center;">
        <button class="sidebar-toggle" onclick="toggleSidebar()">&#9776;</button>
        <span class="topbar-title">${fn:escapeXml(empty pageTitle ? 'EventSphere' : pageTitle)}</span>
    </div>
    <div class="topbar-actions">
        <!-- Notification bell -->
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="notif-badge" title="Notifications">
            &#128276;
            <c:if test="${unreadCount > 0}">
                <span class="badge">${fn:escapeXml(unreadCount)}</span>
            </c:if>
        </a>
        <!-- User info -->
        <span style="font-size:13px;color:#4A5568;">
            ${fn:escapeXml(sessionScope.userFullName)}
        </span>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/logout" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}"><button type="submit" class="btn btn-secondary">
            Logout
        </button></form>
    </div>
</div>

