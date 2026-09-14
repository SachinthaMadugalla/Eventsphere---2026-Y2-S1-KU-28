<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Resources"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128230; Resources</h2><div class="breadcrumb">Home &rsaquo; Resources</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>All Resources</h3>
            <a href="${pageContext.request.contextPath}/resource/create" class="btn btn-accent btn-sm">+ Add Resource</a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>#</th><th>Resource Name</th><th>Category</th><th>Total Qty</th><th>Available</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="r" items="${resources}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${r.resourceName}</strong></td>
                        <td>${empty r.category ? 'â€”' : r.category}</td>
                        <td>${r.totalQuantity}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.availableQuantity <= 0}"><span style="color:#E53E3E;font-weight:600;">0</span></c:when>
                                <c:otherwise>${r.availableQuantity}</c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="es-badge ${r.active ? 'badge-active' : 'badge-inactive'}">${r.active ? 'Active' : 'Inactive'}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/resource/detail/${r.resourceId}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${pageContext.request.contextPath}/resource/edit/${r.resourceId}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${pageContext.request.contextPath}/resource/toggle/${r.resourceId}" method="post" style="display:inline;">
                                <input type="hidden" name="active" value="${!r.active}">
                                <button type="submit" class="btn btn-warning btn-xs">${r.active ? 'Deactivate' : 'Activate'}</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/resource/delete/${r.resourceId}" method="post" style="display:inline;" onsubmit="return confirmDelete('${r.resourceName}')">
                                <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

