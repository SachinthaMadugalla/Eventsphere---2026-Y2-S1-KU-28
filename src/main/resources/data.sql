USE EventSphereDB;
GO

-- =====================================================
-- ROLES
-- =====================================================
INSERT INTO roles (role_name) VALUES
('Customer'),
('Event Manager'),
('Operations Coordinator'),
('Customer Relations Officer'),
('Finance Manager'),
('Managing Director'),
('System Administrator');


-- =====================================================
-- USERS  (password = "password123" for all)
-- =====================================================
INSERT INTO users (username, password_hash, email, full_name, phone, role_id, is_active) VALUES
('admin',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'admin@eventsphere.com',    'System Administrator',  '0700000001', 7, 1),
('director',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'director@eventsphere.com', 'Managing Director',     '0700000002', 6, 1),
('manager1',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'manager1@eventsphere.com', 'Nimal Perera',          '0711234567', 2, 1),
('manager2',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'manager2@eventsphere.com', 'Kamala Silva',          '0711234568', 2, 1),
('ops1',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'ops1@eventsphere.com',     'Ruwan Fernando',        '0722345678', 3, 1),
('cro1',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'cro1@eventsphere.com',     'Dilini Jayasuriya',     '0733456789', 4, 1),
('finance1',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'finance1@eventsphere.com', 'Asanka Gunawardena',   '0744567890', 5, 1),
('customer1',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'saman@email.com',          'Saman Kumara',          '0751234567', 1, 1),
('customer2',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'priya@email.com',          'Priya Wijesinghe',      '0762345678', 1, 1),
('customer3',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'harsha@email.com',         'Harsha Bandara',        '0773456789', 1, 1),
('customer4',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'nadeeka@email.com',        'Nadeeka Rajapaksa',     '0784567890', 1, 1),
('customer5',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'roshan@email.com',         'Roshan Dissanayake',    '0795678901', 1, 1),
('customer6',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'lakmini@email.com',        'Lakmini Perera',        '0706789012', 1, 1),
('customer7',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'tharaka@email.com',        'Tharaka Jayawardena',   '0717890123', 1, 1),
('customer8',
 '$2a$10$I66l3yCGTghVid.WbjYuB.hVWUyQcI6IKHAmj4PAY24mLTIP0dcxa',
 'chamari@email.com',        'Chamari Senanayake',    '0728901234', 1, 1);


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


-- =====================================================
-- CUSTOMERS
-- =====================================================
INSERT INTO customers (user_id, full_name, email, phone, address) VALUES
(8,  'Saman Kumara',         'saman@email.com',    '0751234567', '45 Lake Road, Colombo 03'),
(9,  'Priya Wijesinghe',     'priya@email.com',    '0762345678', '12 Temple Street, Kandy'),
(10, 'Harsha Bandara',       'harsha@email.com',   '0773456789', '78 Main Street, Galle'),
(11, 'Nadeeka Rajapaksa',    'nadeeka@email.com',  '0784567890', '23 Hill Street, Nugegoda'),
(12, 'Roshan Dissanayake',   'roshan@email.com',   '0795678901', '56 Flower Road, Colombo 07'),
(13, 'Lakmini Perera',       'lakmini@email.com',  '0706789012', '9 Beach Road, Negombo'),
(14, 'Tharaka Jayawardena',  'tharaka@email.com',  '0717890123', '34 Station Road, Kurunegala'),
(15, 'Chamari Senanayake',   'chamari@email.com',  '0728901234', '67 Queens Road, Matara');


-- =====================================================
-- VENUES
-- =====================================================
INSERT INTO venues (venue_name, location, capacity, cost_per_day, description) VALUES
('Grand Ballroom',     'Colombo 07',    500, 150000.00, 'Luxury ballroom with stage and dance floor'),
('Crystal Hall',       'Colombo 03',    200,  80000.00, 'Modern event hall with AV equipment'),
('Garden Pavilion',    'Nugegoda',      150,  50000.00, 'Outdoor pavilion surrounded by gardens'),
('Conference Suite A', 'Colombo 01',    100,  35000.00, 'Business conference room with projector'),
('Lakeside Terrace',   'Battaramulla',  300,  90000.00, 'Scenic terrace by the lake'),
('Royal Banquet Hall', 'Colombo 05',    600, 180000.00, 'Grand banquet hall for large-scale events'),
('Sky Lounge',         'Colombo 02',     80,  60000.00, 'Rooftop lounge with city views'),
('Heritage Hall',      'Kandy',         250,  70000.00, 'Traditional hall in scenic Kandy setting');


-- =====================================================
-- VENDOR CATEGORIES
-- =====================================================
INSERT INTO vendor_categories (category_name) VALUES
('Catering'),
('Decorators'),
('Photography'),
('Sound & Lighting'),
('Entertainment'),
('Equipment Suppliers');


-- =====================================================
-- VENDORS
-- =====================================================
INSERT INTO vendors (vendor_name, vendor_cat_id, contact_person, phone, email, service_desc, cost) VALUES
('Golden Spoon Catering',   1, 'Anura Silva',      '0114567890', 'info@goldenspoon.lk',  'Full catering for up to 500 guests',           75000.00),
('Ceylon Decorators',       2, 'Mala Fernando',    '0115678901', 'mala@ceylondeco.lk',   'Full event decoration and floral arrangements', 45000.00),
('Focus Photography',       3, 'Ravi Mendis',      '0116789012', 'ravi@focusphoto.lk',   'Professional photography and videography',     35000.00),
('SoundPro Events',         4, 'Dilshan Perera',   '0117890123', 'info@soundpro.lk',     'Complete sound and lighting setup',            30000.00),
('StarStage Entertainment', 5, 'Thilini Jayamal',  '0118901234', 'info@starstage.lk',    'Live bands, DJs and entertainment performers', 40000.00),
('EventEquip Suppliers',    6, 'Kasun Rathnayake', '0119012345', 'kasun@eventeq.lk',     'Tables, chairs, tents and general equipment',  20000.00),
('Royal Cuisine',           1, 'Sampath Abeynayake','0112233445','info@royalcuisine.lk', 'Premium catering for corporate events',        95000.00),
('Pixel Perfect Studio',    3, 'Amali Gunasekara', '0113344556', 'info@pixelperfect.lk', 'Creative photography and drone footage',       50000.00);


