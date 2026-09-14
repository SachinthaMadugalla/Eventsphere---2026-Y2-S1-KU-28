<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/create" class="btn btn-accent btn-sm">+ Add Resource</a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>#</th><th>Resource Name</th><th>Category</th><th>Total Qty</th><th>Available</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="r" items="${resources}" varStatus="st">
                    <tr>
                        <td>${fn:escapeXml(st.count)}</td>
                        <td><strong>${fn:escapeXml(r.resourceName)}</strong></td>
                        <td>${fn:escapeXml(empty r.category ? '—' : r.category)}</td>
                        <td>${fn:escapeXml(r.totalQuantity)}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.availableQuantity <= 0}"><span style="color:#E53E3E;font-weight:600;">0</span></c:when>
                                <c:otherwise>${fn:escapeXml(r.availableQuantity)}</c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="es-badge ${fn:escapeXml(r.active ? 'badge-active' : 'badge-inactive')}">${fn:escapeXml(r.active ? 'Active' : 'Inactive')}</span></td>
                        <td>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/detail/${fn:escapeXml(r.resourceId)}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/edit/${fn:escapeXml(r.resourceId)}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${fn:escapeXml(pageContext.request.contextPath)}/resource/toggle/${fn:escapeXml(r.resourceId)}" method="post" style="display:inline;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                <input type="hidden" name="active" value="${fn:escapeXml(!r.active)}">
                                <button type="submit" class="btn btn-warning btn-xs">${fn:escapeXml(r.active ? 'Deactivate' : 'Activate')}</button>
                            </form>
                            <form action="${fn:escapeXml(pageContext.request.contextPath)}/resource/delete/${fn:escapeXml(r.resourceId)}" method="post" style="display:inline;" onsubmit="return confirmAction('Proceed with this change?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
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

