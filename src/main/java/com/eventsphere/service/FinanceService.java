package com.eventsphere.service;

import com.eventsphere.dao.BudgetDAO;
import com.eventsphere.dao.ExpenseDAO;
import com.eventsphere.dao.InvoiceDAO;
import com.eventsphere.dao.NotificationDAO;
import com.eventsphere.dao.PaymentDAO;
import com.eventsphere.model.Budget;
import com.eventsphere.model.Expense;
import com.eventsphere.model.Invoice;
import com.eventsphere.model.Payment;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Service for Finance & Payment Management (Module 6).
 * Handles budgets, expenses, invoices, and payments.
 */
@Service
@org.springframework.transaction.annotation.Transactional
public class FinanceService {

    private final com.eventsphere.dao.EventDAO eventDAO;
    private final com.eventsphere.dao.CustomerDAO customerDAO;
    private final BudgetDAO budgetDAO;
    private final ExpenseDAO expenseDAO;
    private final InvoiceDAO invoiceDAO;
    private final PaymentDAO paymentDAO;
    private final NotificationDAO notificationDAO;

    public FinanceService(com.eventsphere.dao.EventDAO eventDAO, com.eventsphere.dao.CustomerDAO customerDAO, BudgetDAO budgetDAO,
                          ExpenseDAO expenseDAO,
                          InvoiceDAO invoiceDAO,
                          PaymentDAO paymentDAO,
                          NotificationDAO notificationDAO) {
        this.eventDAO = eventDAO;
        this.customerDAO = customerDAO;
        this.budgetDAO        = budgetDAO;
        this.expenseDAO       = expenseDAO;
        this.invoiceDAO       = invoiceDAO;
        this.paymentDAO       = paymentDAO;
        this.notificationDAO  = notificationDAO;
    }

    // ── BUDGETS ────────────────────────────────────────────────

    public Optional<Budget> getBudgetByEventId(int eventId) {
        return budgetDAO.findByEventId(eventId);
    }

    public Optional<Budget> getBudgetById(int budgetId) {
        return budgetDAO.findById(budgetId);
    }

    public List<Budget> getAllBudgets() {
        return budgetDAO.findAll();
    }

    /**
     * Creates an event budget. Returns null on success, error on failure.
     */
    public String createBudget(Budget budget) {
        if (budget.getTotalBudget() == null || budget.getTotalBudget().compareTo(BigDecimal.ZERO) < 0) {
            return "Budget amount cannot be negative.";
        }
        if (budgetDAO.findByEventId(budget.getEventId()).isPresent()) {
            return "A budget already exists for this event.";
        }
        if (budget.getEstimatedCost() == null) budget.setEstimatedCost(BigDecimal.ZERO);
        budget.setActualCost(expenseDAO.getTotalByEventId(budget.getEventId()));
        budgetDAO.addBudget(budget);
        return null;
    }

    /**
     * Updates a budget. Returns null on success, error on failure.
     */
    public String updateBudget(Budget budget) {
        if (budget.getTotalBudget() == null || budget.getTotalBudget().compareTo(BigDecimal.ZERO) < 0) {
            return "Budget amount cannot be negative.";
        }
        Budget existing = budgetDAO.findById(budget.getBudgetId()).orElseThrow();
        budget.setEventId(existing.getEventId());
        if (budget.getEstimatedCost() == null) budget.setEstimatedCost(BigDecimal.ZERO);
        budget.setActualCost(expenseDAO.getTotalByEventId(existing.getEventId()));
        budgetDAO.updateBudget(budget);
        return null;
    }

    public void deleteBudget(int budgetId) {
        budgetDAO.deleteBudget(budgetId);
    }

    // ── EXPENSES ───────────────────────────────────────────────

    public List<Expense> getAllExpenses()               { return expenseDAO.findAll(); }
    public List<Expense> getExpensesByEvent(int eid)   { return expenseDAO.findByEventId(eid); }
    public Optional<Expense> getExpenseById(int id)    { return expenseDAO.findById(id); }

