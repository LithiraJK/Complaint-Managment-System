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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(45deg, #2575fc, #6a11cb);
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
            border: 3px solid white;
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
                <p>[Employee]</p>
            </div>
        </div>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Your Complaints</h2>
                <a href="pages/submit-complaint.jsp" class="btn btn-success">+ New Complaint</a>
            </div>


            <div class="card-box">
                <h5 class="mb-3">Complaint History</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-primary">
                        <tr>
                            <th>ID</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created At</th>
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
                            <td><%= c.getComplaintId() %></td>
                            <td><%= c.getTitle() %></td>
                            <td><%= c.getCategory() %></td>
                            <td>
                                <span class="badge bg-<%= c.getPriority().equalsIgnoreCase("HIGH") ? "danger" : c.getPriority().equalsIgnoreCase("MEDIUM") ? "warning text-dark" : "secondary" %>">
                                    <%= c.getPriority() %>
                                </span>
                            </td>
                            <td><%= c.getStatus() %></td>
                            <td><%= c.getCreatedAt() %></td>
                            <td>
                                <div class="d-flex gap-2">
                                    <form action="edit-complaint" method="get">
                                        <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                        <button type="submit" class="btn btn-sm btn-primary" <%= disabled ? "disabled" : "" %>>Edit</button>
                                    </form>
                                    <form action="delete-complaint" method="post" onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                                        <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" <%= disabled ? "disabled" : "" %>>Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="7" class="text-center text-muted">No complaints found.</td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div>
                <a href="pages/logout.jsp" class="btn btn-danger" type="button">Logout</a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
