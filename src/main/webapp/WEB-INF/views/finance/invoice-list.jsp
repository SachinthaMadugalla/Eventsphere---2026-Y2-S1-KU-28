<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Invoices"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128203; Invoices</h2><div class="breadcrumb">Home &rsaquo; Finance &rsaquo; Invoices</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>All Invoices</h3><a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/create" class="btn btn-accent btn-sm">+ Create Invoice</a></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Invoice #</th><th>Event</th><th>Customer</th><th>Total (LKR)</th><th>Issued</th><th>Due</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="inv" items="${invoices}">
                    <tr>
                        <td><strong>${fn:escapeXml(inv.invoiceNumber)}</strong></td>
                        <td>${fn:escapeXml(inv.eventName)}</td>
                        <td>${fn:escapeXml(inv.customerName)}</td>
                        <td><fmt:formatNumber value="${inv.totalAmount}" type="number" groupingUsed="true"/></td>
                        <td>${fn:escapeXml(inv.issuedDate)}</td>
                        <td>${fn:escapeXml(inv.dueDate)}</td>
                        <td><c:set var="s" value="${inv.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(inv.status)}</span></td>
                        <td>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${fn:escapeXml(inv.invoiceId)}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/edit/${fn:escapeXml(inv.invoiceId)}" class="btn btn-primary btn-xs">Edit</a>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/payment/record?invoiceId=${fn:escapeXml(inv.invoiceId)}" class="btn btn-success btn-xs">+ Payment</a>
                            <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/delete/${fn:escapeXml(inv.invoiceId)}" method="post" style="display:inline;" onsubmit="return confirmDelete('this invoice')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

