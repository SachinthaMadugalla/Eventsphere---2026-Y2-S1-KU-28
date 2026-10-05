<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Edit Invoice"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2><i class="fa-solid fa-pen-to-square"></i> Edit Invoice ${fn:escapeXml(invoice.invoiceNumber)}</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/list">Invoices</a>
            &rsaquo; <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${invoice.invoiceId}">${fn:escapeXml(invoice.invoiceNumber)}</a>
            &rsaquo; Edit
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:700px;">
        <div class="card-header">
            <h3>Invoice Overview</h3>
            <c:set var="s" value="${invoice.status.toLowerCase().replace(' ','')}"/>
            <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(invoice.status)}</span>
        </div>

        <!-- Read-only Event & Customer Details -->
        <div class="detail-grid" style="margin-bottom: 20px; padding: 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;">
            <div class="detail-item">
                <div class="detail-label">Invoice Number</div>
                <div class="detail-value"><strong>${fn:escapeXml(invoice.invoiceNumber)}</strong></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Event</div>
                <div class="detail-value">${fn:escapeXml(invoice.eventName)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Customer</div>
                <div class="detail-value">${fn:escapeXml(invoice.customerName)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Issued Date</div>
                <div class="detail-value">${fn:escapeXml(invoice.issuedDate)}</div>
            </div>
        </div>

        <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/edit/${invoice.invoiceId}" method="post" class="es-validate">
            <input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Total Amount (LKR)</label>
                    <input type="number" name="totalAmount" class="es-input" required min="1" step="0.01" value="${fn:escapeXml(invoice.totalAmount)}">
                </div>
                <div class="es-form-group">
                    <label>Due Date</label>
                    <input type="date" name="dueDate" class="es-input" value="${fn:escapeXml(invoice.dueDate)}">
                </div>
            </div>

            <div class="es-form-group">
                <label>Notes</label>
                <textarea name="notes" class="es-textarea" rows="3" placeholder="Additional notes or payment terms...">${fn:escapeXml(invoice.notes)}</textarea>
            </div>

            <div style="display:flex; gap:12px; margin-top:20px;">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-check"></i> Save Changes</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${invoice.invoiceId}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
