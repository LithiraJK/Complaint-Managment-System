package lk.cms.complaintmanagmentsystem.dao;

import lk.cms.complaintmanagmentsystem.model.Complaint;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private  final BasicDataSource dataSource;

    public ComplaintDAO(BasicDataSource dataSource) {
        this.dataSource = dataSource;
    }

    public boolean addComplaint(Complaint complaint) throws SQLException {
        String sql = "INSERT INTO complaints (" +
                "complaint_id, title, description, category, priority, status, " +
                "submitted_by, admin_remarks, created_at, updated_at" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection connection = dataSource.getConnection();
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, complaint.getComplaintId());
        ps.setString(2, complaint.getTitle());
        ps.setString(3, complaint.getDescription());
        ps.setString(4, complaint.getCategory());
        ps.setString(5, complaint.getPriority());
        ps.setString(6, complaint.getStatus());
        ps.setString(7, complaint.getSubmittedBy());
        ps.setString(8, complaint.getAdminRemarks());
        ps.setTimestamp(9, complaint.getCreatedAt());
        ps.setTimestamp(10, complaint.getUpdatedAt());

        int executed = ps.executeUpdate();
        return executed > 0 ;

    }

    public List<Complaint> getComplaintsBySubmittedUser(String userId) throws SQLException {
        String sql = "SELECT * FROM complaints WHERE submitted_by = ? ORDER BY created_at DESC";
        List<Complaint> list = new ArrayList<>();

        try (Connection con = dataSource.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = new Complaint(
                        rs.getString("complaint_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("priority"),
                        rs.getString("status"),
                        rs.getString("submitted_by"),
                        rs.getString("admin_remarks"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(complaint);
            }
        }
        return list;
    }
    

    public boolean updateComplaintByEmployee(Complaint complaint) throws SQLException {
        String sql = "UPDATE complaints SET title=?, description=?, category=?, priority=?, updated_at=? WHERE complaint_id=?";

        try (
                Connection con = dataSource.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, complaint.getTitle());
                    ps.setString(2, complaint.getDescription());
                    ps.setString(3, complaint.getCategory());
                    ps.setString(4, complaint.getPriority());
                    ps.setTimestamp(5, complaint.getUpdatedAt());
                    ps.setString(6, complaint.getComplaintId());
                    return ps.executeUpdate() > 0;
        }
    }

    public Complaint getComplaintById(String id) throws SQLException {
        String sql = "SELECT * FROM complaints WHERE complaint_id = ?";
        try (Connection con = dataSource.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Complaint(
                        rs.getString("complaint_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("priority"),
                        rs.getString("status"),
                        rs.getString("submitted_by"),
                        rs.getString("admin_remarks"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
            }
        }
        return null;
    }

    public boolean deleteComplaintById(String id) {
        String sql = "DELETE FROM complaints WHERE complaint_id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, id);
                return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
                return false;
        }
    }

    public List<Complaint> getAllComplaints() throws SQLException {
        String sql = "SELECT * FROM complaints ORDER BY created_at DESC";
        List<Complaint> list = new ArrayList<>();

        try (Connection con = dataSource.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Complaint c = new Complaint(
                        rs.getString("complaint_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("category"),
                        rs.getString("priority"),
                        rs.getString("status"),
                        rs.getString("submitted_by"),
                        rs.getString("admin_remarks"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(c);
            }
        }

        return list;
    }

    public boolean updateComplaintByAdmin(String complaintId, String status, String adminRemark) {
        String sql = "UPDATE complaints SET status = ?, admin_remarks = ?, updated_at = CURRENT_TIMESTAMP WHERE complaint_id = ?";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, status);
                ps.setString(2, adminRemark);
                ps.setString(3, complaintId);
                return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
