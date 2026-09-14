<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Assign Venue"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>&#127968; Assign Venue to Event</h2>
        <div class="breadcrumb"><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list">Events</a> &rsaquo; Assign Venue</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <c:if test="${not empty event}">
        <div class="es-alert es-alert-info">
            Assigning venue to: <strong>${fn:escapeXml(event.eventName)}</strong> on <strong>${fn:escapeXml(event.eventDate)}</strong> (${fn:escapeXml(event.guestCount)} guests)
        </div>
    </c:if>

    <div class="es-card" style="max-width:600px;">
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/venue/assign" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
            <div class="es-form-group">
                <label class="required">Select Venue</label>
                <select name="venueId" class="es-select" required>
                    <option value="">-- Select Venue --</option>
                    <c:forEach var="v" items="${venues}">
                        <option value="${fn:escapeXml(v.venueId)}">${fn:escapeXml(v.venueName)} – ${fn:escapeXml(v.location)} (Cap: ${fn:escapeXml(v.capacity)})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="es-form-group">
                <label class="required">Assigned Date</label>
                <input type="date" name="assignedDate" class="es-input" value="${fn:escapeXml(event.eventDate)}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Time</label>
                    <input type="time" name="startTime" class="es-input">
                </div>
                <div class="es-form-group">
                    <label>End Time</label>
                    <input type="time" name="endTime" class="es-input">
                </div>
            </div>
            <div class="es-form-group">
                <label>Notes</label>
                <input type="text" name="notes" class="es-input" placeholder="Optional notes">
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">Assign Venue</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(event.eventId)}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

