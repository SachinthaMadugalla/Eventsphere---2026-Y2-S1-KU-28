<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Booking Details"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; Booking Details</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/bookings">My Bookings</a>
            &rsaquo; ${fn:escapeXml(event.eventName)}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>${fn:escapeXml(event.eventName)}</h3>
            <c:set var="s" value="${event.status.toLowerCase().replace(' ','')}"/>
            <span class="es-badge badge-${fn:escapeXml(s)}">${fn:escapeXml(event.status)}</span>
        </div>

        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Category</div>
                <div class="detail-value">${fn:escapeXml(event.categoryName)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Event Date</div>
                <div class="detail-value">
                    ${fn:escapeXml(event.eventDate)}
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Start Time</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty event.startTime}">${fn:escapeXml(event.startTime)}</c:when>
                        <c:otherwise>Not specified</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">End Time</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty event.endTime}">${fn:escapeXml(event.endTime)}</c:when>
                        <c:otherwise>Not specified</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Location</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty event.location}">${fn:escapeXml(event.location)}</c:when>
                        <c:otherwise>To be assigned</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Guest Count</div>
                <div class="detail-value">${fn:escapeXml(event.guestCount)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Event Manager</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty event.managerName}">${fn:escapeXml(event.managerName)}</c:when>
                        <c:otherwise>Not yet assigned</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Submitted On</div>
                <div class="detail-value">
                    ${fn:escapeXml(event.createdAt)}
                </div>
            </div>
        </div>

        <c:if test="${not empty event.requirements}">
        <div style="margin-top:16px;">
            <div class="detail-item">
                <div class="detail-label">Special Requirements</div>
                <div class="detail-value" style="margin-top:6px;">${fn:escapeXml(event.requirements)}</div>
            </div>
        </div>
        </c:if>

        <div style="margin-top:20px;display:flex;gap:12px;flex-wrap:wrap;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/bookings" class="btn btn-secondary">
                &#8592; Back to Bookings
            </a>
            <c:if test="${event.status == 'Requested' or event.status == 'Pending'}">
                <form action="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/cancel/${fn:escapeXml(event.eventId)}"
                      method="post" onsubmit="return confirmAction('Cancel this booking?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                    <button type="submit" class="btn btn-danger">Cancel Booking</button>
                </form>
            </c:if>
            <c:if test="${event.status == 'Completed'}">
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/submit?eventId=${fn:escapeXml(event.eventId)}"
                   class="btn btn-accent">&#11088; Leave Feedback</a>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/submit"
                   class="btn btn-secondary">&#9888; Submit Complaint</a>
            </c:if>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

