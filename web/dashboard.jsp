<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Sunrise Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Sunrise Dental Clinic - <%= role %> Panel</a>
            <form action="auth" method="POST" class="d-flex">
                <input type="hidden" name="action" value="logout">
                <button class="btn btn-outline-light" type="submit">Logout</button>
            </form>
        </div>
    </nav>

    <div class="container mt-5">
        <h1>Welcome, <%= user %>!</h1>
        <p>You are logged in as: <strong><%= role %></strong></p>

        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card p-3">
                    <h3>Appointments</h3>
                    <p>Manage patient visits.</p>
                    <a href="appointments.jsp" class="btn btn-primary">Go to Appointments</a>
                </div>
            </div>
            <% if ("ADMIN".equals(role)) { %>
            <div class="col-md-4">
                <div class="card p-3">
                    <h3>User Management</h3>
                    <p>Add/Edit Staff and Doctors.</p>
                    <a href="users.jsp" class="btn btn-secondary">Manage Users</a>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
