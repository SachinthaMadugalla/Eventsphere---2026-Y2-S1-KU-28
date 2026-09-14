<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Vendors"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header">
        <h2>&#128722; Vendors</h2>
        <div class="breadcrumb">Home &rsaquo; Vendors</div>
    </div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>All Vendors</h3>
            <a href="${pageContext.request.contextPath}/vendor/create" class="btn btn-accent btn-sm">+ Add Vendor</a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>#</th><th>Vendor Name</th><th>Category</th><th>Contact</th><th>Phone</th><th>Cost (LKR)</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="v" items="${vendors}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${v.vendorName}</strong></td>
                        <td>${v.categoryName}</td>
                        <td>${empty v.contactPerson ? 'â€”' : v.contactPerson}</td>
                        <td>${empty v.phone ? 'â€”' : v.phone}</td>
                        <td><fmt:formatNumber value="${v.cost}" type="number" groupingUsed="true"/></td>
                        <td><span class="es-badge ${v.active ? 'badge-active' : 'badge-inactive'}">${v.active ? 'Active' : 'Inactive'}</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/vendor/detail/${v.vendorId}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${pageContext.request.contextPath}/vendor/edit/${v.vendorId}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${pageContext.request.contextPath}/vendor/toggle/${v.vendorId}" method="post" style="display:inline;">
                                <input type="hidden" name="active" value="${!v.active}">
                                <button type="submit" class="btn btn-warning btn-xs">${v.active ? 'Deactivate' : 'Activate'}</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/vendor/delete/${v.vendorId}" method="post" style="display:inline;" onsubmit="return confirmDelete('${v.vendorName}')">
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

