<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Operations Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#9989; Operations Dashboard</h2><div class="breadcrumb">Home &rsaquo; Operations</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="stat-cards">
        <div class="stat-card"><div class="stat-label">Upcoming Events</div><div class="stat-value">${fn:escapeXml(upcomingEvents.size())}</div></div>
        <div class="stat-card gold"><div class="stat-label">Pending Tasks</div><div class="stat-value">${fn:escapeXml(pendingCount)}</div></div>
        <div class="stat-card red"><div class="stat-label">Overdue Tasks</div><div class="stat-value">${fn:escapeXml(overdueCount)}</div></div>
        <div class="stat-card blue"><div class="stat-label">In Progress</div><div class="stat-value">${fn:escapeXml(inProgressTasks.size())}</div></div>
    </div>

    <!-- Overdue tasks alert -->
    <c:if test="${not empty overdueTasks}">
        <div class="es-alert es-alert-error">
            &#9888; <strong>${fn:escapeXml(overdueTasks.size())} overdue task(s)</strong> require immediate attention.
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list?status=overdue" style="color:#C53030;text-decoration:underline;">View all</a>
        </div>
    </c:if>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <!-- Upcoming events -->
        <div class="es-card">
            <div class="card-header"><h3>Upcoming Events</h3><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="btn btn-secondary btn-sm">All</a></div>
            <c:choose>
                <c:when test="${empty upcomingEvents}"><div class="es-empty"><p>No upcoming events.</p></div></c:when>
                <c:otherwise>
                    <div class="es-table-wrap">
                        <table class="es-table">
                            <thead><tr><th>Event</th><th>Date</th><th>Status</th></tr></thead>
                            <tbody>
                            <c:forEach var="e" items="${upcomingEvents}" varStatus="st">
                                <c:if test="${st.index < 5}">
                                <tr>
                                    <td><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(e.eventId)}">${fn:escapeXml(e.eventName)}</a></td>
                                    <td>${fn:escapeXml(e.eventDate)}</td>
                                    <td><c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(e.status)}</span></td>
                                </tr>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pending tasks -->
        <div class="es-card">
            <div class="card-header"><h3>Pending Tasks</h3><a href="${fn:escapeXml(pageContext.request.contextPath)}/task/create" class="btn btn-accent btn-sm">+ New Task</a></div>
            <c:choose>
                <c:when test="${empty pendingTasks}"><div class="es-empty"><p>No pending tasks.</p></div></c:when>
                <c:otherwise>
                    <div class="es-table-wrap">
                        <table class="es-table">
                            <thead><tr><th>Task</th><th>Event</th><th>Due</th><th>Priority</th></tr></thead>
                            <tbody>
                            <c:forEach var="t" items="${pendingTasks}" varStatus="st">
                                <c:if test="${st.index < 5}">
                                <tr class="${fn:escapeXml(t.overdue ? 'overdue' : '')}">
                                    <td><a href="${fn:escapeXml(pageContext.request.contextPath)}/task/detail/${fn:escapeXml(t.taskId)}">${fn:escapeXml(t.title)}</a></td>
                                    <td>${fn:escapeXml(t.eventName)}</td>
                                    <td>${fn:escapeXml(t.dueDate)}</td>
                                    <td><span class="es-badge badge-${fn:escapeXml(t.priority.toLowerCase())}">${fn:escapeXml(t.priority)}</span></td>
                                </tr>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Overdue tasks detail -->
    <c:if test="${not empty overdueTasks}">
    <div class="es-card">
        <div class="card-header"><h3 style="color:#E53E3E;">&#9888; Overdue Tasks</h3></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Task</th><th>Event</th><th>Assigned To</th><th>Due Date</th><th>Priority</th><th>Action</th></tr></thead>
                <tbody>
                <c:forEach var="t" items="${overdueTasks}">
                    <tr class="overdue">
                        <td>${fn:escapeXml(t.title)}</td>
                        <td>${fn:escapeXml(t.eventName)}</td>
                        <td>${fn:escapeXml(empty t.staffName ? 'Unassigned' : t.staffName)}</td>
                        <td style="color:#E53E3E;">${fn:escapeXml(t.dueDate)}</td>
                        <td><span class="es-badge badge-${fn:escapeXml(t.priority.toLowerCase())}">${fn:escapeXml(t.priority)}</span></td>
                        <td><a href="${fn:escapeXml(pageContext.request.contextPath)}/task/detail/${fn:escapeXml(t.taskId)}" class="btn btn-secondary btn-xs">View</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    </c:if>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

