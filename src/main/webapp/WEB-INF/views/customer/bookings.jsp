<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Bookings"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; My Bookings</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a> &rsaquo; My Bookings
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>Booking History</h3>
            <a href="${pageContext.request.contextPath}/customer/booking/new" class="btn btn-accent btn-sm">
                + New Booking
            </a>
        </div>

        <c:choose>
            <c:when test="${empty events}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128197;</span>
                    <p>You have no bookings yet.</p>
                    <a href="${pageContext.request.contextPath}/customer/booking/new"
                       class="btn btn-accent" style="margin-top:12px;">Submit a Booking</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table" id="bookingsTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Event Name</th>
                                <th>Category</th>
                                <th>Date</th>
                                <th>Guests</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="e" items="${events}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td><strong>${e.eventName}</strong></td>
                                <td>${e.categoryName}</td>
                                <td>${e.eventDate}</td>
                                <td>${e.guestCount}</td>
                                <td>
                                    <c:set var="s" value="${e.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${s}">${e.status}</span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/customer/booking/${e.eventId}"
                                       class="btn btn-secondary btn-xs">Details</a>
                                    <c:if test="${e.status == 'Requested' or e.status == 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/customer/booking/cancel/${e.eventId}"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirmAction('Cancel this booking request?')">
                                            <button type="submit" class="btn btn-danger btn-xs">Cancel</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${e.status == 'Completed'}">
                                        <a href="${pageContext.request.contextPath}/reporting/feedback/submit?eventId=${e.eventId}"
                                           class="btn btn-accent btn-xs">&#11088; Feedback</a>
                                    </c:if>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

