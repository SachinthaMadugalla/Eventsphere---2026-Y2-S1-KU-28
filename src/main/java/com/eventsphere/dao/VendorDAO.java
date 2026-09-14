package com.eventsphere.dao;

import com.eventsphere.model.EventVendor;
import com.eventsphere.model.Vendor;
import com.eventsphere.model.VendorCategory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * DAO for Vendor Management (Module 3).
 * All SQL queries are explicitly written here.
 */
@Repository
public class VendorDAO {

    private final JdbcTemplate jdbcTemplate;

    public VendorDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMappers ─────────────────────────────────────────────

    private final RowMapper<Vendor> vendorRowMapper = (rs, rowNum) -> {
        Vendor v = new Vendor();
        v.setVendorId(rs.getInt("vendor_id"));
        v.setVendorName(rs.getString("vendor_name"));
        v.setVendorCatId(rs.getInt("vendor_cat_id"));
        v.setCategoryName(rs.getString("category_name"));
        v.setContactPerson(rs.getString("contact_person"));
        v.setPhone(rs.getString("phone"));
        v.setEmail(rs.getString("email"));
        v.setServiceDesc(rs.getString("service_desc"));
        v.setCost(rs.getBigDecimal("cost"));
        v.setActive(rs.getBoolean("is_active"));
        v.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return v;
    };

    private final RowMapper<VendorCategory> catRowMapper = (rs, rowNum) -> {
        VendorCategory vc = new VendorCategory();
        vc.setVendorCatId(rs.getInt("vendor_cat_id"));
        vc.setCategoryName(rs.getString("category_name"));
        return vc;
    };

    private final RowMapper<EventVendor> eventVendorRowMapper = (rs, rowNum) -> {
        EventVendor ev = new EventVendor();
        ev.setEventVendorId(rs.getInt("event_vendor_id"));
        ev.setEventId(rs.getInt("event_id"));
        ev.setEventName(rs.getString("event_name"));
        ev.setVendorId(rs.getInt("vendor_id"));
        ev.setVendorName(rs.getString("vendor_name"));
        ev.setCategoryName(rs.getString("category_name"));
        ev.setServiceDate(rs.getDate("service_date") != null
                ? rs.getDate("service_date").toLocalDate() : null);
        ev.setNotes(rs.getString("notes"));
        return ev;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new vendor record.
     */
    public int addVendor(Vendor vendor) {
        String sql =
            "INSERT INTO vendors (vendor_name, vendor_cat_id, contact_person, phone, " +
            "                     email, service_desc, cost) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                vendor.getVendorName(),
                vendor.getVendorCatId(),
                vendor.getContactPerson(),
                vendor.getPhone(),
                vendor.getEmail(),
                vendor.getServiceDesc(),
                vendor.getCost());
    }

    /**
     * Assigns a vendor to an event.
     */
    public int assignVendorToEvent(EventVendor ev) {
        String sql =
            "INSERT INTO event_vendors (event_id, vendor_id, service_date, notes) " +
            "VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                ev.getEventId(),
                ev.getVendorId(),
                ev.getServiceDate(),
                ev.getNotes());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all vendors with their category names.
     */
    public List<Vendor> findAll() {
        String sql =
            "SELECT v.vendor_id, v.vendor_name, v.vendor_cat_id, vc.category_name, " +
            "       v.contact_person, v.phone, v.email, v.service_desc, " +
            "       v.cost, v.is_active, v.created_at " +
            "FROM vendors v " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "ORDER BY v.vendor_name";
        return jdbcTemplate.query(sql, vendorRowMapper);
    }

    /**
     * Returns only active vendors (for assignment dropdowns).
     */
    public List<Vendor> findAllActive() {
        String sql =
            "SELECT v.vendor_id, v.vendor_name, v.vendor_cat_id, vc.category_name, " +
            "       v.contact_person, v.phone, v.email, v.service_desc, " +
            "       v.cost, v.is_active, v.created_at " +
            "FROM vendors v " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "WHERE v.is_active = 1 ORDER BY v.vendor_name";
        return jdbcTemplate.query(sql, vendorRowMapper);
    }

