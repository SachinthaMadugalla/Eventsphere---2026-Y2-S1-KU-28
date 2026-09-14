<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Staff Allocation Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128100; Staff Allocation Report</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/reports">Reports</a>
            &rsaquo; Staff Allocation
        </div>
    </div>

    <div style="display:flex;justify-content:flex-end;margin-bottom:12px;">
        <button class="btn btn-secondary btn-sm" onclick="printPage()">&#128424; Print</button>
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>Staff Assignments</h3>
            <span style="font-size:12px;color:#718096;">${assignments.size()} assignment(s)</span>
        </div>
        <c:choose>
            <c:when test="${empty assignments}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128100;</span>
                    <p>No staff assignments on record.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Staff Member</th>
                                <th>Event</th>
                                <th>Event Date</th>
                                <th>Role at Event</th>
                                <th>Assigned Date</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td><strong>${a.staffName}</strong></td>
                                <td>${a.eventName}</td>
                                <td>
                                    ${a.eventDate}
                                </td>
                                <td>${empty a.roleAtEvent ? 'â€”' : a.roleAtEvent}</td>
                                <td>
                                    ${a.assignedDate}
                                </td>
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

