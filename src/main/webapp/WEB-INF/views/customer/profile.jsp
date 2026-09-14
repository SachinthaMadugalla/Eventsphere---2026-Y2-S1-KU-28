<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128100; My Profile</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a> &rsaquo; Profile
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card" style="max-width:600px;">
        <div class="card-header">
            <h3>Update Profile</h3>
        </div>

        <form action="${pageContext.request.contextPath}/customer/profile/update"
              method="post" class="es-validate">
            <input type="hidden" name="customerId" value="${customer.customerId}">

            <div class="es-form-group">
                <label class="required">Full Name</label>
                <input type="text" name="fullName" class="es-input"
                       value="${customer.fullName}" required>
            </div>

            <div class="es-form-group">
                <label class="required">Email Address</label>
                <input type="email" name="email" class="es-input"
                       value="${customer.email}" required>
            </div>

            <div class="es-form-group">
                <label>Phone Number</label>
                <input type="text" name="phone" class="es-input"
                       value="${customer.phone}" placeholder="07XXXXXXXX">
            </div>

            <div class="es-form-group">
                <label>Address</label>
                <textarea name="address" class="es-textarea" rows="2">${customer.address}</textarea>
            </div>

            <div style="display:flex;gap:12px;margin-top:8px;">
                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="${pageContext.request.contextPath}/customer/dashboard"
                   class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

