package com.clinic.model;

public class Patient {
    private int id;
    private String name;
    private String address;
    private String contact;
    private int age;
    private String gender;

    public Patient() {}

    public Patient(int id, String name, String address, String contact) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.contact = contact;
    }

    public Patient(int id, String name, String address, String contact, int age, String gender) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.contact = contact;
        this.age = age;
        this.gender = gender;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
}
