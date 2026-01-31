-- 1. Insert Roles
insert into [Role] (role_name) values ('Admin'), ('Student'), ('Instructor');

-- 2. Insert Users (Password: 123 for all)
insert into [User] (email, password, role_id) values 
('student1@depi.com', '123', 2),
('inst1@depi.com', '123', 3);

-- 3. Insert Student & Instructor
insert into [Student] (student_id, f_name, l_name, gender) values (1, 'Ahmed', 'Ali', 'M');
insert into [Instructor] (instructor_id, instructor_name) values (2, 'Dr. Mohamed');

-- 4. Insert Course
insert into [Course] (course_name, description, min_degree, max_degree) 
values ('SQL Basics', 'Database Fundamentals', 50, 100);

-- 5. Insert Exam (Valid for 2 hours from now)
insert into [Exam] (course_id, instructor_id, exam_type, start_time, end_time, total_time, [year])
values (1, 2, 'Exam', getdate(), dateadd(hour, 2, getdate()), 120, 2024);

-- 6. Insert Questions
insert into [Question] (course_id, question_text, question_type, correct_answer) 
values (1, 'What does SQL stand for?', 'MCQ', 'Structured Query Language');

-- 7. Insert MC Choices
insert into [Question_MC] (question_id, choice1, choice2, choice3, choice4)
values (1, 'Simple Query Language', 'Structured Query Language', 'Standard Query Logic', 'None');

-- 8. Link Question to Exam
insert into [Exam_Question] (exam_id, question_id, question_degree, sequence_number)
values (1, 1, 10, 1);






-- This should work fine
execute Sp_Student_Enter_Exam @StudentId = 1, @ExamId = 1; -- First time entry

-- This should throw an error because you already entered
execute Sp_Student_Enter_Exam @StudentId = 1, @ExamId = 1; -- Re-entering same exam

-- This should throw an error because exam not found
execute Sp_Student_Enter_Exam @StudentId = 1, @ExamId = 999; -- Non-existing exam

-- This should throw an error because exam not started yet
select * from Student_Exam where student_id = 1; -- Check existing records