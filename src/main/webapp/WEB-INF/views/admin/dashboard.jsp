<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Admin Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#9881; System Administrator Dashboard</h2>
        <div class="breadcrumb">Home &rsaquo; Admin Dashboard</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- System stats -->
    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-label">Total Users</div>
            <div class="stat-value">${totalUsers}</div>
            <div class="stat-sub">All system accounts</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${stats.totalEvents}</div>
        </div>
        <div class="stat-card green">
            <div class="stat-label">Total Customers</div>
            <div class="stat-value">${stats.totalCustomers}</div>
        </div>
        <div class="stat-card blue">
            <div class="stat-label">Total Staff</div>
            <div class="stat-value">${stats.totalStaff}</div>
        </div>
        <div class="stat-card red">
            <div class="stat-label">Open Complaints</div>
            <div class="stat-value">${stats.openComplaints}</div>
        </div>
    </div>

    <!-- Quick links -->
    <div class="es-card">
        <div class="card-header"><h3>&#128295; Administration Tools</h3></div>
        <div style="display:flex;gap:12px;flex-wrap:wrap;padding:8px 0;">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                &#128101; Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/event/list" class="btn btn-secondary">
                &#128197; View Events
            </a>
            <a href="${pageContext.request.contextPath}/venue/list" class="btn btn-secondary">
                &#127968; View Venues
            </a>
            <a href="${pageContext.request.contextPath}/vendor/list" class="btn btn-secondary">
                &#128722; View Vendors
            </a>
            <a href="${pageContext.request.contextPath}/staff/list" class="btn btn-secondary">
                &#128100; View Staff
            </a>
            <a href="${pageContext.request.contextPath}/resource/list" class="btn btn-secondary">
                &#128230; View Resources
            </a>
            <a href="${pageContext.request.contextPath}/reporting/reports" class="btn btn-secondary">
                &#128200; Reports
            </a>
        </div>
    </div>

    <!-- Recent users table -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128101; All System Users</h3>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-accent btn-sm">
                Manage Users
            </a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${u.username}</strong></td>
                        <td>${u.fullName}</td>
                        <td>${u.email}</td>
                        <td><span class="es-badge badge-pending">${u.roleName}</span></td>
                        <td>
                            <span class="es-badge ${u.active ? 'badge-active' : 'badge-inactive'}">
                                ${u.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>
                            ${u.createdAt.toLocalDate()}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

