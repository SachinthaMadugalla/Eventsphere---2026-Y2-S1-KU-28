<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manage Users"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>
<div class="es-main">
<%@ include file="/WEB-INF/views/common/topbar.jsp" %>
<div class="es-content">

    <div class="page-header">
        <h2>&#128101; Manage Users</h2>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
            &rsaquo; Users
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/alerts.jsp" %>

    <div class="es-alert es-alert-info">
        &#8505; Use this page to activate, deactivate, or change the role of any system user.
        You cannot deactivate your own account.
    </div>

    <div class="es-card">
        <div class="card-header">
            <h3>All Accounts (${users.size()})</h3>
            <!-- Client-side search -->
            <input type="text" class="es-input" style="max-width:240px;"
                   placeholder="Search users..." oninput="filterTable('userTable', this.value)">
        </div>

        <div class="es-table-wrap">
            <table class="es-table" id="userTable">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Current Role</th>
                        <th>Status</th>
                        <th>Joined</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><strong>${u.username}</strong></td>
                        <td>${u.fullName}</td>
                        <td>${u.email}</td>
                        <td>${empty u.phone ? 'â€”' : u.phone}</td>
                        <td>
                            <span class="es-badge badge-pending">${u.roleName}</span>
                        </td>
                        <td>
                            <span class="es-badge ${u.active ? 'badge-active' : 'badge-inactive'}">
                                ${u.active ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td>
                            ${u.createdAt.toLocalDate()}
                        </td>
                        <td>
                            <!-- Activate / Deactivate -->
                            <form action="${pageContext.request.contextPath}/admin/users/toggle/${u.userId}"
                                  method="post" style="display:inline;"
                                  onsubmit="return confirmAction('${u.active ? 'Deactivate' : 'Activate'} account for ${u.username}?')">
                                <input type="hidden" name="active" value="${!u.active}">
                                <button type="submit"
                                        class="btn ${u.active ? 'btn-warning' : 'btn-success'} btn-xs">
                                    ${u.active ? 'Deactivate' : 'Activate'}
                                </button>
                            </form>

                            <!-- Change Role -->
                            <button type="button"
                                    class="btn btn-primary btn-xs"
                                    onclick="openRoleModal(${u.userId}, '${u.username}', ${u.roleId})">
                                Change Role
                            </button>

                            <!-- Delete (only non-self) -->
                            <c:if test="${u.userId != sessionScope.userId}">
                                <form action="${pageContext.request.contextPath}/admin/users/delete/${u.userId}"
                                      method="post" style="display:inline;"
                                      onsubmit="return confirmDelete('account for ${u.username}')">
                                    <button type="submit" class="btn btn-danger btn-xs">Delete</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<!-- â”€â”€ Change Role Modal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ -->
<div class="es-modal-overlay" id="roleModal">
    <div class="es-modal">
        <h3>&#128100; Change User Role</h3>
        <p id="roleModalLabel" style="color:#718096;font-size:13px;margin-bottom:16px;"></p>

        <form id="roleForm" method="post">
            <div class="es-form-group">
                <label class="required">Select New Role</label>
                <select name="roleId" id="roleSelect" class="es-select" required>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.role_id}">${r.role_name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('roleModal')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">Save Role</button>
            </div>
        </form>
    </div>
</div>

<script>
function openRoleModal(userId, username, currentRoleId) {
    document.getElementById('roleModalLabel').textContent =
        'Changing role for: ' + username;
    document.getElementById('roleForm').action =
        '${pageContext.request.contextPath}/admin/users/role/' + userId;

    // Pre-select current role
    var select = document.getElementById('roleSelect');
    for (var i = 0; i < select.options.length; i++) {
        select.options[i].selected = (parseInt(select.options[i].value) === currentRoleId);
    }
    openModal('roleModal');
}
</script>

