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
        <div class="stat-card"><div class="stat-label">Upcoming Events</div><div class="stat-value">${upcomingEvents.size()}</div></div>
        <div class="stat-card gold"><div class="stat-label">Pending Tasks</div><div class="stat-value">${pendingCount}</div></div>
        <div class="stat-card red"><div class="stat-label">Overdue Tasks</div><div class="stat-value">${overdueCount}</div></div>
        <div class="stat-card blue"><div class="stat-label">In Progress</div><div class="stat-value">${inProgressTasks.size()}</div></div>
    </div>

    <!-- Overdue tasks alert -->
    <c:if test="${not empty overdueTasks}">
        <div class="es-alert es-alert-error">
            &#9888; <strong>${overdueTasks.size()} overdue task(s)</strong> require immediate attention.
            <a href="${pageContext.request.contextPath}/task/list?status=overdue" style="color:#C53030;text-decoration:underline;">View all</a>
        </div>
    </c:if>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <!-- Upcoming events -->
        <div class="es-card">
            <div class="card-header"><h3>Upcoming Events</h3><a href="${pageContext.request.contextPath}/event/list" class="btn btn-secondary btn-sm">All</a></div>
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
                                    <td><a href="${pageContext.request.contextPath}/event/detail/${e.eventId}">${e.eventName}</a></td>
                                    <td>${e.eventDate}</td>
                                    <td><c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${s}">${e.status}</span></td>
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
            <div class="card-header"><h3>Pending Tasks</h3><a href="${pageContext.request.contextPath}/task/create" class="btn btn-accent btn-sm">+ New Task</a></div>
            <c:choose>
                <c:when test="${empty pendingTasks}"><div class="es-empty"><p>No pending tasks.</p></div></c:when>
                <c:otherwise>
                    <div class="es-table-wrap">
                        <table class="es-table">
                            <thead><tr><th>Task</th><th>Event</th><th>Due</th><th>Priority</th></tr></thead>
                            <tbody>
                            <c:forEach var="t" items="${pendingTasks}" varStatus="st">
                                <c:if test="${st.index < 5}">
                                <tr class="${t.overdue ? 'overdue' : ''}">
                                    <td><a href="${pageContext.request.contextPath}/task/detail/${t.taskId}">${t.title}</a></td>
                                    <td>${t.eventName}</td>
                                    <td>${t.dueDate}</td>
                                    <td><span class="es-badge badge-${t.priority.toLowerCase()}">${t.priority}</span></td>
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
                        <td>${t.title}</td>
                        <td>${t.eventName}</td>
                        <td>${empty t.staffName ? 'Unassigned' : t.staffName}</td>
                        <td style="color:#E53E3E;">${t.dueDate}</td>
                        <td><span class="es-badge badge-${t.priority.toLowerCase()}">${t.priority}</span></td>
                        <td><a href="${pageContext.request.contextPath}/task/detail/${t.taskId}" class="btn btn-secondary btn-xs">View</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    </c:if>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

