<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error â€“ EventSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/eventsphere.css">
</head>
<body>
<div style="display:flex;align-items:center;justify-content:center;
            min-height:100vh;background:#F5F7FB;padding:20px;">
    <div style="text-align:center;max-width:500px;">
        <div style="font-size:64px;margin-bottom:16px;">&#9888;</div>
        <h2 style="color:#2C3E6B;font-size:22px;margin-bottom:12px;">Something went wrong</h2>
        <c:if test="${not empty errorMessage}">
            <div class="es-alert es-alert-error" style="text-align:left;margin-bottom:20px;">
                ${errorMessage}
            </div>
        </c:if>
        <p style="color:#718096;margin-bottom:24px;">
            Please go back and try again. If the problem persists, contact your system administrator.
        </p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
            &#8592; Back to Dashboard
        </a>
        &nbsp;
        <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
    </div>
</div>
</body>
</html>

