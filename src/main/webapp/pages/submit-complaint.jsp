<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");

    if (user == null || !"EMPLOYEE".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Complaint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background: linear-gradient(45deg, #1870f3, #022b51);
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
            <div class="card-box">
                <h3 class="mb-4">Submit a Complaint</h3>

                <form method="post" action="${pageContext.request.contextPath}/employee-dashboard">
                    <div class="mb-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea name="description" rows="4" class="form-control" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <input type="text" name="category" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Priority</label>
                        <select name="priority" class="form-select" required>
                            <option value="LOW">Low</option>
                            <option value="MEDIUM" selected>Medium</option>
                            <option value="HIGH">High</option>
                            <option value="URGENT">Urgent</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Submit</button>
                    <a href="${pageContext.request.contextPath}/employee-dashboard" type="button" class="btn btn-secondary"> Cancel</a>

                </form>

                <p class="text-success mt-3">
                    <%= request.getAttribute("msg") != null ? request.getAttribute("msg") : "" %>
                </p>

            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
