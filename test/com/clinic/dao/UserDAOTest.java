package com.clinic.dao;

/**
 * Basic Test class for UserDAO
 */
public class UserDAOTest {
    public static void main(String[] args) {
        testLogin();
    }

    public static void testLogin() {
        UserDAO dao = new UserDAO();
        // Assuming database has a user admin/admin123
        boolean result = dao.validateUser("admin", "admin123");
        System.out.println("Test Login: " + (result ? "PASSED" : "FAILED"));
    }
}
