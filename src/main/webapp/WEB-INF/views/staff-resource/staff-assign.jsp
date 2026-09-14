<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Assign Staff"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128100; Assign Staff to Event</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <c:if test="${not empty event}">
        <div class="es-alert es-alert-info">Assigning staff to: <strong>${event.eventName}</strong> on <strong>${event.eventDate}</strong></div>
    </c:if>
    <div class="es-card" style="max-width:560px;">
        <form action="${pageContext.request.contextPath}/staff/assign" method="post" class="es-validate">
            <input type="hidden" name="eventId" value="${event.eventId}">
            <div class="es-form-group">
                <label class="required">Select Staff Member</label>
                <select name="staffId" class="es-select" required>
                    <option value="">-- Select --</option>
                    <c:forEach var="s" items="${staffList}">
                        <option value="${s.staffId}">${s.fullName} â€“ ${s.jobRole}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="es-form-group">
                <label>Role at This Event</label>
                <input type="text" name="roleAtEvent" class="es-input" placeholder="e.g. Lead Coordinator">
            </div>
            <div class="es-form-group">
                <label class="required">Assignment Date</label>
                <input type="date" name="assignedDate" class="es-input" value="${event.eventDate}" required>
            </div>
            <div class="es-form-group">
                <label>Notes</label>
                <input type="text" name="notes" class="es-input" placeholder="Optional notes">
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">Assign Staff</button>
                <a href="${pageContext.request.contextPath}/event/detail/${event.eventId}" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

