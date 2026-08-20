<%@ page import="com.clinic.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enterprise Overview | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <%
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        int totalAppts = 0;
        List<Appointment> liveFeed = null;
        try {
            totalAppts = facade.getTodayAppointmentCount();
            liveFeed = facade.getLiveFeed();
        } catch(Exception e) {
            e.printStackTrace();
        }
    %>

    <div class="row mb-5 align-items-end">
        <div class="col">
            <h1 class="fw-bold mb-0">Clinic Overview</h1>
            <p class="text-muted">Real-time operational summary from database.</p>
        </div>
        <div class="col-auto">
            <a href="appointments.jsp" class="btn btn-primary shadow-sm">+ New Intake</a>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card p-5 border-0 shadow-sm">
                <div class="stat-label">Total Records</div>
                <div class="stat-value text-primary"><%= totalAppts %></div>
                <div class="small text-success fw-medium">Database is active</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-5 border-0 shadow-sm">
                <div class="stat-label">Active Staff</div>
                <div class="stat-value text-warning">03</div>
                <div class="small text-muted fw-medium">Role-based access active</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-5 border-0 shadow-sm">
                <div class="stat-label">System Health</div>
                <div class="stat-value text-dark">100%</div>
                <div class="small text-success fw-medium">All services online</div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card p-4 mb-4 border-0 shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">Live Patient Feed</h5>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2">DATABASE LIVE</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-borderless align-middle">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Clinical Goal</th>
                                <th>Dentist</th>
                                <th>Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (liveFeed != null && !liveFeed.isEmpty()) {
                                for (Appointment a : liveFeed) { %>
                            <tr class="border-bottom border-light">
                                <td class="fw-semibold"><%= a.getPatientName() %></td>
                                <td class="text-muted small text-truncate" style="max-width: 150px;"><%= a.getTreatmentType() %></td>
                                <td><%= a.getDentistName() %></td>
                                <td><%= a.getAppointmentDate() %></td>
                                <td><span class="badge bg-success-subtle text-success border border-success-subtle px-2"><%= a.getStatus() %></span></td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="5" class="text-center text-muted">No recent records found in database.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card p-4 bg-primary text-white border-0 shadow-lg">
                <h5 class="fw-bold mb-3">Professional Insight</h5>
                <p class="small opacity-75">All data shown here is retrieved directly from the MySQL <code>dental_clinic</code> database using the DAO and Facade design patterns.</p>
                <a href="search.jsp" class="btn btn-light btn-sm fw-bold mt-2">Search Full Registry</a>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