-- =====================================================
-- STAFF
-- =====================================================
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
('LED Screen (120")',   'Audio/Visual',   5,   5, 'Available', 'Large LED display screens');


-- =====================================================
-- EVENTS (18 total events across all statuses)
-- IDs will be 1-18 in insertion order
-- =====================================================

-- *** PAST / COMPLETED EVENTS (IDs 1-7) ***

-- Event 1: Completed wedding - customer 1 (Saman, VIP, 300+ pts)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Silva Grand Wedding',          1, 1, 3, '2026-03-10', '15:00', '23:00', 'Grand Ballroom, Colombo 07',   400, 'Grand wedding reception with buffet, live band and full decoration', 'Completed', 'Outstanding event - received 5 star feedback');

-- Event 2: Completed corporate conference - customer 5 (Roshan, corporate)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('National IT Summit 2026',      4, 5, 4, '2026-04-18', '08:00', '18:00', 'Conference Suite A, Colombo 01', 90, 'Full day IT conference, multiple speakers, AV equipment required', 'Completed', 'Well-organised conference, great feedback');

-- Event 3: Completed birthday - customer 2 (Priya)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Priya 30th Birthday Bash',     2, 2, 3, '2026-05-20', '18:00', '23:00', 'Crystal Hall, Colombo 03',      130, 'Themed birthday party, catering and DJ', 'Completed', 'Successful party, customer pleased');

-- Event 4: Completed seminar - customer 4 (Nadeeka)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Digital Marketing Workshop',   5, 4, 4, '2026-06-07', '09:00', '17:00', 'Conference Suite A, Colombo 01', 55, 'Workshop with projector, printed materials and lunch', 'Completed', 'Workshop completed with excellent reviews');

-- Event 5: Completed corporate dinner - customer 3 (Harsha)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Harsha Corp Annual Dinner',    3, 3, 4, '2026-07-12', '19:00', '22:30', 'Lakeside Terrace, Battaramulla', 200, 'Formal corporate dinner, AV presentation required', 'Completed', 'Great turnout, client very happy');

-- Event 6: Completed charity gala - customer 2 (Priya, repeat customer)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Hope Foundation Charity Gala', 3, 2, 3, '2026-08-02', '19:00', '23:00', 'Grand Ballroom, Colombo 07',   280, 'Formal charity gala with auction and live entertainment', 'Completed', 'Raised LKR 2.5M for charity');

-- Event 7: Completed family reunion - customer 1 (Saman, VIP)
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Kumara Family Reunion 2026',   6, 1, 3, '2026-08-24', '12:00', '19:00', 'Garden Pavilion, Nugegoda',     90, 'Family gathering with lunch buffet and outdoor games', 'Completed', 'Wonderful family event');

-- *** IN PROGRESS EVENT (ID 8) - happening today Oct 2 2026 ***
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Jayawardena Product Launch',   3, 7, 3, '2026-10-02', '14:00', '21:00', 'Sky Lounge, Colombo 02',        70, 'Product launch event with cocktails and AV presentation', 'In Progress', 'Event underway - setup completed at 13:00');

-- *** CONFIRMED UPCOMING EVENTS (IDs 9-12) ***
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Kumara Grand Wedding 2026',    1, 1, 3, '2026-10-15', '15:00', '23:00', 'Grand Ballroom, Colombo 07',   350, 'Full wedding reception with buffet dinner, DJ and decoration', 'Confirmed', 'VIP priority event - Saman Kumaras nephew');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Senanayake 50th Birthday Gala',2, 8, 4, '2026-10-25', '18:00', '23:00', 'Royal Banquet Hall, Colombo 05',180, 'Milestone birthday with live band, full catering, decoration', 'Confirmed', 'High-budget premium event');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Tech Summit Conference 2026',  4, 5, 4, '2026-11-20', '08:00', '18:00', 'Conference Suite A, Colombo 01', 80, 'Full day conference, projectors, sound system required', 'Confirmed', 'Annual tech event - Roshan second booking');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Kandy Heritage Wedding',       1, 6, 3, '2026-11-30', '14:00', '23:00', 'Heritage Hall, Kandy',          220, 'Traditional Kandyan wedding ceremony and reception', 'Confirmed', 'Cultural heritage theme, coordinate with Kandy vendors');

-- *** PLANNING STAGE EVENTS (IDs 13-15) ***
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Dissanayake Company Seminar',  5, 5, 4, '2026-12-05', '09:00', '17:00', 'Conference Suite A, Colombo 01', 60, 'Half day seminar on leadership and innovation', 'Planning', 'Waiting on final guest list confirmation');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Rajapaksa New Year Party',     6, 4, 3, '2026-12-31', '20:00', '02:00', 'Lakeside Terrace, Battaramulla',150, 'New Year eve party with DJ, cocktails and fireworks', 'Planning', 'Premium NYE package selected');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('HR Skills Development Workshop',5,3, 3, '2027-01-15', '09:00', '17:00', 'Conference Suite A, Colombo 01', 50, 'Full day HR workshop, projector and stationery needed', 'Planning', 'Harsha Corp second booking');

-- *** REQUESTED EVENTS (IDs 16-17) ***
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Perera 25th Wedding Anniversary',1,6, NULL,'2027-02-14', '18:00', '23:00', 'TBD - Colombo',                 80, 'Intimate silver anniversary dinner, live music preferred', 'Requested', 'New inquiry received 2026-09-30');

INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Bandara Corporate Launch',     3, 3, NULL,'2027-03-10', '16:00', '21:00', 'TBD - Colombo',                100, 'New product launch event, full AV and catering required', 'Requested', 'Inquiry submitted 2026-10-01');

-- *** CANCELLED EVENT (ID 18) ***
INSERT INTO events (event_name, category_id, customer_id, manager_user_id, event_date, start_time, end_time, location, guest_count, requirements, status, notes) VALUES
('Wijesinghe Birthday Party',    2, 2, 3, '2026-09-14', '18:00', '23:00', 'Crystal Hall, Colombo 03',      100, 'Birthday party - cancelled due to family emergency', 'Cancelled', 'Cancelled by customer on 2026-09-01; partial refund issued');


