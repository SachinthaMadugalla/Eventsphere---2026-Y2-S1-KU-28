<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Notifications"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128276; Notifications</h2>
        <div class="breadcrumb">Home &rsaquo; Notifications</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>All Notifications</h3>
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/notifications/read-all" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <button type="submit" class="btn btn-secondary btn-sm">Mark All as Read</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128276;</span>
                    <p>No notifications yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="notif" items="${notifications}">
                    <div class="notif-item ${fn:escapeXml(notif.read ? '' : 'unread')}">
                        <div class="notif-icon">&#128276;</div>
                        <div class="notif-body" style="flex:1;">
                            <div class="notif-title">${fn:escapeXml(notif.title)}</div>
                            <div class="notif-msg">${fn:escapeXml(notif.message)}</div>
                            <div class="notif-time">
                                ${fn:escapeXml(notif.createdAt)}
                            </div>
                        </div>
                        <form action="${fn:escapeXml(pageContext.request.contextPath)}/notifications/delete/${fn:escapeXml(notif.notificationId)}"
                              method="post" style="display:inline;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                            <button type="submit" class="btn btn-secondary btn-xs"
                                    title="Dismiss">&#10005;</button>
                        </form>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

