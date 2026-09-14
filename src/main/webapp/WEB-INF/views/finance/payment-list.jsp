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
                        <td>${p.invoiceNumber}</td>
                        <td>${p.eventName}</td>
                        <td>${p.customerName}</td>
                        <td><strong><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/></strong></td>
                        <td>${p.paymentDate}</td>
                        <td>${p.paymentType}</td>
                        <td>${empty p.referenceNo ? 'â€”' : p.referenceNo}</td>
                        <td>${empty p.recordedByName ? 'â€”' : p.recordedByName}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

