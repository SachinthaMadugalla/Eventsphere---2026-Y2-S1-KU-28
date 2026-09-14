<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Submit Complaint"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#9888; Submit a Complaint</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard">Dashboard</a>
            &rsaquo; Submit Complaint
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-alert es-alert-info">
        &#8505; Your complaint will be reviewed by our Customer Relations team.
        We aim to respond within 2–3 business days.
    </div>

    <div class="es-card" style="max-width:640px;">
        <div class="card-header"><h3>Complaint Details</h3></div>

        <%--
          customerId is resolved server-side from session.
          The form does NOT accept a customerId parameter from the browser.
          See ReportingController.submitComplaint() — it reads from session.
        --%>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/submit"
              method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">

            <div class="es-form-group">
                <label>Related Event <span style="color:#718096;font-weight:400;">(optional)</span></label>
                <select name="eventId" class="es-select">
                    <option value="">-- Not related to a specific event --</option>
                    <c:forEach var="e" items="${events}">
                        <option value="${fn:escapeXml(e.eventId)}">${fn:escapeXml(e.eventName)}
                            (${fn:escapeXml(e.eventDate)})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="es-form-group">
                <label class="required">Subject</label>
                <input type="text" name="subject" class="es-input"
                       placeholder="Brief subject of your complaint"
                       required maxlength="200">
            </div>

            <div class="es-form-group">
                <label class="required">Description</label>
                <textarea name="description" class="es-textarea" rows="5"
                          placeholder="Please describe your complaint in detail..."
                          required></textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">
                    &#9888; Submit Complaint
                </button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/customer/dashboard"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

