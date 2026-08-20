package com.clinic.service;

import com.clinic.dao.UserDAO;
import com.clinic.dao.PatientDAO;
import com.clinic.dao.AppointmentDAO;
import com.clinic.model.User;
import com.clinic.model.Patient;
import com.clinic.model.Appointment;
import java.util.List;

/**
 * Facade Pattern to simplify interactions between UI and Business Logic/DAOs
 */
public class ClinicFacade {
    private UserDAO userDAO;
    private PatientDAO patientDAO;
    private AppointmentDAO appointmentDAO;

    public ClinicFacade() {
        this.userDAO = new UserDAO();
        this.patientDAO = new PatientDAO();
        this.appointmentDAO = new AppointmentDAO();
    }

    public boolean login(String username, String password) {
        return userDAO.validateUser(username, password);
    }

    public String getUserRole(String username) {
        return userDAO.getUserRole(username);
    }

    public int registerPatient(String name, String address, String phone) throws Exception {
        Patient p = new Patient(0, name, address, phone);
        return patientDAO.addPatient(p);
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
}
