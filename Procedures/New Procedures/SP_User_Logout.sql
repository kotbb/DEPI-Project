CREATE OR ALTER PROCEDURE SP_User_Logout
    @SessionID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Close the specific session
    UPDATE dbo.System_Session_Log
    SET logout_time = GETDATE(),
        status = 'Closed'
    WHERE session_id = @SessionID;

    -- 2. Check if it worked
    IF @@ROWCOUNT > 0
        SELECT 'SUCCESS' as Status, 'User Logged Out' as Message;
    ELSE
        SELECT 'FAILURE' as Status, 'Session not found or already closed' as Message;
END
GO