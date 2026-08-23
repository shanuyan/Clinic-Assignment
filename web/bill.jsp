<%@ page import="com.clinic.model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Financial Settlement | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .bill-container { max-width: 750px; margin: 0 auto; background: white; padding: 50px; border-radius: 24px; box-shadow: var(--shadow-lg); border: 1px solid #f1f5f9; }
        .queue-card { border-radius: 16px; border: none; box-shadow: var(--shadow); overflow: hidden; }
        .table-invoice thead th { background: #f8fafc; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; padding: 1.25rem; border-bottom: 2px solid #f1f5f9; }
        @media print { .no-print { display: none; } body { background: white; } .bill-container { box-shadow: none; padding: 0; width: 100%; max-width: 100%; } }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <%
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        String selectedId = request.getParameter("apptId");
        List<Appointment> pending = null;
        Appointment current = null;
        double total = 0;

        try {
            if (selectedId == null) {
                pending = facade.getPendingBills();
            } else {
                current = facade.searchAppointment(Integer.parseInt(selectedId));
                total = facade.getTreatmentCost(current.getTreatmentType());
            }
        } catch(Exception e) {}
    %>

    <div class="page-header no-print">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Finance & Revenue</h1>
            <p class="text-muted small">Manage billing cycles and professional clinical invoices.</p>
        </div>
        <div class="d-flex gap-2">
            <% if(selectedId != null) { %><a href="bill.jsp" class="btn-secondary-soft">← Back to Queue</a><% } %>
            <a href="dashboard.jsp" class="btn-secondary-soft">Exit module</a>
        </div>
    </div>

    <% if("billed_success".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success border-0 rounded-4 p-3 mb-4 shadow-sm no-print">
            <strong>Payment Settled!</strong> The invoice has been closed and archived successfully.
        </div>
    <% } %>

    <% if(selectedId == null) { %>
        <!-- PROFESSIONAL BILLING QUEUE -->
        <div class="card queue-card">
            <div class="p-4 border-bottom bg-white d-flex justify-content-between align-items-center">
                <h5 class="fw-bold m-0">Finished Treatments <span class="badge bg-primary-subtle text-primary ms-2"><%= (pending != null) ? pending.size() : 0 %></span></h5>
                <span class="small text-muted fw-bold">READY FOR BILLING</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Patient Profile</th>
                            <th>Treatment Provided</th>
                            <th>Assigned Specialist</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (pending != null && !pending.isEmpty()) {
                            for (Appointment a : pending) { %>
                        <tr>
                            <td class="ps-4">
                                <div class="fw-bold text-dark"><%= a.getPatientName() %></div>
                                <div class="text-muted small">ID: #PAT-<%= a.getPatientId() %></div>
                            </td>
                            <td><span class="badge bg-info-subtle text-info px-3 py-2"><%= a.getTreatmentType() %></span></td>
                            <td class="text-muted small fw-semibold"><%= a.getDentistName() %></td>
                            <td>
                                <a href="bill.jsp?apptId=<%= a.getId() %>" class="btn btn-dark btn-sm px-4 fw-bold rounded-pill">Process Bill</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="4" class="text-center py-5 text-muted">No finished treatments awaiting billing at this moment.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else if (current != null) { %>
        <!-- ENTERPRISE INVOICE VIEW -->
        <div class="bill-container">
            <div class="d-flex justify-content-between mb-5">
                <div>
                    <h2 class="fw-bold text-primary mb-0">SUNRISE DENTAL</h2>
                    <p class="text-muted small">Professional Clinical Solutions<br>123, Galle Road, Colombo</p>
                </div>
                <div class="text-end">
                    <h4 class="fw-bold text-dark">INVOICE</h4>
                    <p class="text-muted small">Reference: <strong>#INV-<%= current.getId() %></strong><br>Date: <%= new java.util.Date() %></p>
                </div>
            </div>

            <div class="row mb-5 p-4 bg-light rounded-4">
                <div class="col-6">
                    <label class="small fw-bold text-muted text-uppercase d-block mb-1">Billing To</label>
                    <h5 class="fw-bold mb-1"><%= current.getPatientName() %></h5>
                    <p class="text-muted small mb-0">Registration ID: #PAT-<%= current.getPatientId() %></p>
                </div>
                <div class="col-6 text-end">
                    <label class="small fw-bold text-muted text-uppercase d-block mb-1">Medical Specialist</label>
                    <h5 class="fw-bold"><%= current.getDentistName() %></h5>
                </div>
            </div>

            <table class="table table-invoice mb-5">
                <thead>
                    <tr>
                        <th class="border-0">Description of Clinical Services</th>
                        <th class="border-0 text-end">Settlement (LKR)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="py-4 fw-medium"><%= current.getTreatmentType() %> Treatment <br><small class="text-muted">Clinical procedure completed as per session notes</small></td>
                        <td class="py-4 text-end fw-bold">LKR <%= String.format("%.2f", total) %></td>
                    </tr>
                    <tr class="border-top">
                        <td class="py-4 text-end fw-bold text-muted uppercase">Grand Total Amount Due</td>
                        <td class="py-4 text-end fw-bold fs-3 text-primary">LKR <%= String.format("%.2f", total) %></td>
                    </tr>
                </tbody>
            </table>

            <div class="text-center mb-5 no-print">
                <p class="text-muted small">This is a system-generated professional invoice. Scan to verify authenticity.</p>
                <%
                    String scheme = request.getScheme();
                    String serverName = request.getServerName();
                    int serverPort = request.getServerPort();
                    String contextPath = request.getContextPath();
                    String verifyUrl = scheme + "://" + serverName + ":" + serverPort + contextPath + "/verify.jsp?id=" + current.getId();
                %>
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=<%= java.net.URLEncoder.encode(verifyUrl, "UTF-8") %>" alt="QR" class="border p-2 rounded-3 shadow-sm">
                <p class="small text-muted mt-2 fw-bold" style="font-size: 0.65rem;">SECURE VERIFICATION TOKEN</p>
            </div>

            <div class="no-print d-flex gap-3 justify-content-center pt-4 border-top">
                <button onclick="window.print()" class="btn btn-outline-dark px-5 py-2 fw-bold rounded-pill">Print Invoice</button>
                <form action="clinical_actions" method="POST">
                    <input type="hidden" name="action" value="process_bill">
                    <input type="hidden" name="apptId" value="<%= current.getId() %>">
                    <button type="submit" class="btn btn-primary px-5 py-2 fw-bold rounded-pill shadow-sm">Mark as Paid & Close</button>
                </form>
            </div>
        </div>
    <% } %>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
