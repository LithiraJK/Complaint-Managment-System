package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.cms.complaintmanagmentsystem.dao.ComplaintDAO;
import lk.cms.complaintmanagmentsystem.model.Complaint;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/edit-complaint")
public class EmployeeEditComplaintServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("complaintId");

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            resp.sendRedirect("signin.jsp");
            return;
        }

        ServletContext context = req.getServletContext();
        BasicDataSource ds = (BasicDataSource) context.getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);

        try {
            Complaint complaint = dao.getComplaintById(id);

            if (complaint == null || !complaint.getSubmittedBy().equals(user.getUserId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
                return;
            }

            if (complaint.getStatus().equals("RESOLVED") || complaint.getStatus().equals("CLOSED")) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot edit closed/resolved complaints.");
                return;
            }

            req.setAttribute("complaint", complaint);
            req.getRequestDispatcher("pages/edit-complaint.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            resp.sendRedirect("signin.jsp");
            return;
        }

        String id = req.getParameter("complaintId");

        try {
            BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
            ComplaintDAO dao = new ComplaintDAO(ds);

            Complaint complaint = dao.getComplaintById(id);
            if (complaint == null || !complaint.getSubmittedBy().equals(user.getUserId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
                return;
            }

            if (complaint.getStatus().equals("RESOLVED") || complaint.getStatus().equals("CLOSED")) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot edit resolved/closed complaint.");
                return;
            }

            complaint.setTitle(req.getParameter("title"));
            complaint.setDescription(req.getParameter("description"));
            complaint.setCategory(req.getParameter("category"));
            complaint.setPriority(req.getParameter("priority"));
            complaint.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

            boolean updated = dao.updateComplaintByEmployee(complaint);

            if (updated) {
                resp.sendRedirect("employee-dashboard");
            } else {
                req.setAttribute("error", "Failed to update complaint.");
                resp.sendRedirect("employee-dashboard");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "An error occurred while updating the complaint: " + e.getMessage());
            resp.sendRedirect("employee-dashboard");
        }
    }
}