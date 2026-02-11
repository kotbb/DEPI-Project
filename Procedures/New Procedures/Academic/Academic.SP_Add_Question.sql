CREATE OR ALTER PROCEDURE [Academic].[Sp_Add_Question]
    @SessionID INT,
    @course_id INT,
    @text NVARCHAR(MAX),
    @type NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @UserID INT; DECLARE @RoleID INT;

        -- Auth
        SELECT @UserID = user_id FROM dbo.System_Session_Log WHERE session_id = @SessionID AND status = 'Active';
        IF @UserID IS NULL THROW 51000, 'Session Expired', 1;

        SELECT @RoleID = role_id FROM dbo.[User] WHERE user_id = @UserID;
        IF @RoleID <> 2 THROW 51000, 'Access Denied: Instructor only', 1;

        -- Logic
        INSERT INTO dbo.Question(course_id, question_text, question_type)
        VALUES(@course_id, @text, @type);

        SELECT 'Success' AS Status, 'Question Added' AS Message;

    END TRY
    BEGIN CATCH
        SELECT 'Error' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END
GO