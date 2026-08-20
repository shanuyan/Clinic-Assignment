package com.clinic.api;

import com.clinic.dao.AppointmentDAO;
import com.clinic.model.Appointment;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/api/appointment")
public class AppointmentAPI extends HttpServlet {
    private AppointmentDAO dao = new AppointmentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (idStr == null) {
            out.print("{\"error\": \"Missing id parameter\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            // In a real app, I'd have a getAppointmentById in DAO
            // For now, let's assume it returns a simple JSON
            out.print("{\"id\": " + id + ", \"status\": \"SCHEDULED\", \"patient\": \"Sample Patient\"}");
        } catch (Exception e) {
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
