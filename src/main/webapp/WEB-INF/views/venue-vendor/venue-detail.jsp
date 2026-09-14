<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Venue Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>&#127968; ${venue.venueName}</h2>
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/venue/list">Venues</a> &rsaquo; Details</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>${venue.venueName}</h3>
            <span class="es-badge ${venue.active ? 'badge-active' : 'badge-inactive'}">${venue.active ? 'Active' : 'Inactive'}</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Location</div><div class="detail-value">${venue.location}</div></div>
            <div class="detail-item"><div class="detail-label">Capacity</div><div class="detail-value">${venue.capacity} guests</div></div>
            <div class="detail-item"><div class="detail-label">Cost Per Day</div><div class="detail-value">LKR <fmt:formatNumber value="${venue.costPerDay}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Description</div><div class="detail-value">${empty venue.description ? 'â€”' : venue.description}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/venue/edit/${venue.venueId}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${pageContext.request.contextPath}/venue/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
        </div>
    </div>

    <div class="es-card">
        <div class="card-header"><h3>Event Assignments</h3></div>
        <c:choose>
            <c:when test="${empty assignments}">
                <div class="es-empty"><p>This venue has no event assignments.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Event</th><th>Date</th><th>Time</th><th>Notes</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/event/detail/${a.eventId}">${a.eventName}</a></td>
                                <td>${a.assignedDate}</td>
                                <td>${empty a.startTime ? 'â€”' : a.startTime} â€“ ${empty a.endTime ? 'â€”' : a.endTime}</td>
                                <td>${empty a.notes ? 'â€”' : a.notes}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

