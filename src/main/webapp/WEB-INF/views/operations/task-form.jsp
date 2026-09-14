<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty task.taskId and task.taskId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Task' : 'Create Task'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${fn:escapeXml(isEdit ? '&#9998; Edit Task' : '&#43; Create Task')}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:640px;">
        <c:set var="action" value="${isEdit ? '/task/edit/'.concat(task.taskId) : '/task/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(action)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-group">
                <label class="required">Task Title</label>
                <input type="text" name="title" class="es-input" value="${fn:escapeXml(task.title)}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event</label>
                    <select name="eventId" class="es-select" required>
                        <option value="">-- Select Event --</option>
                        <c:forEach var="e" items="${events}">
                            <option value="${fn:escapeXml(e.eventId)}" ${fn:escapeXml(task.eventId == e.eventId ? 'selected' : '')}>${fn:escapeXml(e.eventName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label>Assign To (Staff)</label>
                    <select name="assignedTo" class="es-select">
                        <option value="">-- Unassigned --</option>
                        <c:forEach var="s" items="${staffList}">
                            <option value="${fn:escapeXml(s.staffId)}" ${fn:escapeXml(task.assignedTo == s.staffId ? 'selected' : '')}>${fn:escapeXml(s.fullName)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Priority</label>
                    <select name="priority" class="es-select" required>
                        <c:forEach var="p" items="${['Low','Medium','High']}">
                            <option value="${fn:escapeXml(p)}" ${fn:escapeXml(task.priority == p ? 'selected' : '')}>${fn:escapeXml(p)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Status</label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="s" items="${['Not Started','In Progress','Completed','Cancelled']}">
                            <option value="${fn:escapeXml(s)}" ${fn:escapeXml(task.status == s ? 'selected' : '')}>${fn:escapeXml(s)}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Date</label>
                    <input type="date" name="startDate" class="es-input" value="${fn:escapeXml(task.startDate)}">
                </div>
                <div class="es-form-group">
                    <label class="required">Due Date</label>
                    <input type="date" name="dueDate" class="es-input" value="${fn:escapeXml(task.dueDate)}" required>
                </div>
            </div>
            <div class="es-form-group">
                <label>Description</label>
                <textarea name="description" class="es-textarea" rows="3">${fn:escapeXml(task.description)}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${fn:escapeXml(isEdit ? 'Update Task' : 'Create Task')}</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

