BEGIN TRY
    BEGIN TRAN;

    CREATE INDEX idx_users_email ON dbo.users(email);
    CREATE INDEX idx_products_name ON dbo.products(product_name);

    COMMIT TRAN;
END TRY
BEGIN CATCH
    ROLLBACK TRAN;
    THROW;
END CATCH;
