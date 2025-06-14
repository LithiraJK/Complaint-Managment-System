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
<html>
<head>
    <title>Submit Complaint</title>
</head>
<body>
<h2>Submit a Complaint</h2>

<form method="post" action="${pageContext.request.contextPath}/complaint">
    <label>Title:</label><br>
    <input type="text" name="title" required><br><br>

    <label>Description:</label><br>
    <textarea name="description" rows="4" cols="50" required></textarea><br><br>

    <label>Category:</label><br>
    <input type="text" name="category" required><br><br>

    <label>Priority:</label><br>
    <select name="priority" required>
        <option value="LOW">Low</option>
        <option value="MEDIUM" selected>Medium</option>
        <option value="HIGH">High</option>
        <option value="URGENT">Urgent</option>
    </select><br><br>

    <button type="submit">Submit</button>
</form>

<p style="color:green;">
    <%= request.getAttribute("msg") != null ? request.getAttribute("msg") : "" %>
</p>

<p><a href="employee-dashboard.jsp">Back to Dashboard</a></p>
</body>
</html>
