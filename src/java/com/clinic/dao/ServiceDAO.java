package com.clinic.dao;

import com.clinic.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ServiceDAO {
    
    public Map<String, Double> getServicePrices() throws SQLException {
        Map<String, Double> prices = new LinkedHashMap<>(); 
        String query = "SELECT treatment_name, price FROM treatmentdetails ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                prices.put(rs.getString("treatment_name"), rs.getDouble("price"));
            }
        }
        return prices;
    }

    public boolean updateServicePrice(String name, double price) throws SQLException {
        String query = "UPDATE treatmentdetails SET price = ? WHERE treatment_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, price);
            ps.setString(2, name);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean addNewService(String name, double price) throws SQLException {
        String query = "INSERT INTO treatmentdetails (treatment_name, price) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            return ps.executeUpdate() > 0;
        }
    }
    
    public void seedServices() throws SQLException {
        String check = "SELECT COUNT(*) FROM treatmentdetails";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(check)) {
            if (rs.next() && rs.getInt(1) == 0) {
                stmt.execute("INSERT INTO treatmentdetails (treatment_name, price) VALUES " +
                        "('Consultation', 1500.00), " +
                        "('Prophylaxis (Cleaning)', 2500.00), " +
                        "('Composite Filling', 3500.00), " +
                        "('Endodontic Therapy', 15000.00), " +
                        "('Surgical Extraction', 8000.00), " +
                        "('Orthodontic Adj', 5000.00), " +
                        "('Teeth Whitening', 25000.00), " +
                        "('Dental Implant', 120000.00)");
            }
        }
    }
}
