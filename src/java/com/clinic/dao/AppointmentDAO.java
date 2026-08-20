package com.clinic.dao;

import com.clinic.model.Appointment;
import com.clinic.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public boolean addAppointment(Appointment appt) throws SQLException {
        String query = "INSERT INTO appointments (patient_id, dentist_id, appointment_date, status, treatment_type) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getDentistId());
            ps.setString(3, appt.getAppointmentDate());
            ps.setString(4, appt.getStatus());
            ps.setString(5, appt.getTreatmentType());
            
            return ps.executeUpdate() > 0;
        }
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT * FROM appointments WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setDentistId(rs.getInt("dentist_id"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                list.add(appt);
            }
        }
        return list;
    }
}
