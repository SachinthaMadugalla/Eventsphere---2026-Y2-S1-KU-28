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
            <a href="${pageContext.request.contextPath}/venue/create" class="btn btn-accent btn-sm">+ Add Venue</a>
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
                                <td>${st.count}</td>
                                <td><strong>${v.venueName}</strong></td>
                                <td>${v.location}</td>
                                <td>${v.capacity}</td>
                                <td><fmt:formatNumber value="${v.costPerDay}" type="number" groupingUsed="true" xmlns:fmt="jakarta.tags.fmt"/></td>
                                <td><span class="es-badge ${v.active ? 'badge-active' : 'badge-inactive'}">${v.active ? 'Active' : 'Inactive'}</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/venue/detail/${v.venueId}" class="btn btn-secondary btn-xs">View</a>
                                    <a href="${pageContext.request.contextPath}/venue/edit/${v.venueId}" class="btn btn-primary btn-xs">Edit</a>
                                    <form action="${pageContext.request.contextPath}/venue/toggle/${v.venueId}" method="post" style="display:inline;">
                                        <input type="hidden" name="active" value="${!v.active}">
                                        <button type="submit" class="btn btn-warning btn-xs">${v.active ? 'Deactivate' : 'Activate'}</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/venue/delete/${v.venueId}" method="post" style="display:inline;" onsubmit="return confirmDelete('${v.venueName}')">
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

