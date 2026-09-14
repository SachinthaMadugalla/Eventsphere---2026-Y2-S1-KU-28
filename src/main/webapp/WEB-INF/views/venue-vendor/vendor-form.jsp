<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty vendor.vendorId and vendor.vendorId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Vendor' : 'Add Vendor'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>${fn:escapeXml(isEdit ? '&#9998; Edit Vendor' : '&#43; Add Vendor')}</h2>
        <div class="breadcrumb"><a href="${fn:escapeXml(pageContext.request.contextPath)}/vendor/list">Vendors</a> &rsaquo; ${fn:escapeXml(isEdit ? vendor.vendorName : 'New')}</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:640px;">
        <c:set var="action" value="${isEdit ? '/vendor/edit/'.concat(vendor.vendorId) : '/vendor/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(action)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-group">
                <label class="required">Vendor Name</label>
                <input type="text" name="vendorName" class="es-input" value="${fn:escapeXml(vendor.vendorName)}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category</label>
                    <select name="vendorCatId" class="es-select" required>
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${fn:escapeXml(cat.vendorCatId)}" ${fn:escapeXml(vendor.vendorCatId == cat.vendorCatId ? 'selected' : '')}>${fn:escapeXml(cat.categoryName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Service Cost (LKR)</label>
                    <input type="number" name="cost" class="es-input" value="${fn:escapeXml(vendor.cost)}" required min="0" step="0.01">
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Contact Person</label>
                    <input type="text" name="contactPerson" class="es-input" value="${fn:escapeXml(vendor.contactPerson)}">
                </div>
                <div class="es-form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" class="es-input" value="${fn:escapeXml(vendor.phone)}">
                </div>
            </div>
            <div class="es-form-group">
                <label>Email</label>
                <input type="email" name="email" class="es-input" value="${fn:escapeXml(vendor.email)}">
            </div>
            <div class="es-form-group">
                <label>Service Description</label>
                <textarea name="serviceDesc" class="es-textarea" rows="3">${fn:escapeXml(vendor.serviceDesc)}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${fn:escapeXml(isEdit ? 'Update Vendor' : 'Add Vendor')}</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/vendor/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

