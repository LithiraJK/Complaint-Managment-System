package lk.cms.complaintmanagmentsystem.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Complaint {
    private String complaintId;
    private String title;
    private String description;
    private String category;
    private String priority;
    private String status;
    private String submittedBy;
    private String assignedTo;
    private String adminRemarks; //Admin Message
    private Timestamp createdAt;
    private Timestamp updatedAt;

}
