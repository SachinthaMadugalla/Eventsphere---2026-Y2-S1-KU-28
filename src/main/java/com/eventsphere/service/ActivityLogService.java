package com.eventsphere.service;

import com.eventsphere.dao.ActivityLogDAO;
import com.eventsphere.model.ActivityLog;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service for Activity Logging (common supporting function).
 * Call log() after important operations to record them.
 *
 * Usage example (in a controller or service):
 *
 *   activityLogService.log(userId, "Recorded payment LKR 50,000 for invoice INV-2026-001",
 *                          "Payment", paymentId);
 *
 *   activityLogService.log(userId, "Updated event status to Confirmed",
 *                          "Event", eventId);
 */
@Service
public class ActivityLogService {

    private final ActivityLogDAO activityLogDAO;

    public ActivityLogService(ActivityLogDAO activityLogDAO) {
        this.activityLogDAO = activityLogDAO;
    }

    // ── LOG ACTIONS ────────────────────────────────────────────

    /**
     * Logs an action performed by a user on a specific entity.
     *
     * @param userId     The user performing the action (null for system events)
     * @param action     Human-readable description of what happened
     * @param entityType The type of entity affected (e.g. "Event", "Payment")
     * @param entityId   The primary key of the affected record (nullable)
     */
    public void log(Integer userId, String action, String entityType, Integer entityId) {
        try {
            activityLogDAO.log(userId, action, entityType, entityId);
        } catch (Exception e) {
            // Logging must never break the main operation
            // Silently absorb logging failures
        }
    }

    /** Convenience — log without an entity ID (e.g. general system actions) */
    public void log(Integer userId, String action) {
        log(userId, action, null, null);
    }

    // ── READ LOGS ──────────────────────────────────────────────

    public List<ActivityLog> getRecent(int limit) {
        return activityLogDAO.findRecent(limit);
    }

    public List<ActivityLog> getByEntity(String entityType, int entityId) {
        return activityLogDAO.findByEntity(entityType, entityId);
    }

    public List<ActivityLog> getByUser(int userId) {
        return activityLogDAO.findByUser(userId);
    }

    public List<ActivityLog> getAll() {
        return activityLogDAO.findAll();
    }
}
