package com.eventsphere.service;

import com.eventsphere.dao.ResourceDAO;
import com.eventsphere.model.Resource;
import com.eventsphere.model.ResourceAllocation;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for Resource Management (Module 4).
 * Handles resource CRUD and availability validation.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class ResourceService {

    private final ResourceDAO resourceDAO;

    public ResourceService(ResourceDAO resourceDAO) {
        this.resourceDAO = resourceDAO;
    }

    // ── READ ───────────────────────────────────────────────────

    public List<Resource> getAllResources()      { return resourceDAO.findAll(); }
    public List<Resource> getActiveResources()  { return resourceDAO.findAllActive(); }

    public Optional<Resource> getResourceById(int resourceId) {
        return resourceDAO.findById(resourceId);
    }

    public List<ResourceAllocation> getAllocationsByEvent(int eventId) {
        return resourceDAO.findAllocationsByEventId(eventId);
    }

    public List<ResourceAllocation> getAllAllocations() {
        return resourceDAO.findAllAllocations();
    }

    // ── CREATE ─────────────────────────────────────────────────

    /**
     * Adds a new resource. Returns null on success, error message on failure.
     */
    public String addResource(Resource resource) {
        String error = validateResource(resource);
        if (error != null) return error;
        if (resource.getStatus() == null) resource.setStatus("Available");
        resourceDAO.addResource(resource);
        return null;
    }

    // ── ALLOCATE ───────────────────────────────────────────────

    /**
     * Allocates resources to an event.
     *
     * Validates that requested quantity does not exceed available quantity.
     * Deducts available_quantity on successful allocation.
     *
     * @return null on success, error message if insufficient stock
     */
    public String allocateResource(ResourceAllocation allocation) {
        if (allocation.getQuantity() <= 0) {
            return "Quantity must be greater than zero.";
        }

        if (resourceDAO.allocateResource(allocation) == 0) {
            return "Resource is unavailable or has insufficient stock.";
        }
        return null;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates resource details.
     */
    public String updateResource(Resource resource) {
        String error = validateResource(resource);
        if (error != null) return error;
        if (resourceDAO.updateResource(resource) == 0) return "Total quantity cannot be less than the allocated stock, or resource was not found.";
        return null;
    }

    public void setActiveStatus(int resourceId, boolean active) {
        resourceDAO.setActiveStatus(resourceId, active);
    }

    // ── DELETE ─────────────────────────────────────────────────

    public void deleteResource(int resourceId) {
        resourceDAO.deleteResource(resourceId);
    }

    /**
     * Releases an allocation and restores available quantity.
     */
    public void releaseAllocation(int allocationId) {
        resourceDAO.releaseAllocation(allocationId);
    }

    // ── VALIDATION ─────────────────────────────────────────────

    private String validateResource(Resource resource) {
        if (resource.getResourceName() == null || resource.getResourceName().trim().isEmpty()) {
            return "Resource name is required.";
        }
        if (resource.getTotalQuantity() <= 0) {
            return "Total quantity must be greater than zero.";
        }
        return null;
    }
}
