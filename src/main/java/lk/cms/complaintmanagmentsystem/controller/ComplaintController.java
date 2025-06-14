package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lk.cms.complaintmanagmentsystem.dao.ComplaintDAO;
import lk.cms.complaintmanagmentsystem.model.Complaint;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/complaint")
public class ComplaintController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null || !"EMPLOYEE".equals(user.getRole())) {
            response.sendRedirect("pages/signin.jsp");
            return;
        }

        try {
            ServletContext context = request.getServletContext();
            BasicDataSource ds = (BasicDataSource) context.getAttribute("ds");

            ComplaintDAO complaintDAO = new ComplaintDAO(ds);

            Complaint complaint = new Complaint(
                    UUID.randomUUID().toString(),
                    request.getParameter("title"),
                    request.getParameter("description"),
                    request.getParameter("category"),
                    request.getParameter("priority"),
                    "PENDING", // default
                    user.getUserId(),
                    null, // assigned_to is null
                    null, // admin_remarks
                    new Timestamp(System.currentTimeMillis()),
                    new Timestamp(System.currentTimeMillis())
            );

            boolean isAdded = complaintDAO.addComplaint(complaint);
            if (isAdded) {
                request.setAttribute("msg", "Complaint submitted successfully!");
            } else {
                request.setAttribute("error", "Failed to submit complaint. Please try again.");
            }

            request.getRequestDispatcher("pages/employee-dashboard.jsp").forward(request, response);


        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("msg", "Server error: " + e.getMessage());
            request.getRequestDispatcher("pages/submit-complaint.jsp").forward(request, response);
        }


    }


}
