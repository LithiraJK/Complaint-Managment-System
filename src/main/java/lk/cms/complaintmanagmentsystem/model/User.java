package lk.cms.complaintmanagmentsystem.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class User {
    private String userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role; // 'EMPLOYEE' or 'ADMIN'
    private Timestamp createdAt;
    private boolean isActive;


}
