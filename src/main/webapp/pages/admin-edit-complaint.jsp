<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.Complaint" %>
<%@ page import="lk.cms.complaintmanagmentsystem.model.User" %>
<%
    HttpSession httpSession = request.getSession(false);
    User user = (User) httpSession.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
%>

<h2>Update Complaint</h2>

<form action="${pageContext.request.contextPath}/admin-edit-complaint" method="post">
    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

    <p><strong>Title:</strong> <%= complaint.getTitle() %></p>
    <p><strong>Description:</strong> <%= complaint.getDescription() %></p>

    <label>Status:</label><br>
    <select name="status">
        <option value="PENDING" <%= "PENDING".equals(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
        <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(complaint.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
        <option value="RESOLVED" <%= "RESOLVED".equals(complaint.getStatus()) ? "selected" : "" %>>RESOLVED</option>
        <option value="CLOSED" <%= "CLOSED".equals(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
    </select><br><br>

    <label>Admin Remark:</label><br>
    <textarea name="adminRemark" rows="4" cols="50"><%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "" %></textarea><br><br>

    <button type="submit">Update Complaint</button>
</form>

<p><a href="admin-dashboard">← Back to Dashboard</a></p>
