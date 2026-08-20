package com.clinic.api;

import com.clinic.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/api/check-availability")
public class CheckAvailabilityAPI extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dentistId = request.getParameter("dentistId");
        String date = request.getParameter("date");
        response.setContentType("application/json");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT COUNT(*) FROM appointments WHERE dentist_id = ? AND appointment_date = ?")) {
            
            ps.setInt(1, Integer.parseInt(dentistId));
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            
            boolean available = true;
            if (rs.next() && rs.getInt(1) > 0) {
                available = false;
            }
            
            response.getWriter().print("{\"available\": " + available + "}");
        } catch (Exception e) {
            response.getWriter().print("{\"error\": \"Server error\"}");
        }
    }
}
