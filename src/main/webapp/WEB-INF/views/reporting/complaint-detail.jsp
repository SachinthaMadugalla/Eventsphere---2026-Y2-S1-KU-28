<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Complaint Detail"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#9888; Complaint Detail</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/complaint/list">Complaints</a>
            &rsaquo; #${complaint.complaintId}
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:760px;">
        <div class="card-header">
            <h3>${complaint.subject}</h3>
            <div style="display:flex;gap:8px;align-items:center;">
                <c:set var="cs" value="${complaint.status.toLowerCase().replace(' ','')}"/>
                <span class="es-badge badge-${cs}">${complaint.status}</span>
                <c:if test="${complaint.escalated}">
                    <span class="es-badge badge-escalated">Escalated</span>
                </c:if>
            </div>
        </div>

        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Customer</div>
                <div class="detail-value">${complaint.customerName}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Related Event</div>
                <div class="detail-value">${empty complaint.eventName ? 'Not linked to event' : complaint.eventName}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Submitted</div>
                <div class="detail-value">
                    ${complaint.submittedDate}
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Last Updated</div>
                <div class="detail-value">
                    ${complaint.updatedDate}
                </div>
            </div>
        </div>

        <div class="detail-item" style="margin-top:16px;">
            <div class="detail-label">Description</div>
            <div class="detail-value" style="margin-top:6px;line-height:1.6;">
                ${complaint.description}
            </div>
        </div>

        <c:if test="${not empty complaint.response}">
            <div class="detail-item" style="margin-top:12px;background:#F0FFF4;border-color:#9AE6B4;">
                <div class="detail-label" style="color:#276749;">Response</div>
                <div class="detail-value" style="margin-top:6px;line-height:1.6;">
                    ${complaint.response}
                </div>
            </div>
        </c:if>
    </div>

    <!-- Staff update form (not shown to customers) -->
    <c:if test="${sessionScope.userRole != 'Customer'}">
    <div class="es-card" style="max-width:760px;">
        <div class="card-header"><h3>Update Complaint</h3></div>
        <form action="${pageContext.request.contextPath}/reporting/complaint/update/${complaint.complaintId}"
              method="post" class="es-validate">

            <div class="es-form-row">
                <div class="es-form-group">
                    <label class="required">Status</label>
                    <select name="status" class="es-select" required>
                        <c:forEach var="s" items="${['Submitted','Under Review','Resolved','Closed']}">
                            <option value="${s}"
                                ${complaint.status == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label>Escalate to Managing Director</label>
                    <select name="escalated" class="es-select">
                        <option value="false" ${!complaint.escalated ? 'selected' : ''}>No</option>
                        <option value="true"  ${complaint.escalated  ? 'selected' : ''}>Yes</option>
                    </select>
                </div>
            </div>

            <div class="es-form-group">
                <label>Response to Customer</label>
                <textarea name="response" class="es-textarea" rows="4"
                          placeholder="Enter your response to the customer...">${complaint.response}</textarea>
            </div>

            <div style="display:flex;gap:10px;">
                <button type="submit" class="btn btn-primary">Save Update</button>
                <c:if test="${not complaint.escalated}">
                    <form action="${pageContext.request.contextPath}/reporting/complaint/escalate/${complaint.complaintId}"
                          method="post" style="display:inline;"
                          onsubmit="return confirmAction('Escalate to Managing Director?')">
                        <button type="submit" class="btn btn-warning">
                            &#9650; Escalate to Director
                        </button>
                    </form>
                </c:if>
            </div>
        </form>
    </div>
    </c:if>

    <div style="display:flex;gap:10px;flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/reporting/complaint/list"
           class="btn btn-secondary">&#8592; Back to Complaints</a>
        <c:if test="${sessionScope.userRole != 'Customer'}">
            <form action="${pageContext.request.contextPath}/reporting/complaint/delete/${complaint.complaintId}"
                  method="post" onsubmit="return confirmDelete('this complaint')">
                <button type="submit" class="btn btn-danger">Delete</button>
            </form>
        </c:if>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

