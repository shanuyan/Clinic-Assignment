package com.clinic.config;

import com.clinic.util.DBConnection;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing Database...");
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create Users Table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "role ENUM('ADMIN', 'DENTIST', 'STAFF') NOT NULL, " +
                    "full_name VARCHAR(100), " +
                    "email VARCHAR(100))");

            // Create Doctor Profiles Table
            stmt.execute("CREATE TABLE IF NOT EXISTS doctor_profiles (" +
                    "user_id INT PRIMARY KEY, " +
                    "license_number VARCHAR(50), " +
                    "specialization VARCHAR(100), " +
                    "experience INT, " +
                    "photo_path VARCHAR(255), " +
                    "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)");

            // Create Patients Table
            stmt.execute("CREATE TABLE IF NOT EXISTS patients (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "name VARCHAR(100) NOT NULL, " +
                    "phone VARCHAR(20), " +
                    "address TEXT, " +
                    "reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // Create Appointments Table
            stmt.execute("CREATE TABLE IF NOT EXISTS appointments (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "patient_id INT, " +
                    "dentist_id INT, " +
                    "appointment_date DATETIME, " +
                    "status VARCHAR(20) DEFAULT 'PENDING', " +
                    "treatment_type VARCHAR(100), " +
                    "FOREIGN KEY (patient_id) REFERENCES patients(id), " +
                    "FOREIGN KEY (dentist_id) REFERENCES users(id))");

            // Create Treatment Details Table
            stmt.execute("CREATE TABLE IF NOT EXISTS treatmentdetails (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "treatment_name VARCHAR(100), " +
                    "price DECIMAL(10,2))");

            // Create Bills Table
            stmt.execute("CREATE TABLE IF NOT EXISTS bills (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "appointment_id INT, " +
                    "amount DECIMAL(10,2), " +
                    "bill_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "qr_code VARCHAR(255), " +
                    "FOREIGN KEY (appointment_id) REFERENCES appointments(id))");

            // Create System Logs Table
            stmt.execute("CREATE TABLE IF NOT EXISTS system_logs (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "user_id INT, " +
                    "action VARCHAR(255), " +
                    "log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // Create Password Recovery Requests Table
            stmt.execute("CREATE TABLE IF NOT EXISTS password_requests (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "username VARCHAR(50), " +
                    "reason TEXT, " +
                    "request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "status VARCHAR(20) DEFAULT 'PENDING')");

            // Create Dentist Unavailability Table
            stmt.execute("CREATE TABLE IF NOT EXISTS dentist_unavailability (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "dentist_id INT, " +
                    "unavailable_date DATE, " +
                    "reason VARCHAR(255), " +
                    "FOREIGN KEY (dentist_id) REFERENCES users(id) ON DELETE CASCADE)");

            // Seed Default Users if none exist
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if (rs.next() && rs.getInt(1) == 0) {
                stmt.execute("INSERT INTO users (username, password, role, full_name) VALUES " +
                        "('admin', 'admin123', 'ADMIN', 'System Admin'), " +
                        "('doctor1', 'doc123', 'DENTIST', 'Dr. Arul'), " +
                        "('staff1', 'staff123', 'STAFF', 'Receptionist Jane')");
                System.out.println("Default users seeded.");
            }

            System.out.println("Database tables created successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup resources if needed
    }
}
