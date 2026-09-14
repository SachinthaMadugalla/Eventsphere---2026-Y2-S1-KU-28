package com.eventsphere.controller;

import com.eventsphere.model.*;
import com.eventsphere.service.CustomerService;
import com.eventsphere.service.EventService;
import com.eventsphere.service.FinanceService;
import com.eventsphere.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

/**
 * Module 6 – Finance & Payment Management.
 */
@Controller
@RequestMapping("/finance")
public class FinanceController {

    private final FinanceService      financeService;
    private final EventService        eventService;
    private final CustomerService     customerService;
    private final NotificationService notificationService;

    public FinanceController(FinanceService financeService,
                             EventService eventService,
                             CustomerService customerService,
                             NotificationService notificationService) {
        this.financeService      = financeService;
        this.eventService        = eventService;
        this.customerService     = customerService;
        this.notificationService = notificationService;
    }

    private User getUser(HttpSession session) { return (User) session.getAttribute("loggedInUser"); }

    private boolean hasAccess(User user) {
        if (user == null) return false;
        String r = user.getRoleName();
        return "Finance Manager".equals(r) || "Managing Director".equals(r)
            || "Event Manager".equals(r)   || "System Administrator".equals(r);
    }

    // ── FINANCE DASHBOARD ─────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("totalRevenue",     financeService.getTotalRevenue());
        model.addAttribute("totalOutstanding", financeService.getTotalOutstanding());
        model.addAttribute("totalCollected",   financeService.getTotalCollected());
        model.addAttribute("recentInvoices",   financeService.getAllInvoices());
        model.addAttribute("recentPayments",   financeService.getAllPayments());
        model.addAttribute("budgets",          financeService.getAllBudgets());
        model.addAttribute("unreadCount",      notificationService.countUnread(user.getUserId()));
        return "finance/dashboard";
    }

    // ── BUDGETS ────────────────────────────────────────────────

    @GetMapping("/budget/list")
    public String budgetList(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("budgets",    financeService.getAllBudgets());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/budget-list";
    }

    @GetMapping("/budget/create")
    public String budgetCreateForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("budget",     new Budget());
        model.addAttribute("events",     eventService.getAllEvents());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/budget-form";
    }

    @PostMapping("/budget/create")
    public String createBudget(@ModelAttribute Budget budget,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        String error = financeService.createBudget(budget);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/finance/budget/create";
        }
        redirectAttributes.addFlashAttribute("success", "Budget created.");
        return "redirect:/finance/budget/list";
    }

    @GetMapping("/budget/edit/{budgetId}")
    public String budgetEditForm(@PathVariable int budgetId,
                                 HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Budget> opt = financeService.getBudgetById(budgetId);
        if (opt.isEmpty()) return "redirect:/finance/budget/list";

        model.addAttribute("budget",     opt.get());
        model.addAttribute("events",     eventService.getAllEvents());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/budget-form";
    }

    @PostMapping("/budget/edit/{budgetId}")
    public String updateBudget(@PathVariable int budgetId,
                               @ModelAttribute Budget budget,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        budget.setBudgetId(budgetId);
        String error = financeService.updateBudget(budget);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Budget updated.");
        }
        return "redirect:/finance/budget/list";
    }

    @PostMapping("/budget/delete/{budgetId}")
    public String deleteBudget(@PathVariable int budgetId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        financeService.deleteBudget(budgetId);
        redirectAttributes.addFlashAttribute("success", "Budget deleted.");
        return "redirect:/finance/budget/list";
    }

    // ── EXPENSES ───────────────────────────────────────────────

    @GetMapping("/expense/list")
    public String expenseList(HttpSession session, Model model,
                              @RequestParam(required = false) Integer eventId) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        if (eventId != null) {
            model.addAttribute("expenses", financeService.getExpensesByEvent(eventId));
            model.addAttribute("filterEventId", eventId);
        } else {
            model.addAttribute("expenses", financeService.getAllExpenses());
        }
        model.addAttribute("events",      eventService.getAllEvents());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/expense-list";
    }

    @GetMapping("/expense/create")
    public String expenseCreateForm(HttpSession session, Model model,
                                    @RequestParam(required = false) Integer eventId) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Expense expense = new Expense();
        if (eventId != null) expense.setEventId(eventId);

        model.addAttribute("expense",    expense);
        model.addAttribute("events",     eventService.getAllEvents());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/expense-form";
    }

    @PostMapping("/expense/create")
    public String createExpense(@ModelAttribute Expense expense,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        expense.setRecordedBy(user.getUserId());
        String error = financeService.addExpense(expense);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/finance/expense/create";
        }
        redirectAttributes.addFlashAttribute("success", "Expense recorded.");
        return "redirect:/finance/expense/list";
    }

    @GetMapping("/expense/edit/{expenseId}")
    public String expenseEditForm(@PathVariable int expenseId,
                                  HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Expense> opt = financeService.getExpenseById(expenseId);
        if (opt.isEmpty()) return "redirect:/finance/expense/list";

        model.addAttribute("expense",    opt.get());
        model.addAttribute("events",     eventService.getAllEvents());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/expense-form";
    }

    @PostMapping("/expense/edit/{expenseId}")
    public String updateExpense(@PathVariable int expenseId,
                                @ModelAttribute Expense expense,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        expense.setExpenseId(expenseId);
        String error = financeService.updateExpense(expense);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
        } else {
            redirectAttributes.addFlashAttribute("success", "Expense updated.");
        }
        return "redirect:/finance/expense/list";
    }

    @PostMapping("/expense/delete/{expenseId}")
    public String deleteExpense(@PathVariable int expenseId,
                                @RequestParam int eventId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        financeService.deleteExpense(expenseId, eventId);
        redirectAttributes.addFlashAttribute("success", "Expense deleted.");
        return "redirect:/finance/expense/list";
    }

    // ── INVOICES ───────────────────────────────────────────────

    @GetMapping("/invoice/list")
    public String invoiceList(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("invoices",   financeService.getAllInvoices());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/invoice-list";
    }

    @GetMapping("/invoice/detail/{invoiceId}")
    public String invoiceDetail(@PathVariable int invoiceId,
                                HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Invoice> opt = financeService.getInvoiceWithPayments(invoiceId);
        if (opt.isEmpty()) return "redirect:/finance/invoice/list";

        model.addAttribute("invoice",    opt.get());
        model.addAttribute("payments",   financeService.getPaymentsByInvoice(invoiceId));
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/invoice-detail";
    }

    @GetMapping("/invoice/create")
    public String invoiceCreateForm(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("invoice",    new Invoice());
        model.addAttribute("events",     eventService.getAllEvents());
        model.addAttribute("customers",  customerService.getAllCustomers());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/invoice-form";
    }

    @PostMapping("/invoice/create")
    public String createInvoice(@ModelAttribute Invoice invoice,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        String error = financeService.createInvoice(invoice);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/finance/invoice/create";
        }
        redirectAttributes.addFlashAttribute("success", "Invoice created.");
        return "redirect:/finance/invoice/list";
    }

    @GetMapping("/invoice/edit/{invoiceId}")
    public String invoiceEdit(@PathVariable int invoiceId, HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";
        Optional<Invoice> invoice = financeService.getInvoiceById(invoiceId);
        if (invoice.isEmpty()) return "redirect:/finance/invoice/list";
        model.addAttribute("invoice", invoice.get());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/invoice-edit";
    }

    @PostMapping("/invoice/edit/{invoiceId}")
    public String updateInvoice(@PathVariable int invoiceId, @ModelAttribute Invoice invoice,
                                HttpSession session, RedirectAttributes flash) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";
        invoice.setInvoiceId(invoiceId);
        String error = financeService.updateInvoice(invoice);
        flash.addFlashAttribute(error == null ? "success" : "error", error == null ? "Invoice updated." : error);
        return error == null ? "redirect:/finance/invoice/detail/" + invoiceId : "redirect:/finance/invoice/edit/" + invoiceId;
    }

    @PostMapping("/invoice/delete/{invoiceId}")
    public String deleteInvoice(@PathVariable int invoiceId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        financeService.deleteInvoice(invoiceId);
        redirectAttributes.addFlashAttribute("success", "Invoice deleted.");
        return "redirect:/finance/invoice/list";
    }

    // ── PAYMENTS ───────────────────────────────────────────────

    @GetMapping("/payment/list")
    public String paymentList(HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        model.addAttribute("payments",   financeService.getAllPayments());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/payment-list";
    }

    @GetMapping("/payment/record")
    public String recordPaymentForm(@RequestParam int invoiceId,
                                    HttpSession session, Model model) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Optional<Invoice> opt = financeService.getInvoiceWithPayments(invoiceId);
        if (opt.isEmpty()) return "redirect:/finance/invoice/list";

        model.addAttribute("invoice",    opt.get());
        model.addAttribute("payment",    new Payment());
        model.addAttribute("unreadCount", notificationService.countUnread(user.getUserId()));
        return "finance/payment-form";
    }

    @PostMapping("/payment/record")
    public String recordPayment(@RequestParam int invoiceId,
                                @RequestParam BigDecimal amount,
                                @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate paymentDate,
                                @RequestParam String paymentType,
                                @RequestParam(required = false) String referenceNo,
                                @RequestParam(required = false) String notes,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        Payment payment = new Payment();
        payment.setInvoiceId(invoiceId);
        payment.setAmount(amount);
        payment.setPaymentDate(paymentDate);
        payment.setPaymentType(paymentType);
        payment.setReferenceNo(referenceNo);
        payment.setNotes(notes);
        payment.setRecordedBy(user.getUserId());

        String error = financeService.recordPayment(payment, 0);
        if (error != null) {
            redirectAttributes.addFlashAttribute("error", error);
            return "redirect:/finance/payment/record?invoiceId=" + invoiceId;
        }
        redirectAttributes.addFlashAttribute("success", "Payment recorded successfully.");
        return "redirect:/finance/invoice/detail/" + invoiceId;
    }

    @PostMapping("/payment/delete/{paymentId}")
    public String deletePayment(@PathVariable int paymentId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = getUser(session);
        if (!hasAccess(user)) return "redirect:/access-denied";

        financeService.deletePayment(paymentId);
        redirectAttributes.addFlashAttribute("success", "Payment deleted.");
        return "redirect:/finance/payment/list";
    }
}
