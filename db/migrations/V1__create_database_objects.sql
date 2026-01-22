BEGIN TRY
    BEGIN TRAN;

    IF NOT EXISTS (
        SELECT 1 FROM sys.tables WHERE name = 'schema_migrations'
    )
    BEGIN
        CREATE TABLE dbo.schema_migrations (
            version       INT PRIMARY KEY,
            description   NVARCHAR(255),
            script_name   NVARCHAR(255),
            applied_at    DATETIME DEFAULT GETDATE()
        );
    END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;

