CREATE OR ALTER PROCEDURE [Academic].[SP_Instructor_Create_Exam]
(
    @SessionID INT,
    @course_id INT,
    @exam_type NVARCHAR(50),
    @start_time DATETIME,
    @end_time DATETIME,
    @total_time INT,
    @year INT,
    @Q1 INT, @Q2 INT, @Q3 INT, @Q4 INT, @Q5 INT
)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT; DECLARE @RoleID INT;

        -- 1. Security Checks
        SELECT @UserID = user_id FROM dbo.System_Session_Log WHERE session_id = @SessionID AND status = 'Active';
        IF @UserID IS NULL THROW 51000, 'Session Expired', 1;

        SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
        IF @RoleID <> 2 THROW 51000, 'Access Denied: Instructor only', 1;

        -- 2. START TRANSACTION (All or Nothing)
        BEGIN TRANSACTION;

            -- A. Create Exam Header
            INSERT INTO Exam (course_id, instructor_id, exam_type, start_time, end_time, total_time, year)
            VALUES (@course_id, @UserID, @exam_type, @start_time, @end_time, @total_time, @year);

            DECLARE @new_exam_id INT = SCOPE_IDENTITY();

            -- B. Add Random Questions
            INSERT INTO Exam_Question (exam_id, question_id, question_degree, sequence_number)
            SELECT TOP 5 @new_exam_id, question_id, 10, ROW_NUMBER() OVER(ORDER BY NEWID())
            FROM Question
            WHERE question_type = 'T/F' AND course_id = @course_id
            ORDER BY NEWID();

            -- C. Add Manual Questions
            INSERT INTO Exam_Question (exam_id, question_id, question_degree, sequence_number)
            VALUES 
                (@new_exam_id, @Q1, 10, 6), (@new_exam_id, @Q2, 10, 7), 
                (@new_exam_id, @Q3, 10, 8), (@new_exam_id, @Q4, 10, 9), 
                (@new_exam_id, @Q5, 10, 10);

        -- 3. COMMIT (Save everything)
        COMMIT TRANSACTION;

        SELECT 'Success' AS Status, @new_exam_id AS NewExamID;

    END TRY
    BEGIN CATCH
        -- If anything failed, undo the changes
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO