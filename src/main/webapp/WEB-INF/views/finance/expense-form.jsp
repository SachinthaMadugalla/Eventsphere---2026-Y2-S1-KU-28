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
        <h2>${isEdit ? '&#9998; Edit Expense' : '&#43; Record Expense'}</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/finance/expense/list">Expenses</a>
            &rsaquo; ${isEdit ? 'Edit' : 'New Expense'}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:640px;">
        <c:set var="action" value="${isEdit ? '/finance/expense/edit/'.concat(expense.expenseId) : '/finance/expense/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">

            <div class="es-form-group">
                <label class="required">Event</label>
                <select name="eventId" class="es-select" required ${isEdit ? 'disabled' : ''}>
                    <option value="">-- Select Event --</option>
                    <c:forEach var="e" items="${events}">
                        <option value="${e.eventId}"
                            ${expense.eventId == e.eventId ? 'selected' : ''}>
                            ${e.eventName}
                        </option>
                    </c:forEach>
                </select>
                <%-- Re-send eventId as hidden when editing (disabled select not submitted) --%>
                <c:if test="${isEdit}">
                    <input type="hidden" name="eventId" value="${expense.eventId}">
                </c:if>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Category</label>
                    <select name="category" class="es-select" required>
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${['Venue','Catering','Decoration','Photography','Sound & Lighting','Entertainment','Equipment','Staff','Transport','Miscellaneous']}">
                            <option value="${cat}" ${expense.category == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Amount (LKR)</label>
                    <input type="number" name="amount" class="es-input"
                           value="${expense.amount}" required min="0.01" step="0.01"
                           placeholder="0.00">
                </div>
            </div>

            <div class="es-form-group">
                <label class="required">Description</label>
                <input type="text" name="description" class="es-input"
                       value="${expense.description}" required maxlength="255"
                       placeholder="Brief description of the expense">
            </div>

            <div class="es-form-group">
                <label class="required">Expense Date</label>
                <input type="date" name="expenseDate" class="es-input"
                       value="${expense.expenseDate}" required>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">
                    ${isEdit ? 'Update Expense' : 'Record Expense'}
                </button>
                <a href="${pageContext.request.contextPath}/finance/expense/list"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

