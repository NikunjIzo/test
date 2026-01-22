BEGIN TRY
    BEGIN TRAN;

    CREATE TABLE dbo.products (
        product_id INT IDENTITY PRIMARY KEY,
        product_name NVARCHAR(200) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        created_at DATETIME DEFAULT GETDATE()
    );

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;
