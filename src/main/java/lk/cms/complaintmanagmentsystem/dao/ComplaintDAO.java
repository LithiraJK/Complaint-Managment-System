package lk.cms.complaintmanagmentsystem.dao;

import lk.cms.complaintmanagmentsystem.model.Complaint;
import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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


}
