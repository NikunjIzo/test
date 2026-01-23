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

    IF NOT EXISTS (SELECT 1 FROM dbo.schema_migrations WHERE version = 5)
    BEGIN
        INSERT INTO dbo.schema_migrations (version, description, script_name)
        VALUES
        (1, 'baseline', 'baseline'),
        (2, 'baseline', 'baseline'),
        (3, 'baseline', 'baseline'),
        (4, 'baseline', 'baseline'),
        (5, 'baseline', 'baseline');
    END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;
