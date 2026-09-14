package com.eventsphere.dao;

import com.eventsphere.model.Resource;
import com.eventsphere.model.ResourceAllocation;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * DAO for Resource Management (Module 4).
 * All SQL queries are explicitly written here.
 */
@Repository
public class ResourceDAO {

    private final JdbcTemplate jdbcTemplate;

    public ResourceDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMappers ─────────────────────────────────────────────

    private final RowMapper<Resource> resourceRowMapper = (rs, rowNum) -> {
        Resource r = new Resource();
        r.setResourceId(rs.getInt("resource_id"));
        r.setResourceName(rs.getString("resource_name"));
        r.setCategory(rs.getString("category"));
        r.setTotalQuantity(rs.getInt("total_quantity"));
        r.setAvailableQuantity(rs.getInt("available_quantity"));
        r.setStatus(rs.getString("status"));
        r.setDescription(rs.getString("description"));
        r.setActive(rs.getBoolean("is_active"));
        r.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return r;
    };

    private final RowMapper<ResourceAllocation> allocationRowMapper = (rs, rowNum) -> {
        ResourceAllocation ra = new ResourceAllocation();
        ra.setAllocationId(rs.getInt("allocation_id"));
        ra.setEventId(rs.getInt("event_id"));
        ra.setEventName(rs.getString("event_name"));
        ra.setResourceId(rs.getInt("resource_id"));
        ra.setResourceName(rs.getString("resource_name"));
        ra.setQuantity(rs.getInt("quantity"));
        ra.setAllocatedOn(rs.getDate("allocated_on") != null
                ? rs.getDate("allocated_on").toLocalDate() : null);
        ra.setNotes(rs.getString("notes"));
        return ra;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Inserts a new resource record.
     */
    public int addResource(Resource resource) {
        String sql =
            "INSERT INTO resources (resource_name, category, total_quantity, " +
            "                       available_quantity, status, description) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                resource.getResourceName(),
                resource.getCategory(),
                resource.getTotalQuantity(),
                resource.getTotalQuantity(),   // initially all available
                resource.getStatus(),
                resource.getDescription());
    }

    /**
     * Allocates a quantity of a resource to an event
     * and reduces available_quantity accordingly.
     */
    public int allocateResource(ResourceAllocation allocation) {
        // Insert the allocation record
        String insertSql =
            "INSERT INTO resource_allocations (event_id, resource_id, quantity, allocated_on, notes) " +
            "VALUES (?, ?, ?, CAST(GETDATE() AS DATE), ?)";
        int rows = jdbcTemplate.update(insertSql,
                allocation.getEventId(),
                allocation.getResourceId(),
                allocation.getQuantity(),
                allocation.getNotes());

        // Reduce the available quantity
        String updateSql =
            "UPDATE resources SET available_quantity = available_quantity - ? " +
            "WHERE resource_id = ?";
        jdbcTemplate.update(updateSql, allocation.getQuantity(), allocation.getResourceId());

        return rows;
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all resources.
     */
    public List<Resource> findAll() {
        String sql =
            "SELECT resource_id, resource_name, category, total_quantity, " +
            "       available_quantity, status, description, is_active, created_at " +
            "FROM resources ORDER BY resource_name";
        return jdbcTemplate.query(sql, resourceRowMapper);
    }

    /**
     * Returns only active resources (for allocation dropdowns).
     */
    public List<Resource> findAllActive() {
        String sql =
            "SELECT resource_id, resource_name, category, total_quantity, " +
            "       available_quantity, status, description, is_active, created_at " +
            "FROM resources WHERE is_active = 1 ORDER BY resource_name";
        return jdbcTemplate.query(sql, resourceRowMapper);
    }

    /**
     * Finds a resource by primary key.
     */
    public Optional<Resource> findById(int resourceId) {
        String sql =
            "SELECT resource_id, resource_name, category, total_quantity, " +
            "       available_quantity, status, description, is_active, created_at " +
            "FROM resources WHERE resource_id = ?";
        List<Resource> result = jdbcTemplate.query(sql, resourceRowMapper, resourceId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns the current available quantity for a resource.
     */
    public int getAvailableQuantity(int resourceId) {
        String sql = "SELECT available_quantity FROM resources WHERE resource_id = ?";
        Integer qty = jdbcTemplate.queryForObject(sql, Integer.class, resourceId);
        return qty != null ? qty : 0;
    }

    /**
     * Returns all allocations for a specific event.
     */
    public List<ResourceAllocation> findAllocationsByEventId(int eventId) {
        String sql =
            "SELECT ra.allocation_id, ra.event_id, e.event_name, " +
            "       ra.resource_id, r.resource_name, ra.quantity, " +
            "       ra.allocated_on, ra.notes " +
            "FROM resource_allocations ra " +
            "JOIN events    e ON ra.event_id    = e.event_id " +
            "JOIN resources r ON ra.resource_id = r.resource_id " +
            "WHERE ra.event_id = ?";
        return jdbcTemplate.query(sql, allocationRowMapper, eventId);
    }

    /**
     * Returns all resource allocations (for operations overview).
     */
    public List<ResourceAllocation> findAllAllocations() {
        String sql =
            "SELECT ra.allocation_id, ra.event_id, e.event_name, " +
            "       ra.resource_id, r.resource_name, ra.quantity, " +
            "       ra.allocated_on, ra.notes " +
            "FROM resource_allocations ra " +
            "JOIN events    e ON ra.event_id    = e.event_id " +
            "JOIN resources r ON ra.resource_id = r.resource_id " +
            "ORDER BY ra.allocated_on DESC";
        return jdbcTemplate.query(sql, allocationRowMapper);
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates resource details.
     */
    public int updateResource(Resource resource) {
        String sql =
            "UPDATE resources SET resource_name = ?, category = ?, " +
            "                     total_quantity = ?, status = ?, description = ? " +
            "WHERE resource_id = ?";
        return jdbcTemplate.update(sql,
                resource.getResourceName(),
                resource.getCategory(),
                resource.getTotalQuantity(),
                resource.getStatus(),
                resource.getDescription(),
                resource.getResourceId());
    }

    /**
     * Activates or deactivates a resource.
     */
    public int setActiveStatus(int resourceId, boolean active) {
        String sql = "UPDATE resources SET is_active = ? WHERE resource_id = ?";
        return jdbcTemplate.update(sql, active ? 1 : 0, resourceId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a resource by ID.
     */
    public int deleteResource(int resourceId) {
        String sql = "DELETE FROM resources WHERE resource_id = ?";
        return jdbcTemplate.update(sql, resourceId);
    }

    /**
     * Releases (removes) a resource allocation and restores available_quantity.
     */
    public int releaseAllocation(int allocationId) {
        // First get the quantity to restore
        String selectSql =
            "SELECT resource_id, quantity FROM resource_allocations WHERE allocation_id = ?";
        List<int[]> rows = jdbcTemplate.query(selectSql,
                (rs, rowNum) -> new int[]{rs.getInt("resource_id"), rs.getInt("quantity")},
                allocationId);

        if (!rows.isEmpty()) {
            int resourceId = rows.get(0)[0];
            int quantity   = rows.get(0)[1];

            // Restore available quantity
            String restoreSql =
                "UPDATE resources SET available_quantity = available_quantity + ? " +
                "WHERE resource_id = ?";
            jdbcTemplate.update(restoreSql, quantity, resourceId);
        }

        // Delete the allocation record
        String deleteSql = "DELETE FROM resource_allocations WHERE allocation_id = ?";
        return jdbcTemplate.update(deleteSql, allocationId);
    }
}
