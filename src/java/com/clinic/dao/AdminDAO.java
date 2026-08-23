package com.clinic.dao;

import com.clinic.util.DBConnection;
import com.clinic.model.User;
import com.clinic.model.PasswordRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT id, username, role, full_name, profile_image FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                users.add(new User(rs.getInt("id"), rs.getString("username"), 
                                   rs.getString("role"), rs.getString("full_name"),
                                   rs.getString("profile_image")));
            }
        }
        return users;
    }

    public List<User> getUsersByRole(String role) throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT id, username, role, full_name, profile_image FROM users WHERE role = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(new User(rs.getInt("id"), rs.getString("username"), 
                                   rs.getString("role"), rs.getString("full_name"),
                                   rs.getString("profile_image")));
            }
        }
        return users;
    }

    public void logAction(int userId, String action) {
        String query = "INSERT INTO system_logs (user_id, action) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public int createUser(String username, String password, String role, String fullName, String imagePath) throws SQLException {
        String query = "INSERT INTO users (username, password, role, full_name, profile_image) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ps.setString(4, fullName);
            ps.setString(5, (imagePath != null && !imagePath.isEmpty()) ? imagePath : "default_avatar.png");
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    public void createDoctorProfile(int userId, String license, String spec, int exp) throws SQLException {
        String query = "INSERT INTO doctor_profiles (user_id, license_number, specialization, experience) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, license);
            ps.setString(3, spec);
            ps.setInt(4, exp);
            ps.executeUpdate();
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String query = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<String> getRecentLogs() throws SQLException {
        List<String> logs = new ArrayList<>();
        String query = "SELECT l.action, l.log_time, u.username FROM system_logs l " +
                       "JOIN users u ON l.user_id = u.id ORDER BY l.id DESC LIMIT 10";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                logs.add(rs.getString("username") + ": " + rs.getString("action") + " at " + rs.getTimestamp("log_time"));
            }
        }
        return logs;
    }

    public void savePasswordRequest(String username, String reason) throws SQLException {
        String query = "INSERT INTO password_requests (username, reason) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, reason);
            ps.executeUpdate();
        }
    }

    public List<PasswordRequest> getPendingPasswordRequests() throws SQLException {
        List<PasswordRequest> requests = new ArrayList<>();
        String query = "SELECT * FROM password_requests WHERE status = 'PENDING' ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                requests.add(new PasswordRequest(rs.getInt("id"), rs.getString("username"), 
                                               rs.getString("reason"), rs.getTimestamp("request_time"), 
                                               rs.getString("status")));
            }
        }
        return requests;
    }

    public void resolvePasswordRequest(int id) throws SQLException {
        String query = "UPDATE password_requests SET status = 'RESOLVED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void addUnavailability(int dentistId, String date, String reason) throws SQLException {
        String query = "INSERT INTO dentist_unavailability (dentist_id, unavailable_date, reason) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, dentistId);
            ps.setString(2, date);
            ps.setString(3, reason);
            ps.executeUpdate();
        }
    }

    public List<String> getAllUnavailability() throws SQLException {
        List<String> list = new ArrayList<>();
        String query = "SELECT u.full_name, un.unavailable_date, un.reason FROM dentist_unavailability un " +
                       "JOIN users u ON un.dentist_id = u.id ORDER BY un.unavailable_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                list.add(rs.getString("full_name") + " unavailable on " + rs.getDate("unavailable_date") + " (" + rs.getString("reason") + ")");
            }
        }
        return list;
    }
}