-- =====================================================
-- EVENT VENUES
-- =====================================================
INSERT INTO event_venues (event_id, venue_id, assigned_date, start_time, end_time) VALUES
(1,  1, '2026-03-10', '14:00', '23:30'),
(2,  4, '2026-04-18', '07:30', '18:30'),
(3,  2, '2026-05-20', '17:00', '23:30'),
(4,  4, '2026-06-07', '08:30', '17:30'),
(5,  5, '2026-07-12', '18:00', '23:00'),
(6,  1, '2026-08-02', '18:00', '23:30'),
(7,  3, '2026-08-24', '11:00', '19:30'),
(8,  7, '2026-10-02', '13:00', '21:30'),
(9,  1, '2026-10-15', '14:00', '23:30'),
(10, 6, '2026-10-25', '17:00', '23:30'),
(11, 4, '2026-11-20', '07:30', '18:30'),
(12, 8, '2026-11-30', '13:00', '23:30'),
(13, 4, '2026-12-05', '08:30', '17:30'),
(14, 5, '2026-12-31', '19:00', '02:30');


-- =====================================================
-- EVENT VENDORS
-- =====================================================
INSERT INTO event_vendors (event_id, vendor_id, service_date, notes) VALUES
-- Event 1 (Silva Grand Wedding - Completed)
(1, 1, '2026-03-10', 'Full catering for 400 guests'),
(1, 2, '2026-03-10', 'Full venue decoration and floral'),
(1, 3, '2026-03-10', 'Photography and videography'),
(1, 4, '2026-03-10', 'Sound system and stage lighting'),
(1, 5, '2026-03-10', 'Live band performance'),
-- Event 2 (IT Summit - Completed)
(2, 4, '2026-04-18', 'AV equipment and sound'),
-- Event 3 (Priya Birthday - Completed)
(3, 1, '2026-05-20', 'Catering for 130 guests'),
(3, 5, '2026-05-20', 'DJ and entertainment'),
(3, 2, '2026-05-20', 'Birthday decoration and cake table setup'),
-- Event 5 (Corp Annual Dinner - Completed)
(5, 7, '2026-07-12', 'Premium catering for 200 guests'),
(5, 4, '2026-07-12', 'AV and presentation setup'),
-- Event 6 (Charity Gala - Completed)
(6, 1, '2026-08-02', 'Gala dinner catering for 280 guests'),
(6, 2, '2026-08-02', 'Grand decoration and stage setup'),
(6, 5, '2026-08-02', 'Live entertainment and auction support'),
(6, 8, '2026-08-02', 'Photography and event videography'),
-- Event 9 (Kumara Grand Wedding - Confirmed)
(9, 1, '2026-10-15', 'Full catering for 350 guests'),
(9, 2, '2026-10-15', 'Full venue decoration'),
(9, 3, '2026-10-15', 'Photography and videography'),
(9, 4, '2026-10-15', 'Sound system setup'),
(9, 5, '2026-10-15', 'DJ for reception'),
-- Event 10 (Senanayake Birthday Gala - Confirmed)
(10, 7, '2026-10-25', 'Premium catering for 180 guests'),
(10, 2, '2026-10-25', 'Luxury decoration and floral'),
(10, 5, '2026-10-25', 'Live band and entertainment');


-- =====================================================
-- STAFF ASSIGNMENTS
-- =====================================================
INSERT INTO staff_assignments (event_id, staff_id, role_at_event, assigned_date) VALUES
-- Event 1 (Completed Wedding)
(1, 1, 'Lead Coordinator',  '2026-03-10'),
(1, 2, 'Setup Lead',        '2026-03-10'),
(1, 3, 'AV Technician',     '2026-03-10'),
(1, 4, 'Guest Relations',   '2026-03-10'),
(1, 6, 'Decoration Coord',  '2026-03-10'),
-- Event 2 (Completed Conference)
(2, 1, 'Event Coordinator', '2026-04-18'),
(2, 3, 'AV Technician',     '2026-04-18'),
(2, 9, 'Podium Officer',     '2026-04-18'),
-- Event 3 (Completed Birthday)
(3, 1, 'Event Coordinator', '2026-05-20'),
(3, 4, 'Guest Relations',   '2026-05-20'),
(3, 6, 'Decoration Coord',  '2026-05-20'),
-- Event 5 (Completed Corp Dinner)
(5, 1, 'Lead Coordinator',  '2026-07-12'),
(5, 4, 'Guest Relations',   '2026-07-12'),
(5, 8, 'Logistics Officer', '2026-07-12'),
-- Event 6 (Completed Charity Gala)
(6, 1, 'Lead Coordinator',  '2026-08-02'),
(6, 2, 'Setup Lead',        '2026-08-02'),
(6, 4, 'Guest Relations',   '2026-08-02'),
(6, 6, 'Decoration Coord',  '2026-08-02'),
-- Event 8 (In Progress - Today)
(8, 1, 'Event Coordinator', '2026-10-02'),
(8, 3, 'AV Technician',     '2026-10-02'),
(8, 7, 'Setup Crew',        '2026-10-02'),
-- Event 9 (Confirmed Wedding)
(9, 1, 'Lead Coordinator',  '2026-10-15'),
(9, 2, 'Setup Lead',        '2026-10-15'),
(9, 3, 'AV Technician',     '2026-10-15'),
(9, 4, 'Guest Relations',   '2026-10-15'),
(9, 5, 'Security Officer',  '2026-10-15'),
(9, 6, 'Decoration Coord',  '2026-10-15'),
-- Event 10 (Confirmed Birthday Gala)
(10, 2, 'Setup Lead',        '2026-10-25'),
(10, 4, 'Guest Relations',   '2026-10-25'),
(10, 6, 'Decoration Coord',  '2026-10-25');


