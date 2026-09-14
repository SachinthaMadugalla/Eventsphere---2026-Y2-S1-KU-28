package com.eventsphere.dao;

import com.eventsphere.model.Payment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * DAO for Payment Management (Module 6 – Finance).
 * All SQL queries are explicitly written here.
 */
@Repository
public class PaymentDAO {

    private final JdbcTemplate jdbcTemplate;

    public PaymentDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // ── RowMapper ──────────────────────────────────────────────

    private final RowMapper<Payment> paymentRowMapper = (rs, rowNum) -> {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setInvoiceId(rs.getInt("invoice_id"));
        p.setInvoiceNumber(rs.getString("invoice_number"));
        p.setEventId(rs.getInt("event_id"));
        p.setEventName(rs.getString("event_name"));
        p.setCustomerId(rs.getInt("customer_id"));
        p.setCustomerName(rs.getString("customer_name"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentDate(rs.getDate("payment_date") != null
                ? rs.getDate("payment_date").toLocalDate() : null);
        p.setPaymentType(rs.getString("payment_type"));
        p.setReferenceNo(rs.getString("reference_no"));
        p.setNotes(rs.getString("notes"));
        int recBy = rs.getInt("recorded_by");
        p.setRecordedBy(rs.wasNull() ? null : recBy);
        p.setRecordedByName(rs.getString("recorded_by_name"));
        p.setCreatedAt(rs.getTimestamp("created_at") != null
                ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return p;
    };

    // ── INSERT ─────────────────────────────────────────────────

    /**
     * Records a new payment.
     */
    public int addPayment(Payment payment) {
        String sql =
            "INSERT INTO payments " +
            "(invoice_id, event_id, customer_id, amount, payment_date, " +
            " payment_type, reference_no, notes, recorded_by) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                payment.getInvoiceId(),
                payment.getEventId(),
                payment.getCustomerId(),
                payment.getAmount(),
                payment.getPaymentDate(),
                payment.getPaymentType(),
                payment.getReferenceNo(),
                payment.getNotes(),
                payment.getRecordedBy());
    }

    // ── SELECT ─────────────────────────────────────────────────

    /**
     * Returns all payments.
     */
    public List<Payment> findAll() {
        String sql =
            "SELECT p.payment_id, p.invoice_id, i.invoice_number, " +
            "       p.event_id, e.event_name, " +
            "       p.customer_id, c.full_name AS customer_name, " +
            "       p.amount, p.payment_date, p.payment_type, " +
            "       p.reference_no, p.notes, p.recorded_by, " +
            "       u.full_name AS recorded_by_name, p.created_at " +
            "FROM payments p " +
            "JOIN invoices  i ON p.invoice_id  = i.invoice_id " +
            "JOIN events    e ON p.event_id    = e.event_id " +
            "JOIN customers c ON p.customer_id = c.customer_id " +
            "LEFT JOIN users u ON p.recorded_by = u.user_id " +
            "ORDER BY p.payment_date DESC";
        return jdbcTemplate.query(sql, paymentRowMapper);
    }

    /**
     * Finds a payment by its primary key.
     */
    public Optional<Payment> findById(int paymentId) {
        String sql =
            "SELECT p.payment_id, p.invoice_id, i.invoice_number, " +
            "       p.event_id, e.event_name, " +
            "       p.customer_id, c.full_name AS customer_name, " +
            "       p.amount, p.payment_date, p.payment_type, " +
            "       p.reference_no, p.notes, p.recorded_by, " +
            "       u.full_name AS recorded_by_name, p.created_at " +
            "FROM payments p " +
            "JOIN invoices  i ON p.invoice_id  = i.invoice_id " +
            "JOIN events    e ON p.event_id    = e.event_id " +
            "JOIN customers c ON p.customer_id = c.customer_id " +
            "LEFT JOIN users u ON p.recorded_by = u.user_id " +
            "WHERE p.payment_id = ?";
        List<Payment> result = jdbcTemplate.query(sql, paymentRowMapper, paymentId);
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Returns all payments for a specific invoice.
     */
    public List<Payment> findByInvoiceId(int invoiceId) {
        String sql =
            "SELECT p.payment_id, p.invoice_id, i.invoice_number, " +
            "       p.event_id, e.event_name, " +
            "       p.customer_id, c.full_name AS customer_name, " +
            "       p.amount, p.payment_date, p.payment_type, " +
            "       p.reference_no, p.notes, p.recorded_by, " +
            "       u.full_name AS recorded_by_name, p.created_at " +
            "FROM payments p " +
            "JOIN invoices  i ON p.invoice_id  = i.invoice_id " +
            "JOIN events    e ON p.event_id    = e.event_id " +
            "JOIN customers c ON p.customer_id = c.customer_id " +
            "LEFT JOIN users u ON p.recorded_by = u.user_id " +
            "WHERE p.invoice_id = ? ORDER BY p.payment_date DESC";
        return jdbcTemplate.query(sql, paymentRowMapper, invoiceId);
    }

    /**
     * Calculates total payments received across all invoices (total revenue collected).
     */
    public BigDecimal getTotalCollected() {
        String sql = "SELECT ISNULL(SUM(amount), 0) FROM payments";
        BigDecimal total = jdbcTemplate.queryForObject(sql, BigDecimal.class);
        return total != null ? total : BigDecimal.ZERO;
    }

    // ── UPDATE ─────────────────────────────────────────────────

    /**
     * Updates a payment record.
     */
    public int updatePayment(Payment payment) {
        String sql =
            "UPDATE payments SET amount = ?, payment_date = ?, " +
            "                    payment_type = ?, reference_no = ?, notes = ? " +
            "WHERE payment_id = ?";
        return jdbcTemplate.update(sql,
                payment.getAmount(),
                payment.getPaymentDate(),
                payment.getPaymentType(),
                payment.getReferenceNo(),
                payment.getNotes(),
                payment.getPaymentId());
    }

    // ── DELETE ─────────────────────────────────────────────────

    /**
     * Deletes a payment by ID.
     */
    public int deletePayment(int paymentId) {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        return jdbcTemplate.update(sql, paymentId);
    }
}
