package com.eventsphere.dto;

import java.math.BigDecimal;

/**
 * Carries aggregated statistics for dashboard displays.
 * Populated by service layer queries and passed to JSP views.
 */
public class DashboardStatsDTO {

    // Event stats
    private int totalEvents;
    private int requestedEvents;
    private int confirmedEvents;
    private int planningEvents;
    private int completedEvents;
    private int cancelledEvents;
    private int upcomingEvents;

    // Task stats
    private int pendingTasks;
    private int overdueTasks;
    private int inProgressTasks;

    // Finance stats
    private BigDecimal totalRevenue;
    private BigDecimal pendingPayments;
    private BigDecimal totalExpenses;

    // Feedback & complaints
    private int openComplaints;
    private int totalFeedback;

    // User/customer stats
    private int totalCustomers;
    private int totalStaff;

    public DashboardStatsDTO() {}

    // ── Getters & Setters ──────────────────────────────────────

    public int getTotalEvents()                         { return totalEvents; }
    public void setTotalEvents(int totalEvents)         { this.totalEvents = totalEvents; }

    public int getRequestedEvents()                     { return requestedEvents; }
    public void setRequestedEvents(int requestedEvents) { this.requestedEvents = requestedEvents; }

    public int getConfirmedEvents()                     { return confirmedEvents; }
    public void setConfirmedEvents(int confirmedEvents) { this.confirmedEvents = confirmedEvents; }

    public int getPlanningEvents()                      { return planningEvents; }
    public void setPlanningEvents(int planningEvents)   { this.planningEvents = planningEvents; }

    public int getCompletedEvents()                     { return completedEvents; }
    public void setCompletedEvents(int completedEvents) { this.completedEvents = completedEvents; }

    public int getCancelledEvents()                     { return cancelledEvents; }
    public void setCancelledEvents(int cancelledEvents) { this.cancelledEvents = cancelledEvents; }

    public int getUpcomingEvents()                      { return upcomingEvents; }
    public void setUpcomingEvents(int upcomingEvents)   { this.upcomingEvents = upcomingEvents; }

    public int getPendingTasks()                        { return pendingTasks; }
    public void setPendingTasks(int pendingTasks)       { this.pendingTasks = pendingTasks; }

    public int getOverdueTasks()                        { return overdueTasks; }
    public void setOverdueTasks(int overdueTasks)       { this.overdueTasks = overdueTasks; }

    public int getInProgressTasks()                     { return inProgressTasks; }
    public void setInProgressTasks(int inProgressTasks) { this.inProgressTasks = inProgressTasks; }

    public BigDecimal getTotalRevenue()                 { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue){ this.totalRevenue = totalRevenue; }

    public BigDecimal getPendingPayments()                  { return pendingPayments; }
    public void setPendingPayments(BigDecimal pendingPayments){ this.pendingPayments = pendingPayments; }

    public BigDecimal getTotalExpenses()                    { return totalExpenses; }
    public void setTotalExpenses(BigDecimal totalExpenses)  { this.totalExpenses = totalExpenses; }

    public int getOpenComplaints()                      { return openComplaints; }
    public void setOpenComplaints(int openComplaints)   { this.openComplaints = openComplaints; }

    public int getTotalFeedback()                       { return totalFeedback; }
    public void setTotalFeedback(int totalFeedback)     { this.totalFeedback = totalFeedback; }

    public int getTotalCustomers()                      { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers)   { this.totalCustomers = totalCustomers; }

    public int getTotalStaff()                          { return totalStaff; }
    public void setTotalStaff(int totalStaff)           { this.totalStaff = totalStaff; }
}
