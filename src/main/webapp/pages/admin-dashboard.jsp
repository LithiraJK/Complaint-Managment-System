<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");

    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    String today = new SimpleDateFormat("EEE, MMMM d").format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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
                <p>[Administrator]</p>
            </div>
        </div>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2>Welcome back, <%= user.getFullName() %></h2>
                    <p><%= today %></p>
                </div>
                <div>
                    <a href="pages/logout.jsp" class="btn btn-outline-danger" onclick="return confirm('Are you sure Do you want to LogOut?')">Logout</a>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="card-box">Total Complaints: <%= complaints != null ? complaints.size() : 0 %></div>
                </div>
                <div class="col-md-4">
                    <div class="card-box">Resolved:  </div>
                </div>
                <div class="col-md-4">
                    <div class="card-box">Pending:  </div>
                </div>
            </div>

            <div class="card-box">
                <h5>All Complaints</h5>
                <table class="table table-bordered table-striped">
                    <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted By</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (complaints != null && !complaints.isEmpty()) {
                            for (Complaint c : complaints) {
                    %>
                    <tr>
                        <td><%= c.getComplaintId() %></td>
                        <td><%= c.getTitle() %></td>
                        <td><%= c.getPriority() %></td>
                        <td><%= c.getStatus() %></td>
                        <td><%= c.getSubmittedBy() %></td>
                        <td>
                            <form action="admin-edit-complaint" method="get" style="display:inline-block">
                                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                <button class="btn btn-sm btn-primary">Edit</button>
                            </form>
                            <form action="delete-complaint" method="post" style="display:inline-block" onsubmit="return confirm('Delete this complaint?');">
                                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                <button class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr><td colspan="7">No complaints found.</td></tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
