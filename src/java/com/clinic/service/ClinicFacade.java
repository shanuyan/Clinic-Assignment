package com.clinic.service;

import com.clinic.dao.UserDAO;
import com.clinic.dao.PatientDAO;
import com.clinic.dao.AppointmentDAO;
import com.clinic.dao.ServiceDAO;
import com.clinic.dao.BillDAO;
import com.clinic.dao.AdminDAO;
import com.clinic.model.User;
import com.clinic.model.Patient;
import com.clinic.model.Appointment;
import com.clinic.model.PasswordRequest;
import java.util.List;

/**
 * Facade Pattern to simplify interactions between UI and Business Logic/DAOs
 */
public class ClinicFacade {
    private UserDAO userDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;
    private ServiceDAO serviceDAO;
    private BillDAO billDAO;
    private AdminDAO adminDAO;

    public ClinicFacade() {
        this.userDAO = new UserDAO();
        this.patientDAO = new PatientDAO();
        this.appointmentDAO = new AppointmentDAO();
        this.serviceDAO = new ServiceDAO();
        this.billDAO = new BillDAO();
        this.adminDAO = new AdminDAO();
        try {
            this.serviceDAO.seedServices();
        } catch (Exception e) {}
    }

    public List<User> getSystemUsers() throws Exception {
        return adminDAO.getAllUsers();
    }

    public List<User> getDentists() throws Exception {
        return adminDAO.getUsersByRole("DENTIST");
    }

    public List<String> getAuditLogs() throws Exception {
        return adminDAO.getRecentLogs();
    }

    public void audit(String username, String action) {
        int uid = userDAO.getUserIdByUsername(username);
        adminDAO.logAction(uid, action);
    }

    public boolean login(String username, String password) {
        return userDAO.validateUser(username, password);
    }

    public String getUserRole(String username) {
        return userDAO.getUserRole(username);
    }

    public int registerPatient(int id, String name, String address, String phone) throws Exception {
        return patientDAO.addPatient(id, name, address, phone);
    }

    public Patient getPatientById(int id) throws Exception {
        return patientDAO.getPatient(id);
    }

    public boolean scheduleAppointment(int patientId, int dentistId, String date, String treatment) throws Exception {
        Appointment appt = new Appointment();
        appt.setPatientId(patientId);
        appt.setDentistId(dentistId);
        appt.setAppointmentDate(date);
        appt.setTreatmentType(treatment);
        appt.setStatus("SCHEDULED");
        return appointmentDAO.addAppointment(appt);
    }

    public int getTodayAppointmentCount() throws Exception {
        // Simple logic for now: count all from DB
        return appointmentDAO.getAppointmentsByPatient(0).size(); 
    }

    public List<Appointment> getLiveFeed() throws Exception {
        return appointmentDAO.getLatestAppointments(5);
    }

    public Appointment searchAppointment(int id) throws Exception {
        return appointmentDAO.getAppointmentById(id);
    }

    public List<Appointment> getDentistAppointments(String username) throws Exception {
        int id = userDAO.getUserIdByUsername(username);
        return appointmentDAO.getAppointmentsByDentist(id);
    }

    public List<Appointment> getPendingBills() throws Exception {
        return appointmentDAO.getAppointmentsByStatus("COMPLETED");
    }

    public boolean finalizeClinicalSession(int appointmentId) throws Exception {
        return appointmentDAO.updateStatus(appointmentId, "COMPLETED");
    }

    public boolean markAsBilled(int appointmentId) throws Exception {
        return appointmentDAO.updateStatus(appointmentId, "BILLED");
    }

    public double getTreatmentCost(String treatment) throws Exception {
        java.util.Map<String, Double> prices = serviceDAO.getServicePrices();
        return prices.getOrDefault(treatment, 0.0);
    }

    public java.util.Map<String, Double> getAllServiceRates() throws Exception {
        return serviceDAO.getServicePrices();
    }

    public void updateRates(java.util.Map<String, Double> newRates) throws Exception {
        for (java.util.Map.Entry<String, Double> entry : newRates.entrySet()) {
            serviceDAO.updateServicePrice(entry.getKey(), entry.getValue());
        }
    }

    public boolean addTreatmentType(String name, double price) throws Exception {
        return serviceDAO.addNewService(name, price);
    }

    public boolean registerDoctor(String user, String pass, String name, String lic, String spec, int exp) throws Exception {
        int uid = adminDAO.createUser(user, pass, "DENTIST", name);
        if (uid != -1) {
            adminDAO.createDoctorProfile(uid, lic, spec, exp);
            return true;
        }
        return false;
    }

    public boolean registerStaff(String user, String pass, String name) throws Exception {
        return adminDAO.createUser(user, pass, "STAFF", name) != -1;
    }

    public boolean resetUserPassword(int userId, String newPass) throws Exception {
        return adminDAO.updatePassword(userId, newPass);
    }

    public void submitPasswordRequest(String user, String reason) throws Exception {
        adminDAO.savePasswordRequest(user, reason);
    }

    public List<PasswordRequest> getPendingPassRequests() throws Exception {
        return adminDAO.getPendingPasswordRequests();
    }

    public void solvePassRequest(int id) throws Exception {
        adminDAO.resolvePasswordRequest(id);
    }
}
