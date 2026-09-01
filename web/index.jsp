<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Login | Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { margin: 0; padding: 0; overflow: hidden; background-color: #ffffff; }
        .login-wrapper { display: flex; height: 100vh; width: 100%; }

        .image-section {
            flex: 1.2;
            background: linear-gradient(rgba(79, 70, 229, 0.1), rgba(79, 70, 229, 0.1)),
                        url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?q=80&w=2070&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px;
            color: white;
        }

        .image-overlay-card {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(12px);
            padding: 50px;
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            max-width: 550px;
        }

        .form-section {
            flex: 0.8;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            background: #ffffff;
        }

        .auth-card { width: 100%; max-width: 420px; }

        .logo-branding { display: flex; align-items: center; gap: 15px; margin-bottom: 40px; }
        .logo-icon {
            width: 50px; height: 50px;
            background: var(--primary);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px;
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.2);
        }

        .input-group { margin-bottom: 24px; }
        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: var(--text-muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .login-input {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #f1f5f9;
            border-radius: 14px;
            background: #f8fafc;
            font-size: 1rem;
            outline: none;
            transition: 0.2s;
            box-sizing: border-box;
        }

        .login-input:focus { border-color: var(--primary); background: #fff; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.05); }

        .action-btn {
            width: 100%;
            padding: 16px;
            background: #1e293b;
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .action-btn:hover { background: #000; transform: translateY(-2px); box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); }

        .error-message {
            background-color: #fef2f2;
            color: #b91c1c;
            padding: 15px;
            border-radius: 12px;
            font-size: 0.875rem;
            margin-bottom: 25px;
            border: 1px solid #fee2e2;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="image-section">
        <div class="image-overlay-card">
            <h1 style="font-size: 3.5rem; font-weight: 800; line-height: 1.1; margin: 0 0 20px 0;">Exceptional Care, <br>Simplified.</h1>
            <p style="font-size: 1.2rem; opacity: 0.9; line-height: 1.6; margin: 0;">Our advanced management system empowers clinical teams to deliver precision dentistry with a seamless patient experience.</p>
        </div>
    </div>

    <div class="form-section">
        <div class="auth-card">
            <div class="logo-branding">
                <div class="logo-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4.5 10.1c.2 1.8 1.4 3.1 3.1 3.4 1.1.2 2.3-.2 3-1.1L12 11l1.4 1.4c.7.9 1.9 1.3 3 1.1 1.7-.3 2.9-1.6 3.1-3.4.2-2.1-.5-4.2-1.9-5.7C16.2 3 14.1 2.3 12 2.3s-4.2.7-5.6 2.1c-1.4 1.5-2.1 3.6-1.9 5.7z"/>
                        <path d="M12 21.7c-2.1 0-4.2-.7-5.6-2.1-1.4-1.5-2.1-3.6-1.9-5.7.1-.9.3-1.8.7-2.6"/>
                        <path d="M18.8 11.3c.4.8.6 1.7.7 2.6.2 2.1-.5 4.2-1.9 5.7-1.4 1.4-3.5 2.1-5.6 2.1"/>
                    </svg>
                </div>
                <div>
                    <h2 style="font-weight: 800; font-size: 1.5rem; margin: 0; color: #1e293b;">Sunrise <span style="color: var(--primary);">Dental</span></h2>
                    <p style="margin: 0; font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Clinical Portal</p>
                </div>
            </div>

            <h3 style="font-weight: 800; font-size: 2rem; margin-bottom: 10px; color: #1e293b;">Welcome back</h3>
            <p style="color: var(--text-muted); margin-bottom: 40px; font-weight: 500;">Enter your credentials to access the system.</p>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    <span>⚠️</span> Access Denied: Authentication failed.
                </div>
            <% } %>

            <% if("sent".equals(request.getParameter("report"))) { %>
                <div class="alert alert-success border-0 rounded-4 p-3 mb-4 shadow-sm text-center fw-bold" style="background-color: #f0fdf4; color: #15803d; font-size: 0.875rem;">
                    ✅ Recovery request transmitted to Administrator.
                </div>
            <% } %>

            <form action="auth" method="POST">
                <input type="hidden" name="action" value="login">

                <div class="input-group">
                    <label>System Identity</label>
                    <input type="text" name="username" class="login-input" placeholder="e.g. administrator" required>
                </div>

                <div class="input-group">
                    <label>Secure PassKey</label>
                    <input type="password" name="password" class="login-input" placeholder="••••••••••••" required>
                </div>

                <div style="text-align: right; margin-bottom: 30px;">
                    <a href="forgot_key.jsp" style="color: var(--primary); text-decoration: none; font-size: 0.875rem; font-weight: 700;">Reset your key?</a>
                </div>

                <button type="submit" class="action-btn">Sign in to Dashboard</button>
            </form>

            <div style="margin-top: 50px; border-top: 1px solid #f1f5f9; padding-top: 25px; text-align: center;">
                <p style="font-size: 0.75rem; color: #94a3b8; font-weight: 500;">&copy; 2024 Sunrise Clinical Group. Managed Infrastructure.</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