    /**
     * Records a new expense and recalculates the budget's actual cost.
     */
    public String addExpense(Expense expense) {
        if (expense.getAmount() == null || expense.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Expense amount must be greater than zero.";
        }
        if (expense.getDescription() == null || expense.getDescription().trim().isEmpty()) {
            return "Description is required.";
        }
        if (expense.getExpenseDate() == null) {
            return "Expense date is required.";
        }
        expenseDAO.addExpense(expense);
        // Recalculate actual cost in budget
        budgetDAO.recalculateActualCost(expense.getEventId());
        return null;
    }

    public String updateExpense(Expense expense) {
        if (expense.getAmount() == null || expense.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Expense amount must be greater than zero.";
        }
        if (expense.getExpenseDate() == null || expense.getDescription() == null || expense.getDescription().isBlank())
            return "Description and expense date are required.";
        expense.setEventId(expenseDAO.findById(expense.getExpenseId()).orElseThrow().getEventId());
        expenseDAO.updateExpense(expense);
        budgetDAO.recalculateActualCost(expense.getEventId());
        return null;
    }

    public void deleteExpense(int expenseId, int eventId) {
        Optional<Expense> existing = expenseDAO.findById(expenseId);
        if (existing.isEmpty()) return;
        eventId = existing.get().getEventId();
        expenseDAO.deleteExpense(expenseId);
        budgetDAO.recalculateActualCost(eventId);
    }

    public BigDecimal getTotalExpensesByEvent(int eventId) {
        return expenseDAO.getTotalByEventId(eventId);
    }

    // ── INVOICES ───────────────────────────────────────────────

    public List<Invoice> getAllInvoices()                    { return invoiceDAO.findAll(); }
    public List<Invoice> getInvoicesByCustomer(int cid)     { return invoiceDAO.findByCustomerId(cid); }
    public List<Invoice> getInvoicesByEvent(int eid)        { return invoiceDAO.findByEventId(eid); }
    public Optional<Invoice> getInvoiceById(int id)         { return invoiceDAO.findById(id); }

    /**
     * Creates a new invoice. Generates invoice number automatically.
     */
    public String createInvoice(Invoice invoice) {
        if (invoice.getTotalAmount() == null || invoice.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Invoice total must be greater than zero.";
        }
        if (eventDAO.findById(invoice.getEventId()).filter(e -> e.getCustomerId() == invoice.getCustomerId()).isEmpty())
            return "Select the customer who owns this event.";
        if (invoice.getDueDate() != null && invoice.getIssuedDate() != null && invoice.getDueDate().isBefore(invoice.getIssuedDate()))
            return "Due date cannot be before the invoice date.";
        // Auto-generate invoice number if not set
        if (invoice.getInvoiceNumber() == null || invoice.getInvoiceNumber().trim().isEmpty()) {
            invoice.setInvoiceNumber("INV-" + java.util.UUID.randomUUID());
        }
        if (invoice.getIssuedDate() == null) {
            invoice.setIssuedDate(LocalDate.now());
        }
        invoice.setStatus("Pending");
        invoiceDAO.addInvoice(invoice);
        return null;
    }

    public String updateInvoice(Invoice invoice) {
        if (invoice.getTotalAmount() == null || invoice.getTotalAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Invoice total must be greater than zero.";
        }
        Optional<Invoice> existing = invoiceDAO.findById(invoice.getInvoiceId());
        if (existing.isEmpty()) return "Invoice not found.";
        if (invoice.getDueDate() != null && existing.get().getIssuedDate() != null
                && invoice.getDueDate().isBefore(existing.get().getIssuedDate()))
            return "Due date cannot be before the invoice date.";
        BigDecimal paid = invoiceDAO.getTotalPaid(invoice.getInvoiceId());
        if (invoice.getTotalAmount().compareTo(paid) < 0) return "Invoice total cannot be less than payments received.";
        invoice.setStatus(paymentStatus(paid, invoice.getTotalAmount()));
        invoiceDAO.updateInvoice(invoice);
        return null;
    }

