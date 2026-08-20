<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <% if (!"ADMIN".equals(role)) { response.sendRedirect("dashboard.jsp"); return; } %>

    <h2 class="mb-4">Administrative Control</h2>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card p-4 shadow-sm border-0">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4>User Management</h4>
                    <button class="btn btn-primary btn-sm">+ Add New User</button>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Dr. Arul</strong></td>
                                <td><span class="badge bg-info text-dark">Dentist</span></td>
                                <td>arul@clinic.com</td>
                                <td><span class="badge bg-success">Active</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary">Edit</button>
                                    <button class="btn btn-sm btn-outline-danger">Disable</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0 bg-primary text-white mb-4">
                <h4>System Analytics</h4>
                <p>Monthly Growth: +15%</p>
                <hr>
                <p>Top Service: Root Canal</p>
            </div>
            <div class="card p-4 shadow-sm border-0">
                <h4>System Logs</h4>
                <ul class="list-unstyled small">
                    <li class="mb-2">✅ Admin logged in at 10:00 AM</li>
                    <li class="mb-2">📝 New patient registered by Staff1</li>
                    <li class="mb-2">💰 Bill generated for Appt #102</li>
                </ul>
                <button class="btn btn-link btn-sm p-0">View All Logs</button>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
