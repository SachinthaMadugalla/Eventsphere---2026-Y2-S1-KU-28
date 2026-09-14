<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Submit Feedback"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#11088; Submit Feedback</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/bookings">My Bookings</a>
            &rsaquo; Submit Feedback
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <c:if test="${not empty event}">
        <div class="es-alert es-alert-info">
            Submitting feedback for: <strong>${fn:escapeXml(event.eventName)}</strong>
            &bull; Date: ${fn:escapeXml(event.eventDate)}
        </div>
    </c:if>

    <div class="es-card" style="max-width:600px;">
        <div class="card-header"><h3>Your Feedback</h3></div>

        <form action="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/submit"
              method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <%-- eventId and customerId resolved server-side from session in controller --%>
            <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">

            <!-- Star rating input -->
            <div class="es-form-group">
                <label class="required">Overall Rating</label>
                <div class="star-rating-input" style="display:flex;gap:6px;margin-top:6px;">
                    <c:forEach begin="1" end="5" var="i">
                        <span class="star-btn"
                              style="font-size:32px;cursor:pointer;color:#D8DEE8;transition:color 0.1s;">
                            &#9733;
                        </span>
                    </c:forEach>
                    <input type="hidden" name="rating" id="ratingInput" value="0" required>
                </div>
                <div style="font-size:11px;color:#718096;margin-top:4px;">
                    Click a star to select your rating (1 = Poor, 5 = Excellent)
                </div>
            </div>

            <div class="es-form-group">
                <label>Comment <span style="color:#718096;font-weight:400;">(optional)</span></label>
                <textarea name="comment" class="es-textarea" rows="4"
                          placeholder="Tell us about your experience with this event..."></textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-accent"
                        onclick="return validateRating()">
                    &#11088; Submit Feedback
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/bookings"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
// Validate that a rating was selected before submitting
function validateRating() {
    var rating = document.getElementById('ratingInput').value;
    if (!rating || parseInt(rating) < 1) {
        alert('Please select a star rating before submitting.');
        return false;
    }
    return true;
}
</script>

