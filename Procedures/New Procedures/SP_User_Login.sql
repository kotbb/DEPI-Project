CREATE OR ALTER PROCEDURE SP_User_Login
    @Email NVARCHAR(100),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT;
        DECLARE @RoleID INT;
        DECLARE @RoleName NVARCHAR(50);

        -- 1. Validate User
        SELECT 
            @UserID = u.user_id, 
            @RoleID = r.role_id,
            @RoleName = r.role_name
        FROM [User] u
        JOIN [Role] r ON u.role_id = r.role_id
        WHERE u.email = @Email AND u.password = @Password;

        -- 2. Handle Result
        IF @UserID IS NOT NULL
        BEGIN
            INSERT INTO System_Session_Log (user_id) VALUES (@UserID);
            
            SELECT 
                'SUCCESS' as TransactionStatus,
                @UserID as UserID, 
                @RoleName as UserRole, 
                SCOPE_IDENTITY() as SessionID;
        END
        ELSE
        BEGIN
            -- Custom business error
            THROW 51000, 'Invalid email or password.', 1;
        END
    END TRY
    BEGIN CATCH
        -- Return the error cleanly to the app
        SELECT 'FAILURE' as TransactionStatus, ERROR_MESSAGE() as ErrorMessage;
    END CATCH
END
GO