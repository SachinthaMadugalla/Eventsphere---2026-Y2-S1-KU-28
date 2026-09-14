package com.eventsphere.service;

import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.model.Notification;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Service for internal Notification management.
 * Notifications are a common supporting function, not a module.
 */
@Service
public class NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationService(NotificationDAO notificationDAO) {
        this.notificationDAO = notificationDAO;
    }

    public List<Notification> getAllForUser(int userId) {
        return notificationDAO.findByUserId(userId);
    }

    public List<Notification> getUnreadForUser(int userId) {
        return notificationDAO.findUnreadByUserId(userId);
    }

    public int countUnread(int userId) {
        return notificationDAO.countUnread(userId);
    }

    public void send(int userId, String title, String message) {
        notificationDAO.addNotification(userId, title, message);
    }

    public void markAsRead(int notificationId, int userId) {
        notificationDAO.markAsRead(notificationId, userId);
    }

    public void markAllAsRead(int userId) {
        notificationDAO.markAllAsRead(userId);
    }

    public void deleteNotification(int notificationId, int userId) {
        notificationDAO.deleteNotification(notificationId, userId);
    }
}
