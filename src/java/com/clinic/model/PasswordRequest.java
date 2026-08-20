package com.clinic.model;

import java.sql.Timestamp;

public class PasswordRequest {
    private int id;
    private String username;
    private String reason;
    private Timestamp requestTime;
    private String status;

    public PasswordRequest(int id, String username, String reason, Timestamp requestTime, String status) {
        this.id = id;
        this.username = username;
        this.reason = reason;
        this.requestTime = requestTime;
        this.status = status;
    }

    // Getters
    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getReason() { return reason; }
    public Timestamp getRequestTime() { return requestTime; }
    public String getStatus() { return status; }
}
