<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Resource Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128230; ${resource.resourceName}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>${resource.resourceName}</h3><span class="es-badge ${resource.active ? 'badge-active' : 'badge-inactive'}">${resource.active ? 'Active' : 'Inactive'}</span></div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Category</div><div class="detail-value">${empty resource.category ? 'â€”' : resource.category}</div></div>
            <div class="detail-item"><div class="detail-label">Total Quantity</div><div class="detail-value">${resource.totalQuantity}</div></div>
            <div class="detail-item"><div class="detail-label">Available Quantity</div><div class="detail-value" style="${resource.availableQuantity <= 0 ? 'color:#E53E3E;font-weight:700;' : ''}">${resource.availableQuantity}</div></div>
            <div class="detail-item"><div class="detail-label">Description</div><div class="detail-value">${empty resource.description ? 'â€”' : resource.description}</div></div>
        </div>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/resource/edit/${resource.resourceId}" class="btn btn-primary btn-sm">Edit</a>
            <a href="${pageContext.request.contextPath}/resource/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

