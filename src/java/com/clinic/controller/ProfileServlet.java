package com.clinic.controller;

import com.clinic.service.ClinicFacade;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/profile_actions")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileServlet extends HttpServlet {
    private ClinicFacade facade = new ClinicFacade();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("user");
        
        if (username == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String fullName = request.getParameter("full_name");
        String password = request.getParameter("password");
        String profileImage = null;

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
                    String newFileName = "profile_" + username + "_" + System.currentTimeMillis() + extension;
                    
                    // Save to deploy path
                    String deployPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                    File deployDir = new File(deployPath);
                    if (!deployDir.exists()) {
                        deployDir.mkdirs();
                    }
                    File deployFile = new File(deployDir, newFileName);
                    filePart.write(deployFile.getAbsolutePath());
                    
                    // Save copy to source directory to persist changes during development redeployments
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
            System.out.println("Profile image upload failed: " + e.getMessage());
        }

        try {
            boolean success = facade.updateUserProfile(username, fullName, password, profileImage);
            if (success) {
                // If profile image was updated, update the session
                if (profileImage != null) {
                    session.setAttribute("profileImage", profileImage);
                }
                response.sendRedirect("profile.jsp?status=success");
            } else {
                response.sendRedirect("profile.jsp?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=action_failed");
        }
    }
}
