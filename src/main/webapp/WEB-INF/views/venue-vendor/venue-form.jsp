<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty venue.venueId and venue.venueId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Venue' : 'Add Venue'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>${isEdit ? '&#9998; Edit Venue' : '&#43; Add Venue'}</h2>
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/venue/list">Venues</a> &rsaquo; ${isEdit ? venue.venueName : 'New'}</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:600px;">
        <c:set var="action" value="${isEdit ? '/venue/edit/'.concat(venue.venueId) : '/venue/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Venue Name</label>
                <input type="text" name="venueName" class="es-input" value="${venue.venueName}" required>
            </div>
            <div class="es-form-group">
                <label class="required">Location</label>
                <input type="text" name="location" class="es-input" value="${venue.location}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Capacity (guests)</label>
                    <input type="number" name="capacity" class="es-input" value="${venue.capacity}" required min="1">
                </div>
                <div class="es-form-group">
                    <label class="required">Cost Per Day (LKR)</label>
                    <input type="number" name="costPerDay" class="es-input" value="${venue.costPerDay}" required min="0" step="0.01">
                </div>
            </div>
            <div class="es-form-group">
                <label>Description</label>
                <textarea name="description" class="es-textarea" rows="3">${venue.description}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update Venue' : 'Add Venue'}</button>
                <a href="${pageContext.request.contextPath}/venue/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

