<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Venue Usage Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#127968; Venue Usage Report</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/reports">Reports</a>
            &rsaquo; Venue Usage
        </div>
    </div>

    <div style="display:flex;justify-content:flex-end;margin-bottom:12px;">
        <button class="btn btn-secondary btn-sm" onclick="printPage()">&#128424; Print</button>
    </div>

    <div class="es-alert es-alert-info">
        Shows all venue-to-event assignments. Use this to identify the most frequently booked venues.
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>Venue Assignments</h3>
            <span style="font-size:12px;color:#718096;">${assignments.size()} assignment(s)</span>
        </div>
        <c:choose>
            <c:when test="${empty assignments}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#127968;</span>
                    <p>No venue assignments on record.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Venue</th>
                                <th>Event</th>
                                <th>Assigned Date</th>
                                <th>Start Time</th>
                                <th>End Time</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td><strong>${a.venueName}</strong></td>
                                <td>${a.eventName}</td>
                                <td>
                                    ${a.assignedDate}
                                </td>
                                <td>${empty a.startTime ? 'â€”' : a.startTime}</td>
                                <td>${empty a.endTime   ? 'â€”' : a.endTime}</td>
                                <td>${empty a.notes     ? 'â€”' : a.notes}</td>
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

