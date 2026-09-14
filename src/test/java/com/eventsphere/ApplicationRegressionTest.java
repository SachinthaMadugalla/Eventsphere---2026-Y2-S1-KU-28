package com.eventsphere;

import com.eventsphere.dao.*;
import com.eventsphere.model.*;
import com.eventsphere.service.*;
import java.math.BigDecimal;
import java.net.*;
import java.net.http.*;
import java.time.LocalDate;
import java.util.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
    "spring.datasource.url=jdbc:h2:mem:regression;MODE=MSSQLServer;DATABASE_TO_UPPER=false;DB_CLOSE_DELAY=-1"
})
@ActiveProfiles("test")
class ApplicationRegressionTest {
    @LocalServerPort int port;
    @Autowired AuthService auth;
    @Autowired ResourceService resources;
    @Autowired FinanceService finance;
    @Autowired JdbcTemplate jdbc;
    @Autowired DashboardService dashboard;
    @Autowired EventService events;
    @Autowired TaskService tasks;
    @Autowired VenueService venues;
    @Autowired StaffService staff;
    @Autowired VendorService vendors;
    @Autowired ReportingService reporting;
    @Autowired CustomerService customers;
    @Autowired NotificationService notifications;

    private HttpClient client() {
        return HttpClient.newBuilder().cookieHandler(new CookieManager(null, CookiePolicy.ACCEPT_ALL))
                .followRedirects(HttpClient.Redirect.NORMAL).build();
    }
    private HttpResponse<String> get(HttpClient client, String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:" + port + path)).GET().build(), HttpResponse.BodyHandlers.ofString());
    }
    private HttpResponse<String> post(HttpClient client, String path, String body) throws Exception {
        var page = get(client, "/login");
        var matcher = java.util.regex.Pattern.compile("name=\"_csrf\" value=\"([^\"]+)\"").matcher(page.body());
        assertTrue(matcher.find(), "CSRF token missing");
        body = body + "&_csrf=" + matcher.group(1);
        return client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:" + port + path))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body)).build(), HttpResponse.BodyHandlers.ofString());
    }
    private HttpClient login(String username) throws Exception {
        HttpClient client = client();
        var response = post(client, "/login", "username=" + username + "&password=password123");
        assertEquals(200, response.statusCode(), response.body());
        assertFalse(response.uri().getPath().contains("login"), username + " could not log in");
        assertFalse(response.body().contains("Something went wrong"), response.body());
        return client;
    }

    @Test void everyDemoAccountCanLoginAndRenderDashboard() throws Exception {
        for (String username : List.of("admin", "director", "manager1", "manager2", "ops1", "cro1", "finance1", "customer1", "customer2", "customer3")) {
            assertNotNull(auth.login(username, "password123"), username);
            login(username);
        }
        assertNull(auth.login("admin", "wrong"));
        assertNull(auth.login(null, null));
    }

    @Test void allStaffPagesRender() throws Exception {
        HttpClient client = login("admin");
        for (String path : List.of("/admin/users", "/event/dashboard", "/event/list", "/event/archive", "/event/create", "/event/detail/1", "/event/edit/1",
                "/venue/list", "/venue/create", "/venue/detail/1", "/venue/edit/1", "/venue/assign?eventId=1",
                "/vendor/list", "/vendor/create", "/vendor/detail/1", "/vendor/edit/1", "/vendor/assign?eventId=1",
                "/staff/list", "/staff/create", "/staff/detail/1", "/staff/edit/1", "/staff/assign?eventId=1",
                "/resource/list", "/resource/create", "/resource/detail/1", "/resource/edit/1", "/resource/allocate?eventId=1",
                "/task/list", "/task/create", "/task/detail/1", "/task/edit/1", "/operations/dashboard",
                "/finance/dashboard", "/finance/budget/list", "/finance/budget/create", "/finance/budget/edit/1",
                "/finance/expense/list", "/finance/expense/create", "/finance/expense/edit/1",
                "/finance/invoice/list", "/finance/invoice/create", "/finance/invoice/detail/1", "/finance/invoice/edit/1", "/finance/payment/list", "/finance/payment/record?invoiceId=1",
                "/reporting/reports", "/reporting/reports/events", "/reporting/reports/finance", "/reporting/reports/venues", "/reporting/reports/vendors", "/reporting/reports/staff", "/reporting/reports/resources",
                "/reporting/feedback/list", "/reporting/complaint/list", "/reporting/complaint/detail/1", "/notifications")) {
            var response = get(client, path);
            assertEquals(200, response.statusCode(), path + "\n" + response.body());
            assertFalse(response.body().contains("Something went wrong"), path + "\n" + response.body());
            assertFalse(response.uri().getPath().contains("access-denied"), path);
        }
    }

