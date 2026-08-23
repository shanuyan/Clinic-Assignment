<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String user = (String) session.getAttribute("user");
    String profileImage = (String) session.getAttribute("profileImage");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<script src="js/script.js"></script>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="dashboard.jsp">
            <div class="bg-primary rounded-3 p-1 me-2 d-flex align-items-center justify-content-center" style="width:35px; height:35px;">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4.5 10.1c.2 1.8 1.4 3.1 3.1 3.4 1.1.2 2.3-.2 3-1.1L12 11l1.4 1.4c.7.9 1.9 1.3 3 1.1 1.7-.3 2.9-1.6 3.1-3.4.2-2.1-.5-4.2-1.9-5.7C16.2 3 14.1 2.3 12 2.3s-4.2.7-5.6 2.1c-1.4 1.5-2.1 3.6-1.9 5.7z"/>
                    <path d="M12 21.7c-2.1 0-4.2-.7-5.6-2.1-1.4-1.5-2.1-3.6-1.9-5.7.1-.9.3-1.8.7-2.6"/>
                    <path d="M18.8 11.3c.4.8.6 1.7.7 2.6.2 2.1-.5 4.2-1.9 5.7-1.4 1.4-3.5 2.1-5.6 2.1"/>
                </svg>
            </div>
            <span class="fw-bold text-dark fs-5">Sunrise Dental</span>
        </a>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <% if (!"DENTIST".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Overview</a></li>
                    <li class="nav-item"><a class="nav-link" href="appointments.jsp">Clinical</a></li>
                    <li class="nav-item"><a class="nav-link" href="search.jsp">Patient Records</a></li>
                    <li class="nav-item"><a class="nav-link" href="bill.jsp?treatment=Consultation&patient=Guest">Finance</a></li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link active" href="dentist_dashboard.jsp">Clinical Dashboard</a></li>
                <% } %>
                <% if ("ADMIN".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link text-primary" href="admin_dashboard.jsp">System Admin</a></li>
                <% } %>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <div class="dropdown">
                    <a class="d-flex align-items-center gap-3 text-decoration-none dropdown-toggle" href="#" role="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="<%= (profileImage != null && !profileImage.isEmpty() && !profileImage.equals("default_avatar.png")) ? profileImage : "https://api.dicebear.com/7.x/adventurer/svg?seed=" + user %>" 
                             class="rounded-circle border border-2 border-primary-subtle shadow-sm animate-fade-in" 
                             style="width: 36px; height: 36px; object-fit: cover;" 
                             onerror="this.src='https://api.dicebear.com/7.x/adventurer/svg?seed=<%= user %>'">
                        <div class="text-end d-none d-lg-block">
                            <div class="fw-bold small text-dark"><%= user %></div>
                            <div class="text-muted" style="font-size: 10px;"><%= role %></div>
                        </div>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg mt-2 rounded-3" aria-labelledby="profileDropdown">
                        <li><a class="dropdown-item py-2 fw-semibold small" href="profile.jsp">👤 View Profile</a></li>
                        <% if ("ADMIN".equals(role)) { %>
                            <li><a class="dropdown-item py-2 fw-semibold small" href="admin_dashboard.jsp">⚙️ System Admin</a></li>
                        <% } %>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 fw-semibold text-danger small" href="auth?action=logout">🚪 Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
<div class="container main-content mt-4">
