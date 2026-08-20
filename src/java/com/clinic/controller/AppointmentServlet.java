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
                String name = request.getParameter("name");
                String address = request.getParameter("address");
                String phone = request.getParameter("phone");
                String dentistIdStr = request.getParameter("dentistId");
                String date = request.getParameter("date");
                String treatment = request.getParameter("treatment");
                
                int patientId = facade.registerPatient(name, address, phone);
                if (patientId != -1) {
                    int dentistId = Integer.parseInt(dentistIdStr);
                    facade.scheduleAppointment(patientId, dentistId, date, treatment);
                    response.sendRedirect("dashboard.jsp?success=booked");
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
