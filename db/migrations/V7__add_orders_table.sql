BEGIN TRY
    BEGIN TRAN;

    CREATE TABLE dbo.orders (
        order_id INT IDENTITY PRIMARY KEY,
        user_id INT NOT NULL,
        total_amount DECIMAL(10,2) NOT NULL,
        created_at DATETIME DEFAULT GETDATE()
    );

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;

