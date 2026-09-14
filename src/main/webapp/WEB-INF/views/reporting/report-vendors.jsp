<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Vendor Usage Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128722; Vendor Usage Report</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports">Reports</a>
            &rsaquo; Vendor Usage
        </div>
    </div>

    <div style="display:flex;justify-content:flex-end;margin-bottom:12px;">
        <button class="btn btn-secondary btn-sm" onclick="printPage()">&#128424; Print</button>
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>Vendor Assignments</h3>
            <span style="font-size:12px;color:#718096;">${fn:escapeXml(assignments.size())} assignment(s)</span>
        </div>
        <c:choose>
            <c:when test="${empty assignments}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128722;</span>
                    <p>No vendor assignments on record.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Vendor</th>
                                <th>Category</th>
                                <th>Event</th>
                                <th>Service Date</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${assignments}" varStatus="st">
                            <tr>
                                <td>${fn:escapeXml(st.count)}</td>
                                <td><strong>${fn:escapeXml(a.vendorName)}</strong></td>
                                <td>${fn:escapeXml(a.categoryName)}</td>
                                <td>${fn:escapeXml(a.eventName)}</td>
                                <td>
                                    ${fn:escapeXml(a.serviceDate)}
                                </td>
                                <td>${fn:escapeXml(empty a.notes ? '—' : a.notes)}</td>
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

