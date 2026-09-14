<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Staff Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128100; ${staff.fullName}</h2><div class="breadcrumb"><a href="${pageContext.request.contextPath}/staff/list">Staff</a> &rsaquo; Details</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>${staff.fullName}</h3><span class="es-badge ${staff.active ? 'badge-active' : 'badge-inactive'}">${staff.active ? 'Active' : 'Inactive'}</span></div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Job Role</div><div class="detail-value">${staff.jobRole}</div></div>
            <div class="detail-item"><div class="detail-label">Phone</div><div class="detail-value">${empty staff.phone ? 'â€”' : staff.phone}</div></div>
            <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value">${empty staff.email ? 'â€”' : staff.email}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/staff/edit/${staff.staffId}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${pageContext.request.contextPath}/staff/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
        </div>
    </div>
    <div class="es-card">
        <div class="card-header"><h3>Event Assignments</h3></div>
        <c:choose>
            <c:when test="${empty assignments}"><div class="es-empty"><p>No event assignments.</p></div></c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Event</th><th>Role at Event</th><th>Date</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/event/detail/${a.eventId}">${a.eventName}</a></td>
                                <td>${empty a.roleAtEvent ? 'â€”' : a.roleAtEvent}</td>
                                <td>${a.assignedDate}</td>
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

