package com.clinic.service;

import com.clinic.dao.*;
import com.clinic.model.*;
import java.util.List;
import java.util.Map;

public class ClinicFacade {
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private AdminDAO adminDAO = new AdminDAO();

    public ClinicFacade() {
        try { serviceDAO.seedServices(); } catch (Exception e) {}
    }

    // AUTH
    public boolean login(String u, String p) { return userDAO.validateUser(u, p); }
    public String getUserRole(String u) { return userDAO.getUserRole(u); }

    // PATIENT
    public int registerPatient(int id, String n, String a, String p, int age, String gender) throws Exception {
        return patientDAO.addPatient(id, n, a, p, age, gender);
    }

    public boolean isPatientRegistered(int id) throws Exception {
        return patientDAO.isIdExists(id);
    }

    // APPOINTMENT
    public boolean scheduleAppointment(int pId, int dId, String date, String treat) throws Exception {
        Appointment appt = new Appointment();
        appt.setPatientId(pId);
        appt.setDentistId(dId);
        appt.setAppointmentDate(date);
        appt.setTreatmentType(treat);
        appt.setStatus("PENDING"); 
        return appointmentDAO.addAppointment(appt);
    }

    public List<Appointment> getDentistAppointments(String username) throws Exception {
        int id = userDAO.getUserIdByUsername(username);
        return appointmentDAO.getAppointmentsByDentist(id);
    }

    // CLINICAL & BILLING
    public boolean finalizeClinicalSession(int apptId, String notes, String meds) throws Exception {
        return appointmentDAO.finalizeSession(apptId, notes, meds);
    }

    public List<Appointment> getPendingBills() throws Exception {
        return appointmentDAO.getAppointmentsByStatus("COMPLETED");
    }

    public boolean markAsBilled(int apptId) throws Exception {
        return appointmentDAO.updateStatus(apptId, "BILLED");
    }

    public Appointment searchAppointment(int id) throws Exception {
        return appointmentDAO.getAppointmentById(id);
    }

    public List<Appointment> getPatientHistory(int patientId) throws Exception {
        return appointmentDAO.getAppointmentsByPatient(patientId);
    }

    public double getTreatmentCost(String treatment) throws Exception {
        Map<String, Double> prices = serviceDAO.getServicePrices();
        return prices.getOrDefault(treatment, 0.0);
    }

    // DASHBOARD DATA
    public List<Appointment> getLiveFeed() throws Exception {
        return appointmentDAO.getAppointmentsByStatus("PENDING");
    }

    public int getTodayAppointmentCount() throws Exception {
        return appointmentDAO.getAppointmentsByStatus("PENDING").size();
    }

    // ADMIN CONTROLS (Updated for Images)
    public List<User> getSystemUsers() throws Exception { return adminDAO.getAllUsers(); }
    public List<User> getDentists() throws Exception { return adminDAO.getUsersByRole("DENTIST"); }
    
    public boolean registerDoctor(String u, String p, String n, String img, String l, String s, int e) throws Exception {
        int uid = adminDAO.createUser(u, p, "DENTIST", n, img);
        if (uid != -1) { adminDAO.createDoctorProfile(uid, l, s, e); return true; }
        return false;
    }

    public boolean registerStaff(String u, String p, String n, String img) throws Exception {
        return adminDAO.createUser(u, p, "STAFF", n, img) != -1;
    }

    public Map<String, Double> getAllServiceRates() throws Exception { return serviceDAO.getServicePrices(); }
    public void updateRates(Map<String, Double> nr) throws Exception {
        for (Map.Entry<String, Double> ent : nr.entrySet()) { serviceDAO.updateServicePrice(ent.getKey(), ent.getValue()); }
    }
    public boolean addTreatmentType(String n, double p) throws Exception { return serviceDAO.addNewService(n, p); }
    public boolean resetUserPassword(int uId, String pass) throws Exception { return adminDAO.updatePassword(uId, pass); }
    public List<PasswordRequest> getPendingPassRequests() throws Exception { return adminDAO.getPendingPasswordRequests(); }
    public void solvePassRequest(int id) throws Exception { adminDAO.resolvePasswordRequest(id); }
    public void submitPasswordRequest(String u, String r) throws Exception { adminDAO.savePasswordRequest(u, r); }
    public void reportUnavailability(String u, String d, String r) throws Exception {
        int id = userDAO.getUserIdByUsername(u);
        adminDAO.addUnavailability(id, d, r);
    }
    public List<String> getClinicalUnavailability() throws Exception { return adminDAO.getAllUnavailability(); }
    public List<String> getAuditLogs() throws Exception { return adminDAO.getRecentLogs(); }
    public String getProfileImage(String u) { return userDAO.getProfileImage(u); }
    
    public com.clinic.model.User getUserByUsername(String u) { return userDAO.getUserByUsername(u); }
    public boolean updateUserProfile(String u, String name, String pass, String img) {
        return userDAO.updateUserProfile(u, name, pass, img);
    }
}
