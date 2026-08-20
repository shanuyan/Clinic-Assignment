package com.clinic.dao;

import com.clinic.util.DBConnection;
import java.sql.*;
import java.util.*;

public class ServiceDAO {
    public Map<String, Double> getServicePrices() throws SQLException {
        Map<String, Double> prices = new HashMap<>();
        String query = "SELECT service_name, price FROM services";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                prices.put(rs.getString("service_name"), rs.getDouble("price"));
            }
        }
        return prices;
    }
    
    // Default data insert if empty
    public void seedServices() throws SQLException {
        String check = "SELECT COUNT(*) FROM services";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(check)) {
            if (rs.next() && rs.getInt(1) == 0) {
                stmt.execute("INSERT INTO services (service_name, price) VALUES " +
                        "('Cleaning', 500.00), ('Root Canal', 5000.00), " +
                        "('Extraction', 1500.00), ('Consultation', 1000.00)");
            }
        }
    }
}
