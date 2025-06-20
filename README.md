# Complaint Management System (CMS)

## 📌 Project Overview

The **Complaint Management System (CMS)** is a web-based Java EE application developed as part of an individual, research-driven assignment. It allows internal employees and administrative staff of a municipal organization to **submit**, **track**, and **resolve complaints** in a structured manner.

This project was developed using **JavaServer Pages (JSP)**, **Jakarta EE (Servlets)**, and **MySQL**, strictly following synchronous, form-based HTTP interactions with session management and role-based access control.

---

## 🔧 Technologies Used

- **Frontend**: JSP, HTML, CSS, Bootstrap, JavaScript (for form validation only)
- **Backend**: Jakarta EE (Servlets), Apache Commons DBCP
- **Database**: MySQL
- **Deployment Server**: Apache Tomcat
- **Architecture**: Model-View-Controller (MVC)

---

## 🧩 System Features

### 🔐 Authentication Module
- User login using `username` and `password`
- Session management using `HttpSession`
- Role-based redirection for:
  - **Employees**
  - **Admins**

### 📝 Complaint Management Module

#### Employee Role:
- Create a new complaint using a standard HTML form
- View a list of personal complaints
- Edit or delete complaints *only if not resolved*

#### Admin Role:
- View all complaints submitted in the system
- Update complaint status (Pending, In Progress, Resolved)
- Add admin remarks
- Delete any complaint

---

## 🗂️ Folder Structure (MVC Pattern)

```
complaint-managment-system/
│
├── pom.xml
├── README.md
├── db/
│   └── schema.sql
├── src/
│   └── main/
│       ├── java/
│       │   └── lk/
│       │       └── cms/
│       │           └── complaintmanagmentsystem/
│       │               ├── controller/
│       │               │   ├── AdminEditComplaintServlet.java
│       │               │   ├── AdminServlet.java
│       │               │   ├── AuthController.java
│       │               │   ├── DeleteComplaintServlet.java
│       │               │   ├── EmployeeEditComplaintServlet.java
│       │               │   └── EmployeeServlet.java
│       │               ├── dao/
│       │               │   ├── ComplaintDAO.java
│       │               │   └── UserDAO.java
│       │               ├── model/
│       │               │   ├── Complaint.java
│       │               │   └── User.java
│       │               └── util/
���       │                   └── DataSource.java
│       ├── resources/
│       └── webapp/
│           ├── index.jsp
│           ├── assets/
│           │   └── images/
│           │       └── login-wallpaper.png
│           ├── css/
│           │   ├── admin-dashboard.css
│           │   └── employee-dashboard.css
│           ├── js/
│           │   ├── admin-dashboard.js
│           │   └── employee-dashboard.js
│           ├── pages/
│           │   ├── admin-dashboard.jsp
│           │   ├── employee-dashboard.jsp
│           │   ├── logout.jsp
│           │   ├── signin.jsp
│           │   └── signup.jsp
│           └── WEB-INF/
│               └── web.xml
│
├── src/test/
│   ├── java/
│   └── resources/
│
└── target/ (generated after build)
    └── ...
```

---

## ⚙️ Setup Instructions

1. **Clone the project** or download the source.
2. **Import into IntelliJ IDEA / Eclipse** as a Maven Dynamic Web Project.
3. Set up your **MySQL database** and run the `cms.sql` script to create tables.
4. Configure **Apache Tomcat server** (e.g., Tomcat 9).
5. Add your MySQL credentials in the **DBCP config** (`DBConnectionPool.java`).
6. Run the project on Tomcat and open it in your browser:  
   `http://localhost:8080/CMS`

---

## 📂 Database Schema (MySQL)

```sql
CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('EMPLOYEE', 'ADMIN') NOT NULL
);

CREATE TABLE complaints (
    complaint_id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    title VARCHAR(255),
    description TEXT,
    status ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED') DEFAULT 'PENDING',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
```

---

## 🚫 Restrictions (Assignment Requirements)

✅ All operations are synchronous using standard HTML `<form>`  
❌ No AJAX or asynchronous requests allowed  
✅ POST used for state-changing operations (create/update/delete)  
✅ GET used for read-only operations (list/view)  
✅ Secure session handling using `HttpSession`

---

## 👨‍🎓 Author

- **Name:** Lithira Jayanaka
- **Institute:** IJSE  
- **Batch:** GDSE 72  
- **Module:** Java Web Application Development (JSP & Jakarta EE)

---

## 📃 License

This project is submitted as an academic assignment and is not licensed for commercial use.

