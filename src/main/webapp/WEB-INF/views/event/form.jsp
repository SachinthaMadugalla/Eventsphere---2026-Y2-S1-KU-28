<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty event.eventId and event.eventId > 0}"/>
<c:set var="isOpsCoordinator" value="${sessionScope.userRole == 'Operations Coordinator' or isOpsCoordinator}"/>
<c:set var="pageTitle" value="${isEdit ? (isOpsCoordinator ? 'Event Operations' : 'Edit Event') : 'Create Event'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<style>
.badge-locked {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    background: #f1f5f9;
    color: #64748b;
    border: 1px solid #cbd5e1;
    border-radius: 4px;
    padding: 1px 7px;
    font-size: 11px;
    font-weight: 500;
    margin-left: 8px;
    text-transform: none;
    letter-spacing: normal;
}
.badge-action {
    display: inline-flex;
    align-items: center;
    background: #dbeafe;
    color: #1d4ed8;
    border-radius: 4px;
    padding: 1px 6px;
    margin-left: 6px;
    font-size: 11px;
    font-weight: 600;
    text-transform: none;
    letter-spacing: normal;
}
[data-theme="dark"] .badge-locked {
    background: #1e293b;
    color: #94a3b8;
    border-color: #334155;
}
[data-theme="dark"] .badge-action {
    background: rgba(59, 130, 246, 0.2);
    color: #93c5fd;
}
[data-theme="dark"] .ops-banner {
    background: rgba(30, 58, 138, 0.2) !important;
    border-color: #1e40af !important;
}
[data-theme="dark"] .ops-banner .ops-banner-title {
    color: #93c5fd !important;
}
[data-theme="dark"] .ops-banner .ops-banner-text {
    color: #cbd5e1 !important;
}
</style>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>
            <c:choose>
                <c:when test="${isEdit and isOpsCoordinator}"><i class="fa-solid fa-user-gear"></i> Event Operations & Manager Assignment</c:when>
                <c:when test="${isEdit}"><i class="fa-solid fa-pen-to-square"></i> Edit Event</c:when>
                <c:otherwise><i class="fa-solid fa-plus"></i> Create Event</c:otherwise>
            </c:choose>
        </h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list">Events</a>
            &rsaquo; ${fn:escapeXml(isEdit ? event.eventName : 'New Event')}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <c:if test="${isEdit and isOpsCoordinator}">
        <div class="ops-banner" style="background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border: 1px solid #bfdbfe; border-left: 4px solid #2563eb; border-radius: 8px; padding: 14px 18px; margin-bottom: 20px; display: flex; align-items: flex-start; gap: 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); max-width:800px;">
            <div style="background: #2563eb; color: #fff; width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-top: 2px;">
                <i class="fa-solid fa-shield-halved" style="font-size: 15px;"></i>
            </div>
            <div class="ops-banner-text" style="font-size: 13px; color: #1e3a8a; line-height: 1.5;">
                <strong class="ops-banner-title" style="display: block; font-size: 14px; margin-bottom: 3px; color: #1e40af;">Operations Management View</strong>
                Customer booking specifications (<strong>Event Name, Category, Customer, Event Date, Times, Guest Count, Requirements</strong>) are locked because they were placed by the customer.
                As Operations, you can <strong>Assign an Event Manager</strong>, update the operational <strong>Status</strong>, set the <strong>Location</strong>, and add <strong>Internal Notes</strong>.
            </div>
        </div>
    </c:if>

    <div class="es-card" style="max-width:800px;">
        <c:set var="formAction" value="${isEdit ? '/event/edit/'.concat(event.eventId) : '/event/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(formAction)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <!-- Event Name -->
            <div class="es-form-group">
                <label class="required">Event Name
                    <c:if test="${isEdit and isOpsCoordinator}">
                        <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                    </c:if>
                </label>
                <c:choose>
                    <c:when test="${isEdit and isOpsCoordinator}">
                        <input type="text" class="es-input" value="${fn:escapeXml(event.eventName)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                    </c:when>
                    <c:otherwise>
                        <input type="text" name="eventName" class="es-input" value="${fn:escapeXml(event.eventName)}" required maxlength="200">
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Category & Customer -->
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(event.categoryName)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <select name="categoryId" class="es-select" required>
                                <option value="">-- Select --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${fn:escapeXml(cat.categoryId)}" ${event.categoryId == cat.categoryId ? 'selected' : ''}>${fn:escapeXml(cat.categoryName)}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="es-form-group">
                    <label class="required">Customer
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(event.customerName)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <select name="customerId" class="es-select" required>
                                <option value="">-- Select Customer --</option>
                                <c:forEach var="c" items="${customers}">
                                    <option value="${fn:escapeXml(c.customerId)}" ${event.customerId == c.customerId ? 'selected' : ''}>${fn:escapeXml(c.fullName)}</option>
                                </c:forEach>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Assign Event Manager & Status -->
            <div class="es-form-row">
                <div class="es-form-group">
                    <label <c:if test="${isEdit and isOpsCoordinator}">style="font-weight: 600; color: #1e40af;"</c:if>>
                        <i class="fa-solid fa-user-tie" style="color: #2563eb; margin-right: 4px;"></i> Assign Event Manager
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-action">Operations Action</span>
                        </c:if>
                    </label>
                    <select name="managerUserId" class="es-select" <c:if test="${isEdit and isOpsCoordinator}">style="border-color:#3b82f6; box-shadow:0 0 0 1px rgba(59,130,246,0.15); font-weight:500;"</c:if>>
                        <option value="">-- Not assigned --</option>
                        <c:forEach var="m" items="${managers}">
                            <option value="${fn:escapeXml(m.userId)}" ${event.managerUserId == m.userId ? 'selected' : ''}>${fn:escapeXml(m.fullName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required" <c:if test="${isEdit and isOpsCoordinator}">style="font-weight: 600;"</c:if>>
                        <i class="fa-solid fa-tag" style="color: #2563eb; margin-right: 4px;"></i> Status
                    </label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                            <option value="${fn:escapeXml(st)}" ${event.status == st ? 'selected' : ''}>${fn:escapeXml(st)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Event Date & Guest Count -->
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event Date
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(event.eventDate)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <input type="date" name="eventDate" class="es-input no-past-date" value="${fn:escapeXml(event.eventDate)}" required>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="es-form-group">
                    <label class="required">Guest Count
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(event.guestCount)} Guests" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <input type="number" name="guestCount" class="es-input" value="${fn:escapeXml(event.guestCount)}" required min="1">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Start Time & End Time -->
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Time
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(empty event.startTime ? 'Not specified' : event.startTime)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <input type="time" name="startTime" class="es-input" value="${fn:escapeXml(event.startTime)}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="es-form-group">
                    <label>End Time
                        <c:if test="${isEdit and isOpsCoordinator}">
                            <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                        </c:if>
                    </label>
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}">
                            <input type="text" class="es-input" value="${fn:escapeXml(empty event.endTime ? 'Not specified' : event.endTime)}" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">
                        </c:when>
                        <c:otherwise>
                            <input type="time" name="endTime" class="es-input" value="${fn:escapeXml(event.endTime)}">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Location -->
            <div class="es-form-group">
                <label><i class="fa-solid fa-location-dot" style="color: #2563eb; margin-right: 4px;"></i> Location / Venue Note</label>
                <input type="text" name="location" class="es-input" value="${fn:escapeXml(event.location)}" placeholder="Event venue, area, or room">
            </div>

            <!-- Requirements / Notes -->
            <div class="es-form-group">
                <label>Customer Requirements / Notes
                    <c:if test="${isEdit and isOpsCoordinator}">
                        <span class="badge-locked"><i class="fa-solid fa-lock"></i> Customer Specified</span>
                    </c:if>
                </label>
                <c:choose>
                    <c:when test="${isEdit and isOpsCoordinator}">
                        <textarea class="es-textarea" rows="3" readonly disabled style="background-color: #f8fafc; color: #475569; cursor: not-allowed; border-color: #cbd5e1;">${fn:escapeXml(event.requirements)}</textarea>
                    </c:when>
                    <c:otherwise>
                        <textarea name="requirements" class="es-textarea" rows="3">${fn:escapeXml(event.requirements)}</textarea>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Internal Notes -->
            <div class="es-form-group">
                <label><i class="fa-solid fa-clipboard-list" style="color: #2563eb; margin-right: 4px;"></i> Internal Notes</label>
                <textarea name="notes" class="es-textarea" rows="2" placeholder="Operations, logistics, or staff notes...">${fn:escapeXml(event.notes)}</textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:16px;">
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${isEdit and isOpsCoordinator}"><i class="fa-solid fa-check"></i> Save Operational Details</c:when>
                        <c:when test="${isEdit}"><i class="fa-solid fa-check"></i> Update Event</c:when>
                        <c:otherwise><i class="fa-solid fa-plus"></i> Create Event</c:otherwise>
                    </c:choose>
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