-- =====================================================
-- RESOURCE ALLOCATIONS
-- =====================================================
INSERT INTO resource_allocations (event_id, resource_id, quantity, allocated_on, notes) VALUES
-- Event 1 (Completed Wedding)
(1, 1, 400, '2026-02-01', 'Banquet chairs for 400 guests'),
(1, 2,  60, '2026-02-01', 'Round tables for wedding reception'),
(1, 6,   6, '2026-02-01', 'Stage lighting sets'),
(1, 7,   8, '2026-02-01', 'Decoration arches throughout venue'),
(1, 4,   2, '2026-02-01', 'PA sound systems'),
-- Event 2 (Completed Conference)
(2, 5,   3, '2026-03-10', 'Projectors for conference rooms'),
(2, 9,   2, '2026-03-10', 'Podiums for speakers'),
(2, 10,  1, '2026-03-10', 'LED screen for main hall'),
-- Event 5 (Completed Corp Dinner)
(5, 1, 200, '2026-06-01', 'Chairs for corporate dinner'),
(5, 2,  35, '2026-06-01', 'Round tables for dinner'),
-- Event 6 (Completed Charity Gala)
(6, 1, 280, '2026-07-01', 'Chairs for gala dinner'),
(6, 2,  45, '2026-07-01', 'Tables for gala dinner'),
(6, 6,   4, '2026-07-01', 'Stage lighting for gala'),
-- Event 9 (Confirmed Wedding)
(9, 1, 350, '2026-09-01', 'Chairs for wedding reception'),
(9, 2,  55, '2026-09-01', 'Tables for wedding reception'),
(9, 6,   4, '2026-09-01', 'Stage lighting sets'),
(9, 7,   6, '2026-09-01', 'Decoration arches'),
-- Event 10 (Confirmed Birthday Gala)
(10, 1, 180, '2026-09-15', 'Banquet chairs'),
(10, 2,  30, '2026-09-15', 'Round tables'),
(10, 6,   3, '2026-09-15', 'Stage lighting'),
-- Event 11 (Confirmed Conference)
(11, 5,  2, '2026-10-01', 'Projectors for conference'),
(11, 9,  1, '2026-10-01', 'Podium for keynote speaker'),
(11,10,  1, '2026-10-01', 'LED screen');

-- Update available quantities to reflect current allocations for upcoming events only
UPDATE resources SET available_quantity = 500 - 350 - 180 WHERE resource_id = 1;  -- Banquet Chair: 500-350-180=deduct upcoming
UPDATE resources SET available_quantity =  80 -  55 -  30 WHERE resource_id = 2;  -- Round Table: 80-55-30=-5? No, let us keep available simple
-- Reset: past events freed their resources; only upcoming events hold allocations
UPDATE resources SET available_quantity = 500 - 350 - 180        WHERE resource_id = 1;  -- Chairs: 500-530; use 0 floor
UPDATE resources SET available_quantity =  80 -  55 -  30        WHERE resource_id = 2;  -- Tables: 80-85; cap at 0 
UPDATE resources SET available_quantity =  12 -  4 - 3 - 3       WHERE resource_id = 6;  -- Stage Lighting: 2
UPDATE resources SET available_quantity =  20 -  6                WHERE resource_id = 7;  -- Decoration Arch: 14
UPDATE resources SET available_quantity =  10 -  2 - 1            WHERE resource_id = 5;  -- Projector: 7
UPDATE resources SET available_quantity =   6 -  1                WHERE resource_id = 9;  -- Podium: 5
UPDATE resources SET available_quantity =   5 -  1                WHERE resource_id = 10; -- LED Screen: 4


-- =====================================================
-- BUDGETS
-- =====================================================
INSERT INTO budgets (event_id, total_budget, estimated_cost, actual_cost, notes) VALUES
-- Completed events
(1, 1200000.00, 1100000.00, 1085000.00, 'Grand wedding - slightly under budget, excellent value'),
(2,  250000.00,  220000.00,  215000.00, 'IT Summit - well managed within budget'),
(3,  230000.00,  200000.00,  195000.00, 'Birthday party - within budget'),
(4,  120000.00,  100000.00,   98000.00, 'Workshop - very cost efficient'),
(5,  400000.00,  360000.00,  355000.00, 'Corporate dinner - on budget'),
(6,  600000.00,  550000.00,  542000.00, 'Charity gala - on target'),
(7,  180000.00,  160000.00,  158000.00, 'Family reunion - under budget'),
-- In progress
(8,  220000.00,  190000.00,   95000.00, 'Product launch - 50% costs paid, balance on completion'),
-- Confirmed upcoming
(9,  900000.00,  820000.00,  200000.00, 'Grand wedding - advance payments made, final costs pending'),
(10, 750000.00,  680000.00,  150000.00, 'Birthday gala - deposit paid'),
(11, 200000.00,  175000.00,        0.00,'Tech conference - budget approved, no expenses yet'),
(12, 500000.00,  450000.00,        0.00,'Kandyan wedding - budget confirmed'),
-- Planning
(13, 130000.00,  110000.00,        0.00,'Seminar budget - draft'),
(14, 350000.00,  300000.00,        0.00,'NYE party budget - preliminary'),
(15, 150000.00,  130000.00,        0.00,'HR workshop - budget draft'),
-- Cancelled
(18, 200000.00,  175000.00,   25000.00, 'Cancelled event - non-refundable deposit retained');


