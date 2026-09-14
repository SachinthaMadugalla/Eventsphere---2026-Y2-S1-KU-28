<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Complaints"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#9888; Complaints</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/reports">Reports</a>
            &rsaquo; Complaints
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header">
            <h3>All Complaints</h3>
            <input type="text" class="es-input" style="max-width:220px;"
                   placeholder="Search complaints..."
                   oninput="filterTable('complaintTable', this.value)">
        </div>

        <c:choose>
            <c:when test="${empty complaints}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#9989;</span>
                    <p>No complaints on record.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table" id="complaintTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Subject</th>
                                <th>Customer</th>
                                <th>Event</th>
                                <th>Submitted</th>
                                <th>Status</th>
                                <th>Escalated</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="c" items="${complaints}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td><strong>${c.subject}</strong></td>
                                <td>${c.customerName}</td>
                                <td>${empty c.eventName ? 'â€”' : c.eventName}</td>
                                <td>
                                    ${c.submittedDate}
                                </td>
                                <td>
                                    <c:set var="cs" value="${c.status.toLowerCase().replace(' ','')}"/>
                                    <span class="es-badge badge-${cs}">${c.status}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.escalated}">
                                            <span class="es-badge badge-escalated">Yes</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#A0AEC0;font-size:12px;">No</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reporting/complaint/detail/${c.complaintId}"
                                       class="btn btn-secondary btn-xs">View</a>
                                    <c:if test="${not c.escalated and (c.status == 'Submitted' or c.status == 'Under Review')}">
                                        <form action="${pageContext.request.contextPath}/reporting/complaint/escalate/${c.complaintId}"
                                              method="post" style="display:inline;"
                                              onsubmit="return confirmAction('Escalate this complaint to the Managing Director?')">
                                            <button type="submit" class="btn btn-warning btn-xs">
                                                Escalate
                                            </button>
                                        </form>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/reporting/complaint/delete/${c.complaintId}"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirmDelete('this complaint')">
                                        <button type="submit" class="btn btn-danger btn-xs">Delete</button>
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

