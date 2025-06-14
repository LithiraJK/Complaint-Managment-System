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

<h2>Your Complaints</h2>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Category</th>
        <th>Priority</th>
        <th>Status</th>
        <th>Created At</th>
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
        <td><%= c.getCreatedAt() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr><td colspan="6">No complaints found.</td></tr>
    <%
        }
    %>
</table>
<p>
    <a href="submit-complaint.jsp">Submit a New Complaint</a>
</p>
