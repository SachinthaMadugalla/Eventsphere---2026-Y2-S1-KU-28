package com.eventsphere.service;

import com.eventsphere.dao.ComplaintDAO;
import com.eventsphere.dao.FeedbackDAO;
import com.eventsphere.model.Complaint;
import com.eventsphere.model.Feedback;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for Reporting & Feedback Management (Module 7).
 * Handles feedback and complaints. Reporting data is gathered
 * from other services (EventService, FinanceService, etc.)
 * and assembled in the controller.
 */
@Service
public class ReportingService {

    private final FeedbackDAO feedbackDAO;
    private final ComplaintDAO complaintDAO;

    public ReportingService(FeedbackDAO feedbackDAO, ComplaintDAO complaintDAO) {
        this.feedbackDAO  = feedbackDAO;
        this.complaintDAO = complaintDAO;
    }

    // ── FEEDBACK ───────────────────────────────────────────────

    public List<Feedback> getAllFeedback()                    { return feedbackDAO.findAll(); }
    public Optional<Feedback> getFeedbackById(int id)        { return feedbackDAO.findById(id); }
    public List<Feedback> getFeedbackByCustomer(int cid)     { return feedbackDAO.findByCustomerId(cid); }
    public List<Feedback> getFeedbackByEvent(int eid)        { return feedbackDAO.findByEventId(eid); }
    public double getAverageRating()                         { return feedbackDAO.getAverageRating(); }

    /**
     * Submits new feedback for a completed event.
     * Validates rating range and prevents duplicate submissions.
     */
    public String submitFeedback(Feedback feedback) {
        if (feedback.getRating() < 1 || feedback.getRating() > 5) {
            return "Rating must be between 1 and 5.";
        }
        if (feedbackDAO.hasSubmittedFeedback(feedback.getCustomerId(), feedback.getEventId())) {
            return "You have already submitted feedback for this event.";
        }
        feedbackDAO.addFeedback(feedback);
        return null;
    }

    /**
     * Moderates inappropriate feedback.
     */
    public String moderateFeedback(int feedbackId, String reason) {
        if (reason == null || reason.trim().isEmpty()) {
            return "Moderation reason is required.";
        }
        feedbackDAO.moderateFeedback(feedbackId, reason.trim());
        return null;
    }

    public void deleteFeedback(int feedbackId) {
        feedbackDAO.deleteFeedback(feedbackId);
    }

    // ── COMPLAINTS ─────────────────────────────────────────────

    public List<Complaint> getAllComplaints()               { return complaintDAO.findAll(); }
    public Optional<Complaint> getComplaintById(int id)    { return complaintDAO.findById(id); }
    public List<Complaint> getComplaintsByCustomer(int cid){ return complaintDAO.findByCustomerId(cid); }
    public List<Complaint> getEscalatedComplaints()        { return complaintDAO.findEscalated(); }
    public int countOpenComplaints()                       { return complaintDAO.countOpen(); }

    /**
     * Submits a new complaint.
     */
    public String submitComplaint(Complaint complaint) {
        if (complaint.getSubject() == null || complaint.getSubject().trim().isEmpty()) {
            return "Complaint subject is required.";
        }
        if (complaint.getDescription() == null || complaint.getDescription().trim().isEmpty()) {
            return "Complaint description is required.";
        }
        complaintDAO.addComplaint(complaint);
        return null;
    }

    /**
     * Updates complaint status and response, with optional escalation.
     */
    public String updateComplaint(Complaint complaint) {
        if (complaint.getStatus() == null || complaint.getStatus().trim().isEmpty()) {
            return "Status is required.";
        }
        complaintDAO.updateComplaint(complaint);
        return null;
    }

    /**
     * Escalates a complaint to the Managing Director.
     */
    public void escalateComplaint(int complaintId) {
        complaintDAO.escalateComplaint(complaintId);
    }

    public void deleteComplaint(int complaintId) {
        complaintDAO.deleteComplaint(complaintId);
    }
}
