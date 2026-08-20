package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            
            if (facade.login(user, pass)) {
                String role = facade.getUserRole(user);
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", role);
                
                response.sendRedirect("dashboard.jsp");
            } else {
                response.sendRedirect("index.html?error=invalid");
            }
        } else if ("logout".equals(action)) {
            request.getSession().invalidate();
            response.sendRedirect("index.html");
        }
    }
}
