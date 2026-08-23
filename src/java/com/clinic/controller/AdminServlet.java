package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/admin_actions")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
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
                String profileImage = request.getParameter("profile_image");
                
                try {
                    Part filePart = request.getPart("profile_image_file");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = filePart.getSubmittedFileName();
                        if (fileName != null && !fileName.isEmpty()) {
                            String extension = "";
                            int dotIndex = fileName.lastIndexOf('.');
                            if (dotIndex >= 0) {
                                extension = fileName.substring(dotIndex);
                            }
                            String newFileName = "profile_" + user + "_" + System.currentTimeMillis() + extension;
                            
                            // Save to deploy path
                            String deployPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                            File deployDir = new File(deployPath);
                            if (!deployDir.exists()) {
                                deployDir.mkdirs();
                            }
                            File deployFile = new File(deployDir, newFileName);
                            filePart.write(deployFile.getAbsolutePath());
                            
                            // Optional: Save copy to source directory to persist changes during development redeployments
                            try {
                                String realPath = request.getServletContext().getRealPath("");
                                String srcPath = realPath.replace("build" + File.separator + "web", "web");
                                if (!srcPath.equals(realPath)) {
                                    File srcDir = new File(srcPath + File.separator + "uploads");
                                    if (!srcDir.exists()) {
                                        srcDir.mkdirs();
                                    }
                                    File srcFile = new File(srcDir, newFileName);
                                    java.nio.file.Files.copy(deployFile.toPath(), srcFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                                }
                            } catch (Exception ex) {
                                System.out.println("Could not copy uploaded image to development source directory: " + ex.getMessage());
                            }
                            
                            profileImage = "uploads/" + newFileName;
                        }
                    }
                } catch (Exception e) {
                    System.out.println("File upload processing failed or no file provided: " + e.getMessage());
                }
                
                if ("DENTIST".equals(role)) {
                    String lic = request.getParameter("license");
                    String spec = request.getParameter("spec");
                    int exp = Integer.parseInt(request.getParameter("exp"));
                    facade.registerDoctor(user, pass, name, profileImage, lic, spec, exp);
                } else {
                    facade.registerStaff(user, pass, name, profileImage);
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
