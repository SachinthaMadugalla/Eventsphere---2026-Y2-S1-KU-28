<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Feedback Detail"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#11088; Feedback Detail</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/list">Feedback</a>
            &rsaquo; Detail
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:680px;">
        <div class="card-header">
            <h3>Feedback #${fn:escapeXml(feedback.feedbackId)}</h3>
            <c:choose>
                <c:when test="${feedback.status == 'Moderated'}">
                    <span class="es-badge badge-moderated">Moderated</span>
                </c:when>
                <c:otherwise>
                    <span class="es-badge badge-active">Active</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Event</div>
                <div class="detail-value">${fn:escapeXml(feedback.eventName)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Customer</div>
                <div class="detail-value">${fn:escapeXml(feedback.customerName)}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Rating</div>
                <div class="detail-value">
                    <span style="color:#E8A020;font-size:20px;">
                        <c:forEach begin="1" end="${feedback.rating}">&#9733;</c:forEach>
                        <c:forEach begin="${feedback.rating + 1}" end="5">
                            <span style="color:#D8DEE8;">&#9733;</span>
                        </c:forEach>
                    </span>
                    <span style="color:#718096;font-size:13px;margin-left:6px;">
                        ${fn:escapeXml(feedback.rating)} out of 5
                    </span>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Submitted</div>
                <div class="detail-value">
                    ${fn:escapeXml(feedback.submittedDate)}
                </div>
            </div>
        </div>

        <div class="detail-item" style="margin-top:16px;">
            <div class="detail-label">Comment</div>
            <div class="detail-value" style="margin-top:6px;line-height:1.6;">
                ${fn:escapeXml(empty feedback.comment ? 'No comment provided.' : feedback.comment)}
            </div>
        </div>

        <c:if test="${feedback.status == 'Moderated' and not empty feedback.modReason}">
            <div class="detail-item" style="margin-top:12px;background:#FFF5F5;border-color:#FEB2B2;">
                <div class="detail-label" style="color:#E53E3E;">Moderation Reason</div>
                <div class="detail-value">${fn:escapeXml(feedback.modReason)}</div>
            </div>
        </c:if>

        <div style="margin-top:20px;display:flex;gap:10px;flex-wrap:wrap;">
            <c:if test="${feedback.status == 'Active'}">
                <button type="button" class="btn btn-warning"
                        onclick="openModal('moderateModal')">
                    &#9888; Moderate This Feedback
                </button>
            </c:if>
            <form action="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/delete/${fn:escapeXml(feedback.feedbackId)}"
                  method="post" onsubmit="return confirmDelete('this feedback entry')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                <button type="submit" class="btn btn-danger">Delete</button>
            </form>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/list"
               class="btn btn-secondary">&#8592; Back to Feedback</a>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Moderate Modal -->
<div class="es-modal-overlay" id="moderateModal">
    <div class="es-modal">
        <h3>&#9888; Moderate Feedback</h3>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/moderate/${fn:escapeXml(feedback.feedbackId)}"
              method="post">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-group">
                <label class="required">Moderation Reason</label>
                <textarea name="reason" class="es-textarea" rows="3" required
                          placeholder="e.g. Contains inappropriate language..."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                        onclick="closeModal('moderateModal')">Cancel</button>
                <button type="submit" class="btn btn-warning">Confirm Moderate</button>
            </div>
        </form>
    </div>
</div>

