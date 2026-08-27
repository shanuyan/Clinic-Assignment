package com.clinic.util;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // 1. CLEAR BROWSER CACHE (Prevents "Back Button" showing old data after logout)
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        res.setHeader("Pragma", "no-cache"); // HTTP 1.0
        res.setDateHeader("Expires", 0); // Proxies

        // 2. SESSION VALIDATION
        HttpSession session = req.getSession(false);
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow access to login page, static files, and public verification page
        boolean isStaticFile = path.contains("/css/") || path.contains("/js/") || path.contains("/images/");
        boolean isPublicPage = path.equals("/") || path.equals("/index.jsp") || path.equals("/index.html") || 
                               path.equals("/auth") || path.equals("/forgot_key.jsp") || path.equals("/verify.jsp") ||
                               path.equals("/recovery_action");

        if (session == null || session.getAttribute("user") == null) {
            if (!isPublicPage && !isStaticFile) {
                res.sendRedirect(req.getContextPath() + "/index.jsp");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
