<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Access Denied"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content" style="display:flex;align-items:center;justify-content:center;min-height:60vh;">
    <div style="text-align:center;">
        <div style="font-size:64px;margin-bottom:16px;">&#128274;</div>
        <h2 style="color:#2C3E6B;font-size:24px;margin-bottom:8px;">Access Denied</h2>
        <p style="color:#718096;margin-bottom:24px;">
            You do not have permission to view this page.
        </p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
            &#8592; Back to Dashboard
        </a>
    </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

