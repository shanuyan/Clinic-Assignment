package com.clinic.dao;

import com.clinic.util.DBConnection;
import java.sql.*;

public class UserDAO {
    
    public boolean validateUser(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getUserRole(String username) {
        String query = "SELECT role FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("role");
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int getUserIdByUsername(String username) {
        String query = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public String getProfileImage(String username) {
        String query = "SELECT profile_image FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("profile_image");
        } catch (SQLException e) { e.printStackTrace(); }
        return "default_avatar.png";
    }

    public com.clinic.model.User getUserByUsername(String username) {
        String query = "SELECT id, username, role, full_name, profile_image FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new com.clinic.model.User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("role"),
                    rs.getString("full_name"),
                    rs.getString("profile_image")
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateUserProfile(String username, String fullName, String password, String profileImage) {
        StringBuilder query = new StringBuilder("UPDATE users SET full_name = ?");
        boolean updatePassword = password != null && !password.trim().isEmpty();
        boolean updateImage = profileImage != null && !profileImage.trim().isEmpty();
        
        if (updatePassword) {
            query.append(", password = ?");
        }
        if (updateImage) {
            query.append(", profile_image = ?");
        }
        query.append(" WHERE username = ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            int paramIndex = 1;
            ps.setString(paramIndex++, fullName);
            if (updatePassword) {
                ps.setString(paramIndex++, password);
            }
            if (updateImage) {
                ps.setString(paramIndex++, profileImage);
            }
            ps.setString(paramIndex, username);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
