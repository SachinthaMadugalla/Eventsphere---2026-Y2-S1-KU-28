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
        <h2>&#128197; ${event.eventName}</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/event/list">Events</a> &rsaquo; Details
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Event header card -->
    <div class="es-card">
        <div class="card-header">
            <h3>${event.eventName}</h3>
            <div style="display:flex;gap:8px;align-items:center;">
                <c:set var="s" value="${event.status.toLowerCase().replace(' ','')}"/>
                <span class="es-badge badge-${s}">${event.status}</span>
                <a href="${pageContext.request.contextPath}/event/edit/${event.eventId}" class="btn btn-primary btn-sm">Edit</a>
            </div>
        </div>

        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Category</div><div class="detail-value">${event.categoryName}</div></div>
            <div class="detail-item"><div class="detail-label">Customer</div><div class="detail-value">${event.customerName}</div></div>
            <div class="detail-item"><div class="detail-label">Event Date</div><div class="detail-value">${event.eventDate}</div></div>
            <div class="detail-item"><div class="detail-label">Time</div><div class="detail-value">${empty event.startTime ? 'â€”' : event.startTime} â€“ ${empty event.endTime ? 'â€”' : event.endTime}</div></div>
            <div class="detail-item"><div class="detail-label">Guest Count</div><div class="detail-value">${event.guestCount}</div></div>
            <div class="detail-item"><div class="detail-label">Location</div><div class="detail-value">${empty event.location ? 'Not set' : event.location}</div></div>
            <div class="detail-item"><div class="detail-label">Event Manager</div><div class="detail-value">${empty event.managerName ? 'Not assigned' : event.managerName}</div></div>
            <div class="detail-item"><div class="detail-label">Created</div><div class="detail-value">${event.createdAt}</div></div>
        </div>

        <c:if test="${not empty event.requirements}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Requirements</div><div class="detail-value">${event.requirements}</div></div>
        </c:if>

        <!-- Status update & confirm booking -->
        <div style="margin-top:20px;display:flex;gap:10px;flex-wrap:wrap;">
            <form action="${pageContext.request.contextPath}/event/status/${event.eventId}" method="post" style="display:flex;gap:6px;">
                <select name="status" class="es-select" style="width:auto;">
                    <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                        <option value="${st}" ${event.status == st ? 'selected' : ''}>${st}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Update Status</button>
            </form>
            <c:if test="${event.status == 'Requested' or event.status == 'Pending'}">
                <form action="${pageContext.request.contextPath}/event/confirm/${event.eventId}" method="post">
                    <input type="hidden" name="customerUserId" value="${event.customerId}">
                    <button type="submit" class="btn btn-success btn-sm">&#10003; Confirm Booking</button>
                </form>
            </c:if>
            <form action="${pageContext.request.contextPath}/event/delete/${event.eventId}" method="post" onsubmit="return confirmDelete('this event')">
                <button type="submit" class="btn btn-danger btn-sm">Delete Event</button>
            </form>
        </div>
    </div>

    <!-- Venue Assignments -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#127968; Venue Assignments</h3>
            <a href="${pageContext.request.contextPath}/venue/assign?eventId=${event.eventId}" class="btn btn-accent btn-sm">+ Assign Venue</a>
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
                                <td>${ev.venueName}</td>
                                <td>${ev.assignedDate}</td>
                                <td>${empty ev.startTime ? 'â€”' : ev.startTime} â€“ ${empty ev.endTime ? 'â€”' : ev.endTime}</td>
                                <td>${empty ev.notes ? 'â€”' : ev.notes}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/venue/assign/remove/${ev.eventVenueId}" method="post" onsubmit="return confirmDelete('this venue assignment')">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
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
            <a href="${pageContext.request.contextPath}/vendor/assign?eventId=${event.eventId}" class="btn btn-accent btn-sm">+ Assign Vendor</a>
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
                                <td>${ev.vendorName}</td>
                                <td>${ev.categoryName}</td>
                                <td>${ev.serviceDate}</td>
                                <td>${empty ev.notes ? 'â€”' : ev.notes}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/vendor/assign/remove/${ev.eventVendorId}" method="post" onsubmit="return confirmDelete('this vendor assignment')">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
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
            <a href="${pageContext.request.contextPath}/staff/assign?eventId=${event.eventId}" class="btn btn-accent btn-sm">+ Assign Staff</a>
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
                                <td>${sa.staffName}</td>
                                <td>${empty sa.roleAtEvent ? 'â€”' : sa.roleAtEvent}</td>
                                <td>${sa.assignedDate}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/staff/assign/remove/${sa.assignmentId}" method="post" onsubmit="return confirmDelete('this staff assignment')">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
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
        <a href="${pageContext.request.contextPath}/resource/allocate?eventId=${event.eventId}" class="btn btn-secondary">&#128230; Manage Resources</a>
        <a href="${pageContext.request.contextPath}/task/create?eventId=${event.eventId}" class="btn btn-secondary">&#9989; Add Task</a>
        <a href="${pageContext.request.contextPath}/finance/budget/create" class="btn btn-secondary">&#128176; Budget</a>
        <a href="${pageContext.request.contextPath}/event/list" class="btn btn-secondary">&#8592; Back</a>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

