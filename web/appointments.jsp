<%@ page import="com.clinic.model.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clinical Intake | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .type-selector {
            background: #f8fafc;
            border-radius: 12px;
            padding: 5px;
            display: inline-flex;
            margin-bottom: 2rem;
        }
        .type-btn {
            padding: 10px 25px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            font-size: 0.875rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .type-btn.active { background: white; color: var(--primary); shadow: var(--shadow); }
        .type-btn:not(.active) { color: var(--text-muted); background: transparent; }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <%
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        List<User> dentists = null;
        java.util.Map<String, Double> treatmentRates = null;
        try {
            dentists = facade.getDentists();
            treatmentRates = facade.getAllServiceRates();
        } catch(Exception e) {}
    %>

    <div class="page-header">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Patient Intake</h1>
            <p class="text-muted small">Process new or existing clinical patient sessions.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Back to Overview</a>
    </div>

    <% if(request.getParameter("success") != null) { %>
        <div class="max-width-850 mx-auto mb-4">
            <div class="alert alert-success border-0 rounded-4 p-4 shadow-sm d-flex align-items-center" style="background-color: #f0fdf4; color: #15803d;">
                <div class="me-3 fs-3">✅</div>
                <div>
                    <strong class="d-block">Success!</strong>
                    The session for Patient <strong>#<%= request.getParameter("pid") %></strong> is confirmed.
                </div>
            </div>
        </div>
    <% } %>

    <div class="max-width-850 mx-auto text-center">
        <div class="type-selector">
            <button type="button" class="type-btn active" id="newBtn" onclick="setMode('NEW')">New Patient</button>
            <button type="button" class="type-btn" id="existBtn" onclick="setMode('EXISTING')">Existing Patient</button>
        </div>
    </div>

    <div class="card form-card border-0 mb-5">
        <form action="appointments" method="POST">
            <input type="hidden" name="action" value="register">
            <input type="hidden" name="intake_mode" id="intakeMode" value="NEW">

            <div class="row mb-5">
                <div class="col-lg-4">
                    <h5 class="fw-bold text-dark">Identity Details</h5>
                    <p class="text-muted small">Verify patient history or create a new profile.</p>
                </div>
                <div class="col-lg-8">
                    <!-- Existing Patient Search -->
                    <div id="existingFields" style="display:none;">
                        <label class="form-label">Search Unique Patient ID</label>
                        <input type="number" name="existing_patient_id" class="form-control form-control-lg mb-2" placeholder="e.g. 101">
                        <small class="text-muted">Enter the ID generated during the first visit.</small>
                    </div>

                    <!-- New Patient Fields -->
                    <div id="newFields">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Assign Unique ID</label>
                                <input type="number" name="new_patient_id" class="form-control" placeholder="e.g. 501" required>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label">Legal Full Name</label>
                                <input type="text" name="name" class="form-control" placeholder="Alex Pandian">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact Number</label>
                                <input type="text" name="phone" class="form-control" placeholder="+94 ...">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Residential Address</label>
                                <input type="text" name="address" class="form-control" placeholder="City, Street">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Age</label>
                                <input type="number" name="age" class="form-control" placeholder="e.g. 25">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Sex (Gender)</label>
                                <select name="sex" class="form-select">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="my-5 opacity-25">

            <div class="row mb-4">
                <div class="col-lg-4">
                    <h5 class="fw-bold text-dark">Clinical Session</h5>
                    <p class="text-muted small">Assign a specialist and treatment goal.</p>
                </div>
                <div class="col-lg-8">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label">Assigned Specialist</label>
                            <select name="dentistId" class="form-select" required>
                                <option value="">Select a Dentist...</option>
                                <% if (dentists != null) { for(User d : dentists) { %>
                                    <option value="<%= d.getId() %>"><%= d.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Session Date & Time</label>
                            <input type="datetime-local" name="date" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Treatment Pathway</label>
                            <select name="treatment" class="form-select" required>
                                <option value="">Select Procedure...</option>
                                <% if (treatmentRates != null) { for(String tName : treatmentRates.keySet()) { %>
                                    <option value="<%= tName %>"><%= tName %></option>
                                <% } } %>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-5 pt-4 border-top d-flex justify-content-end gap-3">
                <a href="dashboard.jsp" class="btn-secondary-soft">Cancel & Discard</a>
                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold rounded-3 shadow">Confirm Appointment</button>
            </div>
        </form>
    </div>

    <script>
        function setMode(mode) {
            document.getElementById('intakeMode').value = mode;
            const newFields = document.getElementById('newFields');
            const existFields = document.getElementById('existingFields');
            const newBtn = document.getElementById('newBtn');
            const existBtn = document.getElementById('existBtn');
            
            const newIdInput = document.querySelector('input[name="new_patient_id"]');
            const existIdInput = document.querySelector('input[name="existing_patient_id"]');

            if (mode === 'NEW') {
                newFields.style.display = 'block';
                existFields.style.display = 'none';
                newBtn.classList.add('active');
                existBtn.classList.remove('active');
                if (newIdInput) newIdInput.required = true;
                if (existIdInput) existIdInput.required = false;
            } else {
                newFields.style.display = 'none';
                existFields.style.display = 'block';
                newBtn.classList.remove('active');
                existBtn.classList.add('active');
                if (newIdInput) newIdInput.required = false;
                if (existIdInput) existIdInput.required = true;
            }
        }
    </script>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
