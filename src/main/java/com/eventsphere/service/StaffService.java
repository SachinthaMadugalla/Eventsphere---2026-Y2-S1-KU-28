package com.eventsphere.service;

import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.StaffDAO;
import com.eventsphere.model.Staff;
import com.eventsphere.model.StaffAssignment;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for Staff Management (Module 4).
 * Handles staff CRUD, assignment and conflict detection.
 */
@Service
public class StaffService {

    private final StaffDAO staffDAO;
    private final NotificationDAO notificationDAO;

    public StaffService(StaffDAO staffDAO, NotificationDAO notificationDAO) {
        this.staffDAO         = staffDAO;
        this.notificationDAO  = notificationDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Staff> getAllStaff()        { return staffDAO.findAll(); }
    public List<Staff> getActiveStaff()    { return staffDAO.findAllActive(); }

    public Optional<Staff> getStaffById(int staffId) {
        return staffDAO.findById(staffId);
    }

    public List<StaffAssignment> getAssignmentsByEvent(int eventId) {
        return staffDAO.findAssignmentsByEventId(eventId);
    }

    public List<StaffAssignment> getAssignmentsByStaff(int staffId) {
        return staffDAO.findAssignmentsByStaffId(staffId);
    }

    public List<StaffAssignment> getAllAssignments() {
        return staffDAO.findAllAssignments();
    }

    public int getTotalStaff() { return staffDAO.countAll(); }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Adds a new staff member. Returns null on success, error message on failure.
     */
    public String addStaff(Staff staff) {
        String error = validateStaff(staff);
        if (error != null) return error;
        staffDAO.addStaff(staff);
        return null;
    }

    // ── ASSIGN ─────────────────────────────────────────────────

    /**
     * Assigns a staff member to an event with conflict checking.
     *
     * Conflict rule: same staff already assigned to a different non-cancelled
     * event on the same date.
     *
     * @return null on success, error message if conflict
     */
    public String assignStaffToEvent(StaffAssignment sa) {
        if (sa.getAssignedDate() == null) {
            return "Assignment date is required.";
        }

        int conflicts = staffDAO.countStaffConflicts(
                sa.getStaffId(),
                sa.getAssignedDate(),
                sa.getEventId()
        );

        if (conflicts > 0) {
            return "Scheduling conflict: this staff member is already assigned to another event on " +
                   sa.getAssignedDate() + ".";
        }

        staffDAO.assignStaffToEvent(sa);
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a staff member's details.
     */
    public String updateStaff(Staff staff) {
        String error = validateStaff(staff);
        if (error != null) return error;
        staffDAO.updateStaff(staff);
        return null;
    }

    public void setActiveStatus(int staffId, boolean active) {
        staffDAO.setActiveStatus(staffId, active);
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteStaff(int staffId) {
        staffDAO.deleteStaff(staffId);
    }

    public void removeAssignment(int assignmentId) {
        staffDAO.removeAssignment(assignmentId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateStaff(Staff staff) {
        if (staff.getFullName() == null || staff.getFullName().trim().isEmpty()) {
            return "Staff full name is required.";
        }
        if (staff.getJobRole() == null || staff.getJobRole().trim().isEmpty()) {
            return "Job role is required.";
        }
        return null;
    }
}
