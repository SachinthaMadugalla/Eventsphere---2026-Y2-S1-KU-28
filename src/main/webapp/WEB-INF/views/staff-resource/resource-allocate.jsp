<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Resource Allocation"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128230; Allocate Resources to Event</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <c:if test="${not empty event}">
        <div class="es-alert es-alert-info">Allocating resources to: <strong>${fn:escapeXml(event.eventName)}</strong> (${fn:escapeXml(event.guestCount)} guests)</div>
    </c:if>

    <div class="es-card" style="max-width:560px;">
        <div class="card-header"><h3>Allocate Resource</h3></div>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/resource/allocate" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
            <div class="es-form-group">
                <label class="required">Select Resource</label>
                <select name="resourceId" class="es-select" required>
                    <option value="">-- Select Resource --</option>
                    <c:forEach var="r" items="${resources}">
                        <option value="${fn:escapeXml(r.resourceId)}">${fn:escapeXml(r.resourceName)} (Available: ${fn:escapeXml(r.availableQuantity)})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="es-form-group">
                <label class="required">Quantity</label>
                <input type="number" name="quantity" class="es-input" required min="1" placeholder="How many?">
            </div>
            <div class="es-form-group">
                <label>Notes</label>
                <input type="text" name="notes" class="es-input" placeholder="Optional notes">
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">Allocate</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/event/detail/${fn:escapeXml(event.eventId)}" class="btn btn-secondary">Back to Event</a>
            </div>
        </form>
    </div>

    <!-- Current allocations for this event -->
    <div class="es-card">
        <div class="card-header"><h3>Current Allocations for this Event</h3></div>
        <c:choose>
            <c:when test="${empty allocations}"><div class="es-empty"><p>No resources allocated yet.</p></div></c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead><tr><th>Resource</th><th>Quantity</th><th>Notes</th><th>Action</th></tr></thead>
                        <tbody>
                        <c:forEach var="a" items="${allocations}">
                            <tr>
                                <td>${fn:escapeXml(a.resourceName)}</td>
                                <td>${fn:escapeXml(a.quantity)}</td>
                                <td>${fn:escapeXml(empty a.notes ? '—' : a.notes)}</td>
                                <td>
                                    <form action="${fn:escapeXml(pageContext.request.contextPath)}/resource/allocate/release/${fn:escapeXml(a.allocationId)}" method="post" onsubmit="return confirmAction('Release this allocation?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                        <input type="hidden" name="eventId" value="${fn:escapeXml(event.eventId)}">
                                        <button type="submit" class="btn btn-warning btn-xs">Release</button>
                                    </form>
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

