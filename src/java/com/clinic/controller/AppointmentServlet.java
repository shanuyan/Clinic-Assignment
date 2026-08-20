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
                    patientId = facade.registerPatient(customId, name, address, phone);
                }

                if (patientId != -1) {
                    int dentistId = Integer.parseInt(request.getParameter("dentistId"));
                    String date = request.getParameter("date");
                    String treatment = request.getParameter("treatment");

                    facade.scheduleAppointment(patientId, dentistId, date, treatment);
                    response.sendRedirect("appointments.jsp?success=true&pid=" + patientId);
                } else {
                    response.sendRedirect("appointments.jsp?error=reg_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointments.jsp?error=server_error");
        }
    }
}
