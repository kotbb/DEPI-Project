CREATE OR ALTER PROCEDURE [Student].[SP_Student_Enter_Exam]
    @SessionID INT,
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT; DECLARE @RoleID INT;

        -- 1. Auth Check
        SELECT @UserID = user_id FROM dbo.System_Session_Log WHERE session_id = @SessionID AND status = 'Active';
        IF @UserID IS NULL THROW 51000, 'Session Expired', 1;

        SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
        IF @RoleID <> 1 THROW 51000, 'Access Denied: Students only', 1;

        -- 2. Validation
        IF NOT EXISTS (SELECT 1 FROM Exam WHERE exam_id = @ExamID)
            THROW 51000, 'Exam ID not found', 1;

        IF EXISTS (SELECT 1 FROM Student_Exam WHERE student_id = @UserID AND exam_id = @ExamID)
            THROW 51000, 'You have already started this exam', 1;

        -- 3. Execution
        INSERT INTO Student_Exam (student_id, exam_id, start_time)
        VALUES (@UserID, @ExamID, GETDATE());

        SELECT 'Success' as Status, 'Exam Started' as Message;

        -- 4. Return Questions
        SELECT Q.question_text, Q.question_type 
        FROM Exam_Question EQ
        JOIN Question Q ON EQ.question_id = Q.question_id
        WHERE EQ.exam_id = @ExamID;

    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO