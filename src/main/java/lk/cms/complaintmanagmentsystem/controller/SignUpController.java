package lk.cms.complaintmanagmentsystem.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.dbcp2.BasicDataSource;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

@WebServlet(name = "signup", value = "/signup")
public class SignUpController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("text/html");

        ServletContext context = request.getServletContext();
        BasicDataSource dataSource = (BasicDataSource) context.getAttribute("ds");

        System.out.println(request);

        try {
            Connection connection = dataSource.getConnection();
            PreparedStatement ps = connection.prepareStatement("INSERT INTO users (user_id,username,password,full_name,email,role,is_active) VALUES (?,?,?,?,?,?,?)");
            ps.setString(1, UUID.randomUUID().toString());
            ps.setString(2, request.getParameter("username"));
            ps.setString(3, request.getParameter("password"));
            ps.setString(4, request.getParameter("full_name"));
            ps.setString(5, request.getParameter("email"));
            ps.setString(6, request.getParameter("role"));
            ps.setBoolean(7, true);
            int executed =  ps.executeUpdate();
            if (executed > 0) {
                response.sendRedirect(request.getContextPath() + "pages/signup.jsp?User registered successfully");
            }else {
                response.getWriter().println("User registration failed");
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }
}
