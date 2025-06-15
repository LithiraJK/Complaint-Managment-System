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

        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String id = req.getParameter("complaintId");

        BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);

        try {
            Complaint complaint = dao.getComplaintById(id);

            if (complaint == null || !complaint.getSubmittedBy().equals(user.getUserId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized delete attempt.");
                return;
            }

            if (complaint.getStatus().equals("RESOLVED") || complaint.getStatus().equals("CLOSED")) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot delete resolved or closed complaints.");
                return;
            }

            boolean deleted = dao.deleteComplaintById(id);
            if (deleted) {
                resp.sendRedirect("employee-dashboard");
            } else {
                req.setAttribute("msg", "Delete failed.");
                req.getRequestDispatcher("pages/employee-dashboard.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
