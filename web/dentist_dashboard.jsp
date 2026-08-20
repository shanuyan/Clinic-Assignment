<%@ page import="com.clinic.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Clinical Dashboard | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <%
        if (!"DENTIST".equals(role)) { response.sendRedirect("dashboard.jsp"); return; }
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        List<Appointment> myAppts = null;
        try {
            myAppts = facade.getDentistAppointments(user);
        } catch(Exception e) {}
    %>

    <h2 class="mb-4 text-dark fw-bold">Clinical Dashboard</h2>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card p-4 shadow-sm border-0 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold m-0 text-muted small text-uppercase">Practice Trends</h5>
                    <span class="text-success small fw-bold">Live Data</span>
                </div>
                <canvas id="performanceChart" height="120"></canvas>
            </div>

            <div class="card p-4 shadow-sm border-0">
                <h5 class="fw-bold mb-4 text-primary">Clinical Session Entry</h5>
                <form>
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold text-uppercase">Active Patient</label>
                        <select class="form-select">
                            <option>Select from queue...</option>
                            <% if (myAppts != null) { for(Appointment a : myAppts) { %>
                                <option><%= a.getPatientName() %> (<%= a.getTreatmentType() %>)</option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold text-uppercase">Findings & Diagnosis</label>
                        <textarea class="form-control" rows="3" placeholder="Enter clinical observations..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-muted small fw-bold text-uppercase">Prescription</label>
                        <textarea class="form-control" rows="2" placeholder="Medication, dosage, duration..."></textarea>
                    </div>
                    <button type="button" class="btn btn-primary px-4 py-2 fw-bold">Finalize Session</button>
                </form>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0 h-100">
                <h5 class="fw-bold mb-4 text-primary">Patient Queue</h5>
                <div class="list-group list-group-flush">
                    <% if (myAppts != null && !myAppts.isEmpty()) {
                        for (Appointment a : myAppts) { %>
                    <div class="list-group-item rounded-3 mb-2 border p-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1 fw-bold"><%= a.getPatientName() %></h6>
                                <p class="mb-0 text-muted small"><%= a.getTreatmentType() %></p>
                            </div>
                            <span class="badge bg-primary-subtle text-primary"><%= a.getAppointmentDate().substring(11) %></span>
                        </div>
                    </div>
                    <% } } else { %>
                    <p class="text-center text-muted py-5">No patients in your queue today.</p>
                    <% } %>
                </div>
                <button class="btn btn-outline-primary btn-sm w-100 mt-auto">Update Availability</button>
            </div>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('performanceChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                datasets: [{
                    label: 'Cases Handled',
                    data: [<%= (myAppts != null) ? myAppts.size() : 0 %>, 8, 4, 10, 6, 9],
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.05)',
                    fill: true,
                    tension: 0.4
                }]
            }
        });
    </script>

    <%@ include file="includes/footer.jsp" %>
