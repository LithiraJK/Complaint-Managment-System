package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lk.cms.complaintmanagmentsystem.dao.ComplaintDAO;
import lk.cms.complaintmanagmentsystem.model.Complaint;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;

@WebServlet("/admin-edit-complaint")
public class AdminEditComplaintServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession httpSession = req.getSession(false);
        User user = (User) httpSession.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String complaintId = req.getParameter("complaintId");
        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);

        try {
            Complaint complaint = dao.getComplaintById(complaintId);
            req.setAttribute("complaint", complaint);
            req.getRequestDispatcher("pages/admin-edit-complaint.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect("signin.jsp");
            return;
        }

        String complaintId = req.getParameter("complaintId");
        String status = req.getParameter("status");
        String adminRemark = req.getParameter("adminRemark");

        BasicDataSource ds = (BasicDataSource) getServletContext().getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);

        try {
            boolean updated = dao.updateComplaintByAdmin(complaintId, status, adminRemark);
            if (!updated) {
                req.setAttribute("msg", "Update failed.");
                req.getRequestDispatcher("pages/admin-edit-complaint.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect("admin-dashboard");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
