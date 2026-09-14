# Required SQL Server connection

EventSphere runs against **Microsoft SQL Server**. H2 is a test dependency only:
the executable WAR contains neither the H2 driver nor its test initializer.
The application checks the server product and required tables during startup;
it fails startup if the SQL Server connection or schema is unavailable.

## This computer

- Instance/service: `MSSQLSERVER`
- TCP endpoint: `localhost:1433`
- Database: `EventSphereDB`
- Authentication: **Windows authentication**, using the Windows account that runs the launcher

Double-click `Start-EventSphere.cmd`. On first use it copies `database.example.json`
to `.local/database.json`, downloads the matching Microsoft JDBC native authentication
DLL (with SHA-256 verification), builds the application, and connects to SQL Server.
If `EventSphereDB` is absent it creates it; if the database is empty it installs
`schema.sql` and `data.sql`. Existing databases are checked and preserved.
Schema/seed changes run in a transaction. Partial or incompatible schemas cause an
error instead of resetting data. Stopping the app does not stop SQL Server.

`Setup-SQLServer.cmd` provides interactive configuration, applies repeatable additive
upgrades (including the event archive column), and initializes/verifies
the database without starting the app. Press Enter at each prompt to retain the
Windows-authentication defaults. Configuration changes require stopping the app first.
The server service must be running, TCP/IP must be enabled, and the configured port
must match SQL Server Configuration Manager. Named instances work by specifying
their host and TCP port, without a `\\INSTANCE` suffix.

The Windows login requires access to `EventSphereDB`; first-time database creation
also requires `CREATE DATABASE` permission. An administrator can provision it first.
No SQL Server password is required for Windows authentication.

## Configuration

`.local/database.json` is ignored by Git. It contains no password. Supported fields:

| Field | Default | Purpose |
| --- | --- | --- |
| Host | localhost | SQL Server host/IP |
| Port | 1433 | SQL Server TCP port |
| Database | EventSphereDB | Database name |
| Authentication | Windows | Windows or Sql |
| Username | empty | Used only for SQL authentication |
| TrustServerCertificate | true | Accept the local SQL Server self-signed certificate |
| SeedDemo | true | Load demo data only when creating an empty schema |

Encryption is enabled. For a server with a trusted certificate, set
`TrustServerCertificate` to `false`. SQL authentication is optional: setup prompts
for a password locally and saves it with Windows DPAPI in `.local/sql-password.xml`.
Only the same Windows user on that computer can decrypt that file. Do not commit it.

For IDE/CLI use, application properties support `DB_HOST`, `DB_PORT`, `DB_NAME`,
`DB_INTEGRATED_SECURITY`, `DB_USERNAME`, `DB_PASSWORD`, and `DB_TRUST_SERVER_CERTIFICATE`.
Windows authentication also needs the JVM option
`-Djava.library.path=<project>/.tools/sqlserver-auth`. The launcher adds it automatically.
To override the launcher's JSON settings with environment variables, set
`EVENTSPHERE_USE_ENV_DATABASE=true` and the desired `DB_*` variables.

## Diagnostics and data

- `.local/database-setup.log`: connection and schema setup results
- `.local/server.log`: application log and confirmed SQL Server database name
- `.local/server-error.log`: Java stderr
- Back up application data using SQL Server backup tools; `.local/` contains launcher configuration/logs.
- Any old `.local/eventsphere.mv.db` from the earlier demo is left untouched and is no longer used or automatically migrated.

## Verification

Verified on this computer: SQL Server connection/schema setup, DAO queries, and
a registration write/read with rollback. The isolated 15-test suite passes; the opt-in suite
now contains three SQL Server tests (connection/DAO checks, registration, and CRUD round-trip).
The first two SQL Server tests were run successfully against the configured server before the
CRUD expansion. The packaged WAR was checked to contain no H2 driver.

`mvn test` runs the isolated regression suite without requiring SQL Server.
To additionally execute the real SQL Server integration checks, set
`EVENTSPHERE_SQLSERVER_TEST=true`, configure the `DB_*` variables above, and run:

```powershell
mvn '-Dmaven.repo.local=.tools/m2' '-DargLine=-Djava.library.path=.tools/sqlserver-auth' test
```

`SqlServerIntegrationTest` verifies the server product, schema, DAO queries and a
registration write/read transaction that is rolled back. It never substitutes H2
for the real SQL Server connection. Windows-authentication tests must run under your
normal Windows account, outside a sandbox that lacks access to Windows credentials.

Microsoft's [JDBC Windows authentication documentation](https://learn.microsoft.com/en-us/sql/connect/jdbc/building-the-connection-url)
describes the native DLL and `java.library.path` configuration.
