<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Payments"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128176; Payments</h2><div class="breadcrumb">Home &rsaquo; Finance &rsaquo; Payments</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>All Payments</h3></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Invoice #</th><th>Event</th><th>Customer</th><th>Amount (LKR)</th><th>Date</th><th>Type</th><th>Reference</th><th>Recorded By</th></tr></thead>
                <tbody>
                <c:forEach var="p" items="${payments}">
                    <tr>
                        <td>${fn:escapeXml(p.invoiceNumber)}</td>
                        <td>${fn:escapeXml(p.eventName)}</td>
                        <td>${fn:escapeXml(p.customerName)}</td>
                        <td><strong><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/></strong></td>
                        <td>${fn:escapeXml(p.paymentDate)}</td>
                        <td>${fn:escapeXml(p.paymentType)}</td>
                        <td>${fn:escapeXml(empty p.referenceNo ? '—' : p.referenceNo)}</td>
                        <td>${fn:escapeXml(empty p.recordedByName ? '—' : p.recordedByName)}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

