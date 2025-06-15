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
        <th>Actions</th>
    </tr>

    <%
        if (complaints != null && !complaints.isEmpty()) {
            for (Complaint c : complaints) {
                boolean disabled = c.getStatus().equals("RESOLVED") || c.getStatus().equals("CLOSED");
    %>
    <tr>
        <td><%= c.getComplaintId() %></td>
        <td><%= c.getTitle() %></td>
        <td><%= c.getCategory() %></td>
        <td><%= c.getPriority() %></td>
        <td><%= c.getStatus() %></td>
        <td><%= c.getCreatedAt() %></td>
        <td>
            <form action="edit-complaint" method="get" style="display:inline;">
                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                <button type="submit" <%= disabled ? "disabled" : "" %>>Edit</button>
            </form>

            <form action="delete-complaint" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                <input type="hidden" name="complaintId" value="<%= c.getComplaintId() %>">
                <button type="submit" <%= disabled ? "disabled" : "" %>>Delete</button>
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
</table>

<p>
    <a href="submit-complaint.jsp">Submit a New Complaint</a>
</p>
