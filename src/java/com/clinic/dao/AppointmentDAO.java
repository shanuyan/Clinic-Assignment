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
        String query = (patientId == 0) ? "SELECT * FROM appointments" : "SELECT * FROM appointments WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            if (patientId != 0) ps.setInt(1, patientId);
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

    public Appointment getAppointmentById(int id) throws SQLException {
        String query = "SELECT a.*, p.name as patient_name, u.full_name as dentist_name " +
                       "FROM appointments a " +
                       "JOIN patients p ON a.patient_id = p.id " +
                       "JOIN users u ON a.dentist_id = u.id " +
                       "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setDentistName(rs.getString("dentist_name"));
                return appt;
            }
        }
        return null;
    }

    public List<Appointment> getLatestAppointments(int limit) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT a.*, p.name as patient_name, u.full_name as dentist_name " +
                       "FROM appointments a " +
                       "JOIN patients p ON a.patient_id = p.id " +
                       "JOIN users u ON a.dentist_id = u.id " +
                       "ORDER BY a.id DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setDentistName(rs.getString("dentist_name"));
                list.add(appt);
            }
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDentist(int dentistId) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT a.*, p.name as patient_name FROM appointments a JOIN patients p ON a.patient_id = p.id WHERE a.dentist_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, dentistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setId(rs.getInt("id"));
                appt.setPatientName(rs.getString("patient_name"));
                appt.setTreatmentType(rs.getString("treatment_type"));
                appt.setAppointmentDate(rs.getString("appointment_date"));
                appt.setStatus(rs.getString("status"));
                list.add(appt);
            }
        }
        return list;
    }
}