    @Test void customersCannotAccessOtherCustomersBookingsOrReports() throws Exception {
        HttpClient client = login("customer1");
        for (String path : List.of("/customer/profile", "/customer/bookings", "/customer/booking/new", "/customer/booking/1", "/reporting/complaint/submit")) {
            assertEquals(200, get(client, path).statusCode(), path);
        }
        assertEquals("/access-denied", get(client, "/customer/booking/2").uri().getPath());
        assertEquals("/access-denied", post(client, "/customer/booking/cancel/3", "").uri().getPath());
        assertEquals("Pending", jdbc.queryForObject("SELECT status FROM events WHERE event_id=3", String.class));
        assertEquals("/access-denied", get(client, "/reporting/director/dashboard").uri().getPath());
        assertEquals("/access-denied", get(client, "/reporting/cro/dashboard").uri().getPath());
    }

    @Test @Transactional void resourceStockTracksEditsAllocationsAndRepeatedRelease() {
        Resource resource = resources.getResourceById(1).orElseThrow();
        resource.setTotalQuantity(600);
        assertNull(resources.updateResource(resource));
        assertEquals(130, resources.getResourceById(1).orElseThrow().getAvailableQuantity());
        resource.setTotalQuantity(400);
        assertNotNull(resources.updateResource(resource));
        ResourceAllocation allocation = new ResourceAllocation();
        allocation.setEventId(1); allocation.setResourceId(1); allocation.setQuantity(131);
        assertNotNull(resources.allocateResource(allocation));
        allocation.setQuantity(10);
        assertNull(resources.allocateResource(allocation));
        int id = jdbc.queryForObject("SELECT MAX(allocation_id) FROM resource_allocations", Integer.class);
        resources.releaseAllocation(id); resources.releaseAllocation(id);
        assertEquals(130, resources.getResourceById(1).orElseThrow().getAvailableQuantity());
    }

    @Test @Transactional void paymentsUseInvoiceIdentityAndDeletionRecalculatesStatus() {
        Payment payment = new Payment();
        payment.setInvoiceId(1); payment.setEventId(999); payment.setCustomerId(999);
        payment.setAmount(new BigDecimal("470000")); payment.setPaymentDate(LocalDate.now());
        payment.setPaymentType("Full Payment");
        assertNull(finance.recordPayment(payment, 999));
        assertEquals(1, payment.getCustomerId()); assertEquals(1, payment.getEventId());
        assertEquals("Paid", finance.getInvoiceById(1).orElseThrow().getStatus());
        int id = jdbc.queryForObject("SELECT MAX(payment_id) FROM payments", Integer.class);
        finance.deletePayment(id);
        assertEquals("Partially Paid", finance.getInvoiceById(1).orElseThrow().getStatus());
        finance.deletePayment(1); finance.deletePayment(2);
        assertEquals("Pending", finance.getInvoiceById(1).orElseThrow().getStatus());
        payment.setInvoiceId(999);
        assertNotNull(finance.recordPayment(payment, 8));
    }

    @Test void dashboardUsesExpensesAndTotalInvoicedRevenue() {
        assertEquals(0, new BigDecimal("150000").compareTo(dashboard.getStats().getTotalExpenses()));
        assertEquals(0, new BigDecimal("1205000").compareTo(finance.getTotalRevenue()));
    }

