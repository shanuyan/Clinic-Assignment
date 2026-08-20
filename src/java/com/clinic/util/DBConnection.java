package com.clinic.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton class for Database Connection
 */
public class DBConnection {
    private static DBConnection instance;
    private Connection connection;
    private final String url = "jdbc:mysql://localhost:3306/dental_clinic?createDatabaseIfNotExist=true";
    private final String username = "root";
    private final String password = ""; // Update with your password

    private DBConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException ex) {
            System.out.println("Database Driver not found: " + ex.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        if (instance == null || instance.getConnectionInternal().isClosed()) {
            instance = new DBConnection();
        }
        return instance.getConnectionInternal();
    }

    private Connection getConnectionInternal() {
        return connection;
    }
}
