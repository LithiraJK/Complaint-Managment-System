<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");

    if (user == null || !"EMPLOYEE".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");

    int totalComplaints = complaints != null ? complaints.size() : 0;
    int pendingCount = 0;
    int inProgressCount = 0;
    int resolvedCount = 0;

    if (complaints != null) {
        for (Complaint c : complaints) {
            String status = c.getStatus().toUpperCase();
            switch (status) {
                case "PENDING":
                    pendingCount++;
                    break;
                case "IN_PROGRESS":
                    inProgressCount++;
                    break;
                case "RESOLVED":
                    resolvedCount++;
                    break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard - Municipal CMS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/employee-dashboard.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <i class="bi bi-building"></i> Municipal CMS
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

<div class="container-fluid p-4">
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center">
                <div class="mb-3 mb-md-0">
                    <h2 class="fw-bold">Welcome, <%= user.getFullName() %>!</h2>
                    <p class="text-muted">Manage your complaints</p>
                </div>
                <button class="btn btn-success btn-modern" data-bs-toggle="modal" data-bs-target="#newComplaintModal">
                    <i class="bi bi-plus-circle"></i> New Complaint
                </button>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-6 col-md-3">
            <div class="stats-card">
                <div class="stats-number text-primary"><%= totalComplaints %></div>
                <div class="stats-label">Total</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stats-card">
                <div class="stats-number text-warning"><%= pendingCount %></div>
                <div class="stats-label">Pending</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stats-card">
                <div class="stats-number text-info"><%= inProgressCount %></div>
                <div class="stats-label">In Progress</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stats-card">
                <div class="stats-number text-success"><%= resolvedCount %></div>
                <div class="stats-label">Resolved</div>
            </div>
        </div>
    </div>

    <div class="main-card">
        <div class="card-header-custom">
            <h5 class="mb-0"><i class="bi bi-list-ul"></i> Your Complaints</h5>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-modern table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th class="d-none d-md-table-cell">Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th class="d-none d-lg-table-cell">Description</th>
                        <th class="d-none d-md-table-cell">Created</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (complaints != null && !complaints.isEmpty()) {
                            for (Complaint c : complaints) {
                                boolean disabled = c.getStatus().equalsIgnoreCase("RESOLVED") || c.getStatus().equalsIgnoreCase("CLOSED");
                    %>
                    <tr>
                        <td>
                            <strong><%= c.getTitle() %></strong>
                            <div class="d-md-none">
                                <small class="text-muted"><%= c.getCategory() %></small>
                            </div>
                        </td>
                        <td class="d-none d-md-table-cell"><%= c.getCategory() %></td>
                        <td>
                                <span class="badge bg-<%= c.getPriority().equalsIgnoreCase("HIGH") ? "danger" : c.getPriority().equalsIgnoreCase("MEDIUM") ? "warning text-dark" : c.getPriority().equalsIgnoreCase("URGENT") ? "dark" : "secondary" %>">
                                    <%= c.getPriority() %>
                                </span>
                        </td>
                        <td>
                                <span class="badge bg-<%= c.getStatus().equalsIgnoreCase("RESOLVED") ? "success" : c.getStatus().equalsIgnoreCase("IN_PROGRESS") ? "info" : c.getStatus().equalsIgnoreCase("CLOSED") ? "secondary" : "warning" %>">
                                    <%= c.getStatus() %>
                                </span>
                        </td>
                        <td class="d-none d-lg-table-cell">
                            <%= c.getDescription().length() > 50 ? c.getDescription().substring(0, 50) + "..." : c.getDescription() %>
                        </td>
                        <td class="d-none d-md-table-cell"><%= c.getCreatedAt() %></td>
                        <td>
                            <div class="d-flex gap-1">
                                <button class="btn btn-sm btn-primary"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editModal"
                                        data-complaint-id="<%= c.getComplaintId() %>"
                                        data-complaint-title="<%= c.getTitle() %>"
                                        data-complaint-description="<%= c.getDescription() %>"
                                        data-complaint-category="<%= c.getCategory() %>"
                                        data-complaint-priority="<%= c.getPriority() %>"
                                        <%= disabled ? "disabled" : "" %>>
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-sm btn-danger"
                                        data-bs-toggle="modal"
                                        data-bs-target="#deleteModal"
                                        data-complaint-id="<%= c.getComplaintId() %>"
                                        data-complaint-title="<%= c.getTitle() %>"
                                        <%= disabled ? "disabled" : "" %>>
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center py-4">
                            <i class="bi bi-inbox display-4 text-muted"></i>
                            <p class="text-muted mt-2">No complaints found.</p>
                            <button class="btn btn-success btn-modern" data-bs-toggle="modal" data-bs-target="#newComplaintModal">
                                <i class="bi bi-plus-circle"></i> Submit Your First Complaint
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="newComplaintModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Submit New Complaint</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/employee-dashboard">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Title *</label>
                        <input type="text" name="title" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description *</label>
                        <textarea name="description" rows="4" class="form-control" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Category *</label>
                            <select name="category" class="form-select" required>
                                <option value="">Select Category</option>
                                <option value="Infrastructure">Infrastructure</option>
                                <option value="Roads">Roads</option>
                                <option value="Water">Water</option>
                                <option value="Electricity">Electricity</option>
                                <option value="Waste Management">Waste Management</option>
                                <option value="Noise">Noise</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Priority *</label>
                            <select name="priority" class="form-select" required>
                                <option value="LOW">Low</option>
                                <option value="MEDIUM" selected>Medium</option>
                                <option value="HIGH">High</option>
                                <option value="URGENT">Urgent</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Submit Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Edit Complaint</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/edit-complaint">
                <div class="modal-body">
                    <input type="hidden" name="complaintId" id="editComplaintId">
                    <div class="complaint-info">
                        <h6><i class="bi bi-info-circle"></i> Complaint Information</h6>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editTitle" class="form-label">Title *</label>
                                <input type="text" class="form-control" id="editTitle" name="title" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editCategory" class="form-label">Category *</label>
                                <select name="category" class="form-select" id="editCategory" required>
                                    <option value="Infrastructure">Infrastructure</option>
                                    <option value="Roads">Roads</option>
                                    <option value="Water">Water</option>
                                    <option value="Electricity">Electricity</option>
                                    <option value="Waste Management">Waste Management</option>
                                    <option value="Noise">Noise</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Description *</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="editPriority" class="form-label">Priority</label>
                            <select name="priority" class="form-select" id="editPriority" required>
                                <option value="LOW">Low</option>
                                <option value="MEDIUM">Medium</option>
                                <option value="HIGH">High</option>
                                <option value="URGENT">Urgent</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="bi bi-exclamation-triangle"></i> Confirm Delete</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this complaint?</p>
                <p><strong>Title:</strong> <span id="deleteComplaintTitle"></span></p>
                <div class="alert alert-warning">
                    <strong>Warning:</strong> This action cannot be undone.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <form action="delete-complaint" method="post" style="display: inline;">
                    <input type="hidden" name="complaintId" id="deleteComplaintId">
                    <button type="submit" class="btn btn-danger">Delete Complaint</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="js/employee-dashboard.js"></script>
<script>

</script>
</body>
</html>
