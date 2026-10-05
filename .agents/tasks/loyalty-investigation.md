# EventSphere Loyalty Points Investigation Report

## Executive Summary
All customers currently show **0 loyalty points** because **NO events in the database meet the eligibility criteria**. The loyalty system requires events with status='Completed', but all 5 events in the seed data have statuses of 'Confirmed', 'Planning', 'Pending', or 'Requested' — none are 'Completed'.

---

## Root Cause Analysis

### Primary Issue: No Completed Events
The `LoyaltyService.java` eligibility query requires:
```sql
e.status = 'Completed'
```

**Current event statuses in data.sql:**
- Event 1 (Kumara Family Wedding): **'Confirmed'** ❌
- Event 2 (Priya 30th Birthday Party): **'Planning'** ❌  
- Event 3 (Harsha Corp Annual Dinner): **'Pending'** ❌
- Event 4 (Tech Summit Conference 2026): **'Planning'** ❌
- Event 5 (HR Skills Seminar): **'Requested'** ❌

**Result:** Zero events qualify, so all customers get 0 points.

---

## Secondary Requirements Verified

Even if we had 'Completed' events, the loyalty query also checks:

### ✅ Invoice Requirement
```sql
EXISTS (SELECT 1 FROM invoices i WHERE i.event_id = e.event_id)
```

**Status:** PASS for events 1, 2, 3
- Event 1 has invoice INV-2026-001
- Event 2 has invoice INV-2026-002  
- Event 3 has invoice INV-2026-003
- Events 4, 5 have NO invoices (would fail this check)

### ⚠️ Payment Verification
```sql
AND NOT EXISTS (
    SELECT 1 FROM invoices i WHERE i.event_id = e.event_id
    AND (i.customer_id <> e.customer_id OR i.total_amount <= 0 OR
         COALESCE((SELECT SUM(p.amount) FROM payments p 
                   WHERE p.invoice_id = i.invoice_id
                   AND p.customer_id = e.customer_id 
                   AND p.event_id = e.event_id), 0) < i.total_amount)
)
```

**This checks:**
1. Invoice customer_id matches event customer_id ✅
2. Invoice total_amount > 0 ✅
3. **SUM of payments WHERE payment.customer_id = event.customer_id AND payment.event_id = event.event_id >= invoice.total_amount**

**Critical Schema Observation:**  
The `payments` table **HAS both `customer_id` and `event_id` columns** (verified in schema.sql lines 277-278), so the query structure is valid.

**Payment data for Event 1:**
- Invoice INV-2026-001: total_amount = 720,000 LKR
- Payment 1: invoice_id=1, event_id=1, customer_id=1, amount=150,000
- Payment 2: invoice_id=1, event_id=1, customer_id=1, amount=100,000
- **Total paid: 250,000 < 720,000** ❌ (Partially Paid)

**Result:** Event 1 would FAIL the payment verification even if marked 'Completed' because payments don't cover the full invoice amount.

---

## Schema Analysis

### Payments Table Structure (schema.sql lines 275-288)
```sql
CREATE TABLE payments (
    payment_id     INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id     INT NOT NULL,
    event_id       INT NOT NULL,        ← EXISTS ✅
    customer_id    INT NOT NULL,        ← EXISTS ✅
    amount         DECIMAL(12,2) NOT NULL,
    payment_date   DATE NOT NULL,
    payment_type   NVARCHAR(50) NOT NULL DEFAULT 'Full Payment',
    reference_no   NVARCHAR(100),
    payment_method NVARCHAR(30) NOT NULL DEFAULT 'Cash',
    stripe_session_id NVARCHAR(255),
    notes          NVARCHAR(255),
    recorded_by    INT,
    created_at     DATETIME2 NOT NULL DEFAULT GETDATE(),
    ...
);
```

**Verdict:** No schema gaps detected. All required columns exist with correct foreign key relationships.

---

## Data Gaps Summary

| Requirement | Event 1 | Event 2 | Event 3 | Event 4 | Event 5 |
|-------------|---------|---------|---------|---------|---------|
| Status = 'Completed' | ❌ Confirmed | ❌ Planning | ❌ Pending | ❌ Planning | ❌ Requested |
| Has Invoice | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No | ❌ No |
| Invoice Matches Customer | ✅ Yes | ✅ Yes | ✅ Yes | N/A | N/A |
| Invoice Amount > 0 | ✅ 720K | ✅ 175K | ✅ 310K | N/A | N/A |
| Fully Paid | ❌ 35% paid | ❌ 0% paid | ❌ 0% paid | N/A | N/A |

**Eligible Events:** 0 out of 5

---

## Concrete Fix Plan

To demonstrate a working loyalty points system with real data, apply the following changes to `data.sql`:

### Step 1: Mark Event 1 as Completed
```sql
-- After the existing events INSERT, add:
UPDATE events SET status = 'Completed' WHERE event_id = 1;
```

