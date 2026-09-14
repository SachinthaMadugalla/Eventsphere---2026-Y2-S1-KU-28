<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Resource Usage Report"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128230; Resource Usage Report</h2>
        <div class="breadcrumb">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports">Reports</a>
            &rsaquo; Resource Usage
        </div>
    </div>

    <div style="display:flex;justify-content:flex-end;margin-bottom:12px;">
        <button class="btn btn-secondary btn-sm" onclick="printPage()">&#128424; Print</button>
    </div>

    <!-- Resource availability summary -->
    <div class="es-card">
        <div class="card-header">
            <h3>Resource Availability</h3>
            <span style="font-size:12px;color:#718096;">${fn:escapeXml(resources.size())} resource(s)</span>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Resource Name</th>
                        <th>Category</th>
                        <th>Total Qty</th>
                        <th>Available Qty</th>
                        <th>Allocated Qty</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${resources}" varStatus="st">
                    <c:set var="allocated" value="${r.totalQuantity - r.availableQuantity}"/>
                    <tr>
                        <td>${fn:escapeXml(st.count)}</td>
                        <td><strong>${fn:escapeXml(r.resourceName)}</strong></td>
                        <td>${fn:escapeXml(empty r.category ? '—' : r.category)}</td>
                        <td>${fn:escapeXml(r.totalQuantity)}</td>
                        <td style="${fn:escapeXml(r.availableQuantity <= 0 ? 'color:#E53E3E;font-weight:700;' : '')}">
                            ${fn:escapeXml(r.availableQuantity)}
                        </td>
                        <td>${fn:escapeXml(allocated)}</td>
                        <td>
                            <span class="es-badge ${fn:escapeXml(r.active ? 'badge-active' : 'badge-inactive')}">
                                ${fn:escapeXml(r.active ? 'Active' : 'Inactive')}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Allocation history -->
    <div class="es-card">
        <div class="card-header">
            <h3>Allocation History</h3>
            <span style="font-size:12px;color:#718096;">${fn:escapeXml(allocations.size())} allocation(s)</span>
        </div>
        <c:choose>
            <c:when test="${empty allocations}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#128230;</span>
                    <p>No allocations on record.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Resource</th>
                                <th>Event</th>
                                <th>Quantity</th>
                                <th>Allocated On</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="a" items="${allocations}" varStatus="st">
                            <tr>
                                <td>${fn:escapeXml(st.count)}</td>
                                <td><strong>${fn:escapeXml(a.resourceName)}</strong></td>
                                <td>${fn:escapeXml(a.eventName)}</td>
                                <td>${fn:escapeXml(a.quantity)}</td>
                                <td>
                                    ${fn:escapeXml(a.allocatedOn)}
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

