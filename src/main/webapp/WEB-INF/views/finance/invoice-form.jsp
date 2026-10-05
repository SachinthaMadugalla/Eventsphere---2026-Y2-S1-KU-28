<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Invoice"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#43; Create Invoice</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:640px;">
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/create" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event</label>
                    <select name="eventId" id="eventIdSelect" class="es-select" required>
                        <option value="">-- Select Event --</option>
                        <c:forEach var="e" items="${events}"><option value="${fn:escapeXml(e.eventId)}" data-customer-id="${fn:escapeXml(e.customerId)}">${fn:escapeXml(e.eventName)}</option></c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Customer</label>
                    <select name="customerId" id="customerIdSelect" class="es-select" required>
                        <option value="">-- Select Customer --</option>
                        <c:forEach var="c" items="${customers}"><option value="${fn:escapeXml(c.customerId)}">${fn:escapeXml(c.fullName)}</option></c:forEach>
                    </select>
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Total Amount (LKR)</label>
                    <input type="number" name="totalAmount" class="es-input" required min="1" step="0.01" placeholder="0.00">
                </div>
                <div class="es-form-group">
                    <label>Invoice Number</label>
                    <input type="text" name="invoiceNumber" class="es-input" placeholder="Auto-generated if empty">
                </div>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Issued Date</label>
                    <input type="date" name="issuedDate" class="es-input">
                </div>
                <div class="es-form-group">
                    <label>Due Date</label>
                    <input type="date" name="dueDate" class="es-input">
                </div>
            </div>
            <div class="es-form-group">
                <label>Notes</label>
                <textarea name="notes" class="es-textarea" rows="2"></textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">Create Invoice</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const eventSelect = document.getElementById('eventIdSelect');
        const customerSelect = document.getElementById('customerIdSelect');
        const amountInput = document.querySelector('input[name="totalAmount"]');
        
        const eventBudgets = {
            <c:forEach var="entry" items="${budgetMap}">
                "${entry.key}": ${entry.value},
            </c:forEach>
        };
        
        if (eventSelect) {
            eventSelect.addEventListener('change', function() {
                const selectedOption = eventSelect.options[eventSelect.selectedIndex];
                const customerId = selectedOption ? selectedOption.getAttribute('data-customer-id') : null;
                const eventId = eventSelect.value;
                
                // Auto-fill customer
                if (customerId && customerSelect) {
                    customerSelect.value = customerId;
                    if (customerSelect.tomselect) {
                        customerSelect.tomselect.setValue(customerId);
                    }
                }
                
                // Auto-fill budget
                if (eventId && eventBudgets[eventId] && amountInput) {
                    amountInput.value = eventBudgets[eventId];
                }
            });
        }
    });
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
