<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <% if (!"STAFF".equals(role) && !"ADMIN".equals(role)) { response.sendRedirect("dashboard.jsp"); return; } %>

    <h2 class="mb-4">Clinic Operations</h2>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 h-100">
                <h4 class="mb-4">Front Desk Actions</h4>
                <div class="d-grid gap-3">
                    <a href="appointments.jsp" class="btn btn-primary p-3">
                        <i class="bi bi-calendar-plus"></i> Book New Appointment
                    </a>
                    <a href="appointments.jsp" class="btn btn-info p-3 text-white">
                        <i class="bi bi-person-plus"></i> Register New Patient
                    </a>
                    <a href="bill.jsp" class="btn btn-success p-3">
                        <i class="bi bi-receipt"></i> Generate Billing
                    </a>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card p-4 shadow-sm border-0 h-100">
                <h4>Upcoming Appointments</h4>
                <hr>
                <div class="list-group list-group-flush">
                    <div class="list-group-item px-0">
                        <div class="d-flex justify-content-between">
                            <strong>Ravi Kumar</strong>
                            <span class="text-muted">10:00 AM</span>
                        </div>
                        <small>Treatment: Cleaning | Doctor: Dr. Arul</small>
                    </div>
                    <div class="list-group-item px-0">
                        <div class="d-flex justify-content-between">
                            <strong>Meena Selvam</strong>
                            <span class="text-muted">11:30 AM</span>
                        </div>
                        <small>Treatment: Consultation | Doctor: Dr. Arul</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
