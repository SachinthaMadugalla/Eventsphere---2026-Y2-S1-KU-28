<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Reusable flash alert block.
  Include inside .es-content on any page to show success/error flash messages.
--%>
<c:if test="${not empty success}">
    <div class="es-alert es-alert-success auto-dismiss">
        &#10003; ${success}
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="es-alert es-alert-error auto-dismiss">
        &#9888; ${error}
    </div>
</c:if>
<c:if test="${not empty warning}">
    <div class="es-alert es-alert-warning auto-dismiss">
        &#9888; ${warning}
    </div>
</c:if>
<c:if test="${not empty info}">
    <div class="es-alert es-alert-info">
        &#8505; ${info}
    </div>
</c:if>

