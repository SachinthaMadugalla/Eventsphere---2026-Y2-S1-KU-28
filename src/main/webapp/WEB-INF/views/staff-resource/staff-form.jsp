<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty staff.staffId and staff.staffId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Staff' : 'Add Staff'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${isEdit ? '&#9998; Edit Staff' : '&#43; Add Staff Member'}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:560px;">
        <c:set var="action" value="${isEdit ? '/staff/edit/'.concat(staff.staffId) : '/staff/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Full Name</label>
                <input type="text" name="fullName" class="es-input" value="${staff.fullName}" required>
            </div>
            <div class="es-form-group">
                <label class="required">Job Role</label>
                <input type="text" name="jobRole" class="es-input" value="${staff.jobRole}" required placeholder="e.g. Event Coordinator">
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" class="es-input" value="${staff.phone}" placeholder="07XXXXXXXX">
                </div>
                <div class="es-form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="es-input" value="${staff.email}">
                </div>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Add Staff'}</button>
                <a href="${pageContext.request.contextPath}/staff/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

