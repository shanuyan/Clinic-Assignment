<%@ page import="com.clinic.service.ClinicFacade" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String treatment = request.getParameter("treatment");
    String patientName = request.getParameter("patient");
    ClinicFacade facade = new ClinicFacade();
    double total = 0;
    try {
        total = facade.getTreatmentCost(treatment);
    } catch (Exception e) {}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Bill - Sunrise Dental Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .bill-box { max-width: 600px; margin: 50px auto; padding: 30px; border: 1px solid #eee; box-shadow: 0 0 10px rgba(0,0,0,0.15); }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>
    <div class="bill-box bg-white">
        <h2 class="text-center">SUNRISE DENTAL CLINIC</h2>
        <p class="text-center">123, Galle Road, Colombo</p>
        <hr>
        <div class="row">
            <div class="col-6">
                <strong>Patient:</strong> <%= patientName %><br>
                <strong>Date:</strong> <%= new java.util.Date() %>
            </div>
            <div class="col-6 text-end">
                <strong>Receipt #:</strong> <%= System.currentTimeMillis() %>
            </div>
        </div>
        <table class="table mt-4">
            <thead>
                <tr>
                    <th>Description</th>
                    <th class="text-end">Amount (LKR)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><%= treatment %> Treatment</td>
                    <td class="text-end"><%= total - 1000 %></td>
                </tr>
                <tr>
                    <td>Consultation Fee</td>
                    <td class="text-end">1000.00</td>
                </tr>
                <tr class="table-active">
                    <td><strong>Total</strong></td>
                    <td class="text-end"><strong><%= total %></strong></td>
                </tr>
            </tbody>
        </table>
        <div class="text-center mt-4">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=Bill_<%= System.currentTimeMillis() %>" alt="QR Code">
            <p><small>Scan to view treatment history</small></p>
        </div>
        <div class="mt-4 text-center no-print">
            <button onclick="window.print()" class="btn btn-primary">Print Receipt</button>
            <a href="dashboard.jsp" class="btn btn-secondary">Back</a>
        </div>
    </div>
</body>
</html>
