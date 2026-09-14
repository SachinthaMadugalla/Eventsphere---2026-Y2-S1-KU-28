<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Budgets"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128184; Budgets</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>Event Budgets</h3><a href="${pageContext.request.contextPath}/finance/budget/create" class="btn btn-accent btn-sm">+ Create Budget</a></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Event</th><th>Total Budget</th><th>Estimated Cost</th><th>Actual Cost</th><th>Variance</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="b" items="${budgets}">
                    <tr>
                        <td><strong>${b.eventName}</strong></td>
                        <td>LKR <fmt:formatNumber value="${b.totalBudget}" type="number" groupingUsed="true"/></td>
                        <td>LKR <fmt:formatNumber value="${b.estimatedCost}" type="number" groupingUsed="true"/></td>
                        <td>LKR <fmt:formatNumber value="${b.actualCost}" type="number" groupingUsed="true"/></td>
                        <td style="${b.variance < 0 ? 'color:#E53E3E;' : 'color:#38A169;'}font-weight:600;">
                            LKR <fmt:formatNumber value="${b.variance}" type="number" groupingUsed="true"/>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/finance/budget/edit/${b.budgetId}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${pageContext.request.contextPath}/finance/budget/delete/${b.budgetId}" method="post" style="display:inline;" onsubmit="return confirmDelete('this budget')">
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

