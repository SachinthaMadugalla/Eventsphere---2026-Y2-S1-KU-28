<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Reports"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128200; Reports</h2>
        <div class="breadcrumb">Home &rsaquo; Reports</div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-card">
        <div class="card-header"><h3>Available Reports</h3></div>
        <p style="color:#718096;font-size:13px;margin-bottom:20px;">
            Select a report category below to view detailed data.
        </p>

        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;">

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/events"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #2C3E6B;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(44,62,107,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#128197;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Event Report</div>
                    <div style="font-size:12px;color:#718096;">Events by status, month, category</div>
                </div>
            </a>

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/finance"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #38A169;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(56,161,105,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#128176;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Finance Report</div>
                    <div style="font-size:12px;color:#718096;">Revenue, payments, expenses, budgets</div>
                </div>
            </a>

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/venues"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #E8A020;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(232,160,32,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#127968;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Venue Usage Report</div>
                    <div style="font-size:12px;color:#718096;">Venue bookings and utilisation</div>
                </div>
            </a>

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/vendors"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #805AD5;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(128,90,213,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#128722;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Vendor Usage Report</div>
                    <div style="font-size:12px;color:#718096;">Vendor assignments across events</div>
                </div>
            </a>

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/staff"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #3182CE;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(49,130,206,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#128100;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Staff Allocation Report</div>
                    <div style="font-size:12px;color:#718096;">Staff assignments per event</div>
                </div>
            </a>

            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/reports/resources"
               style="text-decoration:none;">
                <div class="es-card" style="margin-bottom:0;border-left:4px solid #DD6B20;
                     transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(221,107,32,0.12)'"
                     onmouseout="this.style.boxShadow=''">
                    <div style="font-size:28px;margin-bottom:8px;">&#128230;</div>
                    <div style="font-weight:700;color:#2C3E6B;margin-bottom:4px;">Resource Usage Report</div>
                    <div style="font-size:12px;color:#718096;">Resource allocations and availability</div>
                </div>
            </a>

        </div>
    </div>

    <!-- Feedback & Complaints quick links -->
    <div class="es-card">
        <div class="card-header"><h3>Feedback &amp; Complaints</h3></div>
        <div style="display:flex;gap:12px;flex-wrap:wrap;padding:8px 0;">
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/feedback/list"
               class="btn btn-secondary">&#11088; View Feedback</a>
            <a href="${fn:escapeXml(pageContext.request.contextPath)}/reporting/complaint/list"
               class="btn btn-secondary">&#9888; View Complaints</a>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