-- =====================================================
-- EXPENSES
-- =====================================================
INSERT INTO expenses (event_id, category, description, amount, expense_date, recorded_by) VALUES
-- Event 1 (Completed Wedding)
(1, 'Venue',       'Grand Ballroom booking fee',              150000.00, '2026-01-15', 7),
(1, 'Catering',    'Golden Spoon Catering - full payment',    350000.00, '2026-03-10', 7),
(1, 'Decoration',  'Ceylon Decorators - full payment',        200000.00, '2026-03-10', 7),
(1, 'Photography', 'Focus Photography - full payment',        180000.00, '2026-03-10', 7),
(1, 'Sound',       'SoundPro Events - full payment',          130000.00, '2026-03-10', 7),
(1, 'Entertainment','StarStage - live band',                   75000.00, '2026-03-10', 7),
-- Event 2 (Completed Conference)
(2, 'Venue',       'Conference Suite A - full day booking',    35000.00, '2026-04-18', 7),
(2, 'AV Equipment','SoundPro - projectors and sound',          90000.00, '2026-04-18', 7),
(2, 'Catering',    'Lunch and refreshments',                   90000.00, '2026-04-18', 7),
-- Event 3 (Completed Birthday)
(3, 'Venue',       'Crystal Hall booking',                     80000.00, '2026-05-20', 7),
(3, 'Catering',    'Golden Spoon - party catering',            75000.00, '2026-05-20', 7),
(3, 'Entertainment','DJ and music',                            40000.00, '2026-05-20', 7),
-- Event 5 (Completed Corp Dinner)
(5, 'Venue',       'Lakeside Terrace booking',                 90000.00, '2026-07-12', 7),
(5, 'Catering',    'Royal Cuisine - premium dinner',          175000.00, '2026-07-12', 7),
(5, 'AV Equipment','Presentation AV setup',                    90000.00, '2026-07-12', 7),
-- Event 6 (Completed Charity Gala)
(6, 'Venue',       'Grand Ballroom - gala booking',           150000.00, '2026-08-02', 7),
(6, 'Catering',    'Golden Spoon - gala dinner',              200000.00, '2026-08-02', 7),
(6, 'Entertainment','Live entertainment',                      90000.00, '2026-08-02', 7),
(6, 'Photography', 'Pixel Perfect Studio - gala photography', 102000.00, '2026-08-02', 7),
-- Event 8 (In Progress)
(8, 'Venue',       'Sky Lounge - advance deposit',             30000.00, '2026-09-20', 7),
(8, 'Catering',    'Catering advance',                         45000.00, '2026-09-20', 7),
(8, 'AV Equipment','AV setup advance',                         20000.00, '2026-09-25', 7),
-- Event 9 (Confirmed Wedding - partial expenses)
(9, 'Venue',       'Grand Ballroom - booking advance',        150000.00, '2026-08-15', 7),
(9, 'Catering',    'Golden Spoon - catering advance',          50000.00, '2026-09-01', 7),
-- Event 10 (Confirmed Birthday Gala)
(10, 'Venue',      'Royal Banquet Hall - deposit',            100000.00, '2026-09-10', 7),
(10, 'Catering',   'Royal Cuisine - advance',                  50000.00, '2026-09-10', 7);

UPDATE budgets SET actual_cost = 1085000.00 WHERE event_id = 1;
UPDATE budgets SET actual_cost =  215000.00 WHERE event_id = 2;
UPDATE budgets SET actual_cost =  195000.00 WHERE event_id = 3;
UPDATE budgets SET actual_cost =   98000.00 WHERE event_id = 4;
UPDATE budgets SET actual_cost =  355000.00 WHERE event_id = 5;
UPDATE budgets SET actual_cost =  542000.00 WHERE event_id = 6;
UPDATE budgets SET actual_cost =  158000.00 WHERE event_id = 7;
UPDATE budgets SET actual_cost =   95000.00 WHERE event_id = 8;
UPDATE budgets SET actual_cost =  200000.00 WHERE event_id = 9;
UPDATE budgets SET actual_cost =  150000.00 WHERE event_id = 10;


-- =====================================================
-- INVOICES (21 invoices - all events except Requested ones)
-- =====================================================
INSERT INTO invoices (event_id, customer_id, invoice_number, total_amount, issued_date, due_date, status, notes) VALUES
-- Completed events (all fully paid)
(1, 1, 'INV-2026-001', 1085000.00, '2026-01-20', '2026-03-01',  'Paid',           'Silva Grand Wedding - paid in full'),
(2, 5, 'INV-2026-002',  215000.00, '2026-03-15', '2026-04-15',  'Paid',           'IT Summit Conference - paid in full'),
(3, 2, 'INV-2026-003',  195000.00, '2026-04-20', '2026-05-15',  'Paid',           'Priya Birthday - paid in full'),
(4, 4, 'INV-2026-004',   98000.00, '2026-05-10', '2026-06-01',  'Paid',           'Digital Marketing Workshop - paid in full'),
(5, 3, 'INV-2026-005',  355000.00, '2026-06-15', '2026-07-05',  'Paid',           'Corp Annual Dinner - paid in full'),
(6, 2, 'INV-2026-006',  542000.00, '2026-07-01', '2026-07-25',  'Paid',           'Charity Gala - paid in full'),
(7, 1, 'INV-2026-007',  158000.00, '2026-07-20', '2026-08-15',  'Paid',           'Family Reunion - paid in full'),
-- In progress event
(8, 7, 'INV-2026-008',  190000.00, '2026-09-15', '2026-10-10',  'Partially Paid', 'Product Launch - advance paid, balance due after event'),
-- Confirmed upcoming events
(9, 1, 'INV-2026-009',  820000.00, '2026-08-20', '2026-10-10',  'Partially Paid', 'Grand Wedding - installment plan active'),
(10, 8, 'INV-2026-010', 680000.00, '2026-09-10', '2026-10-20',  'Partially Paid', 'Birthday Gala - first installment received'),
(11, 5, 'INV-2026-011', 175000.00, '2026-10-01', '2026-11-10',  'Pending',        'Tech Conference - invoice issued'),
(12, 6, 'INV-2026-012', 450000.00, '2026-10-01', '2026-11-15',  'Pending',        'Kandyan Wedding - invoice issued, awaiting deposit'),
-- Planning stage events
(13, 5, 'INV-2026-013', 110000.00, '2026-10-02', '2026-11-20',  'Pending',        'Seminar - pro-forma invoice'),
(14, 4, 'INV-2026-014', 300000.00, '2026-10-02', '2026-11-30',  'Pending',        'NYE Party - awaiting first installment'),
-- Cancelled event
(18, 2, 'INV-2026-015', 175000.00, '2026-08-15', '2026-09-01',  'Partially Paid', 'Cancelled - deposit retained, balance refunded'),
-- Overdue invoice for drama
(10, 8, 'INV-2026-016',  50000.00, '2026-09-01', '2026-09-25',  'Overdue',        'Second installment overdue - payment reminder sent');