    @Test void feedbackPagesRenderAndRejectOtherCustomersEvents() throws Exception {
        HttpClient owner = login("customer1");
        HttpClient other = login("customer2");
        try {
            jdbc.update("UPDATE events SET status='Completed' WHERE event_id=4");
            assertEquals(200, get(owner, "/reporting/feedback/submit?eventId=4").statusCode());
            assertEquals("/access-denied", get(other, "/reporting/feedback/submit?eventId=4").uri().getPath());
            assertEquals("/access-denied", post(other, "/reporting/feedback/submit", "eventId=4&rating=5&comment=Wrong+owner").uri().getPath());
            assertEquals("/access-denied", post(other, "/reporting/complaint/submit", "eventId=4&subject=Test&description=Wrong+owner").uri().getPath());
            assertEquals(200, post(owner, "/reporting/feedback/submit", "eventId=4&rating=5&comment=Regression+feedback").statusCode());
            int feedbackId = jdbc.queryForObject("SELECT feedback_id FROM feedback WHERE event_id=4 AND customer_id=1", Integer.class);
            HttpClient admin = login("admin");
            for (String path : List.of("/reporting/feedback/list", "/reporting/feedback/detail/" + feedbackId,
                    "/reporting/director/dashboard", "/reporting/cro/dashboard")) {
                assertEquals(200, get(admin, path).statusCode(), path);
            }
        } finally {
            jdbc.update("DELETE FROM activity_logs WHERE action LIKE 'Submitted feedback%' AND entity_id=4");
            jdbc.update("DELETE FROM feedback WHERE event_id=4 AND customer_id=1");
            jdbc.update("UPDATE events SET status='Planning' WHERE event_id=4");
        }
    }

