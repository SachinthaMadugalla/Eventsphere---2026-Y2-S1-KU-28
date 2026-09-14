<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Customer Feedback"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#11088; Customer Feedback</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/reporting/reports">Reports</a>
            &rsaquo; Feedback
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <!-- Summary stat -->
    <div class="stat-cards">
        <div class="stat-card">
            <div class="stat-label">Total Feedback</div>
            <div class="stat-value">${feedbackList.size()}</div>
        </div>
        <div class="stat-card gold">
            <div class="stat-label">Average Rating</div>
            <div class="stat-value">
                <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5
            </div>
        </div>
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>All Feedback</h3>
            <input type="text" class="es-input" style="max-width:220px;"
                   placeholder="Search feedback..."
                   oninput="filterTable('feedbackTable', this.value)">
        </div>

        <c:choose>
            <c:when test="${empty feedbackList}">
                <div class="es-empty">
                    <span class="es-empty-icon">&#11088;</span>
                    <p>No feedback submitted yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="es-table-wrap">
                    <table class="es-table" id="feedbackTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Event</th>
                                <th>Customer</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>Submitted</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="f" items="${feedbackList}" varStatus="st">
                            <tr>
                                <td>${st.count}</td>
                                <td>${f.eventName}</td>
                                <td>${f.customerName}</td>
                                <td>
                                    <span style="color:#E8A020;font-size:14px;">
                                        <c:forEach begin="1" end="${f.rating}">&#9733;</c:forEach>
                                        <c:forEach begin="${f.rating + 1}" end="5">
                                            <span style="color:#D8DEE8;">&#9733;</span>
                                        </c:forEach>
                                    </span>
                                    <span style="font-size:11px;color:#718096;margin-left:4px;">
                                        (${f.rating}/5)
                                    </span>
                                </td>
                                <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                    ${empty f.comment ? 'â€”' : f.comment}
                                </td>
                                <td>
                                    ${f.submittedDate}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${f.status == 'Moderated'}">
                                            <span class="es-badge badge-moderated">Moderated</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="es-badge badge-active">Active</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reporting/feedback/detail/${f.feedbackId}"
                                       class="btn btn-secondary btn-xs">View</a>
                                    <c:if test="${f.status == 'Active'}">
                                        <button type="button"
                                                class="btn btn-warning btn-xs"
                                                onclick="openModerateModal(${f.feedbackId})">
                                            Moderate
                                        </button>
                                    </c:if>
                                    <form action="${pageContext.request.contextPath}/reporting/feedback/delete/${f.feedbackId}"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirmDelete('this feedback entry')">
                                        <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- Moderate Modal -->
<div class="es-modal-overlay" id="moderateModal">
    <div class="es-modal">
        <h3>&#9888; Moderate Feedback</h3>
        <p style="color:#718096;font-size:13px;margin-bottom:16px;">
            Provide a reason for moderating this feedback entry.
        </p>
        <form id="moderateForm" method="post">
            <div class="es-form-group">
                <label class="required">Moderation Reason</label>
                <textarea name="reason" class="es-textarea" rows="3"
                          placeholder="e.g. Inappropriate language, spam..."
                          required></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                        onclick="closeModal('moderateModal')">Cancel</button>
                <button type="submit" class="btn btn-warning">Moderate</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModerateModal(feedbackId) {
    document.getElementById('moderateForm').action =
        '${pageContext.request.contextPath}/reporting/feedback/moderate/' + feedbackId;
    openModal('moderateModal');
}
</script>

