USE EventSphereDB;
GO


-- AUTHENTICATION & USERS
CREATE TABLE roles (
    role_id   INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id       INT IDENTITY(1,1) PRIMARY KEY,
    username      NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    email         NVARCHAR(150) NOT NULL UNIQUE,
    full_name     NVARCHAR(150) NOT NULL,
    phone         NVARCHAR(20),
    role_id       INT NOT NULL,
    is_active     BIT NOT NULL DEFAULT 1,
    created_at    DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_users_roles FOREIGN KEY (role_id) REFERENCES roles(role_id)
);


-- EVENT CATEGORIES
CREATE TABLE event_categories (
    category_id   INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL UNIQUE,
    description   NVARCHAR(255)
);


-- CUSTOMERS (Module 1)
CREATE TABLE customers (
    customer_id   INT IDENTITY(1,1) PRIMARY KEY,
    user_id       INT NOT NULL UNIQUE,
    full_name     NVARCHAR(150) NOT NULL,
    email         NVARCHAR(150) NOT NULL,
    phone         NVARCHAR(20),
    address       NVARCHAR(255),
    registered_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_customers_users FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- EVENTS (Module 2)
CREATE TABLE events (
    event_id          INT IDENTITY(1,1) PRIMARY KEY,
    event_name        NVARCHAR(200) NOT NULL,
    category_id       INT NOT NULL,
    customer_id       INT NOT NULL,
    manager_user_id   INT,
    event_date        DATE NOT NULL,
    start_time        TIME,
    end_time          TIME,
    location          NVARCHAR(255),
    guest_count       INT NOT NULL DEFAULT 0,
    requirements      NVARCHAR(MAX),
    status            NVARCHAR(50) NOT NULL DEFAULT 'Requested',
    is_archived       BIT NOT NULL DEFAULT 0,
    -- Statuses: Requested, Pending, Confirmed, Planning, In Progress, Completed, Cancelled
    notes             NVARCHAR(MAX),
    created_at        DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at        DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_events_categories FOREIGN KEY (category_id) REFERENCES event_categories(category_id),
    CONSTRAINT FK_events_customers  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_events_manager    FOREIGN KEY (manager_user_id) REFERENCES users(user_id)
);


-- VENUES (Module 3)
CREATE TABLE venues (
    venue_id     INT IDENTITY(1,1) PRIMARY KEY,
    venue_name   NVARCHAR(200) NOT NULL,
    location     NVARCHAR(255) NOT NULL,
    capacity     INT NOT NULL,
    cost_per_day DECIMAL(12,2) NOT NULL DEFAULT 0,
    description  NVARCHAR(MAX),
    is_active    BIT NOT NULL DEFAULT 1,
    created_at   DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE event_venues (
    event_venue_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id       INT NOT NULL,
    venue_id       INT NOT NULL,
    assigned_date  DATE NOT NULL,
    start_time     TIME,
    end_time       TIME,
    notes          NVARCHAR(255),
    CONSTRAINT FK_ev_event FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_ev_venue FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
);


-- VENDORS (Module 3)
CREATE TABLE vendor_categories (
    vendor_cat_id   INT IDENTITY(1,1) PRIMARY KEY,
    category_name   NVARCHAR(100) NOT NULL UNIQUE
    -- e.g. Catering, Decorators, Photography, Sound & Lighting, Entertainment, Equipment
);

CREATE TABLE vendors (
    vendor_id       INT IDENTITY(1,1) PRIMARY KEY,
    vendor_name     NVARCHAR(200) NOT NULL,
    vendor_cat_id   INT NOT NULL,
    contact_person  NVARCHAR(150),
    phone           NVARCHAR(20),
    email           NVARCHAR(150),
    service_desc    NVARCHAR(MAX),
    cost            DECIMAL(12,2) NOT NULL DEFAULT 0,
    is_active       BIT NOT NULL DEFAULT 1,
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_vendors_cat FOREIGN KEY (vendor_cat_id) REFERENCES vendor_categories(vendor_cat_id)
);

CREATE TABLE event_vendors (
    event_vendor_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id        INT NOT NULL,
    vendor_id       INT NOT NULL,
    service_date    DATE NOT NULL,
    notes           NVARCHAR(255),
    CONSTRAINT FK_evend_event  FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_evend_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
);


-- STAFF (Module 4)
CREATE TABLE staff (
    staff_id   INT IDENTITY(1,1) PRIMARY KEY,
    full_name  NVARCHAR(150) NOT NULL,
    email      NVARCHAR(150),
    phone      NVARCHAR(20),
    job_role   NVARCHAR(100) NOT NULL,
    is_active  BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE staff_assignments (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id      INT NOT NULL,
    staff_id      INT NOT NULL,
    role_at_event NVARCHAR(150),
    assigned_date DATE NOT NULL,
    notes         NVARCHAR(255),
    CONSTRAINT FK_sa_event FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_sa_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);


-- RESOURCES (Module 4)
CREATE TABLE resources (
    resource_id        INT IDENTITY(1,1) PRIMARY KEY,
    resource_name      NVARCHAR(150) NOT NULL,
    category           NVARCHAR(100),
    -- e.g. Furniture, Audio/Visual, Lighting, Decoration, Other
    total_quantity     INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    status             NVARCHAR(50) NOT NULL DEFAULT 'Available',
    description        NVARCHAR(255),
    is_active          BIT NOT NULL DEFAULT 1,
    created_at         DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE resource_allocations (
    allocation_id INT IDENTITY(1,1) PRIMARY KEY,
    event_id      INT NOT NULL,
    resource_id   INT NOT NULL,
    quantity      INT NOT NULL,
    allocated_on  DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    notes         NVARCHAR(255),
    CONSTRAINT FK_ra_event    FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_ra_resource FOREIGN KEY (resource_id) REFERENCES resources(resource_id)
);


-- TASKS (Module 5)
CREATE TABLE tasks (
    task_id      INT IDENTITY(1,1) PRIMARY KEY,
    event_id     INT NOT NULL,
    assigned_to  INT,          -- staff_id
    title        NVARCHAR(200) NOT NULL,
    description  NVARCHAR(MAX),
    priority     NVARCHAR(20) NOT NULL DEFAULT 'Medium',
    -- Low, Medium, High
    status       NVARCHAR(50) NOT NULL DEFAULT 'Not Started',
    -- Not Started, In Progress, Completed, Cancelled
    start_date   DATE,
    due_date     DATE NOT NULL,
    completed_at DATETIME2,
    created_at   DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_tasks_event FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_tasks_staff FOREIGN KEY (assigned_to) REFERENCES staff(staff_id)
);

-- =====================================================
-- FINANCE (Module 6)
-- =====================================================

CREATE TABLE budgets (
    budget_id       INT IDENTITY(1,1) PRIMARY KEY,
    event_id        INT NOT NULL UNIQUE,
    total_budget    DECIMAL(14,2) NOT NULL DEFAULT 0,
    estimated_cost  DECIMAL(14,2) NOT NULL DEFAULT 0,
    actual_cost     DECIMAL(14,2) NOT NULL DEFAULT 0,
    notes           NVARCHAR(MAX),
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_budgets_event FOREIGN KEY (event_id) REFERENCES events(event_id)
);

CREATE TABLE expenses (
    expense_id   INT IDENTITY(1,1) PRIMARY KEY,
    event_id     INT NOT NULL,
    category     NVARCHAR(100) NOT NULL,
    description  NVARCHAR(255) NOT NULL,
    amount       DECIMAL(12,2) NOT NULL,
    expense_date DATE NOT NULL,
    recorded_by  INT,   -- user_id
    created_at   DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_expenses_event FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_expenses_user  FOREIGN KEY (recorded_by) REFERENCES users(user_id)
);

CREATE TABLE invoices (
    invoice_id     INT IDENTITY(1,1) PRIMARY KEY,
    event_id       INT NOT NULL,
    customer_id    INT NOT NULL,
    invoice_number NVARCHAR(50) NOT NULL UNIQUE,
    total_amount   DECIMAL(14,2) NOT NULL,
    issued_date    DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    due_date       DATE,
    status         NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    -- Pending, Partially Paid, Paid
    notes          NVARCHAR(MAX),
    created_at     DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_invoices_event    FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_invoices_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE payments (
    payment_id     INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id     INT NOT NULL,
    event_id       INT NOT NULL,
    customer_id    INT NOT NULL,
    amount         DECIMAL(12,2) NOT NULL,
    payment_date   DATE NOT NULL,
    payment_type   NVARCHAR(50) NOT NULL DEFAULT 'Full Payment',
    -- Deposit, Partial Payment, Full Payment
    reference_no   NVARCHAR(100),
    notes          NVARCHAR(255),
    recorded_by    INT,   -- user_id
    created_at     DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_payments_invoice  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    CONSTRAINT FK_payments_event    FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_payments_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK_payments_user     FOREIGN KEY (recorded_by) REFERENCES users(user_id)
);

-- =====================================================
-- FEEDBACK & COMPLAINTS (Module 7)
-- =====================================================

CREATE TABLE feedback (
    feedback_id    INT IDENTITY(1,1) PRIMARY KEY,
    event_id       INT NOT NULL,
    customer_id    INT NOT NULL,
    rating         INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment        NVARCHAR(MAX),
    submitted_date DATETIME2 NOT NULL DEFAULT GETDATE(),
    status         NVARCHAR(50) NOT NULL DEFAULT 'Active',
    -- Active, Moderated
    mod_reason     NVARCHAR(255),
    CONSTRAINT FK_feedback_event    FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_feedback_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE complaints (
    complaint_id   INT IDENTITY(1,1) PRIMARY KEY,
    event_id       INT,
    customer_id    INT NOT NULL,
    subject        NVARCHAR(200) NOT NULL,
    description    NVARCHAR(MAX) NOT NULL,
    status         NVARCHAR(50) NOT NULL DEFAULT 'Submitted',
    -- Submitted, Under Review, Resolved, Closed
    response       NVARCHAR(MAX),
    is_escalated   BIT NOT NULL DEFAULT 0,
    submitted_date DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_date   DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_complaints_event    FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT FK_complaints_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =====================================================
-- NOTIFICATIONS (Common Supporting Function)
-- =====================================================

CREATE TABLE notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id         INT NOT NULL,
    title           NVARCHAR(200) NOT NULL,
    message         NVARCHAR(MAX) NOT NULL,
    is_read         BIT NOT NULL DEFAULT 0,
    created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_notif_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================================================
-- ACTIVITY LOGS (Common Supporting Function)
-- =====================================================

CREATE TABLE activity_logs (
    log_id      INT IDENTITY(1,1) PRIMARY KEY,
    user_id     INT,
    action      NVARCHAR(255) NOT NULL,
    entity_type NVARCHAR(100),
    entity_id   INT,
    log_time    DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_log_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =====================================================
-- INDEXES for common queries
-- =====================================================

CREATE INDEX IX_events_status       ON events(status);
CREATE INDEX IX_events_date         ON events(event_date);
CREATE INDEX IX_events_customer     ON events(customer_id);
CREATE INDEX IX_tasks_event         ON tasks(event_id);
CREATE INDEX IX_tasks_status        ON tasks(status);
CREATE INDEX IX_payments_invoice    ON payments(invoice_id);
CREATE INDEX IX_notifications_user  ON notifications(user_id);
CREATE INDEX IX_feedback_event      ON feedback(event_id);
CREATE INDEX IX_complaints_customer ON complaints(customer_id);

GO
