CREATE PROCEDURE SP_Instructor_Create_Exam
(
    @instructor_id INT,
    @course_id INT,
    @exam_type NVARCHAR(50),

    -- Manual Questions
    @Q1 INT,
    @Q2 INT,
    @Q3 INT,
    @Q4 INT,
    @Q5 INT
)
AS
BEGIN

    DECLARE @exam_id UNIQUEIDENTIFIER
    SET @exam_id = NEWID()

    --  Create Exam
    INSERT INTO Exam (exam_id, course_id, instructor_id, exam_type)
    VALUES (@exam_id, @course_id, @instructor_id, @exam_type)

     --- Add 5 Random T/F Questions
    INSERT INTO Exam_Question (exam_id, question_id)
    SELECT TOP 5 @exam_id, question_id
    FROM Question
    WHERE question_type = 'T/F'
    ORDER BY NEWID()

    
    INSERT INTO Exam_Question (exam_id, question_id)
    VALUES
        (@exam_id, @Q1),
        (@exam_id, @Q2),
        (@exam_id, @Q3),
        (@exam_id, @Q4),
        (@exam_id, @Q5)

END;
