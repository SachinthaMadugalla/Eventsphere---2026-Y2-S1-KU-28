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
        <h2>${isEdit ? '&#9998; Edit Event' : '&#43; Create Event'}</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/event/list">Events</a>
            &rsaquo; ${isEdit ? event.eventName : 'New Event'}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:800px;">
        <c:set var="formAction" value="${isEdit ? '/event/edit/'.concat(event.eventId) : '/event/create'}"/>
        <form action="${pageContext.request.contextPath}${formAction}" method="post" class="es-validate">

            <div class="es-form-group">
                <label class="required">Event Name</label>
                <input type="text" name="eventName" class="es-input" value="${event.eventName}" required maxlength="200">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category</label>
                    <select name="categoryId" class="es-select" required>
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${event.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Customer</label>
                    <select name="customerId" class="es-select" required>
                        <option value="">-- Select Customer --</option>
                        <c:forEach var="c" items="${customers}">
                            <option value="${c.customerId}" ${event.customerId == c.customerId ? 'selected' : ''}>${c.fullName}</option>
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
                            <option value="${m.userId}" ${event.managerUserId == m.userId ? 'selected' : ''}>${m.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Status</label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                            <option value="${st}" ${event.status == st ? 'selected' : ''}>${st}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event Date</label>
                    <input type="date" name="eventDate" class="es-input no-past-date" value="${event.eventDate}" required>
                </div>
                <div class="es-form-group">
                    <label class="required">Guest Count</label>
                    <input type="number" name="guestCount" class="es-input" value="${event.guestCount}" required min="1">
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Time</label>
                    <input type="time" name="startTime" class="es-input" value="${event.startTime}">
                </div>
                <div class="es-form-group">
                    <label>End Time</label>
                    <input type="time" name="endTime" class="es-input" value="${event.endTime}">
                </div>
            </div>

            <div class="es-form-group">
                <label>Location</label>
                <input type="text" name="location" class="es-input" value="${event.location}" placeholder="Event venue or area">
            </div>

            <div class="es-form-group">
                <label>Requirements / Notes</label>
                <textarea name="requirements" class="es-textarea" rows="3">${event.requirements}</textarea>
            </div>

            <div class="es-form-group">
                <label>Internal Notes</label>
                <textarea name="notes" class="es-textarea" rows="2">${event.notes}</textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update Event' : 'Create Event'}</button>
                <a href="${pageContext.request.contextPath}/event/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

