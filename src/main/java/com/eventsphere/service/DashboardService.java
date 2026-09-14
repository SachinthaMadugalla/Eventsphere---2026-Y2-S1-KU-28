package com.eventsphere.service;

import com.eventsphere.dao.*;
import com.eventsphere.dto.DashboardStatsDTO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * Service that assembles dashboard statistics for all role dashboards.
 * Pulls counts and totals from multiple DAOs into one DashboardStatsDTO.
 */
@Service
public class DashboardService {

    private final EventDAO eventDAO;
    private final TaskDAO taskDAO;
    private final CustomerDAO customerDAO;
    private final StaffDAO staffDAO;
    private final InvoiceDAO invoiceDAO;
    private final PaymentDAO paymentDAO;
    private final ComplaintDAO complaintDAO;
    private final FeedbackDAO feedbackDAO;

    public DashboardService(EventDAO eventDAO,
                             TaskDAO taskDAO,
                             CustomerDAO customerDAO,
                             StaffDAO staffDAO,
                             InvoiceDAO invoiceDAO,
                             PaymentDAO paymentDAO,
                             ComplaintDAO complaintDAO,
                             FeedbackDAO feedbackDAO) {
        this.eventDAO     = eventDAO;
        this.taskDAO      = taskDAO;
        this.customerDAO  = customerDAO;
        this.staffDAO     = staffDAO;
        this.invoiceDAO   = invoiceDAO;
        this.paymentDAO   = paymentDAO;
        this.complaintDAO = complaintDAO;
        this.feedbackDAO  = feedbackDAO;
    }

    /**
     * Builds a full statistics snapshot used by multiple dashboards.
     * Each piece of data is a simple COUNT or SUM query in the respective DAO.
     */
    public DashboardStatsDTO getStats() {
        DashboardStatsDTO stats = new DashboardStatsDTO();

        // Event counts
        stats.setTotalEvents(eventDAO.countAll());
        stats.setUpcomingEvents(eventDAO.countUpcoming());

        // Break down by status
        for (Object[] row : eventDAO.countByStatus()) {
            String status = (String) row[0];
            int count = (int) row[1];
            switch (status) {
                case "Requested"  -> stats.setRequestedEvents(count);
                case "Confirmed"  -> stats.setConfirmedEvents(count);
                case "Planning"   -> stats.setPlanningEvents(count);
                case "Completed"  -> stats.setCompletedEvents(count);
                case "Cancelled"  -> stats.setCancelledEvents(count);
            }
        }

        // Task counts
        stats.setPendingTasks(taskDAO.countByStatus("Not Started"));
        stats.setInProgressTasks(taskDAO.countByStatus("In Progress"));
        stats.setOverdueTasks(taskDAO.countOverdue());

        // Customer and staff counts
        stats.setTotalCustomers(customerDAO.countAll());
        stats.setTotalStaff(staffDAO.countAll());

        // Finance
        BigDecimal revenue     = invoiceDAO.getTotalRevenue();
        BigDecimal outstanding = invoiceDAO.getTotalOutstanding();
        BigDecimal collected   = paymentDAO.getTotalCollected();

        stats.setTotalRevenue(revenue != null ? revenue : BigDecimal.ZERO);
        stats.setPendingPayments(outstanding != null ? outstanding : BigDecimal.ZERO);
        stats.setTotalExpenses(collected != null ? collected : BigDecimal.ZERO);

        // Feedback & complaints
        stats.setOpenComplaints(complaintDAO.countOpen());
        stats.setTotalFeedback(feedbackDAO.findAll().size());

        return stats;
    }
}
