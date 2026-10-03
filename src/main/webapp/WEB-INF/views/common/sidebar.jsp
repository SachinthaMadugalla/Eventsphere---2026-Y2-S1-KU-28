<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Sidebar navigation — role-aware menu.
  Renders different nav links based on sessionScope.userRole.
--%>
<nav class="es-sidebar" id="main-navigation" aria-label="Main navigation">
    <!-- Brand -->
    <div class="sidebar-brand">
        <h1>Event<span>Sphere</span></h1>
        <p>Every detail. <em>Every moment.</em></p>
    </div>

    <!-- User info -->
    <div class="sidebar-user">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser.profilePicture}">
                <img src="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(sessionScope.loggedInUser.profilePicture)}" alt="Avatar" class="user-avatar" style="object-fit: cover;" aria-hidden="true">
            </c:when>
            <c:otherwise>
                <span class="user-avatar" aria-hidden="true">${fn:escapeXml(fn:toUpperCase(fn:substring(sessionScope.userFullName, 0, 1)))}</span>
            </c:otherwise>
        </c:choose>
        <div class="user-meta">
            <div class="user-name">${fn:escapeXml(sessionScope.userFullName)}</div>
            <div class="user-role">${fn:escapeXml(sessionScope.userRole)}</div>
        </div>
    </div>

    <!-- Navigation -->
    <div class="sidebar-nav">

        <!-- ── CUSTOMER ─────────────────────────────── -->
        <c:if test="${sessionScope.userRole == 'Customer'}">
            <span class="nav-section-title">My Account</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/bookings" class="nav-item">
                <span class="nav-icon">&#128197;</span> My Bookings
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/new" class="nav-item">
                <span class="nav-icon">&#43;</span> New Booking
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/profile" class="nav-item">
                <span class="nav-icon">&#128100;</span> My Profile
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/loyalty" class="nav-item">
                <span class="nav-icon" aria-hidden="true">&#9734;</span> My Loyalty
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="nav-item">
                <span class="nav-icon">&#128276;</span> Notifications
                <c:if test="${unreadCount > 0}">
                    <span class="nav-count">${fn:escapeXml(unreadCount)}</span>
                </c:if>
            </a>
            <span class="nav-section-title">Feedback</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/submit" class="nav-item">
                <span class="nav-icon">&#9888;</span> Submit Complaint
            </a>
        </c:if>

        <!-- ── EVENT MANAGER ──────────────────────── -->
        <c:if test="${sessionScope.userRole == 'Event Manager'}">
            <span class="nav-section-title">Events</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="nav-item">
                <span class="nav-icon">&#128197;</span> All Events
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/create" class="nav-item">
                <span class="nav-icon">&#43;</span> Create Event
            </a>
            <span class="nav-section-title">Venues &amp; Vendors</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/list" class="nav-item">
                <span class="nav-icon">&#127968;</span> Venues
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/vendor/list" class="nav-item">
                <span class="nav-icon">&#128722;</span> Vendors
            </a>
            <span class="nav-section-title">Team</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list" class="nav-item">
                <span class="nav-icon">&#128100;</span> Staff
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/list" class="nav-item">
                <span class="nav-icon">&#128230;</span> Resources
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list" class="nav-item">
                <span class="nav-icon">&#9989;</span> Tasks
            </a>
            <span class="nav-section-title">Finance</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/dashboard" class="nav-item">
                <span class="nav-icon">&#128176;</span> Finance
            </a>
        </c:if>

        <!-- ── OPERATIONS COORDINATOR ────────────── -->
        <c:if test="${sessionScope.userRole == 'Operations Coordinator'}">
            <span class="nav-section-title">Operations</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/operations/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/list" class="nav-item">
                <span class="nav-icon">&#9989;</span> All Tasks
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/task/create" class="nav-item">
                <span class="nav-icon">&#43;</span> Create Task
            </a>
            <span class="nav-section-title">Resources</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list" class="nav-item">
                <span class="nav-icon">&#128100;</span> Staff
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/list" class="nav-item">
                <span class="nav-icon">&#128230;</span> Resources
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="nav-item">
                <span class="nav-icon">&#128197;</span> Events
            </a>
        </c:if>

        <!-- ── CUSTOMER RELATIONS OFFICER ───────── -->
        <c:if test="${sessionScope.userRole == 'Customer Relations Officer'}">
            <span class="nav-section-title">CRO</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/cro/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/list" class="nav-item">
                <span class="nav-icon">&#11088;</span> Feedback
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/list" class="nav-item">
                <span class="nav-icon">&#9888;</span> Complaints
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="nav-item">
                <span class="nav-icon">&#128197;</span> Events
            </a>
        </c:if>

        <!-- ── FINANCE MANAGER ────────────────── -->
        <c:if test="${sessionScope.userRole == 'Finance Manager'}">
            <span class="nav-section-title">Finance</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/invoice/list" class="nav-item">
                <span class="nav-icon">&#128203;</span> Invoices
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/payment/list" class="nav-item">
                <span class="nav-icon">&#128176;</span> Payments
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/budget/list" class="nav-item">
                <span class="nav-icon">&#128184;</span> Budgets
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/expense/list" class="nav-item">
                <span class="nav-icon">&#128181;</span> Expenses
            </a>
            <span class="nav-section-title">Reports</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/finance" class="nav-item">
                <span class="nav-icon">&#128200;</span> Finance Report
            </a>
        </c:if>

        <!-- ── MANAGING DIRECTOR ──────────────── -->
        <c:if test="${sessionScope.userRole == 'Managing Director'}">
            <span class="nav-section-title">Overview</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/director/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="nav-item">
                <span class="nav-icon">&#128197;</span> Events
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/finance/dashboard" class="nav-item">
                <span class="nav-icon">&#128176;</span> Finance
            </a>
            <span class="nav-section-title">Reports</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports" class="nav-item">
                <span class="nav-icon">&#128200;</span> All Reports
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/list" class="nav-item">
                <span class="nav-icon">&#9888;</span> Complaints
            </a>
        </c:if>

        <!-- ── SYSTEM ADMINISTRATOR ───────────── -->
        <c:if test="${sessionScope.userRole == 'System Administrator'}">
            <span class="nav-section-title">Administration</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/admin/dashboard" class="nav-item">
                <span class="nav-icon">&#9634;</span> Dashboard
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/admin/users" class="nav-item">
                <span class="nav-icon">&#128101;</span> Manage Users
            </a>
            <span class="nav-section-title">System</span>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/list" class="nav-item">
                <span class="nav-icon">&#128197;</span> Events
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/venue/list" class="nav-item">
                <span class="nav-icon">&#127968;</span> Venues
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/vendor/list" class="nav-item">
                <span class="nav-icon">&#128722;</span> Vendors
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list" class="nav-item">
                <span class="nav-icon">&#128100;</span> Staff
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/resource/list" class="nav-item">
                <span class="nav-icon">&#128230;</span> Resources
            </a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports" class="nav-item">
                <span class="nav-icon">&#128200;</span> Reports
            </a>
        </c:if>

        <!-- ── SHARED: NOTIFICATIONS ──────────── -->
        <c:if test="${sessionScope.userRole != 'Customer'}">
            <span class="nav-section-title">Account</span>
            <c:if test="${sessionScope.userRole == 'Customer Relations Officer' or sessionScope.userRole == 'System Administrator'}">
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/loyalty/manage" class="nav-item">
                    <span class="nav-icon" aria-hidden="true">&#9734;</span> Customer Loyalty
                </a>
            </c:if>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/notifications" class="nav-item">
                <span class="nav-icon">&#128276;</span> Notifications
                <c:if test="${unreadCount > 0}">
                    <span class="nav-count">${fn:escapeXml(unreadCount)}</span>
                </c:if>
            </a>
        </c:if>

    </div><!-- /sidebar-nav -->

    <div class="sidebar-footer">
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/logout" method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}"><button type="submit" class="btn sidebar-signout">
            Sign out <span aria-hidden="true">&rarr;</span>
        </button></form>
    </div>
</nav>

