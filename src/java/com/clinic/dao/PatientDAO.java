package com.clinic.dao;

import com.clinic.model.Patient;
import com.clinic.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    
    public int addPatient(int customId, String name, String address, String phone, int age, String gender) throws SQLException {
        String query = "INSERT INTO patients (id, name, address, phone, age, gender) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, customId);
            ps.setString(2, name);
            ps.setString(3, address);
            ps.setString(4, phone);
            ps.setInt(5, age);
            ps.setString(6, gender);
            ps.executeUpdate();
            return customId;
        }
    }

    public Patient getPatient(int id) throws SQLException {
        String query = "SELECT * FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Patient(rs.getInt("id"), rs.getString("name"), 
                                   rs.getString("address"), rs.getString("phone"),
                                   rs.getInt("age"), rs.getString("gender"));
            }
        }
        return null;
    }

    public boolean deletePatient(int id) throws SQLException {
        String query = "DELETE FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}
