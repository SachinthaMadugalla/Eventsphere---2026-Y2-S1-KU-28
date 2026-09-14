<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Invoice"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main"><%@ include file="/WEB-INF/views/common/topbar.jsp" %><div class="es-content">
    <div class="page-header"><h2>Edit Invoice</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:640px;">
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/edit/${invoice.invoiceId}" method="post">
            <input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <p><strong>${fn:escapeXml(invoice.invoiceNumber)}</strong> · ${fn:escapeXml(invoice.status)}</p>
            <label class="required">Total Amount (LKR)</label>
            <input type="number" name="totalAmount" class="es-input" required min="1" step="0.01" value="${fn:escapeXml(invoice.totalAmount)}">
            <label>Due Date</label>
            <input type="date" name="dueDate" class="es-input" value="${fn:escapeXml(invoice.dueDate)}">
            <label>Notes</label>
            <textarea name="notes" class="es-textarea" rows="3">${fn:escapeXml(invoice.notes)}</textarea>
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${invoice.invoiceId}" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</div></div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
