package com.clinic.config;

import com.clinic.util.DBConnection;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.*;

@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Create Core Tables
            stmt.execute("CREATE TABLE IF NOT EXISTS users (id INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(50) UNIQUE, password VARCHAR(255), role VARCHAR(20), full_name VARCHAR(100), profile_image VARCHAR(255) DEFAULT 'default_avatar.png')");
            stmt.execute("CREATE TABLE IF NOT EXISTS patients (id INT PRIMARY KEY, name VARCHAR(100), phone VARCHAR(20), address TEXT, age INT, gender VARCHAR(10))");
            stmt.execute("CREATE TABLE IF NOT EXISTS treatmentdetails (id INT PRIMARY KEY AUTO_INCREMENT, treatment_name VARCHAR(100), price DECIMAL(10,2))");
            
            // Create Appointments with proper columns
            stmt.execute("CREATE TABLE IF NOT EXISTS appointments (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT, patient_id INT, dentist_id INT, " +
                    "appointment_date DATETIME, status VARCHAR(20) DEFAULT 'PENDING', " +
                    "treatment_type VARCHAR(100), clinical_notes TEXT, prescribed_medicines TEXT)");

            stmt.execute("CREATE TABLE IF NOT EXISTS system_logs (id INT PRIMARY KEY AUTO_INCREMENT, user_id INT, action VARCHAR(255), log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            stmt.execute("CREATE TABLE IF NOT EXISTS password_requests (id INT PRIMARY KEY AUTO_INCREMENT, username VARCHAR(50), reason TEXT, status VARCHAR(20) DEFAULT 'PENDING', request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            stmt.execute("CREATE TABLE IF NOT EXISTS dentist_unavailability (id INT PRIMARY KEY AUTO_INCREMENT, dentist_id INT, unavailable_date DATE, reason VARCHAR(255))");
            stmt.execute("CREATE TABLE IF NOT EXISTS doctor_profiles (user_id INT PRIMARY KEY, license_number VARCHAR(50), specialization VARCHAR(100), experience INT)");
            stmt.execute("CREATE TABLE IF NOT EXISTS bills (id INT PRIMARY KEY AUTO_INCREMENT, appointment_id INT, amount DECIMAL(10,2), qr_code VARCHAR(255), bill_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            // AUTO-FIX: Add missing columns if tables already existed
            DatabaseMetaData md = conn.getMetaData();
            ResultSet rs = md.getColumns(null, null, "appointments", "clinical_notes");
            if (!rs.next()) {
                stmt.execute("ALTER TABLE appointments ADD COLUMN clinical_notes TEXT");
                stmt.execute("ALTER TABLE appointments ADD COLUMN prescribed_medicines TEXT");
            }
            ResultSet rsP = md.getColumns(null, null, "patients", "age");
            if (!rsP.next()) {
                stmt.execute("ALTER TABLE patients ADD COLUMN age INT");
                stmt.execute("ALTER TABLE patients ADD COLUMN gender VARCHAR(10)");
            }

            ResultSet rsPR = md.getColumns(null, null, "password_requests", "request_time");
            if (!rsPR.next()) {
                stmt.execute("ALTER TABLE password_requests ADD COLUMN request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP");
            }

            // Seed Admin if empty
            ResultSet userCheck = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if (userCheck.next() && userCheck.getInt(1) == 0) {
                stmt.execute("INSERT INTO users (username, password, role, full_name) VALUES ('admin', 'admin123', 'ADMIN', 'System Administrator')");
            }
            
            // Seed Treatments if empty
            ResultSet treatCheck = stmt.executeQuery("SELECT COUNT(*) FROM treatmentdetails");
            if (treatCheck.next() && treatCheck.getInt(1) == 0) {
                stmt.execute("INSERT INTO treatmentdetails (treatment_name, price) VALUES " +
                        "('Consultation', 1500.00), ('Prophylaxis (Cleaning)', 2500.00), " +
                        "('Endodontic Therapy', 15000.00), ('Surgical Extraction', 8000.00)");
            }

        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override public void contextDestroyed(ServletContextEvent sce) {}
}
