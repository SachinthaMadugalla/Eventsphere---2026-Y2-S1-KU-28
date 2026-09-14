<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Top navigation bar â€” included on every authenticated page.
  Expects: pageTitle, unreadCount in model or session.
--%>
<div class="es-topbar">
    <div style="display:flex;align-items:center;">
        <button class="sidebar-toggle" onclick="toggleSidebar()">&#9776;</button>
        <span class="topbar-title">${empty pageTitle ? 'EventSphere' : pageTitle}</span>
    </div>
    <div class="topbar-actions">
        <!-- Notification bell -->
        <a href="${pageContext.request.contextPath}/notifications" class="notif-badge" title="Notifications">
            &#128276;
            <c:if test="${unreadCount > 0}">
                <span class="badge">${unreadCount}</span>
            </c:if>
        </a>
        <!-- User info -->
        <span style="font-size:13px;color:#4A5568;">
            ${sessionScope.userFullName}
        </span>
        <a href="${pageContext.request.contextPath}/logout"
           style="font-size:12px;color:#718096;border:1px solid #D8DEE8;
                  padding:4px 10px;border-radius:4px;">
            Logout
        </a>
    </div>
</div>

