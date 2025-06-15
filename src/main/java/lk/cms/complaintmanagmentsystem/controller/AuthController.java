package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.cms.complaintmanagmentsystem.dao.UserDAO;
import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/auth")
public class AuthController  extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String action = req.getParameter("action");

        ServletContext context = req.getServletContext();
        BasicDataSource ds = (BasicDataSource) context.getAttribute("ds");

        UserDAO userDAO = new UserDAO(ds);

        try {
            if (action.equals("signup")) {
                User user = new User(
                        UUID.randomUUID().toString(),
                        req.getParameter("username"),
                        req.getParameter("password"),
                        req.getParameter("full_name"),
                        req.getParameter("email"),
                        req.getParameter("role"),
                        new Timestamp(System.currentTimeMillis()),
                        true
                );
                boolean saved = userDAO.saveUser(user);
                req.setAttribute("msg", saved ? "Sign up successful!" : "Sign up failed!");
                req.getRequestDispatcher("pages/signin.jsp").forward(req, resp);

            }else if (action.equals("signin")) {
            User user = userDAO.authenticate(
                    req.getParameter("username"),
                    req.getParameter("password")
            );

                if (user != null) {
                    req.getSession().setAttribute("user", user);
                    resp.sendRedirect( (user.getRole().equals("ADMIN") ? "admin-dashboard" : "employee-dashboard"));
                } else {
                    req.setAttribute("error", "Invalid credentials or inactive account.");
                    req.getRequestDispatcher("pages/signin.jsp").forward(req, resp);
                }
            }

        }catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("pages/signin.jsp").forward(req, resp);
        }






    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    }
}
