<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Venues"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>&#127968; Venues</h2>
        <div class="breadcrumb">Home &rsaquo; Venues</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>All Venues</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/create" class="btn btn-accent btn-sm">+ Add Venue</a>
        </div>
        <c:choose>
            <c:when test="${empty venues}">
                <div class="es-empty"><span class="es-empty-icon">&#127968;</span><p>No venues found.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>#</th><th>Venue Name</th><th>Location</th><th>Capacity</th><th>Cost/Day (LKR)</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="v" items="${venues}" varStatus="st">
                            <tr>
                                <td>${fn:escapeXml(st.count)}</td>
                                <td><strong>${fn:escapeXml(v.venueName)}</strong></td>
                                <td>${fn:escapeXml(v.location)}</td>
                                <td>${fn:escapeXml(v.capacity)}</td>
                                <td><fmt:formatNumber value="${v.costPerDay}" type="number" groupingUsed="true"/></td>
                                <td><span class="es-badge ${fn:escapeXml(v.active ? 'badge-active' : 'badge-inactive')}">${fn:escapeXml(v.active ? 'Active' : 'Inactive')}</span></td>
                                <td>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/detail/${fn:escapeXml(v.venueId)}" class="btn btn-secondary btn-xs">View</a>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/edit/${fn:escapeXml(v.venueId)}" class="btn btn-primary btn-xs">Edit</a>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/venue/toggle/${fn:escapeXml(v.venueId)}" method="post" style="display:inline;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <input type="hidden" name="active" value="${fn:escapeXml(!v.active)}">
                                        <button type="submit" class="btn btn-warning btn-xs">${fn:escapeXml(v.active ? 'Deactivate' : 'Activate')}</button>
                                    </form>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/venue/delete/${fn:escapeXml(v.venueId)}" method="post" style="display:inline;" onsubmit="return confirmAction('Proceed with this change?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                                    </form>
                                </td>
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