    /**
     * Finds a vendor by primary key.
     */
    public Optional<Vendor> findById(int vendorId) {
        String sql =
            "SELECT v.vendor_id, v.vendor_name, v.vendor_cat_id, vc.category_name, " +
            "       v.contact_person, v.phone, v.email, v.service_desc, " +
            "       v.cost, v.is_active, v.created_at " +
            "FROM vendors v " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "WHERE v.vendor_id = ?";
        List<Vendor> result = jdbcTemplate.query(sql, vendorRowMapper, vendorId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns all vendor categories for dropdown menus.
     */
    public List<VendorCategory> findAllCategories() {
        String sql =
            "SELECT vendor_cat_id, category_name FROM vendor_categories ORDER BY category_name";
        return jdbcTemplate.query(sql, catRowMapper);
    }

    /**
     * Returns all vendor assignments for a specific event.
     */
    public List<EventVendor> findAssignmentsByEventId(int eventId) {
        String sql =
            "SELECT ev.event_vendor_id, ev.event_id, e.event_name, " +
            "       ev.vendor_id, v.vendor_name, vc.category_name, " +
            "       ev.service_date, ev.notes " +
            "FROM event_vendors ev " +
            "JOIN events e           ON ev.event_id  = e.event_id " +
            "JOIN vendors v          ON ev.vendor_id  = v.vendor_id " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "WHERE ev.event_id = ?";
        return jdbcTemplate.query(sql, eventVendorRowMapper, eventId);
    }

    /**
     * Returns all event assignments for a specific vendor.
     */
    public List<EventVendor> findAssignmentsByVendorId(int vendorId) {
        String sql =
            "SELECT ev.event_vendor_id, ev.event_id, e.event_name, " +
            "       ev.vendor_id, v.vendor_name, vc.category_name, " +
            "       ev.service_date, ev.notes " +
            "FROM event_vendors ev " +
            "JOIN events e           ON ev.event_id  = e.event_id " +
            "JOIN vendors v          ON ev.vendor_id  = v.vendor_id " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "WHERE ev.vendor_id = ? ORDER BY ev.service_date DESC";
        return jdbcTemplate.query(sql, eventVendorRowMapper, vendorId);
    }

    /**
     * Returns all event-vendor assignments (for reporting).
     */
    public List<EventVendor> findAllAssignments() {
        String sql =
            "SELECT ev.event_vendor_id, ev.event_id, e.event_name, " +
            "       ev.vendor_id, v.vendor_name, vc.category_name, " +
            "       ev.service_date, ev.notes " +
            "FROM event_vendors ev " +
            "JOIN events e           ON ev.event_id  = e.event_id " +
            "JOIN vendors v          ON ev.vendor_id  = v.vendor_id " +
            "JOIN vendor_categories vc ON v.vendor_cat_id = vc.vendor_cat_id " +
            "ORDER BY ev.service_date DESC";
        return jdbcTemplate.query(sql, eventVendorRowMapper);
    }

    // ── CONFLICT DETECTION ────────────────────────────────────
    //
    // A vendor conflict occurs when the same vendor is already
    // assigned to a different event on the same service date.

    /**
     * Checks if a vendor is already booked on the given service date.
     * Excludes cancelled events.
     *
     * @return count of conflicts (0 = no conflict)
     */
    public int countVendorConflicts(int vendorId, LocalDate serviceDate, int excludeEventId) {
        String sql =
            "SELECT COUNT(*) " +
            "FROM event_vendors ev " +
            "JOIN events e ON ev.event_id = e.event_id " +
            "WHERE ev.vendor_id  = ? " +
            "  AND ev.service_date = ? " +
            "  AND ev.event_id    <> ? " +
            "  AND e.status NOT IN ('Cancelled')";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class,
                vendorId, serviceDate, excludeEventId);
        return count != null ? count : 0;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates vendor details.
     */
    public int updateVendor(Vendor vendor) {
        String sql =
            "UPDATE vendors SET vendor_name = ?, vendor_cat_id = ?, contact_person = ?, " +
            "                   phone = ?, email = ?, service_desc = ?, cost = ? " +
            "WHERE vendor_id = ?";
        return jdbcTemplate.update(sql,
                vendor.getVendorName(),
                vendor.getVendorCatId(),
                vendor.getContactPerson(),
                vendor.getPhone(),
                vendor.getEmail(),
                vendor.getServiceDesc(),
                vendor.getCost(),
                vendor.getVendorId());
    }

    /**
     * Activates or deactivates a vendor.
     */
    public int setActiveStatus(int vendorId, boolean active) {
        String sql = "UPDATE vendors SET is_active = ? WHERE vendor_id = ?";
        return jdbcTemplate.update(sql, active ? 1 : 0, vendorId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a vendor by ID.
     */
    public int deleteVendor(int vendorId) {
        String sql = "DELETE FROM vendors WHERE vendor_id = ?";
        return jdbcTemplate.update(sql, vendorId);
    }

    /**
     * Removes a vendor from a specific event.
     */
    public int removeAssignment(int eventVendorId) {
        String sql = "DELETE FROM event_vendors WHERE event_vendor_id = ?";
        return jdbcTemplate.update(sql, eventVendorId);
    }
}
