<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Appointment - Sunrise Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Register New Appointment</h2>
        <form action="appointments" method="POST" class="mt-4">
            <input type="hidden" name="action" value="register">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Patient Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Address</label>
                <textarea name="address" class="form-control" required></textarea>
            </div>
            <div class="row">
                <div class="col-md-4 mb-3">
                    <label class="form-label">Dentist ID</label>
                    <input type="number" name="dentistId" class="form-control" required>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Date & Time</label>
                    <input type="datetime-local" name="date" class="form-control" required>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Treatment Type</label>
                    <select name="treatment" class="form-control">
                        <option value="Cleaning">Cleaning</option>
                        <option value="Root Canal">Root Canal</option>
                        <option value="Extraction">Extraction</option>
                        <option value="Consultation">Consultation</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn btn-success">Book Appointment</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Back</a>
        </form>
    </div>
</body>
</html>
