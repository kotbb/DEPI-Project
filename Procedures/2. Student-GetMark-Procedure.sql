create procedure SP_Get_Student_Mark 
 @student_id int, @course_name nvarchar(50)
as
begin
	select S.f_name + ' ' + S.l_name As StudentName,
	C.course_name,
	E.exam_type,
	SE.total_score
	From Student S
	join Student_Exam SE on S.student_id = SE.student_id
	join Exam E on SE.exam_id = E.exam_id
    join Course C on E.course_id = C.course_id
	where S.student_id = @student_id 
      and C.course_name = @course_name;
end
