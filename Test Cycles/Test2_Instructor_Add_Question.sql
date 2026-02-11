-- =============================================
-- TEST CYCLE 2: INSTRUCTOR (Login -> Add Question -> Logout)
-- =============================================

DECLARE @InstSessionID INT;

-- A. LOGIN
PRINT '1. Logging in as Instructor...';
DECLARE @InstLoginResult TABLE (Status NVARCHAR(20), UserID INT, Role NVARCHAR(50), SessionID INT);

INSERT INTO @InstLoginResult
EXEC SP_User_Login @Email = 'instructor@depi.com', @Password = '123456';

SELECT @InstSessionID = SessionID FROM @InstLoginResult;
PRINT '   Logged in! Session ID: ' + CAST(@InstSessionID AS VARCHAR);

-- B. ACTION: ADD QUESTION
PRINT '2. Adding a Question to Course #1...';
-- Using the Schema [Academic] and passing the SessionID
EXEC [Academic].[Sp_Add_Question] 
    @SessionID = @InstSessionID,
    @course_id = 1,
    @text = 'What is the primary key of a table?',
    @type = 'MCQ';

-- C. LOGOUT
PRINT '3. Logging out...';
EXEC SP_User_Logout @SessionID = @InstSessionID;

-- D. VERIFY
PRINT '4. Verifying Session Log...';
SELECT * FROM System_Session_Log WHERE session_id = @InstSessionID;
GO