<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");

    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }

    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
<h2>Welcome, <%= user.getFullName() %> (Admin)</h2>
<h3>All Complaints</h3>

<table border="1" cellpadding="6" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Category</th>
        <th>Priority</th>
        <th>Status</th>
        <th>Submitted By</th>
        <th>Assigned To</th>
        <th>Created At</th>
        <th>Actions</th>
    </tr>

    <%
        if (complaints != null && !complaints.isEmpty()) {
            for (Complaint c : complaints) {
    %>
    <tr>
        <td><%= c.getComplaintId() %></td>
        <td><%= c.getTitle() %></td>
        <td><%= c.getCategory() %></td>
        <td><%= c.getPriority() %></td>
        <td><%= c.getStatus() %></td>
        <td><%= c.getSubmittedBy() %></td>
        <td><%= c.getCreatedAt() %></td>
        <td>
            <form action="admin-edit-complaint" method="get" style="display:inline;">
                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                <button type="submit">Edit</button>
            </form>

            <form action="delete-complaint" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                <button type="submit">Delete</button>
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="9">No complaints found.</td></tr>
    <%
        }
    %>
</table>
</body>
</html>
