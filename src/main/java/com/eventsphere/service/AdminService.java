package com.eventsphere.service;

import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for System Administrator functions.
 * Covers simple user management: view, activate/deactivate, role change.
 * Security is kept simple as instructed.
 */
@Service
public class AdminService {

    private final UserDAO userDAO;

    public AdminService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public Optional<User> getUserById(int userId) {
        return userDAO.findById(userId);
    }

    public int getTotalUsers() {
        return userDAO.countAll();
    }

    /**
     * Activates or deactivates a user account.
     */
    public void setUserActiveStatus(int userId, boolean active) {
        userDAO.setActiveStatus(userId, active);
    }

    /**
     * Changes the role of a user (e.g., promotes a user to Event Manager).
     */
    public void changeUserRole(int userId, int roleId) {
        userDAO.updateRole(userId, roleId);
    }

    /**
     * Deletes a user account. Use with caution.
     */
    public void deleteUser(int userId) {
        userDAO.deleteUser(userId);
    }

    /**
     * Updates user profile fields (name, email, phone).
     */
    public void updateUser(User user) {
        userDAO.updateUser(user);
    }
}
