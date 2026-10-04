-- Repeatable, additive upgrades for an existing EventSphere database.
IF COL_LENGTH('dbo.events', 'is_archived') IS NULL
    ALTER TABLE dbo.events ADD is_archived BIT NOT NULL CONSTRAINT DF_events_is_archived DEFAULT 0;
GO
IF COL_LENGTH('dbo.payments', 'payment_method') IS NULL
    ALTER TABLE dbo.payments ADD payment_method NVARCHAR(30) NOT NULL CONSTRAINT DF_payments_payment_method DEFAULT 'Cash';
GO
IF COL_LENGTH('dbo.payments', 'stripe_session_id') IS NULL
    ALTER TABLE dbo.payments ADD stripe_session_id NVARCHAR(255) NULL;
GO
-- One payment row per Stripe Checkout session (guards against double-recording).
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_payments_stripe_session' AND object_id = OBJECT_ID('dbo.payments'))
    CREATE UNIQUE INDEX UX_payments_stripe_session ON dbo.payments(stripe_session_id) WHERE stripe_session_id IS NOT NULL;
GO
