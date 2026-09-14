# Local fixes and verification

The repository was cloned locally; these changes have not been pushed to GitHub.

## Startup

- Added Windows start/stop launchers, private Maven fallback, dependency caching,
  readiness checks, duplicate-start detection, port selection, and log files.
- Resolved Java PATH shortcuts to the real executable for reliable stopping and
  normalized duplicate Windows environment variable names before process launch.
- SQL Server is mandatory for the runnable application. The launcher uses Windows
  authentication, provisions only a missing database/empty schema, and checks the
  real connection before starting. H2 and its initializer are test-only.
- Removed the committed SQL Server password from configuration; use `DB_PASSWORD`.
- Corrected all ten demo BCrypt hashes to match the documented `password123`.

## Application corrections

- Corrected CRO/director dashboard redirects and invalid JSP namespace usage.
- Repaired garbled UTF-8 text in JSP pages and titles.
- Enforced customer ownership of booking details/cancellation, profile edits,
  feedback, complaints, and notification mutations.
- Added CSRF tokens to POST forms, changed logout to POST, rotated sessions on
  login, and refreshed account status/roles during existing sessions.
- Escaped HTML output and removed user text from inline JavaScript arguments.
- Prevented administrators from removing their own administrator role; assigning
  the Customer role creates a customer profile when necessary.
- Wrapped multi-record operations in transactions. Stock reservation is atomic,
  invalid allocations roll back, repeated releases do not inflate inventory,
  and inventory edits preserve already allocated quantities.
- Completing/cancelling events releases their resource allocations.
- Fixed invoice ownership/payment notification recipients, missing-invoice
  handling, invoice status after deleting payments, and totals below existing payments.
- Budgets use recorded expenses for actual cost, including expenses entered before
  budget creation. Expense edits/deletions resolve the event from stored data.
- Dashboard expenses use expense records. The invoiced total includes all invoices;
  UI labels distinguish this from cash collected and outstanding balances.
- Added date/time/status validation, inactive assignment checks, duplicate staff/vendor
  checks, and all-day venue conflict handling. Reopening tasks clears completion time.
- Errors return appropriate HTTP status codes and do not expose SQL or stack traces in pages.
- Completed/cancelled events can be archived and restored without deleting their related
  bookings, financial records, assignments, or feedback. Current event lists and dashboard
  counts exclude archived history. Invoice detail pages now expose a validated edit workflow.

## Verification scope

The 15-test isolated regression suite passes. Three opt-in SQL Server integration tests
cover the real connection, registration, and CRUD round-trips; the first two were run
successfully against the configured server before the CRUD expansion. The updated suite and
WAR compile successfully, and the
executable WAR built successfully. The 15 isolated regression tests exercise the HTTP server/JSP engine and H2 in SQL
Server compatibility mode, including ten demo logins, the main forms/lists/reports,
customer access restrictions, CSRF, output escaping, transaction rollback,
stock, scheduling conflicts, task completion, and registration through invoicing/payment.
The packaged WAR is also tested through the Windows launcher, including stopping,
restarting with the persistent database, and starting an already running instance.
The SQL Server configuration, additive archive-column migration, and real-database verification are documented in SQL-SERVER.md.

H2 tests are not a substitute for SQL Server integration tests. The opt-in
SqlServerIntegrationTest verifies the actual database product, DAO queries and a
transactional registration write/read using the configured SQL Server. These are
the identified fixes, not a guarantee that every concurrency scenario is eliminated.
