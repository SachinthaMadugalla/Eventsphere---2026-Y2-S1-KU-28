<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty staff.staffId and staff.staffId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Staff' : 'Add Staff'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${isEdit ? '&#9998;' : '&#43;'} ${fn:escapeXml(isEdit ? 'Edit Staff' : 'Add Staff Member')}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:560px;">
        <c:set var="action" value="${isEdit ? '/staff/edit/'.concat(staff.staffId) : '/staff/create'}"/>
        <form action="${fn:escapeXml(pageContext.request.contextPath)}${fn:escapeXml(action)}" method="post" class="es-validate">
<input type="hidden" name="_csrf" value="${fn:escapeXml(sessionScope.csrfToken)}">
            <div class="es-form-group">
                <label class="required">Full Name</label>
                <input type="text" name="fullName" class="es-input" value="${fn:escapeXml(staff.fullName)}" required
                       minlength="2" maxlength="100" data-rule="name">
            </div>
            <div class="es-form-group">
                <label class="required">Job Role</label>
                <input type="text" name="jobRole" class="es-input" value="${fn:escapeXml(staff.jobRole)}" required maxlength="100" placeholder="e.g. Event Coordinator">
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Phone</label>
                    <input type="tel" name="phone" class="es-input" value="${fn:escapeXml(staff.phone)}" placeholder="07XXXXXXXX"
                           inputmode="numeric" maxlength="10" pattern="0[0-9]{9}"
                           title="Exactly 10 digits starting with 0 (e.g. 0771234567)" data-rule="phone">
                </div>
                <div class="es-form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="es-input" value="${fn:escapeXml(staff.email)}" maxlength="150">
                </div>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${fn:escapeXml(isEdit ? 'Update' : 'Add Staff')}</button>
                <a href="${fn:escapeXml(pageContext.request.contextPath)}/staff/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

