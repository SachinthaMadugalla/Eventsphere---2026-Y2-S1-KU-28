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
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/eventsphere.css">
    <link rel="stylesheet" href="${fn:escapeXml(pageContext.request.contextPath)}/static/css/dashboard.css">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="es-wrapper">

