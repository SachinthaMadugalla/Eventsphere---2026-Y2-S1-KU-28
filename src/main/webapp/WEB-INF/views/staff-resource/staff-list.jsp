<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Staff"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>&#128100; Staff Members</h2><div class="breadcrumb">Home &rsaquo; Staff</div></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card">
        <div class="card-header">
            <h3>All Staff</h3>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/create" class="btn btn-accent btn-sm">+ Add Staff</a>
        </div>
        <div class="es-table-wrap">
            <table class="es-table">
                <thead><tr><th>#</th><th>Full Name</th><th>Job Role</th><th>Phone</th><th>Email</th><th>Status</th><th>Actions</th></tr></thead>
                <tbody>
                <c:forEach var="s" items="${staffList}" varStatus="st">
                    <tr>
                        <td>${fn:escapeXml(st.count)}</td>
                        <td><strong>${fn:escapeXml(s.fullName)}</strong></td>
                        <td>${fn:escapeXml(s.jobRole)}</td>
                        <td>${fn:escapeXml(empty s.phone ? '—' : s.phone)}</td>
                        <td>${fn:escapeXml(empty s.email ? '—' : s.email)}</td>
                        <td><span class="es-badge ${fn:escapeXml(s.active ? 'badge-active' : 'badge-inactive')}">${fn:escapeXml(s.active ? 'Active' : 'Inactive')}</span></td>
                        <td>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/detail/${fn:escapeXml(s.staffId)}" class="btn btn-secondary btn-xs">View</a>
                            <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/edit/${fn:escapeXml(s.staffId)}" class="btn btn-primary btn-xs">Edit</a>
                            <form action="${fn:escapeXml(pageContext.request.contextPath)}/staff/toggle/${fn:escapeXml(s.staffId)}" method="post" style="display:inline;">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                <input type="hidden" name="active" value="${fn:escapeXml(!s.active)}">
                                <button type="submit" class="btn btn-warning btn-xs">${fn:escapeXml(s.active ? 'Deactivate' : 'Activate')}</button>
                            </form>
                            <form action="${fn:escapeXml(pageContext.request.contextPath)}/staff/delete/${fn:escapeXml(s.staffId)}" method="post" style="display:inline;" onsubmit="return confirmAction('Proceed with this change?')">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
                                <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

