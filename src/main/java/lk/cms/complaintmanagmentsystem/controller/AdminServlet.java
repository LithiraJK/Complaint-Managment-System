package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.cms.complaintmanagmentsystem.dao.ComplaintDAO;
import lk.cms.complaintmanagmentsystem.model.Complaint;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-dashboard")
public class AdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect("signin.jsp");
            return;
        }

        BasicDataSource ds = (BasicDataSource) req.getServletContext().getAttribute("ds");
        ComplaintDAO dao = new ComplaintDAO(ds);


        try {
            System.out.println("Complaints: " + dao.getAllComplaints().size()); //testing

            List<Complaint> allComplaints = dao.getAllComplaints();
            req.setAttribute("complaints", allComplaints);
            req.getRequestDispatcher("pages/admin-dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
