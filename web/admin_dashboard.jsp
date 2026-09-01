<%@ page import="com.clinic.model.User" %>
<%@ page import="com.clinic.model.Appointment" %>
<%@ page import="com.clinic.model.PasswordRequest" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Administration | Sunrise Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .activity-card { transition: all 0.3s ease; }
        .activity-card:hover { background-color: #f8fafc; }
        .table-clinical thead th {
            position: sticky;
            top: 0;
            background: #f8fafc !important;
            z-index: 10;
            box-shadow: inset 0 -1px 0 var(--border-color);
        }
        .clinical-frame {
            max-height: 400px;
            overflow-y: auto;
            scrollbar-width: thin;
        }
        .badge-pulse { width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: 8px; }
    </style>
</head>
<body>
    <%@ include file="includes/header.jsp" %>

    <%
        if (!"ADMIN".equals(role)) { response.sendRedirect("dashboard.jsp"); return; }
        com.clinic.service.ClinicFacade facade = new com.clinic.service.ClinicFacade();
        List<User> userList = null;
        List<Appointment> recentAppts = null;
        List<String> auditLogs = null;
        List<PasswordRequest> passRequests = null;
        List<String> doctorAlerts = null;
        java.util.Map<String, Double> rates = null;
        try {
            userList = facade.getSystemUsers();
            recentAppts = facade.getLiveFeed();
            auditLogs = facade.getAuditLogs();
            rates = facade.getAllServiceRates();
            passRequests = facade.getPendingPassRequests();
            doctorAlerts = facade.getClinicalUnavailability();
        } catch(Exception e) {}
    %>

    <div class="page-header">
        <div>
            <h1 class="fw-bold mb-0 text-dark">Administrative Control</h1>
            <p class="text-muted small">Managing core infrastructure and clinical operations registry.</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary fw-bold px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#userModal">+ New Identity</button>
            <button class="btn btn-primary fw-bold px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#priceModal">Configure Rates</button>
        </div>
    </div>

    <!-- Feedback Alerts -->
    <% if(request.getParameter("status") != null || request.getParameter("error") != null) {
        String status = request.getParameter("status");
        String error = request.getParameter("error");
        String msg = "";
        String type = "success";

        if("onboarded".equals(status)) msg = "System Identity provisioned successfully!";
        else if("logged_in".equals(status)) msg = "Authentication successful. Welcome back to the command center!";
        else if("pass_updated".equals(status)) msg = "Access Key has been updated securely.";
        else if("ticket_resolved".equals(status)) msg = "Security ticket marked as resolved.";
        else if("rates_updated".equals(status)) msg = "Clinical pricing architecture updated.";
        else if("treatment_added".equals(status)) msg = "New clinical procedure added to catalog.";

        if("action_failed".equals(error)) { msg = "System error: Operation could not be completed."; type = "danger"; }

        if(!msg.isEmpty()) { %>
        <div class="alert alert-<%= type %> border-0 rounded-4 p-3 mb-4 shadow-sm animate-fade-in d-flex align-items-center">
            <span class="me-3 fs-4"><%= "danger".equals(type) ? "❌" : "✅" %></span>
            <div class="fw-bold"><%= msg %></div>
        </div>
    <% } } %>

    <!-- Stats Section -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="card p-4 border-0 shadow-sm border-start border-primary border-4">
                <div class="stat-label">Revenue Growth</div>
                <div class="stat-value text-primary">+14.2%</div>
                <div class="small text-muted">System Benchmark</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-4 border-0 shadow-sm border-start border-success border-4">
                <div class="stat-label">Verified Staff</div>
                <div class="stat-value text-dark"><%= (userList != null) ? userList.size() : 0 %></div>
                <div class="small text-muted">Active Access Points</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-4 border-0 shadow-sm border-start border-info border-4">
                <div class="stat-label">Daily Load</div>
                <div class="stat-value text-dark"><%= (recentAppts != null) ? recentAppts.size() : 0 %></div>
                <div class="small text-muted">Clinical Capacity</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card p-4 border-0 shadow-sm border-start border-warning border-4">
                <div class="stat-label">Satisfaction</div>
                <div class="stat-value text-dark">98%</div>
                <div class="small text-muted">Service Quality</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Identity Management -->
        <div class="col-lg-12 mb-4">
            <div class="card border-0 shadow-sm overflow-hidden">
                <div class="p-4 border-bottom bg-white d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold m-0">System Identities & Authorization</h5>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">FullName & Identity</th>
                                <th>Authorization Role</th>
                                <th>Management Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userList != null) { for(User u : userList) { %>
                            <tr>
                                <td class="ps-4 fw-bold">
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="<%= (u.getProfileImage() != null && !u.getProfileImage().isEmpty() && !u.getProfileImage().equals("default_avatar.png")) ? u.getProfileImage() : "https://api.dicebear.com/7.x/adventurer/svg?seed=" + u.getUsername() %>" 
                                             class="rounded-circle border border-2 border-primary-subtle shadow-sm" 
                                             style="width: 45px; height: 45px; object-fit: cover;" 
                                             onerror="this.src='https://api.dicebear.com/7.x/adventurer/svg?seed=<%= u.getUsername() %>'">
                                        <div>
                                            <%= u.getFullName() %>
                                            <br><small class="text-muted fw-normal">System ID: <%= u.getUsername() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td><span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2"><%= u.getRole() %></span></td>
                                <td>
                                    <button class="btn btn-sm btn-dark fw-bold rounded-pill px-4" onclick="openResetModal('<%= u.getId() %>')">Reset PassKey</button>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Clinical Activity (Now in full width for better look) -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm overflow-hidden">
                <div class="p-4 border-bottom bg-white d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold m-0 text-dark">Recent Clinical Activity Log</h5>
                    <span class="badge bg-success-subtle text-success">Live Updates</span>
                </div>
                <div class="table-responsive clinical-frame">
                    <table class="table table-hover align-middle m-0 table-clinical">
                        <thead>
                            <tr class="text-muted small text-uppercase">
                                <th class="ps-4">Patient Profile</th>
                                <th>Clinical Goal</th>
                                <th>Assigned Specialist</th>
                                <th>Schedule</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentAppts != null) { for(Appointment a : recentAppts) { %>
                            <tr class="activity-card">
                                <td class="ps-4">
                                    <div class="fw-bold text-dark"><%= a.getPatientName() %></div>
                                    <div class="text-muted" style="font-size: 11px;">#PAT-<%= a.getPatientId() %></div>
                                </td>
                                <td><span class="fw-medium text-dark"><%= a.getTreatmentType() %></span></td>
                                <td><div class="text-muted small fw-semibold"><%= a.getDentistName() %></div></td>
                                <td>
                                    <div class="small fw-bold text-dark"><%= a.getAppointmentDate().substring(11) %></div>
                                    <div class="text-muted" style="font-size: 10px;"><%= a.getAppointmentDate().substring(0, 10) %></div>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="4" class="text-center py-5 text-muted">No records found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Audit Logs (Right Side) -->
        <div class="col-lg-4">
            <div class="card p-4 border-0 shadow-sm h-auto mb-4">
                <h5 class="fw-bold mb-4 text-dark">Security Tickets (New)</h5>
                <div class="list-group list-group-flush">
                    <% if (passRequests != null && !passRequests.isEmpty()) {
                        for(PasswordRequest pr : passRequests) { %>
                        <div class="list-group-item px-0 border-light py-3">
                            <div class="d-flex justify-content-between mb-1">
                                <span class="fw-bold text-danger">@<%= pr.getUsername() %></span>
                                <small class="text-muted"><%= pr.getRequestTime() %></small>
                            </div>
                            <p class="small text-muted mb-2"><%= pr.getReason() %></p>
                            <div class="d-flex gap-2">
                                <form action="admin_actions" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="resolve_ticket">
                                    <input type="hidden" name="ticketId" value="<%= pr.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-success fw-bold px-3 rounded-pill">Done</button>
                                </form>
                                <button class="btn btn-sm btn-outline-primary fw-bold px-3 rounded-pill"
                                        onclick="openResetModalByUsername('<%= pr.getUsername() %>')">Fix Key</button>
                            </div>
                        </div>
                    <% } } else { %>
                        <p class="text-muted small">No pending security requests.</p>
                    <% } %>
                </div>
            </div>

            <div class="card p-4 border-0 shadow-sm h-auto mb-4 bg-light">
                <h5 class="fw-bold mb-4 text-dark">Specialist Leave Reports</h5>
                <div class="list-group list-group-flush">
                    <% if (doctorAlerts != null && !doctorAlerts.isEmpty()) {
                        for(String alert : doctorAlerts) { %>
                        <div class="list-group-item px-0 border-0 py-2 small">
                            <i class="text-danger me-2">📅</i> <%= alert %>
                        </div>
                    <% } } else { %>
                        <p class="text-muted small">No leave reports from doctors.</p>
                    <% } %>
                </div>
            </div>

            <div class="card p-4 border-0 shadow-sm h-100">
                <h5 class="fw-bold mb-4 text-dark border-bottom pb-3">Security Audit Trail</h5>
                <div class="list-group list-group-flush small">
                    <% if (auditLogs != null) { for(String log : auditLogs) { %>
                        <div class="list-group-item px-0 border-light py-3">
                            <div class="d-flex align-items-start">
                                <span class="badge-pulse bg-primary mt-1"></span>
                                <div><%= log %></div>
                            </div>
                        </div>
                    <% } } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals (Centred and Fixed) -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-header border-0 p-4 pb-0">
                    <h4 class="fw-bold m-0">Specialist Provisioning</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="admin_actions" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="register">
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Legal Full Name</label>
                                <input type="text" name="name" class="form-control" placeholder="Dr. Alex Pandian" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Clinical ID (Username)</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Security PassKey</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted text-uppercase">Access Permission</label>
                                <select name="role" id="roleSelect" class="form-select" onchange="toggleDocFields()">
                                    <option value="DENTIST">DENTIST (Medical)</option>
                                    <option value="STAFF">STAFF (Operations)</option>
                                </select>
                            </div>
                        </div>
                        <div class="row g-3 mb-4">
                            <div class="col-md-12">
                                <label class="form-label small fw-bold text-muted text-uppercase mb-2">Profile Image Setup</label>
                                
                                <ul class="nav nav-pills mb-3 gap-2" id="imageSourceTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active small py-1.5 px-3 fw-bold rounded-pill" id="upload-tab" data-bs-toggle="pill" data-bs-target="#upload-pane" type="button" role="tab" aria-controls="upload-pane" aria-selected="true">📤 Upload Image</button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link small py-1.5 px-3 fw-bold rounded-pill" id="preset-tab" data-bs-toggle="pill" data-bs-target="#preset-pane" type="button" role="tab" aria-controls="preset-pane" aria-selected="false">✨ Choose Preset / URL</button>
                                    </li>
                                </ul>
                                
                                <div class="tab-content" id="imageSourceTabContent">
                                    <!-- Upload Pane -->
                                    <div class="tab-pane fade show active" id="upload-pane" role="tabpanel" aria-labelledby="upload-tab">
                                        <div class="d-flex align-items-center gap-4 p-3 bg-light rounded-4 border border-light-subtle">
                                            <div class="position-relative">
                                                <img id="imagePreview" src="https://api.dicebear.com/7.x/adventurer/svg?seed=placeholder" 
                                                     class="rounded-circle border border-3 border-primary-subtle shadow-sm" 
                                                     style="width: 85px; height: 85px; object-fit: cover;"
                                                     onerror="this.src='https://api.dicebear.com/7.x/adventurer/svg?seed=placeholder'">
                                            </div>
                                            <div class="flex-grow-1">
                                                <input type="file" name="profile_image_file" id="profileImageFile" accept="image/*" class="form-control form-control-sm mb-2" onchange="previewUploadFile(this)">
                                                <small class="text-muted d-block" style="font-size: 11px;">Recommended: Square ratio, max 2MB (JPEG, PNG, WEBP)</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Preset Pane -->
                                    <div class="tab-pane fade" id="preset-pane" role="tabpanel" aria-labelledby="preset-tab">
                                        <div class="p-3 bg-light rounded-4 border border-light-subtle mb-3">
                                            <input type="text" name="profile_image" id="profileImageInput" class="form-control" placeholder="https://example.com/image.jpg or select a preset below..." oninput="previewUrlChange(this.value)">
                                        </div>
                                        
                                        <label class="form-label small fw-bold text-muted text-uppercase d-block mb-2">Quick Avatar Presets</label>
                                        <div class="d-flex gap-3 flex-wrap align-items-center">
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1594824813573-246434de83fb?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1594824813573-246434de83fb?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                            <div class="preset-avatar-wrapper" style="cursor: pointer;" onclick="selectPreset('https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=150&auto=format&fit=crop')">
                                                <img src="https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=150&auto=format&fit=crop" class="rounded-circle border border-2 preset-avatar" style="width:45px; height:45px; object-fit:cover; transition: all 0.2s;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="doctorFields" class="p-4 bg-light rounded-4 mb-4 border border-light-subtle">
                            <h6 class="fw-bold text-primary mb-3">Professional Credentials</h6>
                            <div class="row g-3">
                                <div class="col-md-4"><label class="small fw-bold">License No.</label><input type="text" name="license" class="form-control"></div>
                                <div class="col-md-4"><label class="small fw-bold">Specialization</label><input type="text" name="spec" class="form-control"></div>
                                <div class="col-md-4"><label class="small fw-bold">Experience (Yrs)</label><input type="number" name="exp" class="form-control" value="0"></div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-3 rounded-3 shadow-sm">Authorize Specialist</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Password Reset Modal -->
    <div class="modal fade" id="resetModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-body p-5 text-center">
                    <div class="text-primary fs-1 mb-3">🛡️</div>
                    <h4 class="fw-bold mb-4">Reset System PassKey</h4>
                    <form action="admin_actions" method="POST">
                        <input type="hidden" name="action" value="reset_pass">
                        <input type="hidden" name="userId" id="resetUid">
                        <div class="mb-4 text-start">
                            <label class="form-label small fw-bold text-muted text-uppercase">New Access Key</label>
                            <input type="password" name="newPass" class="form-control form-control-lg" placeholder="••••••••" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 shadow-sm">Confirm Update</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Configure Rates Modal -->
    <div class="modal fade" id="priceModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 rounded-4 shadow-lg">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="fw-bold m-0">Clinical Pricing Architecture</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <!-- Section A: Add New Treatment -->
                    <div class="p-3 bg-light rounded-4 mb-4 border border-light-subtle">
                        <h6 class="fw-bold text-primary mb-3">Add New Procedure</h6>
                        <form action="admin_actions" method="POST" class="row g-2">
                            <input type="hidden" name="action" value="add_treatment">
                            <div class="col-7">
                                <input type="text" name="serviceName" class="form-control form-control-sm" placeholder="Procedure Name" required>
                            </div>
                            <div class="col-3">
                                <input type="number" name="servicePrice" class="form-control form-control-sm" placeholder="Price" required>
                            </div>
                            <div class="col-2">
                                <button type="submit" class="btn btn-primary btn-sm w-100 fw-bold">+</button>
                            </div>
                        </form>
                    </div>

                    <p class="text-muted small mb-3 fw-bold text-uppercase">Existing Rates</p>
                    <form action="admin_actions" method="POST">
                        <input type="hidden" name="action" value="update_rates">
                        <div class="list-group list-group-flush mb-4" style="max-height: 300px; overflow-y: auto;">
                            <% if (rates != null) { for(java.util.Map.Entry<String, Double> entry : rates.entrySet()) { %>
                            <div class="list-group-item d-flex justify-content-between align-items-center border-light px-0 py-3">
                                <span class="fw-semibold text-dark small"><%= entry.getKey() %></span>
                                <div class="input-group w-50">
                                    <span class="input-group-text bg-light border-0 small">LKR</span>
                                    <input type="number" step="0.01" name="rate_<%= entry.getKey().replace(" ", "_") %>"
                                           class="form-control form-control-sm text-end border-0 bg-light"
                                           value="<%= entry.getValue() %>">
                                </div>
                            </div>
                            <% } } %>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold py-2 rounded-3">Publish New Rates</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleDocFields() {
            const role = document.getElementById('roleSelect').value;
            document.getElementById('doctorFields').style.display = (role === 'DENTIST') ? 'block' : 'none';
        }
        function openResetModal(id) {
            document.getElementById('resetUid').value = id;
            new bootstrap.Modal(document.getElementById('resetModal')).show();
        }
        function openResetModalByUsername(user) {
            alert("Please find user @" + user + " in the Registry table above to reset their key.");
        }
        function previewUploadFile(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('imagePreview').src = e.target.result;
                };
                reader.readAsDataURL(input.files[0]);
                
                // Clear preset URL input and selections
                document.getElementById('profileImageInput').value = '';
                const presets = document.querySelectorAll('.preset-avatar');
                presets.forEach(p => {
                    p.classList.remove('border-primary');
                    p.style.transform = 'scale(1)';
                });
            }
        }

        function previewUrlChange(url) {
            if (url) {
                document.getElementById('imagePreview').src = url;
                // Clear file input
                document.getElementById('profileImageFile').value = '';
            } else {
                document.getElementById('imagePreview').src = 'https://api.dicebear.com/7.x/adventurer/svg?seed=placeholder';
            }
        }

        function selectPreset(url) {
            document.getElementById('profileImageInput').value = url;
            document.getElementById('imagePreview').src = url;
            
            // Clear file input
            document.getElementById('profileImageFile').value = '';
            
            const presets = document.querySelectorAll('.preset-avatar');
            presets.forEach(p => {
                p.classList.remove('border-primary');
                p.style.transform = 'scale(1)';
            });
            
            if (event && event.currentTarget) {
                const targetImg = event.currentTarget.querySelector('.preset-avatar');
                if (targetImg) {
                    targetImg.classList.add('border-primary');
                    targetImg.style.transform = 'scale(1.1)';
                }
            }
        }
    </script>
    <%@ include file="includes/footer.jsp" %>
</body>
</html>
