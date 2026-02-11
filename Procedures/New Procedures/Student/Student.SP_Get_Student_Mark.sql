CREATE OR ALTER PROCEDURE [Student].[SP_Get_Student_Mark] 
    @SessionID INT,       -- Security Token
    @course_name NVARCHAR(60)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UserID INT; 
    DECLARE @RoleID INT;

    -- 1. Validate Session
    SELECT @UserID = user_id FROM dbo.System_Session_Log 
    WHERE session_id = @SessionID AND status = 'Active';

    IF @UserID IS NULL
    BEGIN
        SELECT 'AuthError' AS Status, 'Session Expired' AS Message;
        RETURN;
    END

    -- 2. Validate Role (Student = 1)
    SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
    IF @RoleID <> 1
    BEGIN
        SELECT 'AccessDenied' AS Status, 'Only Students can view marks' AS Message;
        RETURN;
    END

    -- 3. Business Logic (Filtered by @UserID)
    SELECT 
        S.f_name + ' ' + S.l_name As StudentName,
        C.course_name,
        E.exam_type,
        SE.total_score
    FROM dbo.Student S
    JOIN dbo.Student_Exam SE on S.student_id = SE.student_id
    JOIN dbo.Exam E on SE.exam_id = E.exam_id
    JOIN dbo.Course C on E.course_id = C.course_id
    WHERE S.student_id = @UserID  -- SECURE: Forces their own ID
      AND C.course_name = @course_name;
END
GO