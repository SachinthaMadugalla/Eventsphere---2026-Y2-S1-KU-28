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
        <h2>&#128276; My Notifications</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard">Dashboard</a>
            &rsaquo; Notifications
        </div>
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>All Notifications</h3>
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/notifications/read-all" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <button type="submit" class="btn btn-secondary btn-sm">Mark All Read</button>
            </form>
        </div>
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128276;</span>
                    <p>No notifications.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${notifications}">
                    <div class="notif-item ${fn:escapeXml(n.read ? '' : 'unread')}">
                        <div class="notif-icon">&#128276;</div>
                        <div class="notif-body" style="flex:1;">
                            <div class="notif-title">${fn:escapeXml(n.title)}</div>
                            <div class="notif-msg">${fn:escapeXml(n.message)}</div>
                            <div class="notif-time">
                                ${fn:escapeXml(n.createdAt)}
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

