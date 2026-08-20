<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Operations Hub | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <% if (!"STAFF".equals(role) && !"ADMIN".equals(role)) { response.sendRedirect("dashboard.jsp"); return; } %>

    <div class="page-header">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Front Desk Operations</h1>
            <p class="text-muted">Orchestrate patient intake and financial transactions.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="appointments.jsp" class="btn btn-primary fw-bold px-4">Start New Intake</a>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-6">
            <div class="card p-5 border-0 shadow-sm h-100">
                <h4 class="fw-bold mb-4">Operational Shortcuts</h4>
                <div class="row g-3">
                    <div class="col-12">
                        <a href="appointments.jsp" class="card p-3 text-decoration-none border border-light-subtle hover-shadow transition-all">
                            <div class="d-flex align-items-center">
                                <div class="bg-primary-subtle text-primary rounded-3 p-3 me-3">📅</div>
                                <div>
                                    <div class="fw-bold text-dark">Schedule Appointment</div>
                                    <div class="text-muted small">Book slots for existing patients</div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-12">
                        <a href="appointments.jsp" class="card p-3 text-decoration-none border border-light-subtle hover-shadow transition-all">
                            <div class="d-flex align-items-center">
                                <div class="bg-info-subtle text-info rounded-3 p-3 me-3">👤</div>
                                <div>
                                    <div class="fw-bold text-dark">Register New Patient</div>
                                    <div class="text-muted small">Onboard first-time clinic visitors</div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-12">
                        <a href="bill.jsp" class="card p-3 text-decoration-none border border-light-subtle hover-shadow transition-all">
                            <div class="d-flex align-items-center">
                                <div class="bg-success-subtle text-success rounded-3 p-3 me-3">💳</div>
                                <div>
                                    <div class="fw-bold text-dark">Process Billing</div>
                                    <div class="text-muted small">Calculate fees and generate receipts</div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card p-5 border-0 shadow-sm h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold m-0">Upcoming Queue</h4>
                    <a href="search.jsp" class="small text-decoration-none fw-bold">View Registry</a>
                </div>
                <div class="list-group list-group-flush">
                    <div class="list-group-item px-0 py-3 border-light">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="fw-bold text-dark">Ravi Kumar</span>
                            <span class="badge bg-secondary-subtle text-secondary">10:00 AM</span>
                        </div>
                        <div class="text-muted small">Cleaning Treatment | Dr. Arul</div>
                    </div>
                    <div class="list-group-item px-0 py-3 border-light">
                        <div class="d-flex justify-content-between mb-1">
                            <span class="fw-bold text-dark">Meena Selvam</span>
                            <span class="badge bg-secondary-subtle text-secondary">11:30 AM</span>
                        </div>
                        <div class="text-muted small">General Consultation | Dr. Arul</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
