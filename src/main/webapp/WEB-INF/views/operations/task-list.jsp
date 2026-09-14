<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Tasks"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#9989; Tasks</h2><div class="breadcrumb">Home &rsaquo; Tasks</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>Task List</h3>
            <div style="display:flex;gap:8px;">
                <a href="${pageContext.request.contextPath}/task/create" class="btn btn-accent btn-sm">+ New Task</a>
            </div>
        </div>

        <!-- Filter -->
        <form method="get" action="${pageContext.request.contextPath}/task/list" style="display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;">
            <select name="status" class="es-select" style="max-width:180px;">
                <option value="">All Statuses</option>
                <c:forEach var="s" items="${['Not Started','In Progress','Completed','Cancelled']}">
                    <option value="${s}" ${filterStatus == s ? 'selected' : ''}>${s}</option>
                </c:forEach>
            </select>
            <select name="eventId" class="es-select" style="max-width:220px;">
                <option value="">All Events</option>
                <c:forEach var="e" items="${events}">
                    <option value="${e.eventId}">${e.eventName}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="${pageContext.request.contextPath}/task/list" class="btn btn-secondary btn-sm">Clear</a>
        </form>

        <c:choose>
            <c:when test="${empty tasks}"><div class="es-empty"><span class="es-empty-icon">&#9989;</span><p>No tasks found.</p></div></c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>#</th><th>Title</th><th>Event</th><th>Assigned To</th><th>Due Date</th><th>Priority</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="t" items="${tasks}" varStatus="st">
                            <tr class="${t.overdue ? 'overdue' : ''}">
                                <td>${st.count}</td>
                                <td><strong>${t.title}</strong></td>
                                <td>${t.eventName}</td>
                                <td>${empty t.staffName ? 'â€”' : t.staffName}</td>
                                <td>${t.dueDate}</td>
                                <td><span class="es-badge badge-${t.priority.toLowerCase()}">${t.priority}</span></td>
                                <td><c:set var="s" value="${t.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${s}">${t.status}</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/task/detail/${t.taskId}" class="btn btn-secondary btn-xs">View</a>
                                    <a href="${pageContext.request.contextPath}/task/edit/${t.taskId}" class="btn btn-primary btn-xs">Edit</a>
                                    <form action="${pageContext.request.contextPath}/task/delete/${t.taskId}" method="post" style="display:inline;" onsubmit="return confirmDelete('this task')">
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

