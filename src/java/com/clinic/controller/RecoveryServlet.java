package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/recovery_action")
public class RecoveryServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("recovery_username");
        String reason = request.getParameter("reason");
        
        try {
            facade.submitPasswordRequest(username, reason);
            response.sendRedirect("index.jsp?report=sent");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot_key.jsp?error=failed");
        }
    }
}
