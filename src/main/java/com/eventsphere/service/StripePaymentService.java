package com.eventsphere.service;

import com.eventsphere.model.Invoice;
import com.stripe.StripeClient;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.exception.StripeException;
import com.stripe.model.Event;
import com.stripe.model.checkout.Session;
import com.stripe.net.Webhook;
import com.stripe.param.checkout.SessionCreateParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Thin wrapper around Stripe Checkout.
 * Customers are sent to Stripe's hosted payment page, so card details never touch EventSphere.
 * Payments are only recorded after the session is re-read from Stripe (or a signed webhook arrives).
 */
@Service
public class StripePaymentService {

    private static final Logger log = LoggerFactory.getLogger(StripePaymentService.class);

    private final String secretKey;
    private final String webhookSecret;
    private final String currency;
    private final FinanceService financeService;
    private StripeClient client;

    public StripePaymentService(@Value("${stripe.secret-key:}") String secretKey,
                                @Value("${stripe.webhook-secret:}") String webhookSecret,
                                @Value("${stripe.currency:lkr}") String currency,
                                FinanceService financeService) {
        this.secretKey = secretKey == null ? "" : secretKey.trim();
        this.webhookSecret = webhookSecret == null ? "" : webhookSecret.trim();
        this.currency = currency == null || currency.isBlank() ? "lkr" : currency.trim().toLowerCase();
        this.financeService = financeService;
    }

    /** Card payments are offered only when a Stripe secret key is configured. */
    public boolean isEnabled() {
        return !secretKey.isEmpty();
    }

    private StripeClient client() {
        if (client == null) client = new StripeClient(secretKey);
        return client;
    }

    /**
     * Creates a Checkout session for the invoice's outstanding balance.
     * @return the Stripe-hosted URL to redirect the customer to
     */
    public String createCheckout(Invoice invoice, String customerEmail, String baseUrl) throws StripeException {
        if (!isEnabled()) throw new IllegalStateException("Online card payments are not configured.");
        BigDecimal outstanding = invoice.getOutstanding();
        if (outstanding == null || outstanding.signum() <= 0) {
            throw new IllegalArgumentException("This invoice is already fully paid.");
        }
        long amountMinor = outstanding.setScale(2, RoundingMode.HALF_UP).movePointRight(2).longValueExact();

        SessionCreateParams.Builder params = SessionCreateParams.builder()
                .setMode(SessionCreateParams.Mode.PAYMENT)
                .setSuccessUrl(baseUrl + "/customer/payment/success?session_id={CHECKOUT_SESSION_ID}")
                .setCancelUrl(baseUrl + "/customer/booking/" + invoice.getEventId() + "?payment=cancelled")
                .setClientReferenceId(String.valueOf(invoice.getInvoiceId()))
                .putMetadata("invoiceId", String.valueOf(invoice.getInvoiceId()))
                .putMetadata("eventId", String.valueOf(invoice.getEventId()))
                .putMetadata("customerId", String.valueOf(invoice.getCustomerId()))
                .addLineItem(SessionCreateParams.LineItem.builder()
                        .setQuantity(1L)
                        .setPriceData(SessionCreateParams.LineItem.PriceData.builder()
                                .setCurrency(currency)
                                .setUnitAmount(amountMinor)
                                .setProductData(SessionCreateParams.LineItem.PriceData.ProductData.builder()
                                        .setName("Invoice " + invoice.getInvoiceNumber())
                                        .setDescription(invoice.getEventName())
                                        .build())
                                .build())
                        .build());
        if (customerEmail != null && !customerEmail.isBlank()) params.setCustomerEmail(customerEmail);

        Session session = client().v1().checkout().sessions().create(params.build());
        return session.getUrl();
    }

    /** Reads a Checkout session back from Stripe (the authoritative source of payment status). */
    public Session retrieveSession(String sessionId) throws StripeException {
        return client().v1().checkout().sessions().retrieve(sessionId);
    }

    /**
     * Records the session as a payment if Stripe reports it as paid.
     * @return null on success / already recorded, otherwise an error message
     */
    public String recordIfPaid(Session session) {
        if (!"paid".equals(session.getPaymentStatus())) return "The payment has not been completed yet.";
        if (!currency.equalsIgnoreCase(session.getCurrency())) return "Unexpected payment currency.";
        String invoiceId = session.getMetadata() == null ? null : session.getMetadata().get("invoiceId");
        if (invoiceId == null) return "Payment is not linked to an invoice.";
        String error = financeService.recordStripePayment(session.getId(), Integer.parseInt(invoiceId),
                session.getAmountTotal() == null ? 0 : session.getAmountTotal(), session.getPaymentIntent());
        if (error != null) {
            // Money was taken but could not be applied (e.g. invoice changed meanwhile) - finance must review.
            log.error("Stripe session {} for invoice {} was paid but not recorded: {}", session.getId(), invoiceId, error);
        }
        return error;
    }

    /** Verifies the Stripe-Signature header and parses the webhook event. */
    public Event parseWebhook(String payload, String signatureHeader) throws SignatureVerificationException {
        if (webhookSecret.isEmpty()) throw new IllegalStateException("Stripe webhook secret is not configured.");
        return Webhook.constructEvent(payload, signatureHeader, webhookSecret);
    }
}
