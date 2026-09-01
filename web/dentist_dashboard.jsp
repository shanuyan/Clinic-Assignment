<%@ page import="com.clinic.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clinical Dashboard | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <%
        if (!"DENTIST".equals(role)) { response.sendRedirect("dashboard.jsp"); return; }
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        List<Appointment> myAppts = null;
        try {
            myAppts = facade.getDentistAppointments(user);
        } catch(Exception e) {}
    %>

    <div class="page-header">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Clinical Dashboard</h1>
            <p class="text-muted small">Managing patient queue and session documentation.</p>
        </div>
    </div>

    <% if("logged_in".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success border-0 rounded-4 p-3 mb-4 shadow-sm animate-fade-in d-flex align-items-center">
            <span class="me-3 fs-4">👨‍⚕️</span>
            <div class="fw-bold">Login Successful! Welcome to your clinical workspace.</div>
        </div>
    <% } %>

    <% if("session_saved".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success border-0 rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center animate-fade-in">
            <span class="me-3 fs-4">✅</span>
            <div>
                <strong>Session Finalized!</strong> The clinical report has been sent to the Finance department for billing.
            </div>
        </div>
    <% } %>

    <% if("unavailability_reported".equals(request.getParameter("status"))) { %>
        <div class="alert alert-info border-0 rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center animate-fade-in">
            <span class="me-3 fs-4">📅</span>
            <div>
                <strong>Notified!</strong> Your unavailability has been reported to the System Administrator.
            </div>
        </div>
    <% } %>

    <% if("error".equals(request.getParameter("status"))) { %>
        <div class="alert alert-danger border-0 rounded-4 p-3 mb-4 shadow-sm d-flex align-items-center animate-fade-in">
            <span class="me-3 fs-4">❌</span>
            <div class="fw-bold">Operation failed: Clinical data could not be transmitted.</div>
        </div>
    <% } %>

    <div class="row g-4">
        <div class="col-md-8">
            <div class="card p-4 shadow-sm border-0 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold m-0 text-muted small text-uppercase">Practice Trends</h5>
                </div>
                <canvas id="performanceChart" height="120"></canvas>
            </div>

            <div class="card p-4 shadow-sm border-0">
                <h5 class="fw-bold mb-4 text-primary">Active Session Documentation</h5>
                <form action="clinical_actions" method="POST">
                    <input type="hidden" name="action" value="finalize">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Active Patient Session</label>
                        <select name="apptId" class="form-select" required>
                            <option value="">Select from your queue...</option>
                            <% if (myAppts != null) { for(Appointment a : myAppts) {
                                if(!"BILLED".equals(a.getStatus()) && !"COMPLETED".equals(a.getStatus())) { %>
                                <option value="<%= a.getId() %>"><%= a.getPatientName() %> - <%= a.getTreatmentType() %></option>
                            <% } } } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Diagnosis & Clinical Findings</label>
                        <textarea name="notes" class="form-control" rows="3" placeholder="Enter clinical observations..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase">Digital Prescription</label>
                        <textarea name="medicines" class="form-control" rows="2" placeholder="List medications and dosage..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary px-4 py-2 fw-bold">Complete & Send to Billing</button>
                </form>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow-sm border-0 h-100">
                <h5 class="fw-bold mb-4 text-primary">Live Patient Queue</h5>
                <div class="list-group list-group-flush mb-4">
                    <% if (myAppts != null && !myAppts.isEmpty()) {
                        for (Appointment a : myAppts) {
                            if(!"BILLED".equals(a.getStatus())) { %>
                    <div class="list-group-item rounded-3 mb-2 border p-3 <%= "COMPLETED".equals(a.getStatus()) ? "bg-light opacity-50" : "" %>">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="mb-1 fw-bold"><%= a.getPatientName() %></h6>
                                <p class="mb-0 text-muted small"><%= a.getTreatmentType() %></p>
                            </div>
                            <span class="badge <%= "COMPLETED".equals(a.getStatus()) ? "bg-success" : "bg-primary" %>-subtle <%= "COMPLETED".equals(a.getStatus()) ? "text-success" : "text-primary" %>">
                                <%= "COMPLETED".equals(a.getStatus()) ? "Sent to Bill" : a.getAppointmentDate().substring(11) %>
                            </span>
                        </div>
                    </div>
                    <% } } } else { %>
                    <p class="text-center text-muted py-5">Queue is empty.</p>
                    <% } %>
                </div>

                <hr class="my-4 opacity-25">

                <h5 class="fw-bold mb-3 text-danger small text-uppercase">Report Unavailability</h5>
                <form action="clinical_actions" method="POST">
                    <input type="hidden" name="action" value="report_unavailability">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Select Date</label>
                        <input type="date" name="unavailable_date" class="form-control form-control-sm" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Reason (Optional)</label>
                        <input type="text" name="reason" class="form-control form-control-sm" placeholder="e.g. Conference">
                    </div>
                    <button type="submit" class="btn btn-outline-danger btn-sm w-100 fw-bold">Notify Administrator</button>
                </form>
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
                    data: [5, 8, 4, 10, 6, 9],
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.05)',
                    fill: true,
                    tension: 0.4
                }]
            }
        });
    </script>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
