<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Vendor Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>&#128722; ${vendor.vendorName}</h2>
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/vendor/list">Vendors</a> &rsaquo; Details</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>${vendor.vendorName}</h3>
            <span class="es-badge ${vendor.active ? 'badge-active' : 'badge-inactive'}">${vendor.active ? 'Active' : 'Inactive'}</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Category</div><div class="detail-value">${vendor.categoryName}</div></div>
            <div class="detail-item"><div class="detail-label">Cost</div><div class="detail-value">LKR <fmt:formatNumber value="${vendor.cost}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Contact Person</div><div class="detail-value">${empty vendor.contactPerson ? 'â€”' : vendor.contactPerson}</div></div>
            <div class="detail-item"><div class="detail-label">Phone</div><div class="detail-value">${empty vendor.phone ? 'â€”' : vendor.phone}</div></div>
            <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value">${empty vendor.email ? 'â€”' : vendor.email}</div></div>
            <div class="detail-item"><div class="detail-label">Service Description</div><div class="detail-value">${empty vendor.serviceDesc ? 'â€”' : vendor.serviceDesc}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/vendor/edit/${vendor.vendorId}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${pageContext.request.contextPath}/vendor/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
        </div>
    </div>
    <div class="es-card">
        <div class="card-header"><h3>Event Assignments</h3></div>
        <c:choose>
            <c:when test="${empty assignments}"><div class="es-empty"><p>No event assignments.</p></div></c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Event</th><th>Service Date</th><th>Notes</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/event/detail/${a.eventId}">${a.eventName}</a></td>
                                <td>${a.serviceDate}</td>
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

