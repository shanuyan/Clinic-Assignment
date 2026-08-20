<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Clinical Intake | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body data-theme="light">
    <%@ include file="includes/header.jsp" %>

    <div class="page-header">
        <div>
            <h2 class="fw-bold mb-0 text-dark">Patient Intake Form</h2>
            <p class="text-muted small">Register a new patient and schedule treatment.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Back to Overview</a>
    </div>

    <div class="card form-card shadow-sm border-0">
        <form action="appointments" method="POST">
            <input type="hidden" name="action" value="register">

            <h5 class="fw-bold mb-4 text-primary">Patient Demographics</h5>
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold text-uppercase">Full Name</label>
                    <input type="text" name="name" class="form-control form-control-lg" required placeholder="Enter full name">
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold text-uppercase">Contact Number</label>
                    <input type="text" name="phone" class="form-control form-control-lg" required placeholder="+94 ...">
                </div>
                <div class="col-12">
                    <label class="form-label text-muted small fw-bold text-uppercase">Residential Address</label>
                    <textarea name="address" class="form-control" rows="2" placeholder="Street, City, Postal Code"></textarea>
                </div>
            </div>

            <hr class="my-5 opacity-25">

            <h5 class="fw-bold mb-4 text-primary">Clinical Details</h5>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Assigned Dentist</label>
                    <select name="dentistId" class="form-select form-control-lg">
                        <option value="2">Dr. Arul</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Schedule Date</label>
                    <input type="datetime-local" name="date" class="form-control form-control-lg" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Treatment Goal</label>
                    <select name="treatment" class="form-select form-control-lg">
                        <option value="Consultation">Consultation</option>
                        <option value="Cleaning">Prophylaxis (Cleaning)</option>
                        <option value="Root Canal">Endodontics (Root Canal)</option>
                        <option value="Extraction">Exodontia (Extraction)</option>
                    </select>
                </div>
            </div>

            <div class="mt-5 d-flex gap-3">
                <button type="submit" class="btn btn-primary px-5 py-2 fw-bold">Confirm Registration</button>
                <a href="dashboard.jsp" class="btn-secondary-soft px-4 py-2">Cancel Intake</a>
            </div>
        </form>
    </div>

    <%@ include file="includes/footer.jsp" %>
