<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Recovery | Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8fafc;
        }
        .recovery-card {
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        .icon-box {
            width: 60px;
            height: 60px;
            background: #fef2f2;
            color: #ef4444;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin: 0 auto 1.5rem;
        }
    </style>
</head>
<body>

<div class="recovery-card">
    <div class="icon-box">🔑</div>
    <h2 class="fw-bold text-dark mb-2">Access Recovery</h2>
    <p class="text-muted small mb-4">Forgotten your PassKey? Submit a report to the System Administrator to reset your credentials.</p>

    <form action="recovery_action" method="POST">
        <div style="text-align: left; margin-bottom: 20px;">
            <label class="form-label">Account Username</label>
            <input type="text" name="recovery_username" class="custom-input" placeholder="Enter your system ID" required>
        </div>

        <div style="text-align: left; margin-bottom: 24px;">
            <label class="form-label">Detailed Reason</label>
            <textarea name="reason" class="custom-input" rows="3" placeholder="Explain why you need a reset..." required></textarea>
        </div>

        <button type="submit" class="login-btn-premium">Submit Report to Admin</button>

        <div style="margin-top: 20px;">
            <a href="index.jsp" style="font-size: 0.85rem; color: #64748b; text-decoration: none; font-weight: 600;">← Return to Sign in</a>
        </div>
    </form>
</div>

</body>
</html>
