<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Finance Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128176; Finance & Payment Dashboard</h2><div class="breadcrumb">Home &rsaquo; Finance</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="stat-cards">
        <div class="stat-card green"><div class="stat-label">Total Revenue (Paid)</div><div class="stat-value" style="font-size:18px;">LKR <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true"/></div></div>
        <div class="stat-card gold"><div class="stat-label">Total Collected</div><div class="stat-value" style="font-size:18px;">LKR <fmt:formatNumber value="${totalCollected}" type="number" groupingUsed="true"/></div></div>
        <div class="stat-card red"><div class="stat-label">Outstanding Balance</div><div class="stat-value" style="font-size:18px;">LKR <fmt:formatNumber value="${totalOutstanding}" type="number" groupingUsed="true"/></div></div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
        <div class="es-card">
            <div class="card-header"><h3>Finance Summary</h3></div>
            <div class="chart-container"><canvas id="financeChart"></canvas></div>
        </div>

        <!-- Quick links -->
        <div class="es-card">
            <div class="card-header"><h3>Quick Actions</h3></div>
            <div style="display:flex;flex-direction:column;gap:10px;padding:8px 0;">
                <a href="${pageContext.request.contextPath}/finance/invoice/list" class="btn btn-primary">&#128203; View All Invoices</a>
                <a href="${pageContext.request.contextPath}/finance/invoice/create" class="btn btn-accent">&#43; Create Invoice</a>
                <a href="${pageContext.request.contextPath}/finance/payment/list" class="btn btn-primary">&#128176; View All Payments</a>
                <a href="${pageContext.request.contextPath}/finance/budget/list" class="btn btn-secondary">&#128184; Budgets</a>
                <a href="${pageContext.request.contextPath}/finance/expense/list" class="btn btn-secondary">&#128181; Expenses</a>
                <a href="${pageContext.request.contextPath}/reporting/reports/finance" class="btn btn-secondary">&#128200; Finance Report</a>
            </div>
        </div>
    </div>

    <!-- Recent Invoices -->
    <div class="es-card">
        <div class="card-header"><h3>Recent Invoices</h3><a href="${pageContext.request.contextPath}/finance/invoice/list" class="btn btn-secondary btn-sm">All</a></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Invoice #</th><th>Event</th><th>Customer</th><th>Total</th><th>Due Date</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                <c:forEach var="inv" items="${recentInvoices}" varStatus="st">
                    <c:if test="${st.index < 5}">
                    <tr>
                        <td>${inv.invoiceNumber}</td>
                        <td>${inv.eventName}</td>
                        <td>${inv.customerName}</td>
                        <td>LKR <fmt:formatNumber value="${inv.totalAmount}" type="number" groupingUsed="true"/></td>
                        <td>${inv.dueDate}</td>
                        <td><c:set var="is" value="${inv.status.toLowerCase().replace(' ','')}"/><span class="es-badge badge-${is}">${inv.status}</span></td>
                        <td><a href="${pageContext.request.contextPath}/finance/invoice/detail/${inv.invoiceId}" class="btn btn-secondary btn-xs">View</a></td>
                    </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function () {
    createFinanceChart('financeChart', ${totalRevenue}, ${totalCollected}, ${totalOutstanding});
});
</script>

