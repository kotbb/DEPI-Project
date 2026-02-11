CREATE OR ALTER PROCEDURE [Training].[SP_TrainingManager_DeleteTrack]
    @SessionID INT,
    @TrackId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT; 
        DECLARE @RoleID INT;

        -- 1. Auth: Validate Session
        SELECT @UserID = user_id FROM dbo.System_Session_Log WHERE session_id = @SessionID AND status = 'Active';
        IF @UserID IS NULL THROW 51000, 'Session Expired or Invalid', 1;

        -- 2. Security: Role Check (Manager = 3)
        SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
        IF @RoleID <> 3 THROW 51000, 'Access Denied: Only Training Managers can delete tracks', 1;

        -- 3. Business Logic: Check Existence
        IF NOT EXISTS (SELECT 1 FROM [Track] WHERE track_id = @TrackId)
        BEGIN
            ;THROW 51000, 'Track ID does not exist', 1;
        END
 
        IF EXISTS (SELECT 1 FROM [Student] WHERE track_id = @TrackId)
        BEGIN
            ;THROW 51000, 'Cannot delete Track: Active students are assigned to it.', 1;
        END

        -- 5. Execution: Delete
        DELETE FROM [Track] WHERE track_id = @TrackId;
        
        SELECT 'Success' AS Status, 'Track deleted successfully' AS Message;

    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO