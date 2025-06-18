<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="lk.cms.complaintmanagmentsystem.dao.UserDAO" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="org.apache.commons.dbcp2.BasicDataSource" %>

<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");

    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }

    BasicDataSource ds = (BasicDataSource) application.getAttribute("ds");
    UserDAO userDAO = new UserDAO(ds);

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    String today = new SimpleDateFormat("EEE, MMMM d").format(new Date());

    int resolvedCount = 0;
    int pendingCount = 0;
    int inProgressCount = 0;

    if (complaints != null) {
        for (Complaint c : complaints) {
            String status = c.getStatus().toUpperCase();
            switch (status) {
                case "RESOLVED":
                    resolvedCount++;
                    break;
                case "PENDING":
                    pendingCount++;
                    break;
                case "IN_PROGRESS":
                    inProgressCount++;
                    break;
            }
        }
    }

    Map<String, String> userNameCache = new HashMap<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Municipal CMS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/admin-dashboard.css" rel="stylesheet">

</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-building"></i> Municipal CMS
            <span class="admin-badge">Admin Panel</span>
        </a>

        <div class="navbar-nav ms-auto">
            <div class="nav-item d-flex align-items-center">
                <div class="user-avatar">
                    <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <span class="nav-link"><%= user.getFullName() %></span>
                <a href="pages/logout.jsp" class="nav-link"
                   onclick="return confirm('Are you sure you want to log out?')">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h2 class="mb-1">Welcome back, <%= user.getFullName() %>!</h2>
                <p class="text-muted mb-0">
                    <i class="bi bi-shield-check"></i> Administrator Dashboard - Manage all system complaints
                </p>
            </div>
            <div class="col-md-4 text-md-end">
                <small class="text-muted">
                    <i class="bi bi-calendar3"></i> <%= today %>
                </small>
            </div>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row">
        <div class="col-lg-3 col-md-6">
            <div class="stats-card">
                <div class="stats-number text-primary">
                    <%= complaints != null ? complaints.size() : 0 %>
                </div>
                <div class="stats-label">Total Complaints</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card">
                <div class="stats-number text-warning">
                    <%= pendingCount %>
                </div>
                <div class="stats-label">Pending</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card">
                <div class="stats-number text-info">
                    <%= inProgressCount %>
                </div>
                <div class="stats-label">In Progress</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="stats-card">
                <div class="stats-number text-success">
                    <%= resolvedCount %>
                </div>
                <div class="stats-label">Resolved</div>
            </div>
        </div>
    </div>

    <div class="main-card">
        <div class="card-header-custom">
            <h5 class="mb-0">
                <i class="bi bi-list-ul"></i> System Complaints Management
            </h5>
        </div>

        <div class="card-body p-0">
            <% if (complaints != null && !complaints.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-modern mb-0">
                    <thead>
                    <tr>
                        <th>Complaint Details</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted By</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Complaint c : complaints) {
                            String submittedById = c.getSubmittedBy();
                            String fullName;

                            if (userNameCache.containsKey(submittedById)) {
                                fullName = userNameCache.get(submittedById);
                            } else {
                                User submittedUser = userDAO.getUserById(submittedById);
                                fullName = submittedUser != null ? submittedUser.getFullName() : "Unknown User";
                                userNameCache.put(submittedById, fullName);
                            }
                    %>
                    <tr>
                        <td>
                            <div>
                                <strong><%= c.getTitle() %></strong>
                                <% if (c.getDescription() != null && c.getDescription().length() > 60) { %>
                                <br><small class="text-muted"><%= c.getDescription().substring(0, 60) %>...</small>
                                <% } else if (c.getDescription() != null) { %>
                                <br><small class="text-muted"><%= c.getDescription() %></small>
                                <% } %>
                            </div>
                        </td>
                        <td>
                                    <span class="badge bg-secondary">
                                        <%= c.getCategory() != null ? c.getCategory() : "General" %>
                                    </span>
                        </td>
                        <td>
                                    <span class="badge bg-<%= c.getPriority().equalsIgnoreCase("HIGH") ? "danger" :
                                        c.getPriority().equalsIgnoreCase("MEDIUM") ? "warning" :
                                        c.getPriority().equalsIgnoreCase("URGENT") ? "dark" : "secondary" %>">
                                        <%= c.getPriority() %>
                                    </span>
                        </td>
                        <td>
                                    <span class="badge bg-<%= c.getStatus().equalsIgnoreCase("RESOLVED") ? "success" :
                                        c.getStatus().equalsIgnoreCase("IN_PROGRESS") ? "info" :
                                        c.getStatus().equalsIgnoreCase("CLOSED") ? "secondary" : "warning" %>">
                                        <%= c.getStatus().replace("_", " ") %>
                                    </span>
                        </td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="user-avatar me-2" style="width: 25px; height: 25px; font-size: 0.8rem;">
                                    <%= fullName.substring(0, 1).toUpperCase() %>
                                </div>
                                <%= fullName %>
                            </div>
                        </td>
                        <td>
                            <small><%= new SimpleDateFormat("MMM dd, yyyy").format(c.getCreatedAt()) %></small>
                            <br><small class="text-muted"><%= new SimpleDateFormat("HH:mm").format(c.getCreatedAt()) %></small>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn btn-primary btn-sm btn-modern"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editModal"
                                        onclick="openEditModal('<%= c.getComplaintId() %>', '<%= c.getTitle().replace("'", "\\'") %>', '<%= c.getDescription() != null ? c.getDescription().replace("'", "\\'").replace("\n", "\\n") : "" %>', '<%= c.getCategory() %>', '<%= c.getPriority() %>', '<%= c.getStatus() %>', '<%= c.getAdminRemarks() != null ? c.getAdminRemarks().replace("'", "\\'").replace("\n", "\\n") : "" %>')"
                                        title="Edit Complaint">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-danger btn-sm btn-modern"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        onclick="openDeleteModal('<%= c.getComplaintId() %>', '<%= c.getTitle().replace("'", "\\'") %>', '<%= fullName %>')"
                                        title="Delete Complaint">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <h5>No complaints found</h5>
                <p class="text-muted">System complaints will appear here when users submit them.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">
                    <i class="bi bi-pencil-square"></i> Edit Complaint
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="admin-edit-complaint" method="post" id="editForm">
                <div class="modal-body">
                    <input type="hidden" name="complaintId" id="editComplaintId">

                    <div class="complaint-info">
                        <h6><i class="bi bi-info-circle"></i> Complaint Information</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="editTitle" class="form-label">Title</label>
                                <input type="text" class="form-control" id="editTitle" name="title" readonly>
                            </div>
                            <div class="col-md-6">
                                <label for="editCategory" class="form-label">Category</label>
                                <input type="text" class="form-control" id="editCategory" name="category" readonly>
                            </div>
                        </div>
                        <div class="mt-3">
                            <label for="editDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" readonly></textarea>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <label for="editStatus" class="form-label">Status *</label>
                            <select class="form-select" id="editStatus" name="status" required>
                                <option value="PENDING">Pending</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="RESOLVED">Resolved</option>
                                <option value="CLOSED">Closed</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="editPriority" class="form-label">Priority</label>
                            <input type="text" class="form-control" id="editPriority" name="priority" readonly>
                        </div>
                    </div>

                    <div class="mt-3">
                        <label for="editAdminRemark" class="form-label">Admin Remarks</label>
                        <textarea class="form-control" id="editAdminRemark" name="adminRemark" rows="4"
                                  placeholder="Add your remarks about this complaint..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary btn-modern">
                        <i class="bi bi-check-circle"></i> Update Complaint
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>


<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger">
                <h5 class="modal-title text-white" id="deleteModalLabel">
                    <i class="bi bi-exclamation-triangle"></i> Delete Complaint
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="delete-complaint" method="post" id="deleteForm">
                <div class="modal-body">
                    <input type="hidden" name="complaintId" id="deleteComplaintId">

                    <div class="delete-warning">
                        <i class="bi bi-exclamation-triangle"></i>
                        <strong>Warning:</strong> This action cannot be undone!
                    </div>

                    <p>Are you sure you want to delete this complaint?</p>

                    <div class="complaint-info">
                        <strong>Title:</strong> <span id="deleteTitle"></span><br>
                        <strong>Submitted by:</strong> <span id="deleteSubmittedBy"></span>
                    </div>

                    <p class="text-muted mt-3">
                        <i class="bi bi-info-circle"></i>
                        This will permanently remove the complaint from the system.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-danger btn-modern">
                        <i class="bi bi-trash"></i> Delete Complaint
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/admin-dashboard.js"></script>

</body>
</html>
