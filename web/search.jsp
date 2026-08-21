<%@ page import="com.clinic.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Central Records | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <div class="page-header">
        <div>
            <h2 class="fw-bold mb-0 text-dark">Central Registry Repository</h2>
            <p class="text-muted small">Verified clinical documentation and appointment logs.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Back to Overview</a>
    </div>

    <div class="card p-5 max-width-600 mx-auto border-0 shadow-sm mb-5">
        <h3 class="fw-bold mb-4">🔍 Search Database</h3>
        <form class="mt-3 d-flex gap-2">
            <input type="number" name="id" class="form-control form-control-lg" placeholder="Enter Appointment ID" required>
            <button type="submit" class="btn btn-primary px-4 shadow">Retrieve</button>
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
        <div class="mt-5 p-4 rounded-4 bg-light border border-light-subtle">
            <div class="d-flex justify-content-between align-items-start mb-4">
                <h5 class="fw-bold text-primary m-0">RECORD: #<%= appt.getId() %></h5>
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2"><%= appt.getStatus() %></span>
            </div>

            <div class="row g-4">
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block fw-bold">Patient Profile</label>
                    <span class="text-dark"><%= appt.getPatientName() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block fw-bold">Session Type</label>
                    <span class="text-dark"><%= appt.getTreatmentType() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block fw-bold">Specialist</label>
                    <span class="text-dark"><%= appt.getDentistName() %></span>
                </div>
                <div class="col-6">
                    <label class="text-muted small text-uppercase d-block fw-bold">Timestamp</label>
                    <span class="text-dark"><%= appt.getAppointmentDate() %></span>
                </div>
            </div>

            <div class="mt-4 pt-4 border-top">
                <label class="text-primary small fw-bold text-uppercase d-block mb-2">Clinical Observations</label>
                <div class="p-3 bg-white rounded-3 border">
                    <p class="mb-2 small"><strong>Notes:</strong> <%= (appt.getClinicalNotes() != null) ? appt.getClinicalNotes() : "No clinical notes documented yet." %></p>
                    <p class="mb-0 small"><strong>Prescription:</strong> <%= (appt.getPrescribedMedicines() != null) ? appt.getPrescribedMedicines() : "Awaiting medical authorization." %></p>
                </div>
            </div>

            <% if ("COMPLETED".equals(appt.getStatus())) { %>
            <div class="mt-4 pt-3 text-end">
                <a href="bill.jsp?apptId=<%= appt.getId() %>" class="btn btn-sm btn-success px-4 fw-bold shadow-sm">Proceed to Finance →</a>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="mt-5 alert alert-warning rounded-4 border-0 shadow-sm d-flex align-items-center">
            <span class="me-2">⚠️</span> No record found for ID: <strong><%= idParam %></strong>
        </div>
        <% } } %>
    </div>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
