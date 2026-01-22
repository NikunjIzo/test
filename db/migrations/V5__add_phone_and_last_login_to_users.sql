BEGIN TRY
    BEGIN TRAN;

    IF COL_LENGTH('dbo.users', 'phone_number') IS NULL
    BEGIN
        ALTER TABLE dbo.users
        ADD phone_number NVARCHAR(20) NULL;
    END

    IF COL_LENGTH('dbo.users', 'last_login_at') IS NULL
    BEGIN
        ALTER TABLE dbo.users
        ADD last_login_at DATETIME NULL;
    END

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;
