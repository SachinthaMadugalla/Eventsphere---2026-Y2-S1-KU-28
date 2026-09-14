<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Event Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; Event Report</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports">Reports</a>
            &rsaquo; Events
        </div>
    </div>

    <!-- Filter bar -->
    <div class="es-card">
        <form method="get" action="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/events"
              style="display:flex;gap:8px;flex-wrap:wrap;align-items:flex-end;">
            <div class="es-form-group" style="margin-bottom:0;">
                <label style="font-size:11px;font-weight:600;color:#4A5568;text-transform:uppercase;">
                    Filter by Status
                </label>
                <select name="status" class="es-select" style="width:180px;">
                    <option value="">All Statuses</option>
                    <c:forEach var="s" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                        <option value="${fn:escapeXml(s)}" ${fn:escapeXml(filterStatus == s ? 'selected' : '')}>${fn:escapeXml(s)}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-sm">Apply Filter</button>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/events"
               class="btn btn-secondary btn-sm">Clear</a>
            <button type="button" class="btn btn-secondary btn-sm" onclick="printPage()">
                &#128424; Print
            </button>
        </form>
    </div>

    <!-- Summary stats -->
    <div class="stat-cards">
        <c:forEach var="row" items="${statusCounts}">
            <div class="stat-card">
                <div class="stat-label">${fn:escapeXml(row[0])}</div>
                <div class="stat-value">${fn:escapeXml(row[1])}</div>
            </div>
        </c:forEach>
    </div>

    <!-- Charts -->
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="es-card">
            <div class="card-header"><h3>Events by Status</h3></div>
            <div class="chart-container"><canvas id="evStatusChart"></canvas></div>
        </div>
        <div class="es-card">
            <div class="card-header">
                <h3>Events by Month (${fn:escapeXml(pageContext.request.contextPath)})</h3>
            </div>
            <div class="chart-container"><canvas id="evMonthChart"></canvas></div>
        </div>
    </div>

    <!-- Detailed table -->
    <div class="es-card">
        <div class="card-header">
            <h3>Event Details
                <c:if test="${not empty filterStatus}">
                    — Filtered: <span class="es-badge badge-pending">${fn:escapeXml(filterStatus)}</span>
                </c:if>
            </h3>
            <span style="font-size:12px;color:#718096;">${fn:escapeXml(events.size())} record(s)</span>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>#</th><th>Event Name</th><th>Category</th>
                        <th>Customer</th><th>Date</th><th>Guests</th>
                        <th>Manager</th><th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="e" items="${events}" varStatus="st">
                    <tr>
                        <td>${fn:escapeXml(st.count)}</td>
                        <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                        <td>${fn:escapeXml(e.categoryName)}</td>
                        <td>${fn:escapeXml(e.customerName)}</td>
                        <td>${fn:escapeXml(e.eventDate)}</td>
                        <td>${fn:escapeXml(e.guestCount)}</td>
                        <td>${fn:escapeXml(empty e.managerName ? '—' : e.managerName)}</td>
                        <td>
                            <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                            <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
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
    createEventStatusChart('evStatusChart', statusLabels, statusData);
    createMonthlyBarChart('evMonthChart', monthNums, monthCounts);
});
</script>

