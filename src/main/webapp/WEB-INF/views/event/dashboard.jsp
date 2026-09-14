<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Event Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; Event Management Dashboard</h2>
        <div class="breadcrumb">Home &rsaquo; Event Dashboard</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Stats -->
    <div class="stat-cards">
        <div class="stat-card"><div class="stat-label">Total Events</div><div class="stat-value">${fn:escapeXml(totalEvents)}</div></div>
        <div class="stat-card gold"><div class="stat-label">Upcoming</div><div class="stat-value">${fn:escapeXml(upcomingCount)}</div></div>
        <div class="stat-card blue"><div class="stat-label">Pending Requests</div>
            <div class="stat-value">${fn:escapeXml(requestedEvents.size())}</div></div>
        <div class="stat-card green"><div class="stat-label">Confirmed</div>
            <div class="stat-value">${fn:escapeXml(confirmedEvents.size())}</div></div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <!-- Status chart -->
        <div class="es-card">
            <div class="card-header"><h3>Events by Status</h3></div>
            <div class="chart-container"><canvas id="statusChart"></canvas></div>
        </div>
        <!-- Monthly chart -->
        <div class="es-card">
            <div class="card-header"><h3>Events by Month (${fn:escapeXml(pageContext.request.contextPath)})</h3></div>
            <div class="chart-container"><canvas id="monthlyChart"></canvas></div>
        </div>
    </div>

    <!-- Pending booking requests -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128276; Pending Booking Requests</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list?status=Requested" class="btn btn-secondary btn-sm">View All</a>
        </div>
        <c:choose>
            <c:when test="${empty requestedEvents}">
                <div class="es-empty"><span class="es-empty-icon">&#128197;</span><p>No pending requests.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Event</th><th>Customer</th><th>Category</th><th>Date</th><th>Guests</th><th>Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="e" items="${requestedEvents}" varStatus="st">
                            <c:if test="${st.index < 5}">
                            <tr>
                                <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                                <td>${fn:escapeXml(e.customerName)}</td>
                                <td>${fn:escapeXml(e.categoryName)}</td>
                                <td>${fn:escapeXml(e.eventDate)}</td>
                                <td>${fn:escapeXml(e.guestCount)}</td>
                                <td>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(e.eventId)}" class="btn btn-secondary btn-xs">Review</a>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/confirm/${fn:escapeXml(e.eventId)}" method="post" style="display:inline;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <button type="submit" class="btn btn-success btn-xs">Confirm</button>
                                    </form>
                                </td>
                            </tr>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Upcoming events -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128336; Upcoming Events</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary btn-sm">All Events</a>
        </div>
        <c:choose>
            <c:when test="${empty upcomingEvents}">
                <div class="es-empty"><p>No upcoming events.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Event</th><th>Date</th><th>Customer</th><th>Guests</th><th>Status</th><th></th></tr></thead>
                        <tbody>
                        <c:forEach var="e" items="${upcomingEvents}" varStatus="st">
                            <c:if test="${st.index < 8}">
                            <tr>
                                <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                                <td>${fn:escapeXml(e.eventDate)}</td>
                                <td>${fn:escapeXml(e.customerName)}</td>
                                <td>${fn:escapeXml(e.guestCount)}</td>
                                <td><c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span></td>
                                <td><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(e.eventId)}" class="btn btn-secondary btn-xs">View</a></td>
                            </tr>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
// Build chart data from model
var statusLabels = [], statusData = [];
<c:forEach var="row" items="${statusCounts}">
    statusLabels.push('${row[0]}');
    statusData.push(${row[1]});
</c:forEach>

var monthNums = [], monthCounts = [];
<c:forEach var="row" items="${monthlyCounts}">
    monthNums.push(${row[0]});
    monthCounts.push(${row[1]});
</c:forEach>

document.addEventListener('DOMContentLoaded', function () {
    createEventStatusChart('statusChart', statusLabels, statusData);
    createMonthlyBarChart('monthlyChart', monthNums, monthCounts);
});
</script>

