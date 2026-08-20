<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<script src="js/script.js"></script>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="dashboard.jsp">
            <div class="bg-primary rounded-3 p-2 me-2 d-flex align-items-center justify-content-center" style="width:35px; height:35px;">
                <span class="text-white fw-bold">S</span>
            </div>
            <span class="fw-bold text-dark fs-5">Sunrise Dental</span>
        </a>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="dashboard.jsp">Overview</a></li>
                <li class="nav-item"><a class="nav-link" href="appointments.jsp">Clinical</a></li>
                <li class="nav-item"><a class="nav-link" href="search.jsp">Database</a></li>
                <li class="nav-item"><a class="nav-link" href="bill.jsp?treatment=Consultation&patient=Guest">Finance</a></li>
                <% if ("ADMIN".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link text-primary" href="admin_dashboard.jsp">System Admin</a></li>
                <% } %>
            </ul>

            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-lg-block">
                    <div class="fw-bold small"><%= user %></div>
                    <div class="text-muted" style="font-size: 10px;"><%= role %></div>
                </div>
                <div class="vr mx-2 h-25"></div>
                <button class="btn btn-link p-0 text-muted" onclick="toggleTheme()">🌓</button>
                <a href="auth?action=logout" class="btn btn-outline-danger btn-sm px-3">Exit</a>
            </div>
        </div>
    </div>
</nav>
<div class="container main-content mt-4">
