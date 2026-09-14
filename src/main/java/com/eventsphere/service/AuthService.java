package com.eventsphere.service;

import com.eventsphere.dao.CustomerDAO;
import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.dto.RegistrationDTO;
import com.eventsphere.model.Customer;
import com.eventsphere.model.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

/**
 * Service for authentication: registration, login, password changes.
 * Handles BCrypt hashing and simple role-based account setup.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class AuthService {

    private final UserDAO userDAO;
    private final CustomerDAO customerDAO;
    private final NotificationDAO notificationDAO;
    private final BCryptPasswordEncoder passwordEncoder;

    public AuthService(UserDAO userDAO,
                       CustomerDAO customerDAO,
                       NotificationDAO notificationDAO,
                       BCryptPasswordEncoder passwordEncoder) {
        this.userDAO         = userDAO;
        this.customerDAO     = customerDAO;
        this.notificationDAO = notificationDAO;
        this.passwordEncoder = passwordEncoder;
    }

    // ── REGISTRATION ───────────────────────────────────────────

    /**
     * Registers a new customer account.
     * Validates uniqueness, hashes the password, creates user + customer records.
     *
     * @return null on success, error message string on failure
     */
    public String registerCustomer(RegistrationDTO dto) {

        // Basic validation
        if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
            return "Username is required.";
        }
        if (dto.getPassword() == null || dto.getPassword().length() < 6) {
            return "Password must be at least 6 characters.";
        }
        if (!dto.getPassword().equals(dto.getConfirmPassword())) {
            return "Passwords do not match.";
        }
        if (dto.getEmail() == null || !dto.getEmail().contains("@")) {
            return "A valid email address is required.";
        }
        if (dto.getFullName() == null || dto.getFullName().trim().isEmpty()) {
            return "Full name is required.";
        }

        // Uniqueness checks
        if (userDAO.existsByUsername(dto.getUsername().trim())) {
            return "Username '" + dto.getUsername() + "' is already taken.";
        }
        if (userDAO.existsByEmail(dto.getEmail().trim())) {
            return "An account with this email already exists.";
        }

        // Create User record (role_id=1 → Customer)
        User user = new User();
        user.setUsername(dto.getUsername().trim());
        user.setPasswordHash(passwordEncoder.encode(dto.getPassword()));
        user.setEmail(dto.getEmail().trim());
        user.setFullName(dto.getFullName().trim());
        user.setPhone(dto.getPhone());
        user.setRoleId(1);   // Customer role
        userDAO.addUser(user);

        // Retrieve generated user_id
        int newUserId = userDAO.getLastInsertedUserId(dto.getUsername().trim());

        // Create Customer record
        Customer customer = new Customer();
        customer.setUserId(newUserId);
        customer.setFullName(dto.getFullName().trim());
        customer.setEmail(dto.getEmail().trim());
        customer.setPhone(dto.getPhone());
        customer.setAddress(dto.getAddress());
        customerDAO.addCustomer(customer);

        // Welcome notification
        notificationDAO.addNotification(newUserId,
                "Welcome to EventSphere!",
                "Your account has been created. You can now submit event booking requests.");

        return null; // null = success
    }

    // ── LOGIN ──────────────────────────────────────────────────

    /**
     * Authenticates a user by username and password.
     *
     * @return the User object if login succeeds, null otherwise
     */
    public User login(String username, String password) {
        if (username == null || password == null) return null;
        Optional<User> optUser = userDAO.findByUsername(username.trim());
        if (optUser.isEmpty()) {
            return null;  // User not found
        }
        User user = optUser.get();

        if (!user.isActive()) {
            return null;  // Account deactivated
        }

        // BCrypt comparison – never compare plain-text passwords
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            return null;  // Wrong password
        }

        return user;
    }

    // ── PASSWORD CHANGE ────────────────────────────────────────

    /**
     * Changes a user's password after verifying the current one.
     *
     * @return null on success, error message on failure
     */
    public String changePassword(int userId, String currentPassword,
                                 String newPassword, String confirmPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            return "New password must be at least 6 characters.";
        }
        if (!newPassword.equals(confirmPassword)) {
            return "New passwords do not match.";
        }

        Optional<User> optUser = userDAO.findById(userId);
        if (optUser.isEmpty()) {
            return "User not found.";
        }

        if (!passwordEncoder.matches(currentPassword, optUser.get().getPasswordHash())) {
            return "Current password is incorrect.";
        }

        String newHash = passwordEncoder.encode(newPassword);
        userDAO.updatePassword(userId, newHash);
        return null; // success
    }
}
