<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>Welcome, ${fn:escapeXml(customer.fullName)}!</h2>
        <div class="breadcrumb">Home &rsaquo; Dashboard</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Quick stats -->
    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-label">Total Bookings</div>
            <div class="stat-value">${fn:escapeXml(events.size())}</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-label">Upcoming</div>
            <div class="stat-value">
                <c:set var="upcoming" value="0"/>
                <c:forEach var="e" items="${events}">
                    <c:if test="${e.status != 'Cancelled' and e.status != 'Completed'}">
                        <c:set var="upcoming" value="${upcoming + 1}"/>
                    </c:if>
                </c:forEach>
                ${fn:escapeXml(upcoming)}
            </div>
        </div>
        <div class="stat-card green">
            <div class="stat-label">Completed</div>
            <div class="stat-value">
                <c:set var="completed" value="0"/>
                <c:forEach var="e" items="${events}">
                    <c:if test="${e.status == 'Completed'}"><c:set var="completed" value="${completed + 1}"/></c:if>
                </c:forEach>
                ${fn:escapeXml(completed)}
            </div>
        </div>
        <div class="stat-card blue">
            <div class="stat-label">Unread Alerts</div>
            <div class="stat-value">${fn:escapeXml(unreadCount)}</div>
        </div>
    </div>

    <!-- Recent bookings -->
    <div class="es-card">
        <div class="card-header">
            <h3>My Bookings</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/new" class="btn btn-accent btn-sm">
                + New Booking
            </a>
        </div>
        <c:choose>
            <c:when test="${empty events}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128197;</span>
                    <p>No bookings yet. <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/new">Submit your first booking</a>.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>Event Name</th>
                                <th>Category</th>
                                <th>Date</th>
                                <th>Guests</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${events}">
                            <tr>
                                <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                                <td>${fn:escapeXml(e.categoryName)}</td>
                                <td>${fn:escapeXml(e.eventDate)}</td>
                                <td>${fn:escapeXml(e.guestCount)}</td>
                                <td>
                                    <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span>
                                </td>
                                <td>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/${fn:escapeXml(e.eventId)}"
                                       class="btn btn-secondary btn-xs">View</a>
                                    <c:if test="${e.status == 'Requested' or e.status == 'Pending'}">
                                        <form action="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/cancel/${fn:escapeXml(e.eventId)}"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirmAction('Cancel this booking?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                            <button type="submit" class="btn btn-danger btn-xs">Cancel</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${e.status == 'Completed'}">
                                        <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/submit?eventId=${fn:escapeXml(e.eventId)}"
                                           class="btn btn-accent btn-xs">Feedback</a>
                                    </c:if>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Recent notifications -->
    <c:if test="${not empty notifications}">
    <div class="es-card">
        <div class="card-header">
            <h3>Recent Notifications</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="btn btn-secondary btn-sm">View All</a>
        </div>
        <c:forEach var="n" items="${notifications}" varStatus="s">
            <c:if test="${s.index < 3}">
            <div class="notif-item unread">
                <div class="notif-icon">&#128276;</div>
                <div class="notif-body">
                    <div class="notif-title">${fn:escapeXml(n.title)}</div>
                    <div class="notif-msg">${fn:escapeXml(n.message)}</div>
                </div>
            </div>
            </c:if>
        </c:forEach>
    </div>
    </c:if>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

