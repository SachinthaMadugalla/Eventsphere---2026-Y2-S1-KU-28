<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty budget.budgetId and budget.budgetId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Budget' : 'Create Budget'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${isEdit ? '&#9998; Edit Budget' : '&#43; Create Budget'}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:560px;">
        <c:set var="action" value="${isEdit ? '/finance/budget/edit/'.concat(budget.budgetId) : '/finance/budget/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Event</label>
                <select name="eventId" class="es-select" required ${isEdit ? 'disabled' : ''}>
                    <option value="">-- Select Event --</option>
                    <c:forEach var="e" items="${events}">
                        <option value="${e.eventId}" ${budget.eventId == e.eventId ? 'selected' : ''}>${e.eventName}</option>
                    </c:forEach>
                </select>
                <c:if test="${isEdit}"><input type="hidden" name="eventId" value="${budget.eventId}"></c:if>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Total Budget (LKR)</label>
                    <input type="number" name="totalBudget" class="es-input" value="${budget.totalBudget}" required min="0" step="0.01">
                </div>
                <div class="es-form-group">
                    <label>Estimated Cost (LKR)</label>
                    <input type="number" name="estimatedCost" class="es-input" value="${budget.estimatedCost}" min="0" step="0.01">
                </div>
            </div>
            <c:if test="${isEdit}">
                <div class="es-form-group">
                    <label>Actual Cost (LKR)</label>
                    <input type="number" name="actualCost" class="es-input" value="${budget.actualCost}" min="0" step="0.01">
                </div>
            </c:if>
            <div class="es-form-group">
                <label>Notes</label>
                <textarea name="notes" class="es-textarea" rows="2">${budget.notes}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update Budget' : 'Create Budget'}</button>
                <a href="${pageContext.request.contextPath}/finance/budget/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

