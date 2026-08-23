package com.clinic.model;

public class User {
    private int id;
    private String username;
    private String role;
    private String fullName;
    private String profileImage;

    public User() {}

    public User(int id, String username, String role, String fullName, String profileImage) {
        this.id = id;
        this.username = username;
        this.role = role;
        this.fullName = fullName;
        this.profileImage = profileImage;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
}
