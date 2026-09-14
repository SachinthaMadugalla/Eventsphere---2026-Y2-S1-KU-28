package com.eventsphere.dto;

/**
 * Data Transfer Object for new customer self-registration.
 * Carries all fields from the registration form.
 */
public class RegistrationDTO {

    private String username;
    private String password;
    private String confirmPassword;
    private String email;
    private String fullName;
    private String phone;
    private String address;

    public RegistrationDTO() {}

    // ── Getters & Setters ──────────────────────────────────────

    public String getUsername()                         { return username; }
    public void setUsername(String username)            { this.username = username; }

    public String getPassword()                         { return password; }
    public void setPassword(String password)            { this.password = password; }

    public String getConfirmPassword()                          { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword)      { this.confirmPassword = confirmPassword; }

    public String getEmail()                            { return email; }
    public void setEmail(String email)                  { this.email = email; }

    public String getFullName()                         { return fullName; }
    public void setFullName(String fullName)            { this.fullName = fullName; }

    public String getPhone()                            { return phone; }
    public void setPhone(String phone)                  { this.phone = phone; }

    public String getAddress()                          { return address; }
    public void setAddress(String address)              { this.address = address; }
}