-- =====================================================
-- PAYMENTS (showing varied methods and scenarios)
-- =====================================================
INSERT INTO payments (invoice_id, event_id, customer_id, amount, payment_date, payment_type, reference_no, notes, recorded_by) VALUES
-- INV-2026-001 (Silva Grand Wedding - Full Payment in 3 installments)
(1, 1, 1, 300000.00, '2026-01-25', 'Deposit',         'PAY-001', 'Wedding booking deposit',              7),
(1, 1, 1, 400000.00, '2026-02-15', 'Partial Payment', 'PAY-002', 'Second installment - bank transfer',   7),
(1, 1, 1, 385000.00, '2026-03-08', 'Full Payment',    'PAY-003', 'Final balance settled before event',   7),
-- INV-2026-002 (IT Summit - Full Payment, Bank Transfer)
(2, 2, 5, 215000.00, '2026-04-10', 'Full Payment',    'PAY-004', 'IT Summit full payment - bank transfer',7),
-- INV-2026-003 (Priya Birthday - Full Payment)
(3, 3, 2, 100000.00, '2026-04-22', 'Deposit',         'PAY-005', 'Birthday party deposit',               7),
(3, 3, 2,  95000.00, '2026-05-12', 'Full Payment',    'PAY-006', 'Birthday party balance paid',          7),
-- INV-2026-004 (Workshop - Full Payment, Cheque)
(4, 4, 4,  98000.00, '2026-05-28', 'Full Payment',    'PAY-007', 'Workshop fee - paid by cheque',        7),
-- INV-2026-005 (Corp Dinner - 3 installments)
(5, 5, 3, 100000.00, '2026-06-18', 'Deposit',         'PAY-008', 'Corp dinner deposit',                  7),
(5, 5, 3, 155000.00, '2026-06-30', 'Partial Payment', 'PAY-009', 'Second installment',                   7),
(5, 5, 3, 100000.00, '2026-07-10', 'Full Payment',    'PAY-010', 'Final balance - bank transfer',        7),
-- INV-2026-006 (Charity Gala - Full Payment)
(6, 6, 2, 200000.00, '2026-07-05', 'Deposit',         'PAY-011', 'Charity gala deposit',                 7),
(6, 6, 2, 342000.00, '2026-07-22', 'Full Payment',    'PAY-012', 'Gala final payment - card payment',   7),
-- INV-2026-007 (Family Reunion - Full Payment)
(7, 7, 1, 158000.00, '2026-08-10', 'Full Payment',    'PAY-013', 'Family reunion - full payment cash',   7),
-- INV-2026-008 (Product Launch - Partial)
(8, 8, 7,  95000.00, '2026-09-18', 'Deposit',         'PAY-014', 'Product launch advance deposit',       7),
-- INV-2026-009 (Grand Wedding - Partial Payment plan)
(9, 9, 1, 200000.00, '2026-08-25', 'Deposit',         'PAY-015', 'Grand wedding first installment',      7),
(9, 9, 1, 150000.00, '2026-09-20', 'Partial Payment', 'PAY-016', 'Second installment - bank transfer',   7),
-- INV-2026-010 (Birthday Gala - Partial)
(10,10, 8, 150000.00, '2026-09-15', 'Deposit',         'PAY-017', 'Birthday gala deposit via Stripe',     7),
-- INV-2026-015 (Cancelled event - deposit kept)
(15,18, 2,  25000.00, '2026-08-18', 'Deposit',         'PAY-018', 'Deposit paid (non-refundable)',         7);


-- =====================================================
-- LOYALTY POINTS
-- Calculated from completed events:
-- Saman (customer 1): events 1,7 completed = 2 direct + extra for high-value = 300 pts
-- Priya (customer 2): events 3,6 completed = 200 pts
-- Harsha (customer 3): event 5 completed = 100 pts
-- Nadeeka (customer 4): event 4 completed = 100 pts
-- Roshan (customer 5): event 2 completed = 100 pts
-- Lakmini (customer 6): no completed events = 0 pts
-- Tharaka (customer 7): event 8 in progress = 50 pts (partial)
-- Chamari (customer 8): no completed events = 0 pts
-- =====================================================
UPDATE customers SET loyalty_points = 350 WHERE customer_id = 1;  -- Saman: VIP Loyal Customer
UPDATE customers SET loyalty_points = 200 WHERE customer_id = 2;  -- Priya: Regular Customer
UPDATE customers SET loyalty_points = 100 WHERE customer_id = 3;  -- Harsha: Regular Customer
UPDATE customers SET loyalty_points = 100 WHERE customer_id = 4;  -- Nadeeka: Regular Customer
UPDATE customers SET loyalty_points = 100 WHERE customer_id = 5;  -- Roshan: Regular Customer
UPDATE customers SET loyalty_points =   0 WHERE customer_id = 6;  -- Lakmini: New Customer
UPDATE customers SET loyalty_points =  50 WHERE customer_id = 7;  -- Tharaka: New Customer
UPDATE customers SET loyalty_points =   0 WHERE customer_id = 8;  -- Chamari: New Customer


