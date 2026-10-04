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
                            <div class="tbl-actions">
                                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/detail/${fn:escapeXml(inv.invoiceId)}" class="btn-icon btn-icon-view" title="View Invoice"><i class="fa-solid fa-eye"></i></a>
                                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/edit/${fn:escapeXml(inv.invoiceId)}" class="btn-icon btn-icon-edit" title="Edit Invoice"><i class="fa-solid fa-pen-to-square"></i></a>
                                <c:if test="${inv.status != 'Paid'}">
                                <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/payment/record?invoiceId=${fn:escapeXml(inv.invoiceId)}" class="btn btn-success btn-xs" title="Record Payment" style="height:30px;display:inline-flex;align-items:center;gap:4px;"><i class="fa-solid fa-credit-card"></i> Pay</a>
                                </c:if>
                                <form action="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/delete/${fn:escapeXml(inv.invoiceId)}" method="post" style="display:contents;" onsubmit="return confirmDelete('this invoice')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                    <button type="submit" class="btn-icon btn-icon-danger" title="Delete Invoice"><i class="fa-solid fa-trash-can"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

