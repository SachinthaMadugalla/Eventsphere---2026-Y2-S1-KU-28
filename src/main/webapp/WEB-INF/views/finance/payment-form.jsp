<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Record Payment"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128176; Record Payment</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Invoice summary -->
    <div class="es-alert es-alert-info">
        Invoice <strong>${fn:escapeXml(invoice.invoiceNumber)}</strong> &bull;
        Total: <strong>LKR <fmt:formatNumber value="${invoice.totalAmount}" type="number" groupingUsed="true"/></strong> &bull;
        Paid: <strong>LKR <fmt:formatNumber value="${invoice.totalPaid}" type="number" groupingUsed="true"/></strong> &bull;
        Outstanding: <strong>LKR <fmt:formatNumber value="${invoice.outstanding}" type="number" groupingUsed="true"/></strong>
    </div>

    <div class="es-card" style="max-width:560px;">
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/payment/record" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <input type="hidden" name="invoiceId" value="${fn:escapeXml(invoice.invoiceId)}">
            <input type="hidden" name="eventId" value="${fn:escapeXml(invoice.eventId)}">
            <input type="hidden" name="customerId" value="${fn:escapeXml(invoice.customerId)}">

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Payment Amount (LKR)</label>
                    <input type="number" name="amount" class="es-input" required min="1" step="0.01" placeholder="0.00">
                </div>
                <div class="es-form-group">
                    <label class="required">Payment Date</label>
                    <input type="date" name="paymentDate" class="es-input" required>
                </div>
            </div>
            <div class="es-form-group">
                <label class="required">Payment Type</label>
                <select name="paymentType" class="es-select" required>
                    <option value="Deposit">Deposit</option>
                    <option value="Partial Payment">Partial Payment</option>
                    <option value="Full Payment">Full Payment</option>
                </select>
            </div>
            <div class="es-form-group">
                <label>Reference Number</label>
                <input type="text" name="referenceNo" class="es-input" placeholder="Bank ref / receipt number">
            </div>
            <div class="es-form-group">
                <label>Notes</label>
                <input type="text" name="notes" class="es-input" placeholder="Optional notes">
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-success">Record Payment</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${fn:escapeXml(invoice.invoiceId)}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

