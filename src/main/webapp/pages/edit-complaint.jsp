<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    if (user == null || !"EMPLOYEE".equals(user.getRole())) {
        response.sendRedirect("signin.jsp");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
    if (complaint == null) {
        out.println("<p>Error: Complaint not found.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Complaint</title>
</head>
<body>
<h2>Edit Complaint</h2>

<form method="post" action="${pageContext.request.contextPath}/edit-complaint">
    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

    <label>Title:</label><br>
    <input type="text" name="title" value="<%= complaint.getTitle() %>" required><br><br>

    <label>Description:</label><br>
    <textarea name="description" rows="4" cols="50" required><%= complaint.getDescription() %></textarea><br><br>

    <label>Category:</label><br>
    <input type="text" name="category" value="<%= complaint.getCategory() %>" required><br><br>

    <label>Priority:</label><br>
    <select name="priority" required>
        <option value="LOW" <%= complaint.getPriority().equals("LOW") ? "selected" : "" %>>Low</option>
        <option value="MEDIUM" <%= complaint.getPriority().equals("MEDIUM") ? "selected" : "" %>>Medium</option>
        <option value="HIGH" <%= complaint.getPriority().equals("HIGH") ? "selected" : "" %>>High</option>
        <option value="URGENT" <%= complaint.getPriority().equals("URGENT") ? "selected" : "" %>>Urgent</option>
    </select><br><br>

    <button type="submit">Update Complaint</button>
</form>

<p style="color:green;">
    <%= request.getAttribute("msg") != null ? request.getAttribute("msg") : "" %>
</p>

<p><a href="employee-dashboard.jsp">Back to Dashboard</a></p>
</body>
</html>
