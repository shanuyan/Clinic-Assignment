package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin_actions")
public class AdminServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("register".equals(action)) {
                String role = request.getParameter("role");
                String user = request.getParameter("username");
                String pass = request.getParameter("password");
                String name = request.getParameter("name");
                
                if ("DENTIST".equals(role)) {
                    String lic = request.getParameter("license");
                    String spec = request.getParameter("spec");
                    int exp = Integer.parseInt(request.getParameter("exp"));
                    facade.registerDoctor(user, pass, name, lic, spec, exp);
                } else {
                    facade.registerStaff(user, pass, name);
                }
                response.sendRedirect("admin_dashboard.jsp?status=onboarded");
                
            } else if ("reset_pass".equals(action)) {
                int uid = Integer.parseInt(request.getParameter("userId"));
                String newPass = request.getParameter("newPass");
                facade.resetUserPassword(uid, newPass);
                
                // If there's an associated request, resolve it (simplified)
                response.sendRedirect("admin_dashboard.jsp?status=pass_updated");
            } else if ("resolve_ticket".equals(action)) {
                int ticketId = Integer.parseInt(request.getParameter("ticketId"));
                facade.solvePassRequest(ticketId);
                response.sendRedirect("admin_dashboard.jsp?status=ticket_resolved");
            } else if ("update_rates".equals(action)) {
                java.util.Map<String, Double> newRates = new java.util.HashMap<>();
                java.util.Enumeration<String> params = request.getParameterNames();
                while(params.hasMoreElements()){
                    String paramName = params.nextElement();
                    if(paramName.startsWith("rate_")){
                        String serviceName = paramName.substring(5).replace("_", " ");
                        double price = Double.parseDouble(request.getParameter(paramName));
                        newRates.put(serviceName, price);
                    }
                }
                facade.updateRates(newRates);
                response.sendRedirect("admin_dashboard.jsp?status=rates_updated");
            } else if ("add_treatment".equals(action)) {
                String name = request.getParameter("serviceName");
                double price = Double.parseDouble(request.getParameter("servicePrice"));
                facade.addTreatmentType(name, price);
                response.sendRedirect("admin_dashboard.jsp?status=treatment_added");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_dashboard.jsp?error=action_failed");
        }
    }
}
