package com.clinic.dao;

import com.clinic.model.Appointment;
import com.clinic.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public boolean addAppointment(Appointment appt) throws SQLException {
        // Initial status set to PENDING for the doctor to see
        String query = "INSERT INTO appointments (patient_id, dentist_id, appointment_date, treatment_type, status) VALUES (?, ?, ?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, appt.getPatientId());
            ps.setInt(2, appt.getDentistId());
            ps.setString(3, appt.getAppointmentDate());
            ps.setString(4, appt.getTreatmentType());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Appointment> getAppointmentsByStatus(String status) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        // Professional LEFT JOIN ensures we get records even if some links are broken
        String query = "SELECT a.*, p.name as patient_name, u.full_name as dentist_name " +
                       "FROM appointments a " +
                       "LEFT JOIN patients p ON a.patient_id = p.id " +
                       "LEFT JOIN users u ON a.dentist_id = u.id " +
                       "WHERE a.status = ? ORDER BY a.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name") != null ? rs.getString("patient_name") : "New Patient");
                appt.setDentistName(rs.getString("dentist_name") != null ? rs.getString("dentist_name") : "Medical Staff");
                appt.setClinicalNotes(rs.getString("clinical_notes"));
                appt.setPrescribedMedicines(rs.getString("prescribed_medicines"));
                list.add(appt);
            }
        }
        return list;
    }

    public boolean finalizeSession(int appointmentId, String notes, String medicines) throws SQLException {
        // MOVING STATUS FROM PENDING TO COMPLETED
        String query = "UPDATE appointments SET clinical_notes = ?, prescribed_medicines = ?, status = 'COMPLETED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, notes);
            ps.setString(2, medicines);
            ps.setInt(3, appointmentId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int appointmentId, String status) throws SQLException {
        String query = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            return ps.executeUpdate() > 0;
        }
    }

    public Appointment getAppointmentById(int id) throws SQLException {
        String query = "SELECT a.*, p.name as patient_name, u.full_name as dentist_name FROM appointments a " +
                       "LEFT JOIN patients p ON a.patient_id = p.id LEFT JOIN users u ON a.dentist_id = u.id WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setDentistName(rs.getString("dentist_name"));
                appt.setClinicalNotes(rs.getString("clinical_notes"));
                appt.setPrescribedMedicines(rs.getString("prescribed_medicines"));
                return appt;
            }
        }
        return null;
    }

    public List<Appointment> getAppointmentsByDentist(int dentistId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        // Only show PENDING cases for the doctor
        String query = "SELECT a.*, p.name as patient_name FROM appointments a " +
                       "LEFT JOIN patients p ON a.patient_id = p.id " +
                       "WHERE a.dentist_id = ? AND a.status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, dentistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientName(rs.getString("patient_name") != null ? rs.getString("patient_name") : "Case #"+appt.getId());
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                list.add(appt);
            }
        }
        return list;
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT a.*, p.name as patient_name, u.full_name as dentist_name " +
                       "FROM appointments a " +
                       "LEFT JOIN patients p ON a.patient_id = p.id " +
                       "LEFT JOIN users u ON a.dentist_id = u.id " +
                       "WHERE a.patient_id = ? ORDER BY a.appointment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientId(rs.getInt("patient_id"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setDentistName(rs.getString("dentist_name"));
                appt.setClinicalNotes(rs.getString("clinical_notes"));
                appt.setPrescribedMedicines(rs.getString("prescribed_medicines"));
                list.add(appt);
            }
        }
        return list;
    }
}
