CREATE PROCEDURE SP_Instructor_Create_Exam
(
    @instructor_id INT,
    @course_id INT,
    @exam_type NVARCHAR(50),
	@start_time DATETIME,
    @end_time DATETIME,
    @total_time INT,
    @year INT,

    -- Manual Questions
    @Q1 INT,
    @Q2 INT,
    @Q3 INT,
    @Q4 INT,
    @Q5 INT
)
AS
BEGIN

    INSERT INTO Exam 
	(
		course_id, 
		instructor_id, 
		exam_type, 
		start_time, 
		end_time, 
		total_time, 
		year
	)
    VALUES 
	(
		@course_id, 
		@instructor_id, 
		@exam_type, 
		@start_time, 
		@end_time, 
		@total_time, 
		@year
	);

    -- Get the ID of the exam we just created
    DECLARE @new_exam_id INT = SCOPE_IDENTITY();

    --  5 Random True/False Questions
    INSERT INTO Exam_Question (exam_id, question_id)
    SELECT TOP 5
           @new_exam_id,
           question_id
    FROM Question
    WHERE question_type = 'T/F'
      AND course_id = @course_id
    ORDER BY NEWID()

    --  Manual Questions
    INSERT INTO Exam_Question (exam_id, question_id)
    VALUES
        (@new_exam_id, @Q1),
        (@new_exam_id, @Q2),
        (@new_exam_id, @Q3),
        (@new_exam_id, @Q4),
        (@new_exam_id, @Q5)

END;
