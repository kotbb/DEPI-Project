CREATE OR ALTER PROCEDURE [Training].[SP_TrainingManager_UpdateTrack]
    @SessionID INT,
    @TrackId INT,
    @NewTrackName NVARCHAR(100)
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
        IF @RoleID <> 3 THROW 51000, 'Access Denied: Only Training Managers can update tracks', 1;

        -- 3. Business Logic: Check Existence
        IF NOT EXISTS (SELECT 1 FROM [Track] WHERE track_id = @TrackId)
        BEGIN
            ;THROW 51000, 'Track ID does not exist', 1;
        END

        -- 4. Execution: Update
        UPDATE [Track] 
        SET track_name = @NewTrackName 
        WHERE track_id = @TrackId;
        
        SELECT 'Success' AS Status, 'Track updated successfully' AS Message;

    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO