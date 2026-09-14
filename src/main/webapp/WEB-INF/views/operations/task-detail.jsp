<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Task Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#9989; Task Details</h2><div class="breadcrumb"><a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list">Tasks</a> &rsaquo; ${fn:escapeXml(task.title)}</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>${fn:escapeXml(task.title)}</h3>
            <div style="display:flex;gap:8px;">
                <span class="es-badge badge-${fn:escapeXml(task.priority.toLowerCase())}">${fn:escapeXml(task.priority)}</span>
                <c:set var="s" value="${task.status.toLowerCase().replace(' ','')}"/>
                <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(task.status)}</span>
                <c:if test="${task.overdue}"><span class="es-badge badge-cancelled">OVERDUE</span></c:if>
            </div>
        </div>

        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Event</div><div class="detail-value"><a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(task.eventId)}">${fn:escapeXml(task.eventName)}</a></div></div>
            <div class="detail-item"><div class="detail-label">Assigned To</div><div class="detail-value">${fn:escapeXml(empty task.staffName ? 'Unassigned' : task.staffName)}</div></div>
            <div class="detail-item"><div class="detail-label">Start Date</div><div class="detail-value"><c:choose><c:when test="${not empty task.startDate}">${fn:escapeXml(task.startDate)}</c:when><c:otherwise>—</c:otherwise></c:choose></div></div>
            <div class="detail-item"><div class="detail-label">Due Date</div><div class="detail-value" style="${fn:escapeXml(task.overdue ? 'color:#E53E3E;font-weight:700;' : '')}">${fn:escapeXml(task.dueDate)}</div></div>
        </div>

        <c:if test="${not empty task.description}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Description</div><div class="detail-value">${fn:escapeXml(task.description)}</div></div>
        </c:if>

        <!-- Update status -->
        <div style="margin-top:20px;display:flex;gap:10px;flex-wrap:wrap;align-items:center;">
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/task/status/${fn:escapeXml(task.taskId)}" method="post" style="display:flex;gap:6px;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <select name="status" class="es-select" style="width:auto;">
                    <c:forEach var="s" items="${['Not Started','In Progress','Completed','Cancelled']}">
                        <option value="${fn:escapeXml(s)}" ${fn:escapeXml(task.status == s ? 'selected' : '')}>${fn:escapeXml(s)}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary btn-sm">Update Status</button>
            </form>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/edit/${fn:escapeXml(task.taskId)}" class="btn btn-secondary btn-sm">Edit Task</a>
        </div>

        <!-- Reassign -->
        <div style="margin-top:16px;">
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/task/reassign/${fn:escapeXml(task.taskId)}" method="post" style="display:flex;gap:8px;align-items:center;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <label style="font-size:12px;font-weight:600;color:#4A5568;">Reassign to:</label>
                <select name="staffId" class="es-select" style="width:auto;">
                    <c:forEach var="s" items="${staffList}">
                        <option value="${fn:escapeXml(s.staffId)}" ${fn:escapeXml(task.assignedTo == s.staffId ? 'selected' : '')}>${fn:escapeXml(s.fullName)}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-accent btn-sm">Reassign</button>
            </form>
        </div>

        <div style="margin-top:16px;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list" class="btn btn-secondary btn-sm">&#8592; Back</a>
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/task/delete/${fn:escapeXml(task.taskId)}" method="post" style="display:inline;" onsubmit="return confirmDelete('this task')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <button type="submit" class="btn btn-danger btn-sm" style="margin-left:8px;">Delete</button>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

