<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Task Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#9989; Task Details</h2><div class="breadcrumb"><a href="${pageContext.request.contextPath}/task/list">Tasks</a> &rsaquo; ${task.title}</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>${task.title}</h3>
            <div style="display:flex;gap:8px;">
                <span class="es-badge badge-${task.priority.toLowerCase()}">${task.priority}</span>
                <c:set var="s" value="${task.status.toLowerCase().replace(' ','')}"/>
                <span class="es-badge badge-${s}">${task.status}</span>
                <c:if test="${task.overdue}"><span class="es-badge badge-cancelled">OVERDUE</span></c:if>
            </div>
        </div>

        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Event</div><div class="detail-value"><a href="${pageContext.request.contextPath}/event/detail/${task.eventId}">${task.eventName}</a></div></div>
            <div class="detail-item"><div class="detail-label">Assigned To</div><div class="detail-value">${empty task.staffName ? 'Unassigned' : task.staffName}</div></div>
            <div class="detail-item"><div class="detail-label">Start Date</div><div class="detail-value"><c:choose><c:when test="${not empty task.startDate}">${task.startDate}</c:when><c:otherwise>â€”</c:otherwise></c:choose></div></div>
            <div class="detail-item"><div class="detail-label">Due Date</div><div class="detail-value" style="${task.overdue ? 'color:#E53E3E;font-weight:700;' : ''}">${task.dueDate}</div></div>
        </div>

        <c:if test="${not empty task.description}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Description</div><div class="detail-value">${task.description}</div></div>
        </c:if>

        <!-- Update status -->
        <div style="margin-top:20px;display:flex;gap:10px;flex-wrap:wrap;align-items:center;">
            <form action="${pageContext.request.contextPath}/task/status/${task.taskId}" method="post" style="display:flex;gap:6px;">
                <select name="status" class="es-select" style="width:auto;">
                    <c:forEach var="s" items="${['Not Started','In Progress','Completed','Cancelled']}">
                        <option value="${s}" ${task.status == s ? 'selected' : ''}>${s}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Update Status</button>
            </form>
            <a href="${pageContext.request.contextPath}/task/edit/${task.taskId}" class="btn btn-secondary btn-sm">Edit Task</a>
        </div>

        <!-- Reassign -->
        <div style="margin-top:16px;">
            <form action="${pageContext.request.contextPath}/task/reassign/${task.taskId}" method="post" style="display:flex;gap:8px;align-items:center;">
                <label style="font-size:12px;font-weight:600;color:#4A5568;">Reassign to:</label>
                <select name="staffId" class="es-select" style="width:auto;">
                    <c:forEach var="s" items="${staffList}">
                        <option value="${s.staffId}" ${task.assignedTo == s.staffId ? 'selected' : ''}>${s.fullName}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-accent btn-sm">Reassign</button>
            </form>
        </div>

        <div style="margin-top:16px;">
            <a href="${pageContext.request.contextPath}/task/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
            <form action="${pageContext.request.contextPath}/task/delete/${task.taskId}" method="post" style="display:inline;" onsubmit="return confirmDelete('this task')">
                <button type="submit" class="btn btn-danger btn-sm" style="margin-left:8px;">Delete</button>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

