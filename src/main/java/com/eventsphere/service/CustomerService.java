package com.eventsphere.service;

import com.eventsphere.dao.CustomerDAO;
import com.eventsphere.dao.UserDAO;
import com.eventsphere.model.Customer;
import com.eventsphere.model.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for Customer Management (Module 1).
 * Handles business logic for customer profiles.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class CustomerService {

    private final CustomerDAO customerDAO;
    private final UserDAO userDAO;

    public CustomerService(CustomerDAO customerDAO, UserDAO userDAO) {
        this.customerDAO = customerDAO;
        this.userDAO     = userDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Customer> getAllCustomers() {
        return customerDAO.findAll();
    }

    public Optional<Customer> getCustomerById(int customerId) {
        return customerDAO.findById(customerId);
    }

    public Optional<Customer> getCustomerByUserId(int userId) {
        return customerDAO.findByUserId(userId);
    }

    public List<Customer> searchCustomers(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return customerDAO.findAll();
        }
        return customerDAO.search(keyword.trim());
    }

    public int getTotalCustomers() {
        return customerDAO.countAll();
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a customer's profile.
     * Also syncs email/phone back to the users table.
     *
     * @return null on success, error message on failure
     */
    public String updateCustomer(Customer customer) {
        if (customer.getFullName() == null || customer.getFullName().trim().isEmpty()) {
            return "Full name is required.";
        }
        if (customer.getEmail() == null || !customer.getEmail().contains("@")) {
            return "A valid email address is required.";
        }

        customerDAO.updateCustomer(customer);

        // Keep user table in sync
        Optional<User> optUser = userDAO.findById(customer.getUserId());
        if (optUser.isPresent()) {
            User user = optUser.get();
            user.setEmail(customer.getEmail());
            user.setFullName(customer.getFullName());
            user.setPhone(customer.getPhone());
            userDAO.updateUser(user);
        }

        return null; // success
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteCustomer(int customerId) {
        customerDAO.deleteCustomer(customerId);
    }
}
