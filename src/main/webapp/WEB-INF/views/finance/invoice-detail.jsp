<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Invoice Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128203; Invoice ${fn:escapeXml(invoice.invoiceNumber)}</h2><div class="breadcrumb"><a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/list">Invoices</a> &rsaquo; Details</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/edit/${invoice.invoiceId}" class="btn btn-primary btn-sm">Edit Invoice</a>
    <div class="es-card">
        <div class="card-header">
            <h3>${fn:escapeXml(invoice.invoiceNumber)}</h3>
            <c:set var="s" value="${invoice.status.toLowerCase().replace(' ','')}"/>
            <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(invoice.status)}</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Event</div><div class="detail-value">${fn:escapeXml(invoice.eventName)}</div></div>
            <div class="detail-item"><div class="detail-label">Customer</div><div class="detail-value">${fn:escapeXml(invoice.customerName)}</div></div>
            <div class="detail-item"><div class="detail-label">Total Amount</div><div class="detail-value" style="font-size:18px;font-weight:700;">LKR <fmt:formatNumber value="${invoice.totalAmount}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Total Paid</div><div class="detail-value" style="color:#38A169;font-weight:700;">LKR <fmt:formatNumber value="${invoice.totalPaid}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Outstanding</div><div class="detail-value" style="${fn:escapeXml(invoice.outstanding > 0 ? 'color:#E53E3E;' : '')}font-weight:700;">LKR <fmt:formatNumber value="${invoice.outstanding}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Issued Date</div><div class="detail-value">${fn:escapeXml(invoice.issuedDate)}</div></div>
            <div class="detail-item"><div class="detail-label">Due Date</div><div class="detail-value">${fn:escapeXml(invoice.dueDate)}</div></div>
        </div>
        <c:if test="${not empty invoice.notes}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Notes</div><div class="detail-value">${fn:escapeXml(invoice.notes)}</div></div>
        </c:if>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/payment/record?invoiceId=${fn:escapeXml(invoice.invoiceId)}" class="btn btn-success">+ Record Payment</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/list" class="btn btn-secondary">&#8592; Back</a>
        </div>
    </div>

    <!-- Payments for this invoice -->
    <div class="es-card">
        <div class="card-header"><h3>Payment History</h3></div>
        <c:choose>
            <c:when test="${empty payments}"><div class="es-empty"><p>No payments recorded yet.</p></div></c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Date</th><th>Amount (LKR)</th><th>Type</th><th>Reference</th><th>Recorded By</th></tr></thead>
                        <tbody>
                        <c:forEach var="p" items="${payments}">
                            <tr>
                                <td>${fn:escapeXml(p.paymentDate)}</td>
                                <td><strong><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/></strong></td>
                                <td>${fn:escapeXml(p.paymentType)}</td>
                                <td>${fn:escapeXml(empty p.referenceNo ? '—' : p.referenceNo)}</td>
                                <td>${fn:escapeXml(empty p.recordedByName ? '—' : p.recordedByName)}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

