# EventSphere – Web-Based Event Planning System

SE2030 · Group 2026-Y2-S1-KU-28 · Year 2, Semester 1, 2026

## Required database: Microsoft SQL Server

EventSphere uses Java 17+, Spring Boot 3.2.5, JSP, JdbcTemplate and **SQL Server**.
The runnable application requires a working SQL Server connection. H2 exists only
in the isolated regression tests and is not packaged in the WAR.

## One-click local start (Windows)

1. Ensure SQL Server is installed and its service is running, with TCP/IP enabled.
2. Double-click **Start-EventSphere.cmd**.
3. Log in at **http://127.0.0.1:8080** with **admin / password123**.
4. Double-click **Stop-EventSphere.cmd** to stop the app. SQL Server keeps your data.

On this computer, the connection is **localhost:1433 / EventSphereDB**, using
**Windows authentication**. The first start creates a missing database and installs
the schema/sample data into an empty database. Subsequent starts preserve it.
Your Windows login needs database access and, for first-time provisioning,
permission to create the database. Existing incomplete schemas are reported,
never silently dropped or overwritten.

The launcher detects Java/Maven, downloads a private Maven installation if needed,
and installs the matching Microsoft JDBC Windows-authentication DLL in `.tools/`.
Internet is needed for the first build. There is no password in source control.

Use **Setup-SQLServer.cmd** to configure a different server/port/database or SQL login.
Connection settings live in `.local/database.json`; SQL login passwords, if used,
are saved encrypted for the current Windows account. See **[SQL-SERVER.md](SQL-SERVER.md)**
for configuration, permissions, manual IDE launch, diagnostics and database backup.

Options: `Start-EventSphere.cmd -Port 8081`, `-NoBrowser`, `-BuildOnly`, or `-SetupOnly`.
Stop the app before rebuilding/reconfiguring it. Starting again opens the existing instance.

## Tests

Run `mvn -Dmaven.repo.local=.tools/m2 test` for the isolated regression suite.
`SqlServerIntegrationTest` additionally checks a real SQL Server when
`EVENTSPHERE_SQLSERVER_TEST=true`; see [SQL-SERVER.md](SQL-SERVER.md) for the command.
The real SQL tests run registration and CRUD transactions with rollback, so test data is not
left in your database.

All management screens persist through the SQL Server DAOs. Events, venues, vendors, staff,
resources, tasks, budgets, expenses, invoices, payments, feedback, complaints, users and
notifications have database-backed add/view/update/deactivate/delete operations where the
workflow supports them. Completed or cancelled events also have an Archive/Restore action;
archiving hides them from current lists while retaining their related history.

See [FIXES.md](FIXES.md) for the bug fixes and verification scope.

## Demo Accounts

All demo passwords are: **`password123`**

| Username    | Password    | Role                        |
|-------------|-------------|------------------------------|
| `admin`     | password123 | System Administrator         |
| `director`  | password123 | Managing Director            |
| `manager1`  | password123 | Event Manager                |
| `manager2`  | password123 | Event Manager                |
| `ops1`      | password123 | Operations Coordinator       |
| `cro1`      | password123 | Customer Relations Officer   |
| `finance1`  | password123 | Finance Manager              |
| `customer1` | password123 | Customer (Saman Kumara)      |
| `customer2` | password123 | Customer (Priya Wijesinghe)  |
| `customer3` | password123 | Customer (Harsha Bandara)    |

---

## Seven Major Functional Modules

| # | Module                          | Description                                          |
|---|---------------------------------|------------------------------------------------------|
| 1 | Customer Management             | Customer registration, profiles, bookings            |
| 2 | Event Management                | Full event lifecycle from request to completion      |
| 3 | Venue & Vendor Management       | Venues and vendors with conflict detection           |
| 4 | Staff & Resource Management     | Staff assignments and resource allocations           |
| 5 | Task & Operations Management    | Operational tasks, priorities, deadlines             |
| 6 | Finance & Payment Management    | Budgets, expenses, invoices, payment tracking        |
| 7 | Reporting & Feedback Management | Reports, customer feedback, complaint handling       |

---

## Architecture

```
Browser (JSP)
      ↓  HTTP Request
  Controller
  (com.eventsphere.controller)
      ↓
   Service
  (com.eventsphere.service)
      ↓
     DAO
  (com.eventsphere.dao)
      ↓  JdbcTemplate
  Microsoft SQL Server (EventSphereDB)
```

### Key Design Points

- **Controllers** handle HTTP routing and session checks only
- **Services** contain all business logic and validation
- **DAOs** contain all SQL queries — explicitly visible as Java strings
- **JdbcTemplate** is used for all database access — **no JPA/Hibernate**
- **BCrypt** hashes all passwords — plain-text passwords are never stored

### Example DAO SQL (for viva demonstration)

```java
// CustomerDAO.java — INSERT
String sql =
    "INSERT INTO customers (user_id, full_name, email, phone, address) " +
    "VALUES (?, ?, ?, ?, ?)";

// EventDAO.java — SELECT
String sql =
    "SELECT * FROM events WHERE event_id = ?";

// VenueDAO.java — UPDATE
String sql =
    "UPDATE venues SET venue_name = ?, location = ?, capacity = ? " +
    "WHERE venue_id = ?";

// TaskDAO.java — DELETE
String sql =
    "DELETE FROM tasks WHERE task_id = ?";
```

---
