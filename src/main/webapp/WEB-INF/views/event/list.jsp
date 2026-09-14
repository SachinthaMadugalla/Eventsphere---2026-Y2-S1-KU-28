<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Events"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; Events</h2>
        <div class="breadcrumb">Home &rsaquo; Events</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>${archiveView ? "Archived Events" : "All Events"}</h3>
            <div style="display:flex;gap:8px;flex-wrap:wrap;">
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/archive" class="btn btn-secondary btn-sm">Archive</a>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary btn-sm">Current Events</a>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/create" class="btn btn-accent btn-sm">+ Create Event</a>
            </div>
        </div>

        <!-- Search & Filter -->
        <form method="get" action="${fn:escapeXml(pageContext.request.contextPath)}/event/list" style="display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;">
            <input type="text" name="search" class="es-input" placeholder="Search events..." value="${fn:escapeXml(search)}" style="max-width:260px;">
            <select name="status" class="es-select" style="max-width:180px;">
                <option value="">All Statuses</option>
                <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                    <option value="${fn:escapeXml(st)}" ${fn:escapeXml(filterStatus == st ? 'selected' : '')}>${fn:escapeXml(st)}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary btn-sm">Clear</a>
        </form>

        <c:choose>
            <c:when test="${empty events}">
                <div class="es-empty"><span class="es-empty-icon">&#128197;</span><p>No events found.</p></div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table" id="eventTable">
                        <thead>
                            <tr>
                                <th>#</th><th>Event Name</th><th>Category</th>
                                <th>Customer</th><th>Date</th><th>Guests</th>
                                <th>Manager</th><th>Status</th><th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="e" items="${events}" varStatus="st">
                            <tr>
                                <td>${fn:escapeXml(st.count)}</td>
                                <td><strong>${fn:escapeXml(e.eventName)}</strong></td>
                                <td>${fn:escapeXml(e.categoryName)}</td>
                                <td>${fn:escapeXml(e.customerName)}</td>
                                <td>${fn:escapeXml(e.eventDate)}</td>
                                <td>${fn:escapeXml(e.guestCount)}</td>
                                <td>${fn:escapeXml(empty e.managerName ? '—' : e.managerName)}</td>
                                <td>
                                    <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span>
                                </td>
                                <td>
                                    <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(e.eventId)}" class="btn btn-secondary btn-xs">View</a>
                                    <c:if test="${!e.archived}"><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/edit/${fn:escapeXml(e.eventId)}" class="btn btn-primary btn-xs">Edit</a></c:if>
                                    <c:if test="${e.status == 'Completed' || e.status == 'Cancelled'}">
                                        <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/archive/${e.eventId}" method="post" style="display:inline;">
                                            <input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                            <input type="hidden" name="archived" value="${!e.archived}">
                                            <button class="btn btn-secondary btn-xs">${e.archived ? 'Restore' : 'Archive'}</button>
                                        </form>
                                    </c:if>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/event/delete/${fn:escapeXml(e.eventId)}" method="post" style="display:inline;" onsubmit="return confirmDelete('this event')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <button type="submit" class="btn btn-danger btn-xs">Delete</button>
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
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

