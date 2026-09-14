<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Resource Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128230; ${fn:escapeXml(resource.resourceName)}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>${fn:escapeXml(resource.resourceName)}</h3><span class="es-badge ${fn:escapeXml(resource.active ? 'badge-active' : 'badge-inactive')}">${fn:escapeXml(resource.active ? 'Active' : 'Inactive')}</span></div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Category</div><div class="detail-value">${fn:escapeXml(empty resource.category ? '—' : resource.category)}</div></div>
            <div class="detail-item"><div class="detail-label">Total Quantity</div><div class="detail-value">${fn:escapeXml(resource.totalQuantity)}</div></div>
            <div class="detail-item"><div class="detail-label">Available Quantity</div><div class="detail-value" style="${fn:escapeXml(resource.availableQuantity <= 0 ? 'color:#E53E3E;font-weight:700;' : '')}">${fn:escapeXml(resource.availableQuantity)}</div></div>
            <div class="detail-item"><div class="detail-label">Description</div><div class="detail-value">${fn:escapeXml(empty resource.description ? '—' : resource.description)}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/edit/${fn:escapeXml(resource.resourceId)}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

