package com.eventsphere.dao;

import com.eventsphere.model.Invoice;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * DAO for Invoice Management (Module 6 – Finance).
 * All SQL queries are explicitly written here.
 */
@Repository
public class InvoiceDAO {

    private final JdbcTemplate jdbcTemplate;

    public InvoiceDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Invoice> invoiceRowMapper = (rs, rowNum) -> {
        Invoice i = new Invoice();
        i.setInvoiceId(rs.getInt("invoice_id"));
        i.setEventId(rs.getInt("event_id"));
        i.setEventName(rs.getString("event_name"));
        i.setCustomerId(rs.getInt("customer_id"));
        i.setCustomerName(rs.getString("customer_name"));
        i.setInvoiceNumber(rs.getString("invoice_number"));
        i.setTotalAmount(rs.getBigDecimal("total_amount"));
        i.setIssuedDate(rs.getDate("issued_date") != null
                ? rs.getDate("issued_date").toLocalDate() : null);
        i.setDueDate(rs.getDate("due_date") != null
                ? rs.getDate("due_date").toLocalDate() : null);
        i.setStatus(rs.getString("status"));
        i.setNotes(rs.getString("notes"));
        i.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return i;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Creates a new invoice record.
     */
    public int addInvoice(Invoice invoice) {
        String sql =
            "INSERT INTO invoices (event_id, customer_id, invoice_number, total_amount, " +
            "                      issued_date, due_date, status, notes) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                invoice.getEventId(),
                invoice.getCustomerId(),
                invoice.getInvoiceNumber(),
                invoice.getTotalAmount(),
                invoice.getIssuedDate(),
                invoice.getDueDate(),
                invoice.getStatus(),
                invoice.getNotes());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all invoices.
     */
    public List<Invoice> findAll() {
        String sql =
            "SELECT i.invoice_id, i.event_id, e.event_name, " +
            "       i.customer_id, c.full_name AS customer_name, " +
            "       i.invoice_number, i.total_amount, i.issued_date, " +
            "       i.due_date, i.status, i.notes, i.created_at " +
            "FROM invoices i " +
            "JOIN events    e ON i.event_id    = e.event_id " +
            "JOIN customers c ON i.customer_id = c.customer_id " +
            "ORDER BY i.issued_date DESC";
        return jdbcTemplate.query(sql, invoiceRowMapper);
    }

    /**
     * Finds an invoice by its primary key.
     */
    public Optional<Invoice> findById(int invoiceId) {
        String sql =
            "SELECT i.invoice_id, i.event_id, e.event_name, " +
            "       i.customer_id, c.full_name AS customer_name, " +
            "       i.invoice_number, i.total_amount, i.issued_date, " +
            "       i.due_date, i.status, i.notes, i.created_at " +
            "FROM invoices i " +
            "JOIN events    e ON i.event_id    = e.event_id " +
            "JOIN customers c ON i.customer_id = c.customer_id " +
            "WHERE i.invoice_id = ?";
        List<Invoice> result = jdbcTemplate.query(sql, invoiceRowMapper, invoiceId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns invoices for a specific customer.
     */
    public List<Invoice> findByCustomerId(int customerId) {
        String sql =
            "SELECT i.invoice_id, i.event_id, e.event_name, " +
            "       i.customer_id, c.full_name AS customer_name, " +
            "       i.invoice_number, i.total_amount, i.issued_date, " +
            "       i.due_date, i.status, i.notes, i.created_at " +
            "FROM invoices i " +
            "JOIN events    e ON i.event_id    = e.event_id " +
            "JOIN customers c ON i.customer_id = c.customer_id " +
            "WHERE i.customer_id = ? ORDER BY i.issued_date DESC";
        return jdbcTemplate.query(sql, invoiceRowMapper, customerId);
    }

    /**
     * Returns invoices for a specific event.
     */
    public List<Invoice> findByEventId(int eventId) {
        String sql =
            "SELECT i.invoice_id, i.event_id, e.event_name, " +
            "       i.customer_id, c.full_name AS customer_name, " +
            "       i.invoice_number, i.total_amount, i.issued_date, " +
            "       i.due_date, i.status, i.notes, i.created_at " +
            "FROM invoices i " +
            "JOIN events    e ON i.event_id    = e.event_id " +
            "JOIN customers c ON i.customer_id = c.customer_id " +
            "WHERE i.event_id = ?";
        return jdbcTemplate.query(sql, invoiceRowMapper, eventId);
    }

    /**
     * Returns the total amount paid for a specific invoice.
     */
    public BigDecimal getTotalPaid(int invoiceId) {
        String sql =
            "SELECT ISNULL(SUM(amount), 0) FROM payments WHERE invoice_id = ?";
        BigDecimal total = jdbcTemplate.queryForObject(sql, BigDecimal.class, invoiceId);
        return total != null ? total : BigDecimal.ZERO;
    }

    /**
     * Returns the sum of all invoice totals (total revenue).
     */
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM invoices WHERE status = 'Paid'";
        BigDecimal total = jdbcTemplate.queryForObject(sql, BigDecimal.class);
        return total != null ? total : BigDecimal.ZERO;
    }

    /**
     * Returns sum of outstanding (unpaid) amounts across all invoices.
     */
    public BigDecimal getTotalOutstanding() {
        String sql =
            "SELECT ISNULL(SUM(i.total_amount - ISNULL(p.paid, 0)), 0) " +
            "FROM invoices i " +
            "LEFT JOIN (SELECT invoice_id, SUM(amount) AS paid FROM payments GROUP BY invoice_id) p " +
            "       ON i.invoice_id = p.invoice_id " +
            "WHERE i.status <> 'Paid'";
        BigDecimal total = jdbcTemplate.queryForObject(sql, BigDecimal.class);
        return total != null ? total : BigDecimal.ZERO;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates invoice details.
     */
    public int updateInvoice(Invoice invoice) {
        String sql =
            "UPDATE invoices SET total_amount = ?, due_date = ?, status = ?, notes = ? " +
            "WHERE invoice_id = ?";
        return jdbcTemplate.update(sql,
                invoice.getTotalAmount(),
                invoice.getDueDate(),
                invoice.getStatus(),
                invoice.getNotes(),
                invoice.getInvoiceId());
    }

    /**
     * Updates only the invoice status.
     */
    public int updateStatus(int invoiceId, String status) {
        String sql = "UPDATE invoices SET status = ? WHERE invoice_id = ?";
        return jdbcTemplate.update(sql, status, invoiceId);
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes an invoice by ID.
     */
    public int deleteInvoice(int invoiceId) {
        String sql = "DELETE FROM invoices WHERE invoice_id = ?";
        return jdbcTemplate.update(sql, invoiceId);
    }
}
