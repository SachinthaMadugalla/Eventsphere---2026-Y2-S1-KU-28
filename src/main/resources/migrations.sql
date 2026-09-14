-- Repeatable, additive upgrades for an existing EventSphere database.
IF COL_LENGTH('dbo.events', 'is_archived') IS NULL
    ALTER TABLE dbo.events ADD is_archived BIT NOT NULL CONSTRAINT DF_events_is_archived DEFAULT 0;
GO
