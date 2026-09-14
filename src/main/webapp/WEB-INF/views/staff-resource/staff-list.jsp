<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Staff"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128100; Staff Members</h2><div class="breadcrumb">Home &rsaquo; Staff</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>All Staff</h3>
            <a href="${pageContext.request.contextPath}/staff/create" class="btn btn-accent btn-sm">+ Add Staff</a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>#</th><th>Full Name</th><th>Job Role</th><th>Phone</th><th>Email</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="s" items="${staffList}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${s.fullName}</strong></td>
                        <td>${s.jobRole}</td>
                        <td>${empty s.phone ? 'â€”' : s.phone}</td>
                        <td>${empty s.email ? 'â€”' : s.email}</td>
                        <td><span class="es-badge ${s.active ? 'badge-active' : 'badge-inactive'}">${s.active ? 'Active' : 'Inactive'}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/staff/detail/${s.staffId}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${pageContext.request.contextPath}/staff/edit/${s.staffId}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${pageContext.request.contextPath}/staff/toggle/${s.staffId}" method="post" style="display:inline;">
                                <input type="hidden" name="active" value="${!s.active}">
                                <button type="submit" class="btn btn-warning btn-xs">${s.active ? 'Deactivate' : 'Activate'}</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/staff/delete/${s.staffId}" method="post" style="display:inline;" onsubmit="return confirmDelete('${s.fullName}')">
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

