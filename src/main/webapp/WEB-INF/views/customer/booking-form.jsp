<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="New Booking"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128197; Submit Event Booking</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard">Dashboard</a>
            &rsaquo; New Booking
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:700px;">
        <div class="card-header">
            <h3>Event Details</h3>
        </div>

        <form action="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/submit"
              method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-group">
                <label class="required">Event Name</label>
                <input type="text" name="eventName" class="es-input"
                       placeholder="e.g. My Wedding Reception" required maxlength="200">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event Category</label>
                    <select name="categoryId" class="es-select" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${fn:escapeXml(cat.categoryId)}">${fn:escapeXml(cat.categoryName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Expected Guest Count</label>
                    <input type="number" name="guestCount" class="es-input"
                           placeholder="Number of guests" required min="1" max="5000">
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Event Date</label>
                    <input type="date" name="eventDate" class="es-input no-past-date" required>
                </div>
                <div class="es-form-group">
                    <label>Preferred Location / Venue</label>
                    <input type="text" name="location" class="es-input"
                           placeholder="Preferred area or venue name">
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Preferred Start Time</label>
                    <input type="time" name="startTime" class="es-input">
                </div>
                <div class="es-form-group">
                    <label>Preferred End Time</label>
                    <input type="time" name="endTime" class="es-input">
                </div>
            </div>

            <div class="es-form-group">
                <label>Special Requirements</label>
                <textarea name="requirements" class="es-textarea"
                          placeholder="Describe any special requirements, preferences or requests..."
                          rows="4"></textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-accent">
                    &#128197; Submit Booking Request
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