    @Test void csrfAndMissingPageReturnCorrectHttpStatus() throws Exception {
        var client = client();
        var response = client.send(HttpRequest.newBuilder(URI.create("http://127.0.0.1:" + port + "/login"))
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString("username=admin&password=password123")).build(), HttpResponse.BodyHandlers.ofString());
        assertEquals(403, response.statusCode());
        assertEquals(404, get(client, "/does-not-exist").statusCode());
    }

    @Test void profileIdentityIsTakenFromSessionAndTextIsEscaped() throws Exception {
        HttpClient customer = login("customer1");
        try {
            var response = post(customer, "/customer/profile/update", "customerId=2&userId=9&fullName=%3Cscript%3Ealert(1)%3C%2Fscript%3E&email=saman%40email.com&phone=0751234567");
            assertEquals(200, response.statusCode());
            assertEquals("Priya Wijesinghe", customers.getCustomerById(2).orElseThrow().getFullName());
            assertTrue(response.body().contains("&lt;script&gt;"));
            assertFalse(response.body().contains("<script>alert(1)</script>"));
        } finally {
            jdbc.update("UPDATE customers SET full_name='Saman Kumara', address='45 Lake Road, Colombo 03' WHERE customer_id=1");
            jdbc.update("UPDATE users SET full_name='Saman Kumara' WHERE user_id=8");
        }
    }

    @Test void deactivatedAccountsLoseExistingSessions() throws Exception {
        HttpClient customer = login("customer1");
        try {
            jdbc.update("UPDATE users SET is_active=0 WHERE user_id=8");
            assertEquals("/login", get(customer, "/customer/bookings").uri().getPath());
        } finally { jdbc.update("UPDATE users SET is_active=1 WHERE user_id=8"); }
    }

    @Test @Transactional void notificationsCannotBeDismissedByAnotherUser() {
        notifications.deleteNotification(1, 9);
        assertEquals(1, jdbc.queryForObject("SELECT COUNT(*) FROM notifications WHERE notification_id=1", Integer.class));
        notifications.markAsRead(3, 9);
        assertEquals(0, jdbc.queryForObject("SELECT CAST(is_read AS INT) FROM notifications WHERE notification_id=3", Integer.class));
    }

    @Test void failedAllocationRollsBackStockReservation() {
        int before = resources.getResourceById(1).orElseThrow().getAvailableQuantity();
        ResourceAllocation allocation = new ResourceAllocation();
        allocation.setEventId(99999); allocation.setResourceId(1); allocation.setQuantity(1);
        assertThrows(org.springframework.dao.DataIntegrityViolationException.class, () -> resources.allocateResource(allocation));
        assertEquals(before, resources.getResourceById(1).orElseThrow().getAvailableQuantity());
    }

    @Test @Transactional void completingEventReleasesStockAndTaskReopeningClearsCompletionDate() {
        events.updateStatus(1, "Completed");
        assertEquals(380, resources.getResourceById(1).orElseThrow().getAvailableQuantity());
        events.updateStatus(1, "Completed");
        assertEquals(380, resources.getResourceById(1).orElseThrow().getAvailableQuantity());
        tasks.updateStatus(1, "Completed");
        assertNotNull(tasks.getTaskById(1).orElseThrow().getCompletedAt());
        tasks.updateStatus(1, "In Progress");
        assertNull(tasks.getTaskById(1).orElseThrow().getCompletedAt());
        var task = tasks.getTaskById(1).orElseThrow();
        task.setStatus("Completed");
        assertNull(tasks.updateTask(task));
        assertNotNull(tasks.getTaskById(1).orElseThrow().getCompletedAt());
        assertThrows(IllegalArgumentException.class, () -> events.updateStatus(1, "invalid"));
    }

    @Test @Transactional void venueAndStaffAssignmentsRejectConflictsAndDuplicates() {
        EventVenue venue = new EventVenue();
        venue.setVenueId(1); venue.setEventId(2); venue.setAssignedDate(LocalDate.of(2026,10,15));
        assertNotNull(venues.assignVenueToEvent(venue, 100));
        venue.setAssignedDate(LocalDate.of(2026,10,16));
        assertNull(venues.assignVenueToEvent(venue, 100));
        venue.setEventId(3);
        assertNotNull(venues.assignVenueToEvent(venue, 100));
        StaffAssignment assignment = new StaffAssignment();
        assignment.setStaffId(1); assignment.setEventId(1); assignment.setAssignedDate(LocalDate.of(2026,10,15));
        assertNotNull(staff.assignStaffToEvent(assignment));
        EventVendor vendor = new EventVendor();
        vendor.setVendorId(1); vendor.setEventId(1); vendor.setServiceDate(LocalDate.of(2026,10,15));
        assertNotNull(vendors.assignVendorToEvent(vendor));
    }

    @Test @Transactional void registrationBookingAndFinanceLifecycle() {
        var registration = new com.eventsphere.dto.RegistrationDTO();
        registration.setUsername("regression"); registration.setEmail("regression@example.com"); registration.setFullName("Regression Customer");
        registration.setPassword("password123"); registration.setConfirmPassword("password123");
        assertNull(auth.registerCustomer(registration));
        User user = auth.login("regression", "password123");
        int customerId = customers.getCustomerByUserId(user.getUserId()).orElseThrow().getCustomerId();
        Event event = new Event();
        event.setCustomerId(customerId); event.setCategoryId(1); event.setEventName("Regression Event");
        event.setEventDate(LocalDate.now().plusDays(30)); event.setGuestCount(50);
        assertNull(events.createEvent(event));
        int eventId = events.getEventsByCustomerId(customerId).get(0).getEventId();
        events.confirmBooking(eventId, 1);
        assertTrue(notifications.getAllForUser(user.getUserId()).stream().anyMatch(n -> n.getTitle().equals("Booking Confirmed")));
        Expense expense = new Expense();
        expense.setEventId(eventId); expense.setAmount(new BigDecimal("25")); expense.setCategory("Venue");
        expense.setDescription("Deposit"); expense.setExpenseDate(LocalDate.now());
        assertNull(finance.addExpense(expense));
        Budget budget = new Budget(); budget.setEventId(eventId); budget.setTotalBudget(new BigDecimal("100"));
        assertNull(finance.createBudget(budget));
        assertEquals(0, new BigDecimal("25").compareTo(finance.getBudgetByEventId(eventId).orElseThrow().getActualCost()));
        Invoice invoice = new Invoice(); invoice.setEventId(eventId); invoice.setCustomerId(customerId); invoice.setTotalAmount(new BigDecimal("100"));
        assertNull(finance.createInvoice(invoice));
        int invoiceId = finance.getInvoicesByEvent(eventId).get(0).getInvoiceId();
        Payment payment = new Payment(); payment.setInvoiceId(invoiceId); payment.setAmount(new BigDecimal("100"));
        payment.setPaymentDate(LocalDate.now()); payment.setPaymentType("Full Payment");
        assertNull(finance.recordPayment(payment, 0));
        invoice.setInvoiceId(invoiceId); invoice.setTotalAmount(new BigDecimal("50"));
        assertNotNull(finance.updateInvoice(invoice));
        events.updateStatus(eventId, "Completed");
        Feedback feedback = new Feedback(); feedback.setCustomerId(customerId); feedback.setEventId(eventId); feedback.setRating(5); feedback.setComment("Great");
        assertNull(reporting.submitFeedback(feedback));
        assertNotNull(reporting.submitFeedback(feedback));
        Complaint complaint = new Complaint(); complaint.setCustomerId(customerId); complaint.setEventId(eventId);
        complaint.setSubject("Question"); complaint.setDescription("Follow up");
        assertNull(reporting.submitComplaint(complaint));
    }
}
