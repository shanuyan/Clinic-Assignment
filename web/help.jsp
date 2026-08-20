<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Knowledge Base | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <div class="page-header">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Knowledge Base & Support</h1>
            <p class="text-muted small">Step-by-step operational guide for clinic staff.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Exit to Dashboard</a>
    </div>

    <div class="card border-0 shadow-sm overflow-hidden mb-5">
        <div class="bg-primary p-5 text-white">
            <h3 class="fw-bold mb-2">How can we help you today?</h3>
            <p class="opacity-75 mb-0">Search our guides or browse common workflows below.</p>
        </div>
        <div class="p-5">
            <div class="row g-5">
                <div class="col-md-6">
                    <h5 class="fw-bold text-dark mb-4">Core Workflows</h5>
                    <div class="accordion accordion-flush" id="helpAccordion">
                        <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                            <h2 class="accordion-header">
                                <button class="accordion-button fw-bold py-3" type="button" data-bs-toggle="collapse" data-bs-target="#c1">
                                    Patient Registration & Intake
                                </button>
                            </h2>
                            <div id="c1" class="accordion-collapse collapse show">
                                <div class="accordion-body text-muted small lh-lg">
                                    1. Navigate to <strong>Clinical</strong> or click <strong>+ New Intake</strong>.<br>
                                    2. Capture patient demographics (Name, Phone, Address).<br>
                                    3. Assign a dentist and selecting the appropriate treatment goal.<br>
                                    4. Confirm to save the record to the central database.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed fw-bold py-3" type="button" data-bs-toggle="collapse" data-bs-target="#c2">
                                    Financial Settlement & Billing
                                </button>
                            </h2>
                            <div id="c2" class="accordion-collapse collapse">
                                <div class="accordion-body text-muted small lh-lg">
                                    1. Access the <strong>Finance</strong> module.<br>
                                    2. Select the patient and treatment type.<br>
                                    3. The system automatically calculates treatment cost + consultation fees.<br>
                                    4. Use the <strong>Print Receipt</strong> button to generate a professional invoice with a unique QR code.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <h5 class="fw-bold text-dark mb-4">System Roles</h5>
                    <div class="p-4 rounded-4 bg-light">
                        <ul class="list-unstyled small mb-0">
                            <li class="mb-3">
                                <span class="badge bg-primary px-2 me-2">Admin</span>
                                <span class="text-muted">Full control over users, settings, and infrastructure.</span>
                            </li>
                            <li class="mb-3">
                                <span class="badge bg-success px-2 me-2">Dentist</span>
                                <span class="text-muted">Clinical dashboard for patient queue and prescriptions.</span>
                            </li>
                            <li>
                                <span class="badge bg-info px-2 me-2">Staff</span>
                                <span class="text-muted">Operational access for booking and billing.</span>
                            </li>
                        </ul>
                    </div>
                    <div class="mt-4 p-4 rounded-4 border border-primary-subtle bg-primary-subtle text-primary">
                        <h6 class="fw-bold small mb-2">Technical Support</h6>
                        <p class="small mb-0">For database connectivity issues, please contact the System Administrator immediately.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>
