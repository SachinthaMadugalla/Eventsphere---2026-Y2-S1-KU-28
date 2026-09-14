<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Invoice Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128203; Invoice ${invoice.invoiceNumber}</h2><div class="breadcrumb"><a href="${pageContext.request.contextPath}/finance/invoice/list">Invoices</a> &rsaquo; Details</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>${invoice.invoiceNumber}</h3>
            <c:set var="s" value="${invoice.status.toLowerCase().replace(' ','')}"/>
            <span class="es-badge badge-${s}">${invoice.status}</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item"><div class="detail-label">Event</div><div class="detail-value">${invoice.eventName}</div></div>
            <div class="detail-item"><div class="detail-label">Customer</div><div class="detail-value">${invoice.customerName}</div></div>
            <div class="detail-item"><div class="detail-label">Total Amount</div><div class="detail-value" style="font-size:18px;font-weight:700;">LKR <fmt:formatNumber value="${invoice.totalAmount}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Total Paid</div><div class="detail-value" style="color:#38A169;font-weight:700;">LKR <fmt:formatNumber value="${invoice.totalPaid}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Outstanding</div><div class="detail-value" style="${invoice.outstanding > 0 ? 'color:#E53E3E;' : ''}font-weight:700;">LKR <fmt:formatNumber value="${invoice.outstanding}" type="number" groupingUsed="true"/></div></div>
            <div class="detail-item"><div class="detail-label">Issued Date</div><div class="detail-value">${invoice.issuedDate}</div></div>
            <div class="detail-item"><div class="detail-label">Due Date</div><div class="detail-value">${invoice.dueDate}</div></div>
        </div>
        <c:if test="${not empty invoice.notes}">
            <div class="detail-item" style="margin-top:12px;"><div class="detail-label">Notes</div><div class="detail-value">${invoice.notes}</div></div>
        </c:if>
        <div style="margin-top:16px;display:flex;gap:10px;">
            <a href="${pageContext.request.contextPath}/finance/payment/record?invoiceId=${invoice.invoiceId}" class="btn btn-success">+ Record Payment</a>
            <a href="${pageContext.request.contextPath}/finance/invoice/list" class="btn btn-secondary">&#8592; Back</a>
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
                                <td>${p.paymentDate}</td>
                                <td><strong><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/></strong></td>
                                <td>${p.paymentType}</td>
                                <td>${empty p.referenceNo ? 'â€”' : p.referenceNo}</td>
                                <td>${empty p.recordedByName ? 'â€”' : p.recordedByName}</td>
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

