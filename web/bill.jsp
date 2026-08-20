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
        .bill-container { max-width: 700px; margin: 0 auto; background: white; padding: 40px; border-radius: 20px; box-shadow: var(--shadow); }
        @media print { .no-print { display: none; } body { background: white; } .bill-container { box-shadow: none; padding: 0; } }
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
            <h1 class="fw-bold mb-0 text-dark">Finance & Billing</h1>
            <p class="text-muted small">Process clinical reports and generate patient invoices.</p>
        </div>
        <a href="dashboard.jsp" class="btn-secondary-soft">← Back to Overview</a>
    </div>

    <% if(selectedId == null) { %>
        <!-- View 1: Pending Billing Queue -->
        <div class="card border-0 shadow-sm overflow-hidden mb-5">
            <div class="p-4 border-bottom bg-white d-flex justify-content-between align-items-center">
                <h5 class="fw-bold m-0">Pending Billing Queue</h5>
                <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-3 py-2">AWAITING SETTLEMENT</span>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Patient Name</th>
                            <th>Clinical Goal</th>
                            <th>Specialist</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (pending != null && !pending.isEmpty()) {
                            for (Appointment a : pending) { %>
                        <tr>
                            <td class="ps-4 fw-bold"><%= a.getPatientName() %></td>
                            <td><span class="badge bg-primary-subtle text-primary"><%= a.getTreatmentType() %></span></td>
                            <td class="text-muted small"><%= a.getDentistName() %></td>
                            <td>
                                <a href="bill.jsp?apptId=<%= a.getId() %>" class="btn btn-sm btn-primary px-3 fw-bold">Process Bill</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="4" class="text-center py-5 text-muted">No pending clinical reports found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } else if (current != null) { %>
        <!-- View 2: Invoice Generation -->
        <div class="bill-container">
            <div class="d-flex justify-content-between align-items-start mb-5">
                <div>
                    <h2 class="fw-bold text-primary mb-0">SUNRISE DENTAL</h2>
                    <p class="text-muted small">123, Galle Road, Colombo<br>+94 11 234 5678</p>
                </div>
                <div class="text-end">
                    <h4 class="fw-bold text-dark">INVOICE</h4>
                    <p class="text-muted small">Date: <%= new java.util.Date() %><br>Ref: #INV-<%= current.getId() %></p>
                </div>
            </div>

            <div class="row mb-5">
                <div class="col-6">
                    <label class="small fw-bold text-muted text-uppercase d-block">Billed To</label>
                    <h5 class="fw-bold"><%= current.getPatientName() %></h5>
                    <p class="text-muted small">Patient ID: #PAT-<%= current.getPatientId() %></p>
                </div>
                <div class="col-6 text-end">
                    <label class="small fw-bold text-muted text-uppercase d-block">Consulting Specialist</label>
                    <h5 class="fw-bold"><%= current.getDentistName() %></h5>
                </div>
            </div>

            <table class="table mb-5">
                <thead>
                    <tr class="bg-light">
                        <th class="border-0">Description</th>
                        <th class="border-0 text-end">Amount (LKR)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="py-3"><%= current.getTreatmentType() %> - Clinical Procedure</td>
                        <td class="py-3 text-end"><%= total - 1000 %>.00</td>
                    </tr>
                    <tr>
                        <td class="py-3">Consultation & Facility Fee</td>
                        <td class="py-3 text-end">1000.00</td>
                    </tr>
                    <tr class="border-top border-dark">
                        <td class="py-3 fw-bold">Total Settlement Amount</td>
                        <td class="py-3 text-end fw-bold fs-4 text-primary">LKR <%= total %>0</td>
                    </tr>
                </tbody>
            </table>

            <div class="text-center mb-5">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=INV_<%= current.getId() %>" alt="QR Code" class="mb-2">
                <p class="text-muted" style="font-size: 10px;">Scan to verify digital clinical record</p>
            </div>

            <div class="no-print d-flex gap-3 justify-content-center">
                <button onclick="window.print()" class="btn btn-outline-dark px-4 fw-bold">Print Receipt</button>
                <form action="clinical_actions" method="POST">
                    <input type="hidden" name="action" value="process_bill">
                    <input type="hidden" name="apptId" value="<%= current.getId() %>">
                    <button type="submit" class="btn btn-primary px-4 fw-bold">Mark as Paid & Close</button>
                </form>
                <a href="bill.jsp" class="btn btn-light px-4 fw-bold">Cancel</a>
            </div>
        </div>
    <% } %>

    <%@ include file="includes/footer.jsp" %>
</body>
</html>
