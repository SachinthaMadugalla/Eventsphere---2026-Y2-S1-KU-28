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

    <!-- INVOICE SECTION -->
    <c:if test="${not empty invoice}">
    <div class="es-card" style="margin-top:24px;">
        <div class="card-header">
            <h3>&#128179; Payment & Invoice</h3>
            <span class="es-badge badge-${fn:escapeXml(invoice.status.toLowerCase())}">${fn:escapeXml(invoice.status)}</span>
        </div>
        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Invoice Total</div>
                <div class="detail-value" style="color: #2b6cb0; font-size: 16px; font-weight: bold;">
                    LKR <fmt:formatNumber value="${invoice.totalAmount}" pattern="#,##0.00"/>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Amount Paid</div>
                <div class="detail-value" style="color: #38a169; font-weight: bold;">
                    LKR <fmt:formatNumber value="${invoice.paidAmount}" pattern="#,##0.00"/>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Outstanding Balance</div>
                <div class="detail-value" style="color: #e53e3e; font-weight: bold;">
                    LKR <fmt:formatNumber value="${invoice.outstanding}" pattern="#,##0.00"/>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Due Date</div>
                <div class="detail-value">${fn:escapeXml(invoice.dueDate)}</div>
            </div>
        </div>
        
        <c:if test="${invoice.outstanding > 0}">
        <div style="margin-top:20px; padding-top:16px; border-top: 1px solid #EEF1F6;">
            <p style="font-size: 13px; color: #718096; margin-bottom: 12px;">You have an outstanding balance. You can pay securely online using your credit or debit card.</p>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/payment/checkout?invoiceId=${fn:escapeXml(invoice.invoiceId)}" class="btn btn-primary" style="font-size: 15px; padding: 10px 20px;">
                <i class="fa-solid fa-credit-card"></i> Pay LKR <fmt:formatNumber value="${invoice.outstanding}" pattern="#,##0.00"/> Securely
            </a>
            <div style="font-size: 11px; color: #a0aec0; margin-top: 8px;">
                <i class="fa-solid fa-lock"></i> Payments are securely processed by Stripe. Your card details are never stored on our servers.
            </div>
        </div>
        </c:if>
    </div>
    </c:if>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

