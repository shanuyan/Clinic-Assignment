<%@ page import="com.clinic.model.User" %>
<%@ page import="com.clinic.service.ClinicFacade" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .profile-avatar-container {
            position: relative;
            width: 140px;
            height: 140px;
            margin: 0 auto;
        }
        .profile-avatar-preview {
            width: 140px;
            height: 140px;
            object-fit: cover;
            border: 4px solid var(--card-bg);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }
        .profile-avatar-container:hover .profile-avatar-preview {
            opacity: 0.95;
            transform: scale(1.02);
        }
        .avatar-edit-badge {
            position: absolute;
            bottom: 4px;
            right: 4px;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background-color: var(--primary);
            border: 3px solid #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0,0,0,0.15);
            transition: all 0.2s ease;
        }
        .avatar-edit-badge:hover {
            background-color: var(--primary-hover);
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>
    
    <%
        // The header.jsp already checks for session "user" and redirects to login if null.
        // We will load the user's detailed information through the facade.
        ClinicFacade profileFacade = new ClinicFacade();
        User currentUser = null;
        try {
            currentUser = profileFacade.getUserByUsername(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (currentUser == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
    %>

    <div class="page-header max-width-850 mx-auto mt-4">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Profile Settings</h1>
            <p class="text-muted small">Update your personal details, credentials, and profile image.</p>
        </div>
        <a href="dashboard.jsp" class="btn btn-outline-secondary fw-semibold rounded-3 px-3">← Dashboard</a>
    </div>

    <!-- Alert Notifications -->
    <div class="max-width-850 mx-auto mb-4">
        <% if ("success".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success border-0 rounded-4 p-3 shadow-sm d-flex align-items-center mb-0" style="background-color: #f0fdf4; color: #15803d;">
                <div class="me-3 fs-4">✅</div>
                <div>
                    <strong class="d-block">Success!</strong>
                    Your profile information was updated successfully.
                </div>
            </div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger border-0 rounded-4 p-3 shadow-sm d-flex align-items-center mb-0" style="background-color: #fef2f2; color: #b91c1c;">
                <div class="me-3 fs-4">❌</div>
                <div>
                    <strong class="d-block">Error</strong>
                    <%= "update_failed".equals(request.getParameter("error")) ? "Unable to update profile details. Please try again." : "An unexpected error occurred." %>
                </div>
            </div>
        <% } %>
    </div>

    <div class="max-width-850 mx-auto mb-5">
        <form action="profile_actions" method="POST" enctype="multipart/form-data">
            <div class="row g-4">
                <!-- Left Column: Photo & Role -->
                <div class="col-lg-4">
                    <div class="card border-0 p-4 text-center shadow-sm h-100">
                        <h5 class="fw-bold text-dark mb-4">Profile Photo</h5>
                        
                        <div class="profile-avatar-container mb-3">
                            <img id="profileAvatarPreview" src="<%= (currentUser.getProfileImage() != null && !currentUser.getProfileImage().isEmpty() && !currentUser.getProfileImage().equals("default_avatar.png")) ? currentUser.getProfileImage() : "https://api.dicebear.com/7.x/adventurer/svg?seed=" + currentUser.getUsername() %>" 
                                 class="rounded-circle profile-avatar-preview"
                                 onerror="this.src='https://api.dicebear.com/7.x/adventurer/svg?seed=<%= currentUser.getUsername() %>'">
                            
                            <label for="avatarFileInput" class="avatar-edit-badge" title="Change Photo">
                                📷
                            </label>
                        </div>
                        
                        <input type="file" name="profile_image_file" id="avatarFileInput" accept="image/*" class="d-none" onchange="previewProfileImage(this)">
                        
                        <div class="mt-3">
                            <h6 class="fw-bold m-0"><%= currentUser.getFullName() %></h6>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill px-3 py-1.5 mt-2 small text-uppercase fw-semibold"><%= currentUser.getRole() %></span>
                        </div>
                        
                        <hr class="my-4 text-muted opacity-25">
                        
                        <p class="small text-muted text-start mb-0">
                            <strong>System ID:</strong> @<%= currentUser.getUsername() %><br>
                            Click the camera icon to upload a square image (JPEG, PNG, WEBP, max 2MB).
                        </p>
                    </div>
                </div>

                <!-- Right Column: Personal Data & Credentials -->
                <div class="col-lg-8">
                    <div class="card border-0 p-4 shadow-sm h-100">
                        <h5 class="fw-bold text-dark mb-4 border-bottom pb-3">Security & Personal Details</h5>
                        
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-uppercase small fw-bold text-muted">Legal Full Name</label>
                                <input type="text" name="full_name" class="form-control" value="<%= currentUser.getFullName() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-uppercase small fw-bold text-muted">Clinical ID (Username)</label>
                                <input type="text" class="form-control bg-light text-muted" value="@<%= currentUser.getUsername() %>" disabled>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label text-uppercase small fw-bold text-muted">New PassKey (Leave blank to keep current)</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-uppercase small fw-bold text-muted">Access Level Role</label>
                                <input type="text" class="form-control bg-light text-muted text-uppercase" value="<%= currentUser.getRole() %>" disabled>
                            </div>
                        </div>
                        
                        <div class="mt-auto pt-4 d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary fw-bold px-5 py-2.5 rounded-3 shadow-sm">Save Changes</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        function previewProfileImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileAvatarPreview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
