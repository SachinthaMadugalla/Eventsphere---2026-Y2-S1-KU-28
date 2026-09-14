<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty expense.expenseId and expense.expenseId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Expense' : 'Record Expense'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>${fn:escapeXml(isEdit ? '&#9998; Edit Expense' : '&#43; Record Expense')}</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/expense/list">Expenses</a>
            &rsaquo; ${fn:escapeXml(isEdit ? 'Edit' : 'New Expense')}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:640px;">
        <c:set var="action" value="${isEdit ? '/finance/expense/edit/'.concat(expense.expenseId) : '/finance/expense/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(action)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-group">
                <label class="required">Event</label>
                <select name="eventId" class="es-select" required ${fn:escapeXml(isEdit ? 'disabled' : '')}>
                    <option value="">-- Select Event --</option>
                    <c:forEach var="e" items="${events}">
                        <option value="${fn:escapeXml(e.eventId)}"
                            ${fn:escapeXml(expense.eventId == e.eventId ? 'selected' : '')}>
                            ${fn:escapeXml(e.eventName)}
                        </option>
                    </c:forEach>
                </select>
                <%-- Re-send eventId as hidden when editing (disabled select not submitted) --%>
                <c:if test="${isEdit}">
                    <input type="hidden" name="eventId" value="${fn:escapeXml(expense.eventId)}">
                </c:if>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category</label>
                    <select name="category" class="es-select" required>
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${['Venue','Catering','Decoration','Photography','Sound & Lighting','Entertainment','Equipment','Staff','Transport','Miscellaneous']}">
                            <option value="${fn:escapeXml(cat)}" ${fn:escapeXml(expense.category == cat ? 'selected' : '')}>${fn:escapeXml(cat)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Amount (LKR)</label>
                    <input type="number" name="amount" class="es-input"
                           value="${fn:escapeXml(expense.amount)}" required min="0.01" step="0.01"
                           placeholder="0.00">
                </div>
            </div>

            <div class="es-form-group">
                <label class="required">Description</label>
                <input type="text" name="description" class="es-input"
                       value="${fn:escapeXml(expense.description)}" required maxlength="255"
                       placeholder="Brief description of the expense">
            </div>

            <div class="es-form-group">
                <label class="required">Expense Date</label>
                <input type="date" name="expenseDate" class="es-input"
                       value="${fn:escapeXml(expense.expenseDate)}" required>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">
                    ${fn:escapeXml(isEdit ? 'Update Expense' : 'Record Expense')}
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/expense/list"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