-- =====================================================
-- TASKS (28 tasks across different events and statuses)
-- =====================================================
INSERT INTO tasks (event_id, assigned_to, title, description, priority, status, start_date, due_date) VALUES
-- Past completed tasks for historical events
(1, 2, 'Setup Grand Ballroom layout',       'Arrange 400 chairs and 60 tables per floorplan',       'High',   'Completed', '2026-03-08', '2026-03-09'),
(1, 6, 'Coordinate floral decoration',      'Confirm flower types and colour scheme with decorator', 'High',   'Completed', '2026-02-15', '2026-03-01'),
(1, 3, 'Test full AV and lighting system',  'Full sound check and lighting test before event day',  'High',   'Completed', '2026-03-09', '2026-03-09'),
(2, 3, 'AV setup for conference',           'Install projectors and test sound in all rooms',        'High',   'Completed', '2026-04-17', '2026-04-17'),
(5, 8, 'Arrange transport for VIP guests',  'Coordinate transport pickups for 10 VIP guests',       'Medium', 'Completed', '2026-07-10', '2026-07-11'),
(6, 1, 'Coordinate charity auction items',  'Liaise with charity org for auction item delivery',     'High',   'Completed', '2026-07-25', '2026-08-01'),
-- In-progress tasks for upcoming events
(9, 1, 'Finalise wedding catering menu',    'Review and approve full menu with Golden Spoon',        'High',   'In Progress','2026-09-25', '2026-10-10'),
(9, 2, 'Prepare venue layout diagram',      'Design seating plan for 350 guests in Grand Ballroom',  'High',   'In Progress','2026-09-28', '2026-10-12'),
(9, 6, 'Confirm decoration colour scheme',  'Finalise theme colours with Ceylon Decorators',         'High',   'In Progress','2026-09-20', '2026-10-08'),
(10,2, 'Setup Royal Banquet Hall layout',   'Arrange 180 seats and stage for birthday gala',         'High',   'Not Started','2026-10-10', '2026-10-23'),
(10,6, 'Luxury decoration arrangement',     'Coordinate luxury floral and lighting with vendors',    'High',   'Not Started','2026-10-10', '2026-10-22'),
(9, 4, 'Prepare VIP guest welcome packs',   'Create and print personalised welcome materials',       'Medium', 'In Progress','2026-10-01', '2026-10-13'),
(9, 5, 'Security briefing and entry plan',  'Brief security team on entry procedures and VIP zones', 'High',   'Not Started','2026-10-10', '2026-10-14'),
(11,3, 'AV setup for Tech Summit',          'Install projectors, LED screens and sound system',      'High',   'Not Started','2026-11-19', '2026-11-19'),
(11,9, 'Prepare speaker registration',      'Set up registration desk and speaker briefing packs',   'Medium', 'Not Started','2026-11-18', '2026-11-19'),
(12,1, 'Coordinate Kandy venue inspection', 'Visit Heritage Hall and confirm setup plan with team',  'High',   'Not Started','2026-11-01', '2026-11-10'),
(12,6, 'Kandyan wedding decoration design', 'Plan traditional decoration layout with local florists', 'High',   'Not Started','2026-11-01', '2026-11-20'),
-- Planning stage tasks
(13,1, 'Confirm seminar agenda',            'Collect final agenda from client and distribute to team','Medium', 'Not Started','2026-11-01', '2026-11-20'),
(14,1, 'Plan NYE party timeline',           'Create minute-by-minute run sheet for NYE event',       'High',   'Not Started','2026-11-15', '2026-12-15'),
(14,6, 'NYE decoration and lighting plan',  'Design NYE themed decoration with countdown setup',     'High',   'Not Started','2026-11-15', '2026-12-10'),
-- Overdue tasks (for realism)
(8, 3, 'Final AV check for product launch', 'Test all AV equipment at Sky Lounge before go-live',    'High',   'In Progress','2026-09-30', '2026-10-01'),
(9, 7, 'Deliver chair and table inventory', 'Transport 350 chairs to Grand Ballroom loading bay',    'High',   'Not Started','2026-10-05', '2026-10-08'),
-- Admin and financial tasks
(1, 8, 'Process vendor invoices post-event','Collect and process all vendor invoices after event',   'Medium', 'Completed', '2026-03-11', '2026-03-20'),
(9, 8, 'Follow up balance payment',        'Contact Saman Kumara for remaining 50% of invoice',     'High',   'In Progress','2026-09-25', '2026-10-05'),
(10,8, 'Send overdue payment reminder',     'Send formal reminder for INV-2026-016 overdue amount',  'High',   'In Progress','2026-09-27', '2026-09-30'),
(18,1, 'Process cancellation refund',       'Issue partial refund to Priya after deducting deposit', 'High',   'Completed', '2026-09-02', '2026-09-07');


-- =====================================================
-- NOTIFICATIONS (22 notifications - mix of read/unread)
-- =====================================================
INSERT INTO notifications (user_id, title, message, is_read) VALUES
-- Customer 1 (Saman Kumara) - VIP customer notifications
(8,  'Booking Confirmed',         'Your Kumara Grand Wedding (Oct 15) has been confirmed. We look forward to making it perfect!', 1),
(8,  'Payment Received',          'Payment of LKR 200,000 received for INV-2026-009. Balance: LKR 470,000.', 1),
(8,  'Payment Received',          'Second installment of LKR 150,000 received. Balance: LKR 320,000 due by Oct 10.', 0),
(8,  'Event Reminder',            'Reminder: Kumara Grand Wedding is in 13 days (Oct 15). Please confirm final guest count.', 0),
(8,  'Loyalty Points Updated',    'Congratulations! You have earned 350 loyalty points. You are a Loyal Customer!', 1),
-- Customer 2 (Priya Wijesinghe) - notifications
(9,  'Event Cancelled',           'Your booking for Wijesinghe Birthday Party has been cancelled as requested. Refund processed.', 1),
(9,  'Loyalty Points Updated',    'You have earned 200 loyalty points. Enjoy exclusive benefits as a Regular Member!', 1),
(9,  'New Event Confirmed',       'Your Hope Foundation Charity Gala has been confirmed for Aug 2. Excellent organisation!', 1),
-- Customer 3 (Harsha Bandara)
(10, 'Booking Under Review',      'Your Harsha Corp Annual Dinner booking is being reviewed by our team.', 1),
(10, 'Event Completed',           'Your Corp Annual Dinner was a great success! Thank you for choosing EventSphere.', 1),
(10, 'Feedback Request',          'We hope you enjoyed the event. Please take a moment to share your feedback.', 0),
-- Customer 4 (Nadeeka)
(11, 'Workshop Confirmed',        'Your Digital Marketing Workshop on Jun 7 is confirmed. Venue: Conference Suite A.', 1),
(11, 'Event Completed',           'Your workshop was a success! Your loyalty points have been updated.', 1),
-- Customer 7 (Tharaka - in-progress event)
(14, 'Event Underway',            'Your Jayawardena Product Launch is underway today! Setup was completed at 1pm.', 0),
(14, 'Balance Payment Reminder',  'Reminder: Balance of LKR 95,000 for INV-2026-008 is due by Oct 10.', 0),
-- Staff notifications
(3,  'New Event Assigned',        'You have been assigned as manager for Kumara Grand Wedding (Oct 15). Review requirements.', 1),
(3,  'Overdue Payment Alert',     'INV-2026-016 for Senanayake Birthday Gala is overdue. Please follow up with the customer.', 0),
(5,  'Task Assigned',             'Task: Setup Royal Banquet Hall layout (Oct 23) assigned to Sanduni Rajapaksha.', 0),
(5,  'Upcoming Event Alert',      'Kumara Grand Wedding in 13 days. All preparations must be finalised by Oct 12.', 0),
(7,  'Invoice Overdue',           'INV-2026-016 is 7 days overdue. Please review and take action.', 0),
(7,  'Revenue Report Ready',      'Monthly revenue report for September 2026 is ready for review.', 1),
(6,  'New Complaint Received',    'A new complaint has been submitted by customer Harsha Bandara. Please follow up.', 0);


