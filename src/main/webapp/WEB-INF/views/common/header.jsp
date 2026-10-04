<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Common HTML head + opening body tags.
  Include at the top of every authenticated page:
    <%@ include file="/WEB-INF/views/common/header.jsp" %>
  pageTitle variable should be set before include.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(empty pageTitle ? 'EventSphere' : pageTitle)} – EventSphere</title>
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/eventsphere.css?v=9">
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/dashboard.css?v=9">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Tom Select (Searchable Dropdowns) -->
    <link href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.default.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>
</head>
<%--
  Derive the module (view folder) and page type (dashboard / list / form / detail)
  from the rendered view path, e.g. /WEB-INF/views/finance/invoice-form.jsp.
  dashboard.css uses these body classes to give every module its own look.
--%>
<c:set var="esViewPath" value="${pageContext.request.servletPath}"/>
<c:set var="esModule" value="${fn:substringBefore(fn:substringAfter(esViewPath, '/views/'), '/')}"/>
<c:set var="esPage" value="${fn:substringBefore(fn:substringAfter(esViewPath, esModule.concat('/')), '.jsp')}"/>
<c:choose>
    <c:when test="${fn:contains(esPage, 'dashboard')}"><c:set var="esPageType" value="dashboard"/></c:when>
    <c:when test="${fn:contains(esPage, 'form') or fn:contains(esPage, 'assign') or fn:contains(esPage, 'allocate') or fn:contains(esPage, 'edit')}"><c:set var="esPageType" value="form"/></c:when>
    <c:when test="${fn:contains(esPage, 'detail')}"><c:set var="esPageType" value="detail"/></c:when>
    <c:otherwise><c:set var="esPageType" value="list"/></c:otherwise>
</c:choose>
<body class="mod-${fn:escapeXml(empty esModule ? 'common' : esModule)} page-${fn:escapeXml(esPageType)} view-${fn:escapeXml(esPage)}">
<div class="es-wrapper">

