package com.eventsphere.controller;

import com.eventsphere.service.StripePaymentService;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.exception.StripeException;
import com.stripe.model.Event;
import com.stripe.model.StripeObject;
import com.stripe.model.checkout.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

/**
 * Receives Stripe webhook events so payments are recorded even if the customer
 * closes the browser before returning from Stripe Checkout.
 * Authenticity is checked with the Stripe-Signature header (it replaces the CSRF check here).
 */
@RestController
public class StripeWebhookController {

    private static final Logger log = LoggerFactory.getLogger(StripeWebhookController.class);
    private final StripePaymentService stripeService;

    public StripeWebhookController(StripePaymentService stripeService) {
        this.stripeService = stripeService;
    }

    @PostMapping("/stripe/webhook")
    public ResponseEntity<String> handle(@RequestBody String payload,
                                         @RequestHeader(value = "Stripe-Signature", required = false) String signature) {
        if (!stripeService.isEnabled()) return ResponseEntity.status(503).body("Stripe is not configured");
        Event event;
        try {
            event = stripeService.parseWebhook(payload, signature);
        } catch (SignatureVerificationException | IllegalStateException ex) {
            log.warn("Rejected Stripe webhook: {}", ex.getMessage());
            return ResponseEntity.badRequest().body("Invalid signature");
        }

        String type = event.getType();
        if ("checkout.session.completed".equals(type) || "checkout.session.async_payment_succeeded".equals(type)) {
            try {
                StripeObject object = event.getDataObjectDeserializer().getObject()
                        .orElseGet(() -> {
                            try { return event.getDataObjectDeserializer().deserializeUnsafe(); }
                            catch (Exception e) { return null; }
                        });
                if (!(object instanceof Session sent)) return ResponseEntity.ok("ignored");
                // Re-read from Stripe rather than trusting the event body.
                String error = stripeService.recordIfPaid(stripeService.retrieveSession(sent.getId()));
                if (error != null) log.warn("Stripe session {} not recorded: {}", sent.getId(), error);
            } catch (StripeException ex) {
                log.error("Stripe webhook processing failed", ex);
                return ResponseEntity.status(500).body("retry");   // Stripe retries on non-2xx
            }
        }
        return ResponseEntity.ok("ok");
    }
}
