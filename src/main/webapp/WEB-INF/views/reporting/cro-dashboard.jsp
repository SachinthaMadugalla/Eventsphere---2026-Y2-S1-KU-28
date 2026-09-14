<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="CRO Dashboard"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128101; Customer Relations Dashboard</h2>
        <div class="breadcrumb">Home &rsaquo; CRO Dashboard</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Summary stats -->
    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-label">Total Customers</div>
            <div class="stat-value">${customers.size()}</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-label">Total Feedback</div>
            <div class="stat-value">${feedbackList.size()}</div>
        </div>
        <div class="stat-card red">
            <div class="stat-label">Open Complaints</div>
            <div class="stat-value">${openComplaints}</div>
        </div>
        <div class="stat-card green">
            <div class="stat-label">Avg. Rating</div>
            <div class="stat-value">
                <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5
            </div>
        </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">

        <!-- Recent complaints -->
        <div class="es-card">
            <div class="card-header">
                <h3>&#9888; Recent Complaints</h3>
                <a href="${pageContext.request.contextPath}/reporting/complaint/list"
                   class="btn btn-secondary btn-sm">View All</a>
            </div>
            <c:choose>
                <c:when test="${empty recentComplaints}">
                    <div class="es-empty">
                        <span class="es-empty-icon">&#9989;</span>
                        <p>No complaints on record.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="es-table-wrap">
                        <table class="es-table">
                            <thead>
                                <tr>
                                    <th>Subject</th>
                                    <th>Customer</th>
                                    <th>Status</th>
                                    <th>Submitted</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="c" items="${recentComplaints}" varStatus="st">
                                <c:if test="${st.index < 6}">
                                <tr>
                                    <td>${c.subject}</td>
                                    <td>${c.customerName}</td>
                                    <td>
                                        <c:set var="cs" value="${c.status.toLowerCase().replace(' ','')}"/>
                                        <span class="es-badge badge-${cs}">${c.status}</span>
                                        <c:if test="${c.escalated}">
                                            <span class="es-badge badge-escalated" style="margin-left:4px;">Escalated</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        ${c.submittedDate}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/reporting/complaint/detail/${c.complaintId}"
                                           class="btn btn-secondary btn-xs">View</a>
                                    </td>
                                </tr>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent feedback -->
        <div class="es-card">
            <div class="card-header">
                <h3>&#11088; Recent Feedback</h3>
                <a href="${pageContext.request.contextPath}/reporting/feedback/list"
                   class="btn btn-secondary btn-sm">View All</a>
            </div>
            <c:choose>
                <c:when test="${empty feedbackList}">
                    <div class="es-empty">
                        <span class="es-empty-icon">&#11088;</span>
                        <p>No feedback submitted yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="es-table-wrap">
                        <table class="es-table">
                            <thead>
                                <tr>
                                    <th>Event</th>
                                    <th>Customer</th>
                                    <th>Rating</th>
                                    <th>Date</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="f" items="${feedbackList}" varStatus="st">
                                <c:if test="${st.index < 6}">
                                <tr>
                                    <td>${f.eventName}</td>
                                    <td>${f.customerName}</td>
                                    <td>
                                        <span style="color:#E8A020;font-size:13px;">
                                            <c:forEach begin="1" end="${f.rating}">&#9733;</c:forEach>
                                            <c:forEach begin="${f.rating + 1}" end="5">
                                                <span style="color:#D8DEE8;">&#9733;</span>
                                            </c:forEach>
                                        </span>
                                    </td>
                                    <td>
                                        ${f.submittedDate}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/reporting/feedback/detail/${f.feedbackId}"
                                           class="btn btn-secondary btn-xs">View</a>
                                    </td>
                                </tr>
                                </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Customer list -->
    <div class="es-card">
        <div class="card-header">
            <h3>&#128101; Registered Customers</h3>
            <input type="text" class="es-input" style="max-width:220px;"
                   placeholder="Search..." oninput="filterTable('custTable', this.value)">
        </div>
        <div class="es-table-wrap">
            <table class="es-table" id="custTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Registered</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="cust" items="${customers}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${cust.fullName}</strong></td>
                        <td>${cust.email}</td>
                        <td>${empty cust.phone ? 'â€”' : cust.phone}</td>
                        <td>${empty cust.address ? 'â€”' : cust.address}</td>
                        <td>
                            ${cust.registeredAt}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

