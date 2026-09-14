<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty event.eventId and event.eventId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Event' : 'Create Event'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>${fn:escapeXml(isEdit ? '&#9998; Edit Event' : '&#43; Create Event')}</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list">Events</a>
            &rsaquo; ${fn:escapeXml(isEdit ? event.eventName : 'New Event')}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:800px;">
        <c:set var="formAction" value="${isEdit ? '/event/edit/'.concat(event.eventId) : '/event/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(formAction)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-group">
                <label class="required">Event Name</label>
                <input type="text" name="eventName" class="es-input" value="${fn:escapeXml(event.eventName)}" required maxlength="200">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category</label>
                    <select name="categoryId" class="es-select" required>
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${fn:escapeXml(cat.categoryId)}" ${fn:escapeXml(event.categoryId == cat.categoryId ? 'selected' : '')}>${fn:escapeXml(cat.categoryName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Customer</label>
                    <select name="customerId" class="es-select" required>
                        <option value="">-- Select Customer --</option>
                        <c:forEach var="c" items="${customers}">
                            <option value="${fn:escapeXml(c.customerId)}" ${fn:escapeXml(event.customerId == c.customerId ? 'selected' : '')}>${fn:escapeXml(c.fullName)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Assign Event Manager</label>
                    <select name="managerUserId" class="es-select">
                        <option value="">-- Not assigned --</option>
                        <c:forEach var="m" items="${managers}">
                            <option value="${fn:escapeXml(m.userId)}" ${fn:escapeXml(event.managerUserId == m.userId ? 'selected' : '')}>${fn:escapeXml(m.fullName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Status</label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                            <option value="${fn:escapeXml(st)}" ${fn:escapeXml(event.status == st ? 'selected' : '')}>${fn:escapeXml(st)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event Date</label>
                    <input type="date" name="eventDate" class="es-input no-past-date" value="${fn:escapeXml(event.eventDate)}" required>
                </div>
                <div class="es-form-group">
                    <label class="required">Guest Count</label>
                    <input type="number" name="guestCount" class="es-input" value="${fn:escapeXml(event.guestCount)}" required min="1">
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Time</label>
                    <input type="time" name="startTime" class="es-input" value="${fn:escapeXml(event.startTime)}">
                </div>
                <div class="es-form-group">
                    <label>End Time</label>
                    <input type="time" name="endTime" class="es-input" value="${fn:escapeXml(event.endTime)}">
                </div>
            </div>

            <div class="es-form-group">
                <label>Location</label>
                <input type="text" name="location" class="es-input" value="${fn:escapeXml(event.location)}" placeholder="Event venue or area">
            </div>

            <div class="es-form-group">
                <label>Requirements / Notes</label>
                <textarea name="requirements" class="es-textarea" rows="3">${fn:escapeXml(event.requirements)}</textarea>
            </div>

            <div class="es-form-group">
                <label>Internal Notes</label>
                <textarea name="notes" class="es-textarea" rows="2">${fn:escapeXml(event.notes)}</textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">${fn:escapeXml(isEdit ? 'Update Event' : 'Create Event')}</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

