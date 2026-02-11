CREATE OR ALTER PROCEDURE [Training].[SP_TrainingManager_AddTrack]
    @SessionID INT,
    @TrackName NVARCHAR(100),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT; DECLARE @RoleID INT;

        -- Auth
        SELECT @UserID = user_id FROM dbo.System_Session_Log WHERE session_id = @SessionID AND status = 'Active';
        IF @UserID IS NULL THROW 51000, 'Session Expired', 1;

        -- Role Check (Manager = 3)
        SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
        IF @RoleID <> 3 THROW 51000, 'Access Denied: Manager only', 1;

        -- Logic
        INSERT INTO [Track] (track_name, branch_id) VALUES (@TrackName, @BranchID);
        
        SELECT 'Success' AS Status, 'Track added successfully' AS Message;

    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO