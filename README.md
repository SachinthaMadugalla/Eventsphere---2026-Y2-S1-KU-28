# EventSphere – Web-Based Event Planning System

**Module:** SE2030 – Software Engineering  
**Group:** 2026-Y2-S1-KU-28  
**Academic Year:** Year 2, Semester 1 – 2026

---

## Project Overview

EventSphere is a web-based event planning and management system that replaces
fragmented manual methods (spreadsheets, phone calls, paper documents) with a
single centralised platform for customers, event managers, staff, venues,
vendors, finance, and management.

---

## Technology Stack

| Layer            | Technology                          |
|------------------|-------------------------------------|
| Frontend         | JSP, HTML5, CSS3, JavaScript        |
| Backend          | Java 17, Spring Boot 3.2.5          |
| Architecture     | Spring MVC + Service + DAO layers   |
| Database Access  | JdbcTemplate (explicit SQL in DAOs) |
| Database         | Microsoft SQL Server (EventSphereDB)|
| JDBC Driver      | mssql-jdbc 12.4.2.jre11             |
| Password Hashing | BCrypt (spring-security-crypto)     |
| Build Tool       | Maven                               |
| Server           | Embedded Tomcat (Spring Boot)       |

---

## Requirements

- **JDK 17** – Download from https://adoptium.net  
- **Apache Maven 3.8+** – Bundled with IntelliJ IDEA  
- **IntelliJ IDEA** (Community or Ultimate)  
- **Microsoft SQL Server** (Express or Developer edition)  
  Download: https://www.microsoft.com/en-us/sql-server/sql-server-downloads  
- **SQL Server Management Studio (SSMS)**  
  Download: https://aka.ms/ssmsfullsetup

---

## Step 1 – Create the Database in SSMS

1. Open **SQL Server Management Studio (SSMS)**
2. Connect to your SQL Server instance (usually `localhost` or `.\SQLEXPRESS`)
3. In the toolbar query window, run:

```sql
CREATE DATABASE EventSphereDB;
```

---

## Step 2 – Run the SQL Scripts

1. In SSMS, select **EventSphereDB** from the database dropdown
2. Open `src/main/resources/schema.sql`
3. Press **F5** to execute — this creates all 23 tables
4. Open `src/main/resources/data.sql`
5. Press **F5** to execute — this inserts all sample data

> Run `schema.sql` **before** `data.sql`.

---

## Step 3 – Configure the Database Connection

Open:

```
src/main/resources/application.properties
```

Find this line and replace `YOUR_SQL_SERVER_PASSWORD` with your actual
SQL Server `sa` password:

```properties
spring.datasource.password=YOUR_SQL_SERVER_PASSWORD
```

If your SQL Server uses a different username or instance, also update:

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=EventSphereDB;encrypt=true;trustServerCertificate=true
spring.datasource.username=sa
```

If you use SQL Server Express with a named instance, the URL might be:

```properties
spring.datasource.url=jdbc:sqlserver://localhost\SQLEXPRESS:1433;databaseName=EventSphereDB;encrypt=true;trustServerCertificate=true
```

---

## Step 4 – Open the Project in IntelliJ IDEA

1. Open IntelliJ IDEA
2. Click **File → Open**
3. Navigate to the `EventSphere` folder and click **OK**
4. IntelliJ will detect the `pom.xml` and import the Maven project
5. If prompted, click **Load Maven Project**

---

## Step 5 – Reload Maven Dependencies

If dependencies are not loaded:

1. Open the **Maven** panel (right side of IntelliJ)
2. Click the **Reload All Maven Projects** button (circular arrow icon)
3. Wait for all dependencies to download

---

## Step 6 – Run the Application

1. In IntelliJ, navigate to:
   ```
   src/main/java/com/eventsphere/EventSphereApplication.java
   ```
2. Right-click → **Run 'EventSphereApplication'**
3. Wait for the console to show:
   ```
   Started EventSphereApplication in X.XXX seconds
   ```

---

## Step 7 – Open in Browser

Navigate to:

```
http://localhost:8080
```

You will be redirected to the login page.

---

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

## Common SQL Server Connection Troubleshooting

### Error: "Cannot connect to localhost:1433"

- Ensure SQL Server service is running:  
  `Windows Services → SQL Server (MSSQLSERVER) → Start`
- Enable TCP/IP in **SQL Server Configuration Manager**:  
  `SQL Server Network Configuration → Protocols → TCP/IP → Enable`
- Ensure port 1433 is not blocked by Windows Firewall

### Error: "Login failed for user 'sa'"

- Ensure **SQL Server Authentication** is enabled:  
  In SSMS → Right-click server → Properties → Security → SQL Server and Windows Authentication mode
- Ensure the `sa` account is enabled:  
  SSMS → Security → Logins → sa → Properties → Status → Login: Enabled
- Verify the password in `application.properties` matches the `sa` password

### Error: "Database 'EventSphereDB' does not exist"

- Create it: `CREATE DATABASE EventSphereDB;` in SSMS
- Then re-run `schema.sql` and `data.sql`

### Error: "The driver could not establish a secure connection"

- The URL already includes `trustServerCertificate=true` which handles
  self-signed certificates. Ensure this is present in `application.properties`.

### Application starts but login fails

- Confirm `data.sql` was executed and rows exist in the `users` table
- Run in SSMS: `SELECT username, is_active FROM users;`
- Passwords in the database must be BCrypt hashes — never plain text

---

## Project Structure

```
EventSphere/
├── pom.xml
├── README.md
└── src/main/
    ├── java/com/eventsphere/
    │   ├── EventSphereApplication.java
    │   ├── config/WebConfig.java
    │   ├── controller/          (12 controllers)
    │   ├── service/             (14 services)
    │   ├── dao/                 (16 DAOs — all SQL visible here)
    │   ├── model/               (21 model classes)
    │   ├── dto/                 (2 DTOs)
    │   └── exception/GlobalExceptionHandler.java
    ├── resources/
    │   ├── application.properties
    │   ├── schema.sql           ← Run in SSMS first
    │   ├── data.sql             ← Run in SSMS second
    │   └── static/css/js/
    └── webapp/WEB-INF/views/    (all JSP pages)
        ├── auth/
        ├── customer/
        ├── event/
        ├── venue-vendor/
        ├── staff-resource/
        ├── operations/
        ├── finance/
        ├── reporting/
        ├── admin/
        └── common/
```
