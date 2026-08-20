package com.clinic.dao;

import com.clinic.util.DBConnection;
import java.sql.*;

public class BillDAO {
    public boolean generateBill(int appointmentId, double totalAmount) throws SQLException {
        String query = "INSERT INTO bills (appointment_id, amount, qr_code) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, appointmentId);
            ps.setDouble(2, totalAmount);
            ps.setString(3, "QR_" + appointmentId + "_" + System.currentTimeMillis());
            return ps.executeUpdate() > 0;
        }
    }
}
