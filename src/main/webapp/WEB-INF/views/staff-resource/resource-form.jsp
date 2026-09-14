<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="isEdit" value="${not empty resource.resourceId and resource.resourceId > 0}"/>
<c:set var="pageTitle" value="${isEdit ? 'Edit Resource' : 'Add Resource'}"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><h2>${isEdit ? '&#9998; Edit Resource' : '&#43; Add Resource'}</h2></div>
    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    <div class="es-card" style="max-width:560px;">
        <c:set var="action" value="${isEdit ? '/resource/edit/'.concat(resource.resourceId) : '/resource/create'}"/>
        <form action="${pageContext.request.contextPath}${action}" method="post" class="es-validate">
            <div class="es-form-group">
                <label class="required">Resource Name</label>
                <input type="text" name="resourceName" class="es-input" value="${resource.resourceName}" required>
            </div>
            <div class="es-form-row">
                <div class="es-form-group">
                    <label>Category</label>
                    <select name="category" class="es-select">
                        <option value="">-- Select --</option>
                        <c:forEach var="cat" items="${['Furniture','Audio/Visual','Lighting','Decoration','Outdoor','Other']}">
                            <option value="${cat}" ${resource.category == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="es-form-group">
                    <label class="required">Total Quantity</label>
                    <input type="number" name="totalQuantity" class="es-input" value="${resource.totalQuantity}" required min="1">
                </div>
            </div>
            <div class="es-form-group">
                <label>Description</label>
                <textarea name="description" class="es-textarea" rows="2">${resource.description}</textarea>
            </div>
            <div style="display:flex;gap:12px;">
                <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Add Resource'}</button>
                <a href="${pageContext.request.contextPath}/resource/list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

