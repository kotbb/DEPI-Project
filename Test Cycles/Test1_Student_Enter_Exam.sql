-- =============================================
-- TEST CYCLE 1: STUDENT (Login -> Enter Exam -> Logout)
-- =============================================
DECLARE @MySessionID INT;
DECLARE @MyUserID INT;
DECLARE @MyRole NVARCHAR(60);

-- A. LOGIN
PRINT '1. Logging in as Student...';
-- We use a table variable to capture the output of the stored procedure
DECLARE @LoginResult TABLE (Status NVARCHAR(20), UserID INT, Role NVARCHAR(60), SessionID INT);

INSERT INTO @LoginResult
EXEC SP_User_Login @Email = 'student@depi.com', @Password = '123456';

-- Save the Session ID for the next steps
SELECT @MySessionID = SessionID, @MyUserID = UserID FROM @LoginResult;
PRINT '   Logged in! Session ID: ' + CAST(@MySessionID AS VARCHAR);

-- B. ACTION: ENTER EXAM
PRINT '2. Attempting to Enter Exam #1...';
-- Pass the SessionID we got from Step A
EXEC [Student].[SP_Student_Enter_Exam] @SessionID = @MySessionID, @ExamID = 1;

-- C. LOGOUT
PRINT '3. Logging out...';
EXEC SP_User_Logout @SessionID = @MySessionID;

-- D. VERIFY
PRINT '4. Verifying Session Log...';
SELECT * FROM System_Session_Log WHERE session_id = @MySessionID;
GO

