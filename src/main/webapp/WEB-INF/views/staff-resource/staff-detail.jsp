<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Staff Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128100; ${fn:escapeXml(staff.fullName)}</h2><div class="breadcrumb"><a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list">Staff</a> &rsaquo; Details</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>${fn:escapeXml(staff.fullName)}</h3><span class="es-badge ${fn:escapeXml(staff.active ? 'badge-active' : 'badge-inactive')}">${fn:escapeXml(staff.active ? 'Active' : 'Inactive')}</span></div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Job Role</div><div class="detail-value">${fn:escapeXml(staff.jobRole)}</div></div>
            <div class="detail-item"><div class="detail-label">Phone</div><div class="detail-value">${fn:escapeXml(empty staff.phone ? '—' : staff.phone)}</div></div>
            <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value">${fn:escapeXml(empty staff.email ? '—' : staff.email)}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/edit/${fn:escapeXml(staff.staffId)}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
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
                                <td><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(a.eventId)}">${fn:escapeXml(a.eventName)}</a></td>
                                <td>${fn:escapeXml(empty a.roleAtEvent ? '—' : a.roleAtEvent)}</td>
                                <td>${fn:escapeXml(a.assignedDate)}</td>
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

