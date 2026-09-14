package com.eventsphere.service;

import com.eventsphere.dao.VendorDAO;
import com.eventsphere.model.EventVendor;
import com.eventsphere.model.Vendor;
import com.eventsphere.model.VendorCategory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Service for Vendor Management (Module 3).
 * Contains vendor business logic and scheduling conflict detection.
 */
@Service
public class VendorService {

    private final VendorDAO vendorDAO;

    public VendorService(VendorDAO vendorDAO) {
        this.vendorDAO = vendorDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Vendor> getAllVendors()        { return vendorDAO.findAll(); }
    public List<Vendor> getActiveVendors()    { return vendorDAO.findAllActive(); }

    public Optional<Vendor> getVendorById(int vendorId) {
        return vendorDAO.findById(vendorId);
    }

    public List<VendorCategory> getAllCategories() {
        return vendorDAO.findAllCategories();
    }

    public List<EventVendor> getAssignmentsByEvent(int eventId) {
        return vendorDAO.findAssignmentsByEventId(eventId);
    }

    public List<EventVendor> getAssignmentsByVendor(int vendorId) {
        return vendorDAO.findAssignmentsByVendorId(vendorId);
    }

    public List<EventVendor> getAllAssignments() {
        return vendorDAO.findAllAssignments();
    }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Adds a new vendor. Returns null on success, error message on failure.
     */
    public String addVendor(Vendor vendor) {
        String error = validateVendor(vendor);
        if (error != null) return error;
        vendorDAO.addVendor(vendor);
        return null;
    }

    // ── ASSIGN ─────────────────────────────────────────────────

    /**
     * Assigns a vendor to an event with schedule conflict checking.
     *
     * Conflict rule: same vendor already booked on the same service date
     * for a different non-cancelled event.
     *
     * @return null on success, error message if conflict
     */
    public String assignVendorToEvent(EventVendor ev) {
        if (ev.getServiceDate() == null) {
            return "Service date is required.";
        }

        int conflicts = vendorDAO.countVendorConflicts(
                ev.getVendorId(),
                ev.getServiceDate(),
                ev.getEventId()
        );

        if (conflicts > 0) {
            return "Scheduling conflict: this vendor is already booked on " +
                   ev.getServiceDate() + " for another event.";
        }

        vendorDAO.assignVendorToEvent(ev);
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates an existing vendor.
     */
    public String updateVendor(Vendor vendor) {
        String error = validateVendor(vendor);
        if (error != null) return error;
        vendorDAO.updateVendor(vendor);
        return null;
    }

    public void setActiveStatus(int vendorId, boolean active) {
        vendorDAO.setActiveStatus(vendorId, active);
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteVendor(int vendorId) {
        vendorDAO.deleteVendor(vendorId);
    }

    public void removeAssignment(int eventVendorId) {
        vendorDAO.removeAssignment(eventVendorId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateVendor(Vendor vendor) {
        if (vendor.getVendorName() == null || vendor.getVendorName().trim().isEmpty()) {
            return "Vendor name is required.";
        }
        if (vendor.getVendorCatId() <= 0) {
            return "Please select a vendor category.";
        }
        if (vendor.getCost() == null || vendor.getCost().compareTo(BigDecimal.ZERO) < 0) {
            return "Cost cannot be negative.";
        }
        return null;
    }
}
