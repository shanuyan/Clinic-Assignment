package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("register".equals(action)) {
                String mode = request.getParameter("intake_mode");
                int patientId = -1;

                if ("EXISTING".equals(mode)) {
                    String existingId = request.getParameter("existing_patient_id");
                    if (existingId == null || existingId.trim().isEmpty()) {
                        response.sendRedirect("appointments.jsp?status=error&msg=missing_fields");
                        return;
                    }
                    patientId = Integer.parseInt(existingId);
                    
                    // Critical Fix: Verify if this existing ID actually exists in the DB
                    if (!facade.isPatientRegistered(patientId)) {
                        response.sendRedirect("appointments.jsp?status=error&msg=patient_not_found");
                        return;
                    }
                } else {
                    String customIdStr = request.getParameter("new_patient_id");
                    String name = request.getParameter("name");
                    String ageStr = request.getParameter("age");
                    String gender = request.getParameter("sex");
                    
                    if (name == null || name.trim().isEmpty() || customIdStr == null || customIdStr.trim().isEmpty()) {
                        response.sendRedirect("appointments.jsp?status=error&msg=missing_fields");
                        return;
                    }

                    int customId = Integer.parseInt(customIdStr);
                    String address = request.getParameter("address");
                    String phone = request.getParameter("phone");
                    
                    // Server-side numeric validation for phone
                    if (phone != null && !phone.matches("\\d{10}")) {
                        response.sendRedirect("appointments.jsp?status=error&msg=invalid_phone");
                        return;
                    }

                    int age = 0;
                    try { age = Integer.parseInt(ageStr); } catch(Exception e) {}
                    
                    patientId = facade.registerPatient(customId, name, address, phone, age, gender);
                }

                if (patientId != -1) {
                    int dentistId = Integer.parseInt(request.getParameter("dentistId"));
                    String date = request.getParameter("date");
                    String treatment = request.getParameter("treatment");

                    boolean scheduled = facade.scheduleAppointment(patientId, dentistId, date, treatment);
                    if (scheduled) {
                        response.sendRedirect("appointments.jsp?status=success&pid=" + patientId);
                    } else {
                        response.sendRedirect("appointments.jsp?status=error&msg=appointment_failed");
                    }
                } else {
                    response.sendRedirect("appointments.jsp?status=error&msg=registration_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointments.jsp?status=error&msg=server_error");
        }
    }
}
