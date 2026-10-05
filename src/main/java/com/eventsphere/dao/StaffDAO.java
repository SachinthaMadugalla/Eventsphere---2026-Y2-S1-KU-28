package com.eventsphere.dao;

import com.eventsphere.model.Staff;
import com.eventsphere.model.StaffAssignment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;


@Repository
public class StaffDAO {

    private final JdbcTemplate jdbcTemplate;

    public StaffDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMappers ─────────────────────────────────────────────

    private final RowMapper<Staff> staffRowMapper = (rs, rowNum) -> {
        Staff s = new Staff();
        s.setStaffId(rs.getInt("staff_id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setJobRole(rs.getString("job_role"));
        s.setActive(rs.getBoolean("is_active"));
        s.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return s;
    };

    private final RowMapper<StaffAssignment> assignmentRowMapper = (rs, rowNum) -> {
        StaffAssignment sa = new StaffAssignment();
        sa.setAssignmentId(rs.getInt("assignment_id"));
        sa.setEventId(rs.getInt("event_id"));
        sa.setEventName(rs.getString("event_name"));
        sa.setEventDate(rs.getDate("event_date") != null
                ? rs.getDate("event_date").toLocalDate() : null);
        sa.setStaffId(rs.getInt("staff_id"));
        sa.setStaffName(rs.getString("staff_name"));
        sa.setRoleAtEvent(rs.getString("role_at_event"));
        sa.setAssignedDate(rs.getDate("assigned_date") != null
                ? rs.getDate("assigned_date").toLocalDate() : null);
        sa.setNotes(rs.getString("notes"));
        return sa;
    };

    // ── INSERT ─────────────────────────────────────────────────


    public int addStaff(Staff staff) {
        String sql =
                "INSERT INTO staff (full_name, email, phone, job_role) " +
                        "VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                staff.getFullName(),
                staff.getEmail(),
                staff.getPhone(),
                staff.getJobRole());
    }


    public int assignStaffToEvent(StaffAssignment sa) {
        String sql =
                "INSERT INTO staff_assignments (event_id, staff_id, role_at_event, assigned_date, notes) " +
                        "VALUES (?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                sa.getEventId(),
                sa.getStaffId(),
                sa.getRoleAtEvent(),
                sa.getAssignedDate(),
                sa.getNotes());
    }

    // ── SELECT ─────────────────────────────────────────────────


    public List<Staff> findAll() {
        String sql =
                "SELECT staff_id, full_name, email, phone, job_role, is_active, created_at " +
                        "FROM staff ORDER BY full_name";
        return jdbcTemplate.query(sql, staffRowMapper);
    }


    public List<Staff> findAllActive() {
        String sql =
                "SELECT staff_id, full_name, email, phone, job_role, is_active, created_at " +
                        "FROM staff WHERE is_active = 1 ORDER BY full_name";
        return jdbcTemplate.query(sql, staffRowMapper);
    }


    public Optional<Staff> findById(int staffId) {
        String sql =
                "SELECT staff_id, full_name, email, phone, job_role, is_active, created_at " +
                        "FROM staff WHERE staff_id = ?";
        List<Staff> result = jdbcTemplate.query(sql, staffRowMapper, staffId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }


    public List<StaffAssignment> findAssignmentsByEventId(int eventId) {
        String sql =
                "SELECT sa.assignment_id, sa.event_id, e.event_name, e.event_date, " +
                        "       sa.staff_id, s.full_name AS staff_name, " +
                        "       sa.role_at_event, sa.assigned_date, sa.notes " +
                        "FROM staff_assignments sa " +
                        "JOIN events e ON sa.event_id = e.event_id " +
                        "JOIN staff  s ON sa.staff_id  = s.staff_id " +
                        "WHERE sa.event_id = ?";
        return jdbcTemplate.query(sql, assignmentRowMapper, eventId);
    }


    public List<StaffAssignment> findAssignmentsByStaffId(int staffId) {
        String sql =
                "SELECT sa.assignment_id, sa.event_id, e.event_name, e.event_date, " +
                        "       sa.staff_id, s.full_name AS staff_name, " +
                        "       sa.role_at_event, sa.assigned_date, sa.notes " +
                        "FROM staff_assignments sa " +
                        "JOIN events e ON sa.event_id = e.event_id " +
                        "JOIN staff  s ON sa.staff_id  = s.staff_id " +
                        "WHERE sa.staff_id = ? ORDER BY e.event_date DESC";
        return jdbcTemplate.query(sql, assignmentRowMapper, staffId);
    }


    public List<StaffAssignment> findAllAssignments() {
        String sql =
                "SELECT sa.assignment_id, sa.event_id, e.event_name, e.event_date, " +
                        "       sa.staff_id, s.full_name AS staff_name, " +
                        "       sa.role_at_event, sa.assigned_date, sa.notes " +
                        "FROM staff_assignments sa " +
                        "JOIN events e ON sa.event_id = e.event_id " +
                        "JOIN staff  s ON sa.staff_id  = s.staff_id " +
                        "ORDER BY e.event_date DESC";
        return jdbcTemplate.query(sql, assignmentRowMapper);
    }

    // ── CONFLICT DETECTION ────────────────────────────────────
    //
    // A staff conflict occurs when the same staff member is assigned
    // to two different events on the same date.


    public int countStaffConflicts(int staffId, LocalDate eventDate, int excludeEventId) {
        String sql =
                "SELECT COUNT(*) " +
                        "FROM staff_assignments sa " +
                        "JOIN events e ON sa.event_id = e.event_id " +
                        "WHERE sa.staff_id  = ? " +
                        "  AND e.event_date  = ? " +
                        "  AND sa.event_id  <> ? " +
                        "  AND e.status NOT IN ('Cancelled')";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class,
                staffId, eventDate, excludeEventId);
        return count != null ? count : 0;
    }

    // ── UPDATE ─────────────────────────────────────────────────


    public int updateStaff(Staff staff) {
        String sql =
                "UPDATE staff SET full_name = ?, email = ?, phone = ?, job_role = ? " +
                        "WHERE staff_id = ?";
        return jdbcTemplate.update(sql,
                staff.getFullName(),
                staff.getEmail(),
                staff.getPhone(),
                staff.getJobRole(),
                staff.getStaffId());
    }


    public int setActiveStatus(int staffId, boolean active) {
        String sql = "UPDATE staff SET is_active = ? WHERE staff_id = ?";
        return jdbcTemplate.update(sql, active ? 1 : 0, staffId);
    }

    // ── DELETE ─────────────────────────────────────────────────


    public int deleteStaff(int staffId) {
        String sql = "DELETE FROM staff WHERE staff_id = ?";
        return jdbcTemplate.update(sql, staffId);
    }


    public int removeAssignment(int assignmentId) {
        String sql = "DELETE FROM staff_assignments WHERE assignment_id = ?";
        return jdbcTemplate.update(sql, assignmentId);
    }

    // ── COUNT ──────────────────────────────────────────────────

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM staff";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
