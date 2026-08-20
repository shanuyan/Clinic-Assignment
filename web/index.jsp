<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Login | Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="login-split-container">
    <!-- Left Side: Professional Dentist Image & Branding -->
    <div class="login-image-side">
        <div style="background: rgba(0,0,0,0.3); padding: 40px; border-radius: 20px; backdrop-filter: blur(8px);">
            <h1 style="font-weight: 800; font-size: 3rem; margin-bottom: 1rem; line-height: 1;">Elevating <br>Dental Care.</h1>
            <p style="font-size: 1.1rem; opacity: 0.9; line-height: 1.6;">Our comprehensive management system ensures seamless clinical operations and exceptional patient experiences.</p>
            <div style="margin-top: 30px; display: flex; gap: 15px;">
                <div style="width: 40px; height: 4px; background: white; border-radius: 2px;"></div>
                <div style="width: 20px; height: 4px; background: rgba(255,255,255,0.3); border-radius: 2px;"></div>
                <div style="width: 20px; height: 4px; background: rgba(255,255,255,0.3); border-radius: 2px;"></div>
            </div>
        </div>
    </div>

    <!-- Right Side: Clean Login Panel -->
    <div class="login-form-side">
        <div class="login-box">
            <div style="margin-bottom: 40px;">
                <div style="width: 48px; height: 48px; background: #4f46e5; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; justify-content: center; padding: 6px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4.5 10.1c.2 1.8 1.4 3.1 3.1 3.4 1.1.2 2.3-.2 3-1.1L12 11l1.4 1.4c.7.9 1.9 1.3 3 1.1 1.7-.3 2.9-1.6 3.1-3.4.2-2.1-.5-4.2-1.9-5.7C16.2 3 14.1 2.3 12 2.3s-4.2.7-5.6 2.1c-1.4 1.5-2.1 3.6-1.9 5.7z"/>
                    <path d="M12 21.7c-2.1 0-4.2-.7-5.6-2.1-1.4-1.5-2.1-3.6-1.9-5.7.1-.9.3-1.8.7-2.6"/>
                    <path d="M18.8 11.3c.4.8.6 1.7.7 2.6.2 2.1-.5 4.2-1.9 5.7-1.4 1.4-3.5 2.1-5.6 2.1"/>
                </svg>
            </div>
                <h1 class="branding-h1">Sunrise <span>Dental</span></h1>
                <p style="color: #64748b; font-weight: 500;">Secure Clinical Gateway</p>
            </div>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-alert">
                    <strong>Access Denied:</strong> Credentials did not match our records.
                </div>
            <% } %>

            <% if("sent".equals(request.getParameter("report"))) { %>
                <div class="alert alert-success border-0 rounded-4 p-3 mb-4" style="background-color: #f0fdf4; color: #15803d; font-size: 0.875rem;">
                    <strong>Report Submitted:</strong> The Administrator will review your request shortly.
                </div>
            <% } %>

            <form action="auth" method="POST">
                <input type="hidden" name="action" value="login">

                <div style="margin-bottom: 24px;">
                    <label class="form-label">System Identity</label>
                    <input type="text" name="username" class="custom-input" placeholder="Enter your username" required autocomplete="username">
                </div>

                <div style="margin-bottom: 10px;">
                    <label class="form-label">Secure PassKey</label>
                    <input type="password" name="password" class="custom-input" placeholder="••••••••••••" required autocomplete="current-password">
                </div>

                <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 30px;">
                    <a href="forgot_key.jsp" style="font-size: 0.85rem; color: #4f46e5; text-decoration: none; font-weight: 600;">Forgot key?</a>
                </div>

                <button type="submit" class="login-btn-premium">Sign in to System</button>
            </form>

            <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #f1f5f9; text-align: center;">
                <p style="font-size: 0.8rem; color: #94a3b8;">&copy; 2024 Sunrise Dental Group. <br>Enterprise Grade Infrastructure.</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
