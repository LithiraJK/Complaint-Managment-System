package lk.cms.complaintmanagmentsystem.dao;

import lk.cms.complaintmanagmentsystem.model.User;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class UserDAO {
    private BasicDataSource dataSource;

    public UserDAO(BasicDataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean saveUser(User user) throws SQLException {
        Connection connection = dataSource.getConnection();
        PreparedStatement ps = connection.prepareStatement("INSERT INTO users (user_id,username,password,full_name,email,role,is_active) VALUES (?,?,?,?,?,?,?)");
        ps.setString(1, UUID.randomUUID().toString());
        ps.setString(2, user.getUsername());
        ps.setString(3, user.getPassword());
        ps.setString(4, user.getFullName());
        ps.setString(5, user.getEmail());
        ps.setString(6, user.getRole());
        ps.setBoolean(7, user.isActive());

        int executed =  ps.executeUpdate();
        return executed > 0;

    }

    public User authenticate(String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = TRUE";
        Connection connection = dataSource.getConnection();
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getString("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("role"),
                        rs.getTimestamp("created_at"),
                        rs.getBoolean("is_active")
                );
            }
        return null;
    }

    public User getUserById(String userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getString("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("User retrieved: " + user);
        return user;
    }

}
