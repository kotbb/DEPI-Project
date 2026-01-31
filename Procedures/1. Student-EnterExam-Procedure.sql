create procedure Sp_Student_Enter_Exam
    @StudentId int,
    @ExamId int
as
begin
    set nocount on;

    -- Declare variables for logic and validation
    declare @CurrentTime datetime = getdate();
    declare @ExamStartTime datetime;
    declare @ExamEndTime datetime;
    declare @ErrorMessage nvarchar(500);

    begin try
        begin transaction;

        -- 1. Validate student existence
        if not exists (select 1 from [Student] where student_id = @StudentId)
        begin
            set @ErrorMessage = 'Error: Student ID ' + cast(@StudentId as nvarchar(10)) + ' does not exist.';
            raiserror(@ErrorMessage, 16, 1);
            return;
        end

        -- 2. Validate exam existence and fetch timing
        select 
            @ExamStartTime = start_time,
            @ExamEndTime = end_time
        from [Exam]
        where exam_id = @ExamId;

        if @ExamStartTime is null
        begin
            raiserror('Error: Exam not found.', 16, 1);
            return;
        end

        -- 3. Validate if the current time is within the allowed window
        if @CurrentTime < @ExamStartTime
        begin
            set @ErrorMessage = 'Error: Exam has not started yet. Starts at ' + convert(nvarchar(20), @ExamStartTime, 120);
            raiserror(@ErrorMessage, 16, 1);
            return;
        end

        if @CurrentTime > @ExamEndTime
        begin
            set @ErrorMessage = 'Error: Exam time has expired. Ended at ' + convert(nvarchar(20), @ExamEndTime, 120);
            raiserror(@ErrorMessage, 16, 1);
            return;
        end

        -- 4. Check if student has already initiated this exam
        if exists (select 1 from [Student_Exam] where student_id = @StudentId and exam_id = @ExamId)
        begin
            raiserror('Error: Student has already taken this exam record.', 16, 1);
            return;
        end

        -- 5. Insert initial participation record
        insert into [Student_Exam] (student_id, exam_id, start_time, is_reviewed)
        values (@StudentId, @ExamId, @CurrentTime, 0);

        -- 6. Retrieve exam questions and choices for MCQ
        select 
            Eq.sequence_number as QuestionNo,
            Q.question_text as Text,
            Q.question_type as Type,
            Qmc.choice1, 
            Qmc.choice2, 
            Qmc.choice3, 
            Qmc.choice4
        from [Exam_Question] Eq
        join [Question] Q on Eq.question_id = Q.question_id
        left join [Question_MC] Qmc on Q.question_id = Qmc.question_id
        where Eq.exam_id = @ExamId
        order by Eq.sequence_number;

        commit transaction;
    end try
    begin catch
        -- Rollback if any error occurs during the process
        if @@trancount > 0 
            rollback transaction;
            
        throw;
    end catch
end