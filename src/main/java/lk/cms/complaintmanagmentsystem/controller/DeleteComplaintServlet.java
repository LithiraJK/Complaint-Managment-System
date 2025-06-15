package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.cms.complaintmanagmentsystem.dao.ComplaintDAO;
import lk.cms.complaintmanagmentsystem.model.Complaint;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

@WebServlet("/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("signin.jsp");
            return;
        }

        String id = req.getParameter("complaintId");
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);

        try {
            Complaint complaint = dao.getComplaintById(id);

            if (complaint == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found.");
                return;
            }

            if ("EMPLOYEE".equals(user.getRole())) {
                if (!complaint.getSubmittedBy().equals(user.getUserId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only delete your own complaints.");
                    return;
                }

                if (complaint.getStatus().equals("RESOLVED") || complaint.getStatus().equals("CLOSED")) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot delete resolved or closed complaints.");
                    return;
                }
            }

            boolean isDeleted = dao.deleteComplaintById(id);

            if (isDeleted) {
                if ("ADMIN".equals(user.getRole())) {
                    resp.sendRedirect("admin-dashboard");
                } else {
                    resp.sendRedirect("employee-dashboard");
                }
            } else {
                req.setAttribute("msg", "Delete failed.");
                String path = "ADMIN".equals(user.getRole()) ? "pages/admin-dashboard.jsp" : "pages/employee-dashboard.jsp";
                req.getRequestDispatcher(path).forward(req, resp);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
