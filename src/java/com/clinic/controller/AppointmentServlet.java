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
                    patientId = Integer.parseInt(request.getParameter("existing_patient_id"));
                } else {
                    int customId = Integer.parseInt(request.getParameter("new_patient_id"));
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String phone = request.getParameter("phone");
                    int age = 0;
                    try { age = Integer.parseInt(request.getParameter("age")); } catch(Exception e) {}
                    String gender = request.getParameter("sex");
                    
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
