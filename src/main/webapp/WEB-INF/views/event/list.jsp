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
            <h3>All Events</h3>
            <div style="display:flex;gap:8px;flex-wrap:wrap;">
                <a href="${pageContext.request.contextPath}/event/create" class="btn btn-accent btn-sm">+ Create Event</a>
            </div>
        </div>

        <!-- Search & Filter -->
        <form method="get" action="${pageContext.request.contextPath}/event/list" style="display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;">
            <input type="text" name="search" class="es-input" placeholder="Search events..." value="${search}" style="max-width:260px;">
            <select name="status" class="es-select" style="max-width:180px;">
                <option value="">All Statuses</option>
                <c:forEach var="st" items="${['Requested','Pending','Confirmed','Planning','In Progress','Completed','Cancelled']}">
                    <option value="${st}" ${filterStatus == st ? 'selected' : ''}>${st}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="${pageContext.request.contextPath}/event/list" class="btn btn-secondary btn-sm">Clear</a>
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
                                <td>${st.count}</td>
                                <td><strong>${e.eventName}</strong></td>
                                <td>${e.categoryName}</td>
                                <td>${e.customerName}</td>
                                <td>${e.eventDate}</td>
                                <td>${e.guestCount}</td>
                                <td>${empty e.managerName ? 'â€”' : e.managerName}</td>
                                <td>
                                    <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${s}">${e.status}</span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/event/detail/${e.eventId}" class="btn btn-secondary btn-xs">View</a>
                                    <a href="${pageContext.request.contextPath}/event/edit/${e.eventId}" class="btn btn-primary btn-xs">Edit</a>
                                    <form action="${pageContext.request.contextPath}/event/delete/${e.eventId}" method="post" style="display:inline;" onsubmit="return confirmDelete('this event')">
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

