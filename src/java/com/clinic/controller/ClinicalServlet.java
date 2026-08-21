package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/clinical_actions")
public class ClinicalServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("finalize".equals(action)) {
                int apptId = Integer.parseInt(request.getParameter("apptId"));
                facade.finalizeClinicalSession(apptId);
                response.sendRedirect("dentist_dashboard.jsp?status=session_saved");
            } else if ("process_bill".equals(action)) {
                int apptId = Integer.parseInt(request.getParameter("apptId"));
                facade.markAsBilled(apptId);
                response.sendRedirect("bill.jsp?status=billed_success");
            } else if ("report_unavailability".equals(action)) {
                String user = (String) request.getSession().getAttribute("user");
                String date = request.getParameter("unavailable_date");
                String reason = request.getParameter("reason");
                facade.reportUnavailability(user, date, reason);
                response.sendRedirect("dentist_dashboard.jsp?status=unavailability_reported");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dentist_dashboard.jsp?error=save_failed");
        }
    }
}
