<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Managing Director Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128202; Managing Director Dashboard</h2>
        <div class="breadcrumb">Home &rsaquo; Director Dashboard</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- High-level KPIs -->
    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${fn:escapeXml(totalEvents)}</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-label">Upcoming Events</div>
            <div class="stat-value">${fn:escapeXml(upcomingEvents.size())}</div>
        </div>
        <div class="stat-card green">
            <div class="stat-label">Total Invoiced</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>
            </div>
        </div>
        <div class="stat-card blue">
            <div class="stat-label">Total Collected</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${totalCollected}" type="number" groupingUsed="true"/>
            </div>
        </div>
        <div class="stat-card red">
            <div class="stat-label">Outstanding Balance</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${outstanding}" type="number" groupingUsed="true"/>
            </div>
        </div>
        <div class="stat-card red">
            <div class="stat-label">Open Complaints</div>
            <div class="stat-value">${fn:escapeXml(openComplaints)}</div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px;">

        <!-- Event status chart -->
        <div class="es-card">
            <div class="card-header"><h3>Events by Status</h3></div>
            <div class="chart-container">
                <canvas id="directorStatusChart"></canvas>
            </div>
        </div>

        <!-- Financial summary -->
        <div class="es-card">
            <div class="card-header"><h3>Financial Overview</h3></div>
            <div class="chart-container">
                <canvas id="directorFinanceChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Upcoming events (read-only) -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128336; Upcoming Events</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary btn-sm">
                View All
            </a>
        </div>
        <c:choose>
            <c:when test="${empty upcomingEvents}">
                <div class="es-empty"><p>No upcoming events.</p></div>
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
                                <th>Manager</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="e" items="${upcomingEvents}" varStatus="st">
                            <c:if test="${st.index < 8}">
                            <tr>
                                <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                                <td>${fn:escapeXml(e.categoryName)}</td>
                                <td>
                                    ${fn:escapeXml(e.eventDate)}
                                </td>
                                <td>${fn:escapeXml(e.guestCount)}</td>
                                <td>${fn:escapeXml(empty e.managerName ? '—' : e.managerName)}</td>
                                <td>
                                    <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span>
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

    <!-- Escalated complaints requiring attention -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#9888; Escalated Complaints Requiring Attention</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/list"
               class="btn btn-secondary btn-sm">All Complaints</a>
        </div>
        <c:choose>
            <c:when test="${empty escalatedComplaints}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#9989;</span>
                    <p>No escalated complaints at this time.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-alert es-alert-error">
                    &#9888; <strong>${fn:escapeXml(escalatedComplaints.size())} complaint(s)</strong>
                    have been escalated and require your review.
                </div>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>Subject</th>
                                <th>Customer</th>
                                <th>Event</th>
                                <th>Status</th>
                                <th>Submitted</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="comp" items="${escalatedComplaints}">
                            <tr>
                                <td><strong>${fn:escapeXml(comp.subject)}</strong></td>
                                <td>${fn:escapeXml(comp.customerName)}</td>
                                <td>${fn:escapeXml(empty comp.eventName ? '—' : comp.eventName)}</td>
                                <td>
                                    <c:set var="cs" value="${comp.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${fn:escapeXml(cs)}">${fn:escapeXml(comp.status)}</span>
                                </td>
                                <td>
                                    ${fn:escapeXml(comp.submittedDate)}
                                </td>
                                <td>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/detail/${fn:escapeXml(comp.complaintId)}"
                                       class="btn btn-danger btn-xs">Review</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Report shortcuts (read-only) -->
    <div class="es-card">
        <div class="card-header"><h3>&#128200; Reports</h3></div>
        <div style="display:flex;gap:12px;flex-wrap:wrap;padding:8px 0;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/events"
               class="btn btn-secondary">Event Report</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/finance"
               class="btn btn-secondary">Finance Report</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/venues"
               class="btn btn-secondary">Venue Usage</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/vendors"
               class="btn btn-secondary">Vendor Usage</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/staff"
               class="btn btn-secondary">Staff Allocation</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/resources"
               class="btn btn-secondary">Resource Usage</a>
        </div>
    </div>

    <!-- Average rating note -->
    <div class="es-card">
        <div class="card-header"><h3>&#11088; Customer Satisfaction</h3></div>
        <div style="padding:12px 0;display:flex;align-items:center;gap:16px;">
            <div>
                <div class="stat-label">Average Event Rating</div>
                <div style="font-size:32px;font-weight:700;color:#E8A020;">
                    <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5
                </div>
            </div>
            <div>
                <span style="color:#E8A020;font-size:28px;">

                    <c:forEach begin="1" end="5" varStatus="i">
                        <c:choose>
                            <c:when test="${i.index <= averageRating}">&#9733;</c:when>
                            <c:otherwise><span style="color:#D8DEE8;">&#9733;</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </span>
            </div>
        </div>
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/list"
           class="btn btn-secondary btn-sm">View All Feedback</a>
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

document.addEventListener('DOMContentLoaded', function () {
    createEventStatusChart('directorStatusChart', statusLabels, statusData);
    createFinanceChart('directorFinanceChart',
        ${totalRevenue}, ${totalCollected}, ${outstanding});
});
</script>

