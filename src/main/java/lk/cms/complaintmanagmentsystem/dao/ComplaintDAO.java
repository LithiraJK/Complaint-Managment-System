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
                "submitted_by, assigned_to, admin_remarks, created_at, updated_at" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection connection = dataSource.getConnection();
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, complaint.getComplaintId());
        ps.setString(2, complaint.getTitle());
        ps.setString(3, complaint.getDescription());
        ps.setString(4, complaint.getCategory());
        ps.setString(5, complaint.getPriority());
        ps.setString(6, complaint.getStatus());
        ps.setString(7, complaint.getSubmittedBy());
        ps.setString(8, complaint.getAssignedTo());
        ps.setString(9, complaint.getAdminRemarks());
        ps.setTimestamp(10, complaint.getCreatedAt());
        ps.setTimestamp(11, complaint.getUpdatedAt());

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
                        rs.getString("assigned_to"),
                        rs.getString("admin_remarks"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(complaint);
            }
        }
        return list;
    }



}
