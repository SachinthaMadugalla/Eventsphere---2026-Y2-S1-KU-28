<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Finance Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128176; Finance Report</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/reports">Reports</a>
            &rsaquo; Finance
        </div>
    </div>

    <div style="display:flex;justify-content:flex-end;margin-bottom:12px;">
        <button class="btn btn-secondary btn-sm" onclick="printPage()">&#128424; Print</button>
    </div>

    <!-- Summary stats -->
    <div class="stat-cards">
        <div class="stat-card green">
            <div class="stat-label">Total Revenue (Paid)</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/>
            </div>
        </div>
        <div class="stat-card blue">
            <div class="stat-label">Total Collected</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${totalCollected}" type="number" groupingUsed="true"/>
            </div>
        </div>
        <div class="stat-card red">
            <div class="stat-label">Outstanding Balance</div>
            <div class="stat-value" style="font-size:16px;">
                LKR <fmt:formatNumber value="${outstanding}" type="number" groupingUsed="true"/>
            </div>
        </div>
    </div>

    <!-- Finance chart -->
    <div class="es-card">
        <div class="card-header"><h3>Financial Overview</h3></div>
        <div class="chart-container">
            <canvas id="finReportChart"></canvas>
        </div>
    </div>

    <!-- Budgets: budget vs actual -->
    <div class="es-card">
        <div class="card-header">
            <h3>Budget vs Actual Cost</h3>
            <span style="font-size:12px;color:#718096;">${budgets.size()} budget(s)</span>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>Event</th>
                        <th>Total Budget (LKR)</th>
                        <th>Estimated Cost (LKR)</th>
                        <th>Actual Cost (LKR)</th>
                        <th>Variance (LKR)</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${budgets}">
                    <tr>
                        <td><strong>${b.eventName}</strong></td>
                        <td><fmt:formatNumber value="${b.totalBudget}" type="number" groupingUsed="true"/></td>
                        <td><fmt:formatNumber value="${b.estimatedCost}" type="number" groupingUsed="true"/></td>
                        <td><fmt:formatNumber value="${b.actualCost}" type="number" groupingUsed="true"/></td>
                        <td style="${b.variance < 0 ? 'color:#E53E3E;' : 'color:#38A169;'}font-weight:600;">
                            <fmt:formatNumber value="${b.variance}" type="number" groupingUsed="true"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Invoices summary -->
    <div class="es-card">
        <div class="card-header">
            <h3>Invoices Summary</h3>
            <span style="font-size:12px;color:#718096;">${invoices.size()} invoice(s)</span>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>Invoice #</th><th>Event</th><th>Customer</th>
                        <th>Total (LKR)</th><th>Issued</th><th>Due</th><th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="inv" items="${invoices}">
                    <tr>
                        <td>${inv.invoiceNumber}</td>
                        <td>${inv.eventName}</td>
                        <td>${inv.customerName}</td>
                        <td><fmt:formatNumber value="${inv.totalAmount}" type="number" groupingUsed="true"/></td>
                        <td>${inv.issuedDate}</td>
                        <td>${inv.dueDate}</td>
                        <td>
                            <c:set var="is" value="${inv.status.toLowerCase().replace(' ','')}"/>
                            <span class="es-badge badge-${is}">${inv.status}</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Payments summary -->
    <div class="es-card">
        <div class="card-header">
            <h3>Payments Summary</h3>
            <span style="font-size:12px;color:#718096;">${payments.size()} payment(s)</span>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>Date</th><th>Event</th><th>Customer</th>
                        <th>Amount (LKR)</th><th>Type</th><th>Reference</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${payments}">
                    <tr>
                        <td>${p.paymentDate}</td>
                        <td>${p.eventName}</td>
                        <td>${p.customerName}</td>
                        <td><strong><fmt:formatNumber value="${p.amount}" type="number" groupingUsed="true"/></strong></td>
                        <td>${p.paymentType}</td>
                        <td>${empty p.referenceNo ? 'â€”' : p.referenceNo}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function () {
    createFinanceChart('finReportChart', ${totalRevenue}, ${totalCollected}, ${outstanding});
});
</script>

