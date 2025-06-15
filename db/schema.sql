-- Complaint Management System Database Schema
CREATE DATABASE IF NOT EXISTS cms;
USE cms;

-- Users table for authentication
CREATE TABLE users (
    user_id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('EMPLOYEE', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Complaints table
CREATE TABLE complaints (
    complaint_id VARCHAR(255) PRIMARY KEY ,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') DEFAULT 'PENDING',
    submitted_by VARCHAR(255) NOT NULL,
    admin_remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, full_name, email, role) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKXIGAcPNi4jRdv2.JvqNMjO.K5W', 'System Administrator', 'admin@municipality.gov', 'ADMIN');
