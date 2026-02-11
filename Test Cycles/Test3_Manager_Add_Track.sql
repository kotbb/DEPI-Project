-- =============================================
-- TEST CYCLE 3: MANAGER (Login -> Add Track -> Logout)
-- =============================================

DECLARE @MgrSessionID INT;

-- A. LOGIN
PRINT '1. Logging in as Training Manager...';
DECLARE @MgrLoginResult TABLE (Status NVARCHAR(20), UserID INT, Role NVARCHAR(50), SessionID INT);

BEGIN TRY
    INSERT INTO @MgrLoginResult
    EXEC SP_User_Login @Email = 'manager@depi.com', @Password = '123456';
    
    SELECT @MgrSessionID = SessionID FROM @MgrLoginResult;
    PRINT '   Logged in! Session ID: ' + CAST(@MgrSessionID AS VARCHAR);
END TRY
BEGIN CATCH
    PRINT 'Login Failed: ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- B. ACTION: ADD TRACK
PRINT '2. Attempting to Add "Data Science" Track...';
-- Pass the SessionID and the required Branch ID (assuming Branch 1 exists)
EXEC [Training].[SP_TrainingManager_AddTrack] 
    @SessionID = @MgrSessionID,
    @TrackName = 'Data Science',
    @BranchID = 1;

-- C. LOGOUT
PRINT '3. Logging out...';
EXEC SP_User_Logout @SessionID = @MgrSessionID;

-- D. VERIFY
PRINT '4. Verifying Session Log...';
SELECT * FROM System_Session_Log WHERE session_id = @MgrSessionID;
GO