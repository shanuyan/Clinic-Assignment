<%@ page import="com.clinic.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Central Records | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <div class="page-header">
        <div>
            <h2 class="fw-bold mb-0 text-dark">Central Records</h2>
            <p class="text-muted small">Search and retrieve clinical appointment history from database.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Back to Dashboard</a>
    </div>

    <div class="card p-5 max-width-600 mx-auto border-0 shadow-sm">
        <h3 class="fw-bold mb-4">🔍 Search Registry</h3>
        <form class="mt-3 d-flex gap-2">
            <input type="number" name="id" class="form-control form-control-lg" placeholder="Enter ID (e.g. 1)" required>
            <button type="submit" class="btn btn-primary px-4">Search</button>
        </form>

        <%
            String idParam = request.getParameter("id");
            if (idParam != null) {
                com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
                Appointment appt = null;
                try {
                    appt = facade.searchAppointment(Integer.parseInt(idParam));
                } catch (Exception e) {}

                if (appt != null) {
        %>
        <div class="mt-5 p-4 rounded-4 bg-light border">
            <h5 class="fw-bold text-primary mb-3">Record Found: #<%= appt.getId() %></h5>
            <div class="row g-3">
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block">Patient Name</label>
                    <span class="fw-bold"><%= appt.getPatientName() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block">Treatment</label>
                    <span class="fw-bold"><%= appt.getTreatmentType() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block">Doctor</label>
                    <span class="fw-bold"><%= appt.getDentistName() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block">Date</label>
                    <span class="fw-bold"><%= appt.getAppointmentDate() %></span>
                </div>
            </div>
            <div class="mt-4 pt-3 border-top">
                <a href="bill.jsp?patient=<%= appt.getPatientName() %>&treatment=<%= appt.getTreatmentType() %>" class="btn btn-sm btn-success px-3">Generate Bill</a>
            </div>
        </div>
        <% } else { %>
        <div class="mt-5 alert alert-warning rounded-4 border-0">
            No record found for Appointment ID: <strong><%= idParam %></strong>
        </div>
        <% } } %>
    </div>

    <%@ include file="includes/footer.jsp" %>
