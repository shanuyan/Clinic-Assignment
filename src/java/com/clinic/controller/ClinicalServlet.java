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
                String apptIdStr = request.getParameter("apptId");
                String notes = request.getParameter("notes");
                String medicines = request.getParameter("medicines");
                
                if (apptIdStr != null && !apptIdStr.isEmpty()) {
                    int apptId = Integer.parseInt(apptIdStr);
                    facade.finalizeClinicalSession(apptId, notes, medicines);
                    response.sendRedirect("dentist_dashboard.jsp?status=session_saved");
                } else {
                    response.sendRedirect("dentist_dashboard.jsp?status=error&msg=missing_id");
                }
                
            } else if ("process_bill".equals(action)) {
                int apptId = Integer.parseInt(request.getParameter("apptId"));
                boolean billed = facade.markAsBilled(apptId);
                if (billed) {
                    response.sendRedirect("bill.jsp?status=billed_success");
                } else {
                    response.sendRedirect("bill.jsp?status=error&msg=billing_failed");
                }
                
            } else if ("report_unavailability".equals(action)) {
                String user = (String) request.getSession().getAttribute("user");
                String date = request.getParameter("unavailable_date");
                String reason = request.getParameter("reason");
                try {
                    facade.reportUnavailability(user, date, reason);
                    response.sendRedirect("dentist_dashboard.jsp?status=unavailability_reported");
                } catch (Exception e) {
                    response.sendRedirect("dentist_dashboard.jsp?status=error&msg=report_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dentist_dashboard.jsp?error=action_failed");
        }
    }
}
