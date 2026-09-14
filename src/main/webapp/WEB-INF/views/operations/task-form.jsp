<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty task.taskId and task.taskId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Task' : 'Create Task'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${isEdit ? '&#9998; Edit Task' : '&#43; Create Task'}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:640px;">
        <c:set var="action" value="${isEdit ? '/task/edit/'.concat(task.taskId) : '/task/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Task Title</label>
                <input type="text" name="title" class="es-input" value="${task.title}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event</label>
                    <select name="eventId" class="es-select" required>
                        <option value="">-- Select Event --</option>
                        <c:forEach var="e" items="${events}">
                            <option value="${e.eventId}" ${task.eventId == e.eventId ? 'selected' : ''}>${e.eventName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label>Assign To (Staff)</label>
                    <select name="assignedTo" class="es-select">
                        <option value="">-- Unassigned --</option>
                        <c:forEach var="s" items="${staffList}">
                            <option value="${s.staffId}" ${task.assignedTo == s.staffId ? 'selected' : ''}>${s.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Priority</label>
                    <select name="priority" class="es-select" required>
                        <c:forEach var="p" items="${['Low','Medium','High']}">
                            <option value="${p}" ${task.priority == p ? 'selected' : ''}>${p}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Status</label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="s" items="${['Not Started','In Progress','Completed','Cancelled']}">
                            <option value="${s}" ${task.status == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Start Date</label>
                    <input type="date" name="startDate" class="es-input" value="${task.startDate}">
                </div>
                <div class="es-form-group">
                    <label class="required">Due Date</label>
                    <input type="date" name="dueDate" class="es-input" value="${task.dueDate}" required>
                </div>
            </div>
            <div class="es-form-group">
                <label>Description</label>
                <textarea name="description" class="es-textarea" rows="3">${task.description}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update Task' : 'Create Task'}</button>
                <a href="${pageContext.request.contextPath}/task/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

