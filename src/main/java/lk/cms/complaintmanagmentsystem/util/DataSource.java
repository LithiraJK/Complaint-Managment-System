package lk.cms.complaintmanagmentsystem.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.SQLException;

@WebListener
public class DataSource implements ServletContextListener {
    public void contextInitialized(ServletContextEvent sce) {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/cms");
        ds.setUsername("root");
        ds.setPassword("mysql");

        ds.setInitialSize(10);
        ds.setMaxTotal(10);

        ServletContext context = sce.getServletContext();
        context.setAttribute("ds", ds);

    }
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            ServletContext sc = sce.getServletContext();
            BasicDataSource ds = (BasicDataSource) sc.getAttribute("ds");
            ds.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

}
