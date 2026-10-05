package com.eventsphere.service;

import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.StaffDAO;
import com.eventsphere.model.Staff;
import com.eventsphere.model.StaffAssignment;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
@org.springframework.transaction.annotation.Transactional
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


    public String addStaff(Staff staff) {
        String error = validateStaff(staff);
        if (error != null) return error;
        staffDAO.addStaff(staff);
        return null;
    }

    // ── ASSIGN ─────────────────────────────────────────────────


    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.SERIALIZABLE)
    public String assignStaffToEvent(StaffAssignment sa) {
        if (staffDAO.findById(sa.getStaffId()).filter(v -> v.isActive()).isEmpty()) return "Selected entry is unavailable.";
        if (sa.getAssignedDate() == null) {
            return "Assignment date is required.";
        }

        if (staffDAO.findAssignmentsByEventId(sa.getEventId()).stream().anyMatch(a ->
                a.getStaffId() == sa.getStaffId() && a.getAssignedDate().equals(sa.getAssignedDate())))
            return "This assignment already exists.";
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
        if (!com.eventsphere.util.ValidationUtil.isValidPersonName(staff.getFullName())) {
            return "Staff name must be 2-100 characters and contain only letters, spaces, dots, apostrophes or hyphens.";
        }
        if (staff.getJobRole() == null || staff.getJobRole().trim().isEmpty()) {
            return "Job role is required.";
        }
        if (staff.getJobRole().trim().length() > 100) {
            return "Job role must not exceed 100 characters.";
        }
        String phoneError = com.eventsphere.util.ValidationUtil.checkOptionalPhone(staff.getPhone());
        if (phoneError != null) return phoneError;
        String emailError = com.eventsphere.util.ValidationUtil.checkOptionalEmail(staff.getEmail());
        if (emailError != null) return emailError;
        staff.setFullName(staff.getFullName().trim());
        staff.setJobRole(staff.getJobRole().trim());
        staff.setPhone(com.eventsphere.util.ValidationUtil.trimToNull(staff.getPhone()));
        staff.setEmail(com.eventsphere.util.ValidationUtil.trimToNull(staff.getEmail()));
        return null;
    }
}