### Step 2: Add Full Payment for Event 1
The invoice total is 720,000 LKR. Currently paid: 250,000 LKR. Need to add: 470,000 LKR.

```sql
-- Add final payment to fully pay invoice INV-2026-001
INSERT INTO payments
    (invoice_id, event_id, customer_id, amount, payment_date,
     payment_type, reference_no, notes, recorded_by)
VALUES
    (1, 1, 1, 470000.00, '2026-10-14', 'Final Payment', 'PAY-003', 
     'Final payment before event - balance cleared', 7);
```

### Step 3: Update Invoice Status to Paid
```sql
-- Update invoice status after full payment
UPDATE invoices SET status = 'Paid' WHERE invoice_id = 1;
```

### Step 4: (Optional) Create Additional Qualifying Events
To demonstrate multiple events earning points for customer 1 (Saman Kumara):

```sql
-- Add a second completed event for customer 1
INSERT INTO events
    (event_name, category_id, customer_id, manager_user_id,
     event_date, start_time, end_time, location,
     guest_count, requirements, status, notes)
VALUES
    ('Saman 25th Anniversary Celebration', 6, 1, 3,
     '2025-08-20', '18:00', '22:00', 'Garden Pavilion, Nugegoda',
     80, 'Anniversary party with catering and decoration',
     'Completed', 'Past event - already completed');

-- Get the new event_id (assuming it's 6 if events 1-5 exist)
-- Add invoice for event 6
INSERT INTO invoices
    (event_id, customer_id, invoice_number, total_amount,
     issued_date, due_date, status, notes)
VALUES
    (6, 1, 'INV-2025-020', 125000.00, '2025-07-15', '2025-08-15', 'Paid', 
     'Anniversary party - fully paid');

-- Add full payment for event 6
INSERT INTO payments
    (invoice_id, event_id, customer_id, amount, payment_date,
     payment_type, reference_no, notes, recorded_by)
VALUES
    (4, 6, 1, 125000.00, '2025-08-10', 'Full Payment', 'PAY-2025-020', 
     'Full payment for anniversary party', 7);
```

**Note:** Invoice_id and event_id will auto-increment. Adjust if your database has different IDs.

---

## Expected Results After Fix

### Minimal Fix (Steps 1-3 only):
- **Customer 1 (Saman Kumara):** 100 points (1 completed event)
- **Customer 2 (Priya Wijesinghe):** 0 points
- **Customer 3 (Harsha Bandara):** 0 points

### With Optional Step 4:
- **Customer 1 (Saman Kumara):** 200 points (2 completed events)
- Status: "Regular Customer" (needs 300 for "Loyal Customer")
- Remaining to Loyal: 100 points (1 more event)

---

## Verification Commands

After applying the fixes, verify in SQL Server Management Studio or via JDBC:

```sql
-- Check event statuses
SELECT event_id, event_name, status, customer_id FROM events WHERE customer_id = 1;

-- Check invoices and payments
SELECT e.event_id, e.event_name, i.invoice_number, i.total_amount,
       COALESCE(SUM(p.amount), 0) AS total_paid,
       i.status AS invoice_status
FROM events e
JOIN invoices i ON i.event_id = e.event_id
LEFT JOIN payments p ON p.invoice_id = i.invoice_id
WHERE e.customer_id = 1
GROUP BY e.event_id, e.event_name, i.invoice_number, i.total_amount, i.status;

-- Check loyalty points via application endpoint
-- GET http://localhost:8080/api/loyalty/customer/1/history
-- Expected: JSON array with qualifying events
```

---

## Implementation Notes

1. **Where to apply changes:** Modify `src/main/resources/data.sql` directly, then restart the application to reload seed data (if using a fresh database), OR execute the SQL statements directly on your existing SQL Server instance.

2. **Auto-increment IDs:** The invoice_id and event_id values in Step 4 assume sequential auto-increment. Query your database first to get the correct next ID:
   ```sql
   SELECT MAX(event_id) FROM events;      -- Should be 5
   SELECT MAX(invoice_id) FROM invoices;  -- Should be 3
   ```

3. **Customer consistency:** All SQL statements use `customer_id = 1` (Saman Kumara). Ensure this matches the user_id=8 → customer_id=1 mapping in the customers table.

4. **Date consistency:** Event 1 is scheduled for 2026-10-15. The payment dates (2026-08-20, 2026-09-15, 2026-10-14) are realistic pre-event payments. Event 6 uses past dates (2025) to represent a historical completed event.

---

## Conclusion

The loyalty points system is **correctly implemented in code** but shows 0 points because the **seed data contains no completed, fully-paid events**. Applying the minimal fix (Steps 1-3) will immediately demonstrate working loyalty points. The optional Step 4 provides richer test data showing point accumulation toward "Loyal Customer" status.
