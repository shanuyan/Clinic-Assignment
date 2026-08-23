<%@ page import="com.clinic.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Official Record Verification | Sunrise Dental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f1f5f9; font-family: 'Inter', system-ui, -apple-system, sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 20px; }
        .v-card { background: white; width: 100%; max-width: 500px; border-radius: 28px; padding: 50px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
        .v-header { border-bottom: 2px solid #f1f5f9; padding-bottom: 30px; margin-bottom: 30px; }
        .v-badge { background: #dcfce7; color: #166534; padding: 6px 14px; border-radius: 99px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; }
        .field { margin-bottom: 24px; }
        .label { color: #94a3b8; font-size: 0.7rem; text-transform: uppercase; font-weight: 800; letter-spacing: 0.05em; margin-bottom: 6px; display: block; }
        .val { color: #1e293b; font-weight: 700; font-size: 1.15rem; line-height: 1.2; }
        .clinical-box { background: #f8fafc; border-radius: 16px; padding: 20px; margin-top: 10px; border: 1px solid #f1f5f9; }
        .clinical-text { font-size: 0.95rem; color: #475569; font-style: italic; }
    </style>
</head>
<body>
    <%
        String idParam = request.getParameter("id");
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        Appointment appt = null;
        if (idParam != null) {
            try { appt = facade.searchAppointment(Integer.parseInt(idParam)); } catch (Exception e) {}
        }
    %>

    <% if (appt != null) { %>
    <div class="v-card">
        <div class="v-header text-center">
            <div style="width: 50px; height: 50px; background: #4f46e5; border-radius: 14px; margin: 0 auto 20px; display: flex; align-items: center; justify-content: center; padding: 10px;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M4.5 10.1c.2 1.8 1.4 3.1 3.1 3.4 1.1.2 2.3-.2 3-1.1L12 11l1.4 1.4c.7.9 1.9 1.3 3 1.1 1.7-.3 2.9-1.6 3.1-3.4.2-2.1-.5-4.2-1.9-5.7C16.2 3 14.1 2.3 12 2.3s-4.2.7-5.6 2.1c-1.4 1.5-2.1 3.6-1.9 5.7z"/><path d="M12 21.7c-2.1 0-4.2-.7-5.6-2.1-1.4-1.5-2.1-3.6-1.9-5.7.1-.9.3-1.8.7-2.6"/><path d="M18.8 11.3c.4.8.6 1.7.7 2.6.2 2.1-.5 4.2-1.9 5.7-1.4 1.4-3.5 2.1-5.6 2.1"/></svg>
            </div>
            <div class="v-badge mb-3">Verified Digital Record</div>
            <h3 style="font-weight: 800; color: #1e293b; margin: 0;">Sunrise Dental Clinic</h3>
        </div>

        <div class="field">
            <span class="label">Patient Name</span>
            <span class="val"><%= appt.getPatientName() %></span>
        </div>

        <div class="row">
            <div class="col-6">
                <div class="field">
                    <span class="label">Treatment</span>
                    <span class="val"><%= appt.getTreatmentType() %></span>
                </div>
            </div>
            <div class="col-6">
                <div class="field">
                    <span class="label">Date</span>
                    <span class="val"><%= (appt.getAppointmentDate() != null && appt.getAppointmentDate().length() >= 10) ? appt.getAppointmentDate().substring(0, 10) : "Live Entry" %></span>
                </div>
            </div>
        </div>

        <div class="field">
            <span class="label">Consulting Specialist</span>
            <span class="val">Dr. <%= appt.getDentistName() %></span>
        </div>

        <div class="field">
            <span class="label">Clinical Documentation</span>
            <div class="clinical-box">
                <div class="label" style="font-size: 0.6rem; color: #64748b; margin-bottom: 10px;">Doctor's Diagnosis & Prescription</div>
                <div class="clinical-text">
                    <%= (appt.getClinicalNotes() != null) ? appt.getClinicalNotes() : "Clinical documentation pending." %>
                    <br><br>
                    <strong>Rx:</strong> <%= (appt.getPrescribedMedicines() != null) ? appt.getPrescribedMedicines() : "Standard recommendation." %>
                </div>
            </div>
        </div>

        <div style="margin-top: 40px; text-align: center; border-top: 1px solid #f1f5f9; padding-top: 20px;">
            <p style="font-size: 0.65rem; color: #94a3b8; font-weight: 700; text-transform: uppercase;">System Verified Record: INV-<%= appt.getId() %></p>
        </div>
    </div>
    <% } else { %>
    <div class="v-card text-center">
        <h4 class="text-danger mb-3">Invalid Link</h4>
        <p class="text-muted small">No record found in our verified repository.</p>
        <a href="index.jsp" class="btn btn-primary btn-sm mt-3">Return to Portal</a>
    </div>
    <% } %>
</body>
</html>
