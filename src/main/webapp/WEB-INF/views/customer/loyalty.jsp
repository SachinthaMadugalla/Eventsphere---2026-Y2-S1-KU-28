<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Customer Loyalty"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">
    <div class="page-header"><p class="dashboard-eyebrow">MORE MOMENTS, MORE REWARDS</p><h2>Customer loyalty</h2></div>
    <div class="es-card">
        <h3>Every completed celebration counts.</h3>
        <p style="margin-top:12px;line-height:1.8">Earn 100 points for each completed event when all its invoices are fully paid. Reach 300 points to become a Loyal Customer.</p>
        <p style="margin-top:8px;color:#657187;line-height:1.7">Points reflect current event and payment records. Cancelled, unpaid and partially paid events do not qualify. Archived completed events still count. Payment corrections may change your points and status.</p>
    </div>
    <c:choose>
    <c:when test="${manageLoyalty}">
        <div class="es-card"><div class="card-header"><h3>Customer loyalty overview</h3></div>
        <div class="es-table-wrap"><table class="es-table"><thead><tr><th>Customer</th><th>Points</th><th>Status</th></tr></thead><tbody>
        <c:forEach var="item" items="${loyaltyCustomers}"><tr><td>${fn:escapeXml(item.fullName)}</td><td>${fn:escapeXml(item.points)}</td><td>${fn:escapeXml(item.status)}</td></tr></c:forEach>
        <c:if test="${empty loyaltyCustomers}"><tr><td colspan="3">No customers yet.</td></tr></c:if>
        </tbody></table></div></div>
    </c:when>
    <c:otherwise>
        <div class="stat-cards">
            <div class="stat-card gold"><div class="stat-label">Your points</div><div class="stat-value">${fn:escapeXml(loyalty.points)}</div></div>
            <div class="stat-card"><div class="stat-label">Membership status</div><h3>${fn:escapeXml(loyalty.status)}</h3><div class="stat-sub">${fn:escapeXml(loyalty.remaining)} points to the loyalty threshold</div></div>
        </div>
        <div class="es-card"><div class="card-header"><h3>Qualifying events</h3></div>
        <div class="es-table-wrap"><table class="es-table"><thead><tr><th>Event</th><th>Event date</th><th>Points</th></tr></thead><tbody>
        <c:forEach var="entry" items="${entries}"><tr><td>${fn:escapeXml(entry.eventName)}</td><td>${fn:escapeXml(entry.eventDate)}</td><td>+${fn:escapeXml(entry.points)}</td></tr></c:forEach>
        <c:if test="${empty entries}"><tr><td colspan="3">No qualifying events yet. Your first completed, fully paid event earns 100 points.</td></tr></c:if>
        </tbody></table></div></div>
    </c:otherwise>
    </c:choose>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
