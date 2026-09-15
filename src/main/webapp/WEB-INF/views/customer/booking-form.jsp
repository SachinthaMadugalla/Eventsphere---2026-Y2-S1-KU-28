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
              method="post" class="es-validate" id="booking-form" data-venues-url="${fn:escapeXml(pageContext.request.contextPath)}/customer/booking/available-venues">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-group">
                <label class="required" for="eventName">Event Name</label>
                <input type="text" name="eventName" id="eventName" value="${fn:escapeXml(event.eventName)}" class="es-input"
                       placeholder="e.g. My Wedding Reception" required maxlength="200">
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required" for="categoryId">Event Category</label>
                    <select name="categoryId" id="categoryId" class="es-select" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${fn:escapeXml(cat.categoryId)}" ${event.categoryId == cat.categoryId ? 'selected' : ''}>${fn:escapeXml(cat.categoryName)}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required" for="guestCount">Expected Guest Count</label>
                    <input type="number" name="guestCount" id="guestCount" value="${event.guestCount > 0 ? event.guestCount : ''}" class="es-input"
                           placeholder="Number of guests" required min="1" max="5000">
                </div>
            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required" for="eventDate">Event Date</label>
                    <input type="date" name="eventDate" id="eventDate" value="${fn:escapeXml(event.eventDate)}" class="es-input no-past-date" required>
                </div>

            </div>

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required" for="startTime">Preferred Start Time</label>
                    <input type="time" name="startTime" id="startTime" value="${fn:escapeXml(event.startTime)}" class="es-input" required>
                </div>
                <div class="es-form-group">
                    <label class="required" for="endTime">Preferred End Time</label>
                    <input type="time" name="endTime" id="endTime" value="${fn:escapeXml(event.endTime)}" class="es-input" required>
                </div>
            </div>

                <div class="es-form-group">
                    <label class="required" for="venueId">Available Venue</label>
                    <select name="venueId" id="venueId" class="es-select" required disabled aria-describedby="venue-status">
                        <option value="">Enter date, times and guest count first</option>
                    </select>
                    <p id="venue-status" role="status" style="margin-top:8px;line-height:1.5">Only available venues with enough capacity will appear.</p>
                    <button type="button" class="btn btn-secondary btn-sm" id="refresh-venues" style="margin-top:8px">Check availability</button>
                </div>
            <div class="es-form-group">
                <label for="requirements">Special Requirements</label>
                <textarea name="requirements" id="requirements" class="es-textarea"
                          placeholder="Describe any special requirements, preferences or requests..."
                          rows="4">${fn:escapeXml(event.requirements)}</textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;flex-wrap:wrap;">
                <button type="submit" class="btn btn-accent" id="submit-booking" disabled>
                    &#128197; Submit Booking Request
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<script src="${fn:escapeXml(pageContext.request.contextPath)}/static/js/booking-venues.js" defer></script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