    public void deleteInvoice(int invoiceId) {
        invoiceDAO.deleteInvoice(invoiceId);
    }

    /**
     * Returns an invoice with total paid and outstanding amounts populated.
     */
    public Optional<Invoice> getInvoiceWithPayments(int invoiceId) {
        Optional<Invoice> opt = invoiceDAO.findById(invoiceId);
        opt.ifPresent(invoice -> {
            BigDecimal paid = invoiceDAO.getTotalPaid(invoiceId);
            invoice.setTotalPaid(paid);
            invoice.setOutstanding(invoice.getTotalAmount().subtract(paid));
        });
        return opt;
    }

    // ── PAYMENTS ───────────────────────────────────────────────

    public List<Payment> getAllPayments()                    { return paymentDAO.findAll(); }
    public List<Payment> getPaymentsByInvoice(int invId)    { return paymentDAO.findByInvoiceId(invId); }
    public Optional<Payment> getPaymentById(int id)         { return paymentDAO.findById(id); }

    /**
     * Records a payment and automatically updates the invoice status.
     */
    @org.springframework.transaction.annotation.Transactional(isolation = org.springframework.transaction.annotation.Isolation.SERIALIZABLE)
    public String recordPayment(Payment payment, int customerUserId) {
        if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Payment amount must be greater than zero.";
        }
        if (payment.getPaymentDate() == null) {
            return "Payment date is required.";
        }

        // Check total paid + new payment doesn't exceed invoice total
        Optional<Invoice> optInvoice = invoiceDAO.findById(payment.getInvoiceId());
        if (optInvoice.isEmpty()) return "Invoice not found.";
        if (optInvoice.isPresent()) {
            Invoice invoice = optInvoice.get();
            BigDecimal alreadyPaid = invoiceDAO.getTotalPaid(payment.getInvoiceId());
            BigDecimal newTotal    = alreadyPaid.add(payment.getAmount());

            if (newTotal.compareTo(invoice.getTotalAmount()) > 0) {
                return "Payment would exceed invoice total. Outstanding: LKR " +
                       invoice.getTotalAmount().subtract(alreadyPaid);
            }

            payment.setEventId(invoice.getEventId());
            payment.setCustomerId(invoice.getCustomerId());
            customerUserId = customerDAO.findById(invoice.getCustomerId()).orElseThrow().getUserId();
            paymentDAO.addPayment(payment);

            // Update invoice status
            if (newTotal.compareTo(invoice.getTotalAmount()) == 0) {
                invoiceDAO.updateStatus(payment.getInvoiceId(), "Paid");
            } else {
                invoiceDAO.updateStatus(payment.getInvoiceId(), "Partially Paid");
            }

            // Notify customer
            notificationDAO.addNotification(customerUserId,
                    "Payment Recorded",
                    "A payment of LKR " + payment.getAmount() +
                    " has been recorded for invoice " + invoice.getInvoiceNumber() + ".");
        }

        return null;
    }

    public void deletePayment(int paymentId) {
        Optional<Payment> payment = paymentDAO.findById(paymentId);
        if (payment.isEmpty()) return;
        int invoiceId = payment.get().getInvoiceId();
        paymentDAO.deletePayment(paymentId);
        Invoice invoice = invoiceDAO.findById(invoiceId).orElseThrow();
        invoiceDAO.updateStatus(invoiceId, paymentStatus(invoiceDAO.getTotalPaid(invoiceId), invoice.getTotalAmount()));
    }

    private String paymentStatus(BigDecimal paid, BigDecimal total) {
        if (paid.signum() == 0) return "Pending";
        return paid.compareTo(total) >= 0 ? "Paid" : "Partially Paid";
    }

    // ── SUMMARY ────────────────────────────────────────────────

    public BigDecimal getTotalRevenue()     { return invoiceDAO.getTotalRevenue(); }
    public BigDecimal getTotalOutstanding() { return invoiceDAO.getTotalOutstanding(); }
    public BigDecimal getTotalCollected()   { return paymentDAO.getTotalCollected(); }
}
