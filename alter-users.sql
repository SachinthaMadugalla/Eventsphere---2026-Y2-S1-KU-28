USE EventSphereDB;
GO

IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[dbo].[users]') 
      AND name = 'profile_picture'
)
BEGIN
    ALTER TABLE users ADD profile_picture NVARCHAR(255) NULL;
END
GO