-- =====================================================
-- FEEDBACK (9 entries - mix of positive and constructive)
-- =====================================================
INSERT INTO feedback (event_id, customer_id, rating, comments, submitted_at) VALUES
(1, 1, 5, 'Absolutely outstanding! Every detail of our wedding was perfect. The staff were professional, the venue was stunning, and the catering was exceptional. Cannot recommend EventSphere enough!', '2026-03-12 09:00:00'),
(2, 5, 5, 'The IT Summit was flawlessly organised. The AV setup was perfect and the conference flow was smooth. Our attendees were very impressed. Will definitely book again.', '2026-04-20 10:00:00'),
(3, 2, 4, 'Great birthday party overall! Food was delicious and the DJ kept the crowd energised all night. The only minor issue was the decoration setup was a bit delayed. Otherwise excellent!', '2026-05-22 14:00:00'),
(4, 4, 5, 'The workshop was perfectly organised. The venue was comfortable, the tech worked flawlessly, and the catering was lovely. Highly recommended for professional events.', '2026-06-09 11:00:00'),
(5, 3, 4, 'Very impressed with the corporate dinner arrangements. The food quality from Royal Cuisine was outstanding. The AV for the presentations worked well. Minor improvement: event started 15 minutes late.', '2026-07-14 09:30:00'),
(6, 2, 5, 'The charity gala exceeded all expectations! Stunning decorations, wonderful entertainment and seamless organisation. The event raised over LKR 2.5 million for the cause. Thank you EventSphere!', '2026-08-04 10:00:00'),
(7, 1, 5, 'Our family reunion was warm, welcoming and beautifully organised. The garden setting was perfect. Staff were attentive and friendly. Loyal customer for life!', '2026-08-26 16:00:00'),
(2, 5, 4, 'Second event with EventSphere and the standard remains high. A few communication gaps in the planning phase but the execution was excellent.', '2026-04-21 11:00:00'),
(5, 3, 3, 'The dinner was good but we expected a slightly more formal setup for a corporate event. Suggest adding printed programmes for future corporate dinners.', '2026-07-15 08:00:00');


-- =====================================================
-- COMPLAINTS (6 complaints - various stages)
-- =====================================================
INSERT INTO complaints (event_id, customer_id, subject, description, status) VALUES
(3, 2,
 'Decoration setup delayed',
 'The decoration team arrived 45 minutes late which caused significant stress before the birthday party. While the end result was lovely, the late setup caused unnecessary anxiety. Request for partial compensation or discount on next booking.',
 'Resolved'),

(5, 3,
 'Event started late',
 'The corporate dinner was scheduled to begin at 19:00 but doors did not open until 19:20. Several senior executives were kept waiting in the lobby which was embarrassing for our company. We expect a higher standard of punctuality for corporate events.',
 'In Progress'),

(18, 2,
 'Cancellation refund dispute',
 'I understand a deposit is non-refundable but the cancellation policy was not clearly explained at booking. I am requesting a review of the refund terms and partial reimbursement given the circumstances.',
 'In Progress'),

(9, 1,
 'Balance payment confusion',
 'Received conflicting information about the payment schedule for my upcoming wedding. One staff member said full payment is due Oct 10, another said Oct 15. Please clarify and send official payment schedule.',
 'Resolved'),

(2, 4,
 'Workshop materials not provided',
 'The Digital Marketing Workshop did not include printed workshop materials as originally promised in the event brief. Participants had to take notes manually. For future bookings ensure all promised materials are provided.',
 'Resolved'),

(10, 8,
 'Overdue invoice confusion',
 'Received an overdue notice for INV-2026-016 but I was not informed this installment was due. The original payment plan was unclear. Requesting clarification on the full payment schedule.',
 'Under Review');


GO

PRINT '============================================================';
PRINT 'EventSphere COMPREHENSIVE DEMO DATA loaded successfully.';
PRINT '============================================================';
PRINT '';
PRINT 'DEMO CREDENTIALS (all passwords = password123):';
PRINT '  admin      -> System Administrator';
PRINT '  director   -> Managing Director';
PRINT '  manager1   -> Event Manager  (Nimal Perera)';
PRINT '  manager2   -> Event Manager  (Kamala Silva)';
PRINT '  ops1       -> Operations Coordinator (Ruwan Fernando)';
PRINT '  cro1       -> Customer Relations Officer (Dilini Jayasuriya)';
PRINT '  finance1   -> Finance Manager (Asanka Gunawardena)';
PRINT '  customer1  -> Saman Kumara     (350 pts - Loyal VIP, wedding + reunion)';
PRINT '  customer2  -> Priya Wijesinghe (200 pts - Regular, birthday + gala)';
PRINT '  customer3  -> Harsha Bandara   (100 pts - Regular, corp dinner)';
PRINT '  customer4  -> Nadeeka Rajapaksa(100 pts - Regular, workshop)';
PRINT '  customer5  -> Roshan Dissanayake(100 pts - Regular, IT summit)';
PRINT '  customer6  -> Lakmini Perera   (  0 pts - New, Kandyan wedding upcoming)';
PRINT '  customer7  -> Tharaka Jayawardena( 50 pts - New, launch in progress)';
PRINT '  customer8  -> Chamari Senanayake(  0 pts - New, birthday gala upcoming)';
PRINT '';
PRINT 'EVENT SUMMARY:';
PRINT '  7 Completed  | 1 In Progress | 4 Confirmed | 3 Planning | 2 Requested | 1 Cancelled';
PRINT '  Total: 18 events across Weddings, Birthdays, Corporate, Conferences, Seminars, Parties';
PRINT '';
PRINT 'FINANCIAL SUMMARY:';
PRINT '  16 Invoices (7 Paid, 2 Partially Paid, 4 Pending, 1 Partially Paid/Cancelled, 1 Overdue, 1 extra)';
PRINT '  18 Payments across Deposit/Partial/Full/Stripe/Cheque/Cash/Bank Transfer';
PRINT '  Loyalty: 350 / 200 / 100 / 100 / 100 / 50 / 0 / 0 pts across 8 customers';
PRINT '============================================================';

SELECT * FROM users;
GO
SELECT * FROM events;
GO
