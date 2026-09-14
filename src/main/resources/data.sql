USE EventSphereDB;
GO

-- ROLES

INSERT INTO roles (role_name) VALUES
('Customer'),
('Event Manager'),
('Operations Coordinator'),
('Customer Relations Officer'),
('Finance Manager'),
('Managing Director'),
('System Administrator');


-- USERS  (password = "password123" for all)

INSERT INTO users (username, password_hash, email, full_name, phone, role_id, is_active) VALUES
('admin',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'admin@eventsphere.com',    'System Administrator',  '0700000001', 7, 1),
('director',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'director@eventsphere.com', 'Managing Director',     '0700000002', 6, 1),
('manager1',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'manager1@eventsphere.com', 'Nimal Perera',          '0711234567', 2, 1),
('manager2',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'manager2@eventsphere.com', 'Kamala Silva',          '0711234568', 2, 1),
('ops1',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'ops1@eventsphere.com',     'Ruwan Fernando',        '0722345678', 3, 1),
('cro1',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'cro1@eventsphere.com',     'Dilini Jayasuriya',     '0733456789', 4, 1),
('finance1',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'finance1@eventsphere.com', 'Asanka Gunawardena',   '0744567890', 5, 1),
('customer1',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'saman@email.com',          'Saman Kumara',          '0751234567', 1, 1),
('customer2',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'priya@email.com',          'Priya Wijesinghe',      '0762345678', 1, 1),
('customer3',
 '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'harsha@email.com',         'Harsha Bandara',        '0773456789', 1, 1);

-- =====================================================
-- EVENT CATEGORIES
-- =====================================================
INSERT INTO event_categories (category_name, description) VALUES
('Wedding',         'Wedding ceremonies and receptions'),
('Birthday',        'Birthday parties and celebrations'),
('Corporate Event', 'Corporate meetings, dinners and events'),
('Conference',      'Conferences and conventions'),
('Seminar',         'Seminars and workshops'),
('Party',           'General parties and celebrations'),
('Other',           'Other event types');


-- CUSTOMERS
INSERT INTO customers (user_id, full_name, email, phone, address) VALUES
(8,  'Saman Kumara',     'saman@email.com',  '0751234567', '45 Lake Road, Colombo 03'),
(9,  'Priya Wijesinghe', 'priya@email.com',  '0762345678', '12 Temple Street, Kandy'),
(10, 'Harsha Bandara',   'harsha@email.com', '0773456789', '78 Main Street, Galle');


-- VENUES
INSERT INTO venues (venue_name, location, capacity, cost_per_day, description) VALUES
('Grand Ballroom',     'Colombo 07',    500, 150000.00, 'Luxury ballroom with stage and dance floor'),
('Crystal Hall',       'Colombo 03',    200,  80000.00, 'Modern event hall with AV equipment'),
('Garden Pavilion',    'Nugegoda',      150,  50000.00, 'Outdoor pavilion surrounded by gardens'),
('Conference Suite A', 'Colombo 01',    100,  35000.00, 'Business conference room with projector'),
('Lakeside Terrace',   'Battaramulla',  300,  90000.00, 'Scenic terrace by the lake');


-- VENDOR CATEGORIES
INSERT INTO vendor_categories (category_name) VALUES
('Catering'),
('Decorators'),
('Photography'),
('Sound & Lighting'),
('Entertainment'),
('Equipment Suppliers');


-- VENDORS
INSERT INTO vendors (vendor_name, vendor_cat_id, contact_person, phone, email, service_desc, cost) VALUES
('Golden Spoon Catering',   1, 'Anura Silva',      '0114567890', 'info@goldenspoon.lk',  'Full catering for up to 500 guests',         75000.00),
('Ceylon Decorators',       2, 'Mala Fernando',    '0115678901', 'mala@ceylondeco.lk',   'Full event decoration and floral arrangements',45000.00),
('Focus Photography',       3, 'Ravi Mendis',      '0116789012', 'ravi@focusphoto.lk',   'Professional photography and videography',   35000.00),
('SoundPro Events',         4, 'Dilshan Perera',   '0117890123', 'info@soundpro.lk',     'Complete sound and lighting setup',          30000.00),
('StarStage Entertainment', 5, 'Thilini Jayamal',  '0118901234', 'info@starstage.lk',    'Live bands, DJs and entertainment performers',40000.00),
('EventEquip Suppliers',    6, 'Kasun Rathnayake', '0119012345', 'kasun@eventeq.lk',     'Tables, chairs, tents and general equipment',20000.00);


-- STAFF
INSERT INTO staff (full_name, email, phone, job_role) VALUES
('Chamara Wickramasinghe', 'chamara@eventsphere.com', '0720001001', 'Event Coordinator'),
('Sanduni Rajapaksha',     'sanduni@eventsphere.com', '0720001002', 'Setup Crew Lead'),
('Malith Dharmawardhana',  'malith@eventsphere.com',  '0720001003', 'AV Technician'),
('Nadeesha Karunaratne',   'nadeesha@eventsphere.com','0720001004', 'Guest Relations'),
('Thilina Wickrama',       'thilina@eventsphere.com', '0720001005', 'Security Officer'),
('Kasuni Herath',          'kasuni@eventsphere.com',  '0720001006', 'Decoration Coordinator'),
('Prasad Liyanage',        'prasad@eventsphere.com',  '0720001007', 'Setup Crew'),
('Amara Senanayake',       'amara@eventsphere.com',   '0720001008', 'Logistics Officer');

-- =====================================================
-- RESOURCES
-- available_quantity = total_quantity on creation.
-- We adjust below AFTER allocations are inserted.
-- =====================================================
INSERT INTO resources
    (resource_name, category, total_quantity, available_quantity, status, description)
VALUES
('Banquet Chair',        'Furniture',    500, 500, 'Available', 'Standard padded banquet chairs'),
('Round Table (6-seat)', 'Furniture',     80,  80, 'Available', 'Round tables seating 6 guests'),
('Long Buffet Table',    'Furniture',     25,  25, 'Available', 'Long rectangular buffet tables'),
('PA Sound System',      'Audio/Visual',   8,   8, 'Available', 'Full PA system with speakers and mixer'),
('Projector (4K)',        'Audio/Visual',  10,  10, 'Available', 'High-resolution event projectors'),
('Stage Lighting Set',   'Lighting',      12,  12, 'Available', 'Full stage lighting kits'),
('Decoration Arch',      'Decoration',    20,  20, 'Available', 'Floral and fabric decoration arches'),
('Event Tent (Large)',   'Outdoor',        8,   8, 'Available', 'Large outdoor event tents (10m x 10m)'),
('Podium',               'Furniture',      6,   6, 'Available', 'Speaker podiums with microphone stand'),
('LED Screen (120")',    'Audio/Visual',   5,   5, 'Available', 'Large LED display screens');


-- EVENTS
INSERT INTO events
    (event_name, category_id, customer_id, manager_user_id,
     event_date, start_time, end_time, location,
     guest_count, requirements, status, notes)
VALUES
('Kumara Family Wedding',      1, 1, 3,
 '2026-10-15', '15:00', '23:00', 'Grand Ballroom, Colombo 07',
 350, 'Full wedding reception with buffet dinner, DJ and decoration',
 'Confirmed', 'Priority event'),

('Priya 30th Birthday Party',  2, 2, 3,
 '2026-10-22', '18:00', '23:00', 'Crystal Hall, Colombo 03',
 120, 'Themed birthday party, catering, cake, DJ',
 'Planning', NULL),

('Harsha Corp Annual Dinner',  3, 3, 4,
 '2026-11-05', '19:00', '22:30', 'Lakeside Terrace',
 200, 'Formal corporate dinner, AV presentation required',
 'Pending', NULL),

('Tech Summit Conference 2026', 4, 1, 4,
 '2026-11-20', '08:00', '18:00', 'Conference Suite A',
 80, 'Full day conference, projectors, sound system',
 'Planning', NULL),

('HR Skills Seminar',           5, 2, 3,
 '2026-12-03', '09:00', '17:00', 'Conference Suite A',
 60, 'Workshop setup, projector required',
 'Requested', NULL);


-- EVENT VENUES
INSERT INTO event_venues (event_id, venue_id, assigned_date, start_time, end_time) VALUES
(1, 1, '2026-10-15', '14:00', '23:30'),
(2, 2, '2026-10-22', '17:00', '23:30'),
(3, 5, '2026-11-05', '18:00', '23:00'),
(4, 4, '2026-11-20', '07:30', '18:30');


-- EVENT VENDORS
INSERT INTO event_vendors (event_id, vendor_id, service_date, notes) VALUES
(1, 1, '2026-10-15', 'Full catering for 350 guests'),
(1, 2, '2026-10-15', 'Full venue decoration'),
(1, 3, '2026-10-15', 'Photography and videography'),
(1, 4, '2026-10-15', 'Sound system setup'),
(2, 1, '2026-10-22', 'Catering for 120 guests'),
(2, 5, '2026-10-22', 'DJ and entertainment');


-- STAFF ASSIGNMENTS
INSERT INTO staff_assignments (event_id, staff_id, role_at_event, assigned_date) VALUES
(1, 1, 'Lead Coordinator',  '2026-10-15'),
(1, 2, 'Setup Lead',        '2026-10-15'),
(1, 3, 'AV Technician',     '2026-10-15'),
(1, 4, 'Guest Relations',   '2026-10-15'),
(2, 1, 'Event Coordinator', '2026-10-22'),
(2, 6, 'Decoration Coord',  '2026-10-22'),
(3, 1, 'Lead Coordinator',  '2026-11-05'),
(3, 4, 'Guest Relations',   '2026-11-05');

-- =====================================================
-- RESOURCE ALLOCATIONS
-- All quantities verified against total_quantity above:
--   Banquet Chair    : total=500, allocated 350+120=470, available=30
--   Round Table      : total=80,  allocated 50+20=70,    available=10
--   Stage Lighting   : total=12,  allocated 4,            available=8
--   Projector (4K)   : total=10,  allocated 2,            available=8
--   Podium           : total=6,   allocated 1,            available=5
-- =====================================================
INSERT INTO resource_allocations
    (event_id, resource_id, quantity, allocated_on, notes)
VALUES
(1, 1, 350, '2026-09-01', 'Chairs for wedding reception guests'),
(1, 2,  50, '2026-09-01', 'Tables for wedding reception'),
(1, 6,   4, '2026-09-01', 'Stage lighting for wedding'),
(2, 1, 120, '2026-09-05', 'Chairs for birthday party'),
(2, 2,  20, '2026-09-05', 'Tables for birthday party'),
(4, 5,   2, '2026-09-10', 'Projectors for conference'),
(4, 9,   1, '2026-09-10', 'Podium for conference speakers');


-- UPDATE available_quantity to reflect allocations above.
-- Formula: available = total - SUM(allocated for this resource)
UPDATE resources SET available_quantity = 500 - 350 - 120 WHERE resource_id = 1;  -- Banquet Chair  : 30
UPDATE resources SET available_quantity =  80 -  50 -  20 WHERE resource_id = 2;  -- Round Table    : 10
UPDATE resources SET available_quantity =  12 -   4      WHERE resource_id = 6;   -- Stage Lighting :  8
UPDATE resources SET available_quantity =  10 -   2      WHERE resource_id = 5;   -- Projector      :  8
UPDATE resources SET available_quantity =   6 -   1      WHERE resource_id = 9;   -- Podium         :  5
-- All other resources: available_quantity already equals total_quantity (no allocations)


-- TASKS
INSERT INTO tasks
    (event_id, assigned_to, title, description, priority, status, start_date, due_date)
VALUES
(1, 2, 'Setup venue layout',
    'Arrange tables and chairs according to floor plan',
    'High', 'In Progress', '2026-10-10', '2026-10-14'),

(1, 3, 'Test AV equipment',
    'Test all sound systems and lighting before event day',
    'High', 'Not Started', '2026-10-13', '2026-10-14'),

(1, 6, 'Confirm decoration details',
    'Confirm flower types and colour scheme with decorator',
    'Medium', 'Completed', '2026-09-15', '2026-09-30'),

(2, 1, 'Confirm birthday theme',
    'Confirm theme and decoration items with customer',
    'Medium', 'Not Started', '2026-10-15', '2026-10-20'),

(3, 1, 'Coordinate catering menu',
    'Discuss corporate dinner menu with catering vendor',
    'High', 'Not Started', '2026-10-20', '2026-10-30'),

(4, 3, 'Setup conference AV',
    'Install projectors and test sound system',
    'High', 'Not Started', '2026-11-19', '2026-11-19'),

(1, 4, 'Prepare guest check-in list',
    'Create and print guest list for check-in at entrance',
    'Medium', 'In Progress', '2026-10-01', '2026-10-12');


-- BUDGETS
INSERT INTO budgets (event_id, total_budget, estimated_cost, actual_cost, notes) VALUES
(1, 800000.00, 720000.00, 150000.00, 'Advance payments made; final costs pending'),
(2, 200000.00, 175000.00,      0.00, 'Budget approved'),
(3, 350000.00, 310000.00,      0.00, 'Awaiting confirmation'),
(4, 150000.00, 135000.00,      0.00, 'Conference budget approved');


-- EXPENSES
INSERT INTO expenses (event_id, category, description, amount, expense_date, recorded_by) VALUES
(1, 'Venue',      'Venue booking deposit – Grand Ballroom', 75000.00, '2026-08-20', 7),
(1, 'Catering',   'Catering advance payment',               50000.00, '2026-09-01', 7),
(1, 'Decoration', 'Decoration advance payment',             25000.00, '2026-09-10', 7);

-- Keep actual_cost in budgets table consistent with expenses
UPDATE budgets SET actual_cost = 150000.00 WHERE event_id = 1;


-- INVOICES
INSERT INTO invoices
    (event_id, customer_id, invoice_number, total_amount,
     issued_date, due_date, status, notes)
VALUES
(1, 1, 'INV-2026-001', 720000.00, '2026-08-15', '2026-10-10', 'Partially Paid', 'Wedding event invoice'),
(2, 2, 'INV-2026-002', 175000.00, '2026-09-01', '2026-10-15', 'Pending',         'Birthday party invoice'),
(3, 3, 'INV-2026-003', 310000.00, '2026-09-15', '2026-11-01', 'Pending',         'Corporate dinner invoice');


-- PAYMENTS
-- Total paid for INV-2026-001: 150,000 + 100,000 = 250,000
-- Invoice total: 720,000 → status = Partially Paid (correct)
INSERT INTO payments
    (invoice_id, event_id, customer_id, amount, payment_date,
     payment_type, reference_no, notes, recorded_by)
VALUES
(1, 1, 1, 150000.00, '2026-08-20', 'Deposit',         'PAY-001', 'Wedding advance deposit',      7),
(1, 1, 1, 100000.00, '2026-09-15', 'Partial Payment', 'PAY-002', 'Second instalment payment',    7);


-- COMPLAINTS
INSERT INTO complaints
    (event_id, customer_id, subject, description, status)
VALUES
(2, 2,
 'Decoration delay concern',
 'The decoration team has not confirmed the design yet. We are concerned about the timeline.',
 'Under Review');


-- NOTIFICATIONS
INSERT INTO notifications (user_id, title, message, is_read) VALUES
(8, 'Booking Confirmed',
    'Your booking for Kumara Family Wedding has been confirmed.',              1),
(8, 'Payment Recorded',
    'A payment of LKR 150,000 has been recorded for INV-2026-001.',           1),
(8, 'Payment Recorded',
    'A second payment of LKR 100,000 has been recorded for INV-2026-001.',    0),
(3, 'New Event Assigned',
    'You have been assigned as manager for Priya 30th Birthday Party.',       0),
(5, 'Task Assigned',
    'Task: Setup venue layout has been assigned to Sanduni Rajapaksha.',      0),
(9, 'Complaint Update',
    'Your complaint has been received and is under review.',                   0);

GO

PRINT '==============================================';
PRINT 'EventSphere sample data loaded successfully.';
PRINT '==============================================';
PRINT 'Demo Credentials (all passwords = password123):';
PRINT '  admin     / password123  -> System Administrator';
PRINT '  director  / password123  -> Managing Director';
PRINT '  manager1  / password123  -> Event Manager';
PRINT '  manager2  / password123  -> Event Manager';
PRINT '  ops1      / password123  -> Operations Coordinator';
PRINT '  cro1      / password123  -> Customer Relations Officer';
PRINT '  finance1  / password123  -> Finance Manager';
PRINT '  customer1 / password123  -> Customer (Saman Kumara)';
PRINT '  customer2 / password123  -> Customer (Priya Wijesinghe)';
PRINT '  customer3 / password123  -> Customer (Harsha Bandara)';
PRINT '==============================================';
