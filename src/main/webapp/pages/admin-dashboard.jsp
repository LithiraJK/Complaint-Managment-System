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
    if (complaints != null) {
        for (Complaint c : complaints) {
            if ("RESOLVED".equalsIgnoreCase(c.getStatus())) {
                resolvedCount++;
            } else if ("PENDING".equalsIgnoreCase(c.getStatus())) {
                pendingCount++;
            }
        }
    }

    Map<String, String> userNameCache = new HashMap<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        }
        .card-box {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        .table thead th{
            background: linear-gradient(30deg, #022b51, #2575fc);;
            color: white;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar d-flex flex-column align-items-center">
            <h3 class="mt-4">CMS</h3>
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
                    <a href="pages/logout.jsp" class="btn btn-outline-danger" onclick="return confirm('Are you sure you want to log out?')">Logout</a>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                    <div class="card-box">Total Complaints: <%= complaints != null ? complaints.size() : 0 %></div>
                </div>
                <div class="col-md-4">
                    <div class="card-box">Resolved: <%= resolvedCount %></div>
                </div>
                <div class="col-md-4">
                    <div class="card-box">Pending: <%= pendingCount %></div>
                </div>
            </div>

            <div class="card-box">
                <h5>All Complaints</h5>
                <table class="table table-bordered table-striped">
                    <thead>
                    <tr>
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
                                String submittedById = c.getSubmittedBy();
                                String fullName;

                                if (userNameCache.containsKey(submittedById)) {
                                    fullName = userNameCache.get(submittedById);
                                    System.out.println(fullName);
                                } else {
                                    User submittedUser = userDAO.getUserById(submittedById);
                                    fullName = submittedUser != null ? submittedUser.getFullName() : "Unknown";
                                    userNameCache.put(submittedById, fullName);
                                }
                    %>
                    <tr>
                        <td><%= c.getTitle() %></td>
                        <td>
                            <span class="badge bg-<%= c.getPriority().equalsIgnoreCase("HIGH") ? "danger" : c.getPriority().equalsIgnoreCase("MEDIUM") ? "warning text-dark" : "secondary" %>">
                                <%= c.getPriority() %>
                            </span>
                        </td>
                        <td><%= c.getStatus() %></td>
                        <td><%= fullName %></td>
                        <td>
                            <form action="admin-edit-complaint" method="get" style="display:inline-block">
                                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                <button class="btn btn-sm btn-success">Edit</button>
                            </form>
                            <form action="delete-complaint" method="post" style="display:inline-block" onclick="return confirm('Delete this complaint?');">
                                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                                <button class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" class="text-center">No complaints found.</td>
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
</body>
</html>
