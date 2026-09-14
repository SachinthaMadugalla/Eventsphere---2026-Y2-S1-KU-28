<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Event Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; ${fn:escapeXml(event.eventName)}</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list">Events</a> &rsaquo; Details
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Event header card -->
    <div class="es-card">
        <div class="card-header">
            <h3>${fn:escapeXml(event.eventName)}</h3>
            <div style="display:flex;gap:8px;align-items:center;">
                <c:set var="s" value="${event.status.toLowerCase().replace(' ','')}"/>
                <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(event.status)}</span>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/edit/${fn:escapeXml(event.eventId)}" class="btn btn-primary btn-sm">Edit</a>
            </div>
        </div>

        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Category</div><div class="detail-value">${fn:escapeXml(event.categoryName)}</div></div>
            <div class="detail-item"><div class="detail-label">Customer</div><div class="detail-value">${fn:escapeXml(event.customerName)}</div></div>
            <div class="detail-item"><div class="detail-label">Event Date</div><div class="detail-value">${fn:escapeXml(event.eventDate)}</div></div>
            <div class="detail-item"><div class="detail-label">Time</div><div class="detail-value">${fn:escapeXml(empty event.startTime ? '—' : event.startTime)} – ${fn:escapeXml(empty event.endTime ? '—' : event.endTime)}</div></div>
            <div class="detail-item"><div class="detail-label">Guest Count</div><div class="detail-value">${fn:escapeXml(event.guestCount)}</div></div>
            <div class="detail-item"><div class="detail-label">Location</div><div class="detail-value">${fn:escapeXml(empty event.location ? 'Not set' : event.location)}</div></div>
            <div class="detail-item"><div class="detail-label">Event Manager</div><div class="detail-value">${fn:escapeXml(empty event.managerName ? 'Not assigned' : event.managerName)}</div></div>
            <div class="detail-item"><div class="detail-label">Created</div><div class="detail-value">${fn:escapeXml(event.createdAt)}</div></div>
        </div>

        <c:if test="${not empty event.requirements}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Requirements</div><div class="detail-value">${fn:escapeXml(event.requirements)}</div></div>
        </c:if>

        <!-- Status update & confirm booking -->
        <div style="margin-top:20px;display:flex;gap:10px;flex-wrap:wrap;">
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/status/${fn:escapeXml(event.eventId)}" method="post" style="display:flex;gap:6px;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <select name="status" class="es-select" style="width:auto;">
                    <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                        <option value="${fn:escapeXml(st)}" ${fn:escapeXml(event.status == st ? 'selected' : '')}>${fn:escapeXml(st)}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Update Status</button>
            </form>
            <c:if test="${event.status == 'Requested' or event.status == 'Pending'}">
                <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/confirm/${fn:escapeXml(event.eventId)}" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                    <button type="submit" class="btn btn-success btn-sm">&#10003; Confirm Booking</button>
                </form>
            </c:if>
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/delete/${fn:escapeXml(event.eventId)}" method="post" onsubmit="return confirmDelete('this event')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <button type="submit" class="btn btn-danger btn-sm">Delete Event</button>
            </form>
        </div>
    </div>

    <!-- Venue Assignments -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#127968; Venue Assignments</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/assign?eventId=${fn:escapeXml(event.eventId)}" class="btn btn-accent btn-sm">+ Assign Venue</a>
        </div>
        <c:choose>
            <c:when test="${empty venueAssignments}">
                <div class="es-empty"><span class="es-empty-icon">&#127968;</span><p>No venue assigned yet.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Venue</th><th>Date</th><th>Time</th><th>Notes</th><th>Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="ev" items="${venueAssignments}">
                            <tr>
                                <td>${fn:escapeXml(ev.venueName)}</td>
                                <td>${fn:escapeXml(ev.assignedDate)}</td>
                                <td>${fn:escapeXml(empty ev.startTime ? '—' : ev.startTime)} – ${fn:escapeXml(empty ev.endTime ? '—' : ev.endTime)}</td>
                                <td>${fn:escapeXml(empty ev.notes ? '—' : ev.notes)}</td>
                                <td>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/venue/assign/remove/${fn:escapeXml(ev.eventVenueId)}" method="post" onsubmit="return confirmDelete('this venue assignment')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
                                        <button type="submit" class="btn btn-danger btn-xs">Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Vendor Assignments -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128722; Vendor Assignments</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/vendor/assign?eventId=${fn:escapeXml(event.eventId)}" class="btn btn-accent btn-sm">+ Assign Vendor</a>
        </div>
        <c:choose>
            <c:when test="${empty vendorAssignments}">
                <div class="es-empty"><span class="es-empty-icon">&#128722;</span><p>No vendors assigned yet.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Vendor</th><th>Category</th><th>Service Date</th><th>Notes</th><th>Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="ev" items="${vendorAssignments}">
                            <tr>
                                <td>${fn:escapeXml(ev.vendorName)}</td>
                                <td>${fn:escapeXml(ev.categoryName)}</td>
                                <td>${fn:escapeXml(ev.serviceDate)}</td>
                                <td>${fn:escapeXml(empty ev.notes ? '—' : ev.notes)}</td>
                                <td>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/vendor/assign/remove/${fn:escapeXml(ev.eventVendorId)}" method="post" onsubmit="return confirmDelete('this vendor assignment')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
                                        <button type="submit" class="btn btn-danger btn-xs">Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Staff Assignments -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128100; Staff Assignments</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/assign?eventId=${fn:escapeXml(event.eventId)}" class="btn btn-accent btn-sm">+ Assign Staff</a>
        </div>
        <c:choose>
            <c:when test="${empty staffAssignments}">
                <div class="es-empty"><span class="es-empty-icon">&#128100;</span><p>No staff assigned yet.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Staff Member</th><th>Role at Event</th><th>Date</th><th>Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="sa" items="${staffAssignments}">
                            <tr>
                                <td>${fn:escapeXml(sa.staffName)}</td>
                                <td>${fn:escapeXml(empty sa.roleAtEvent ? '—' : sa.roleAtEvent)}</td>
                                <td>${fn:escapeXml(sa.assignedDate)}</td>
                                <td>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/staff/assign/remove/${fn:escapeXml(sa.assignmentId)}" method="post" onsubmit="return confirmDelete('this staff assignment')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
                                        <button type="submit" class="btn btn-danger btn-xs">Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Quick links -->
    <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:4px;">
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/allocate?eventId=${fn:escapeXml(event.eventId)}" class="btn btn-secondary">&#128230; Manage Resources</a>
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/create?eventId=${fn:escapeXml(event.eventId)}" class="btn btn-secondary">&#9989; Add Task</a>
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/budget/create" class="btn btn-secondary">&#128176; Budget</a>
        <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary">&#8592; Back</a>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

