<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Complaint - Admin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(45deg, #2575fc,#6a11cb);
            color: white;
            min-height: 100vh;
        }
        .sidebar .profile {
            text-align: center;
            margin: 30px 0;
        }
        .sidebar .profile img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
        }
        .card-box {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar d-flex flex-column align-items-center">
            <h3>CMS</h3>
            <div class="profile">
                <h5 class="mt-2"><%= user.getFullName() %></h5>
                <p>[Admin]</p>
            </div>
        </div>

        <div class="col-md-10 p-4">
            <div class="card-box">
                <h4 class="mb-4">Edit Complaint</h4>

                <form action="${pageContext.request.contextPath}/admin-edit-complaint" method="post">
                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" class="form-control" value="<%= complaint.getTitle() %>" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" rows="4" readonly><%= complaint.getDescription() %></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
                            <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
                            <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>RESOLVED</option>
                            <option value="CLOSED" <%= "CLOSED".equals(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Admin Remark</label>
                        <textarea name="adminRemark" rows="4" class="form-control"><%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary">Update Complaint</button>
                    <a href="admin-dashboard" class="btn btn-secondary ms-2">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
