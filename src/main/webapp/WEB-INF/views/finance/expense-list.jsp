<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Expenses"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128181; Expenses</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header"><h3>All Expenses</h3><a href="${pageContext.request.contextPath}/finance/expense/create" class="btn btn-accent btn-sm">+ Record Expense</a></div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>Event</th><th>Category</th><th>Description</th><th>Amount (LKR)</th><th>Date</th><th>Recorded By</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="ex" items="${expenses}">
                    <tr>
                        <td>${ex.eventName}</td>
                        <td>${ex.category}</td>
                        <td>${ex.description}</td>
                        <td><strong><fmt:formatNumber value="${ex.amount}" type="number" groupingUsed="true"/></strong></td>
                        <td>${ex.expenseDate}</td>
                        <td>${empty ex.recordedByName ? 'â€”' : ex.recordedByName}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/finance/expense/edit/${ex.expenseId}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${pageContext.request.contextPath}/finance/expense/delete/${ex.expenseId}" method="post" style="display:inline;" onsubmit="return confirmDelete('this expense')">
                                <input type="hidden" name="eventId" value="${ex.eventId}">
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

