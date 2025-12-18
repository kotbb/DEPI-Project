
CREATE TABLE [Role] (
  [role_id] int PRIMARY KEY IDENTITY(1, 1),
  [role_name] nvarchar(60) NOT NULL
);
GO

CREATE TABLE [User] (
  [user_id] int PRIMARY KEY IDENTITY(1, 1),
  [email] nvarchar(60) UNIQUE NOT NULL,
  [password] nvarchar(60) NOT NULL,
  [role_id] int NOT NULL
);
GO

CREATE TABLE [Student] (
  [student_id] int PRIMARY KEY,
  [f_name] nvarchar(60) NOT NULL,
  [l_name] nvarchar(60) NOT NULL,
  [date_of_birth] date,
  [address] nvarchar(100),
  [gender] nchar(1), 
  [track_id] int,
  
  CONSTRAINT CHK_Student_Gender CHECK (gender IN ('M', 'F')) 
);
GO

CREATE TABLE [Instructor] (
  [instructor_id] int PRIMARY KEY,
  [instructor_name] nvarchar(60) NOT NULL,
  [hire_date] date
);
GO

CREATE TABLE [Training_Manager] (
  [manager_id] int PRIMARY KEY,
  [manager_name] nvarchar(60) NOT NULL
);
GO

CREATE TABLE [Branch] (
  [branch_id] int PRIMARY KEY IDENTITY(1, 1),
  [branch_name] nvarchar(60) NOT NULL
);
GO

CREATE TABLE [Track] (
  [track_id] int PRIMARY KEY IDENTITY(1, 1),
  [track_name] nvarchar(60) NOT NULL,
  [branch_id] int NOT NULL
);
GO

CREATE TABLE [Course] (
  [course_id] int PRIMARY KEY IDENTITY(1, 1),
  [course_name] nvarchar(60) NOT NULL,
  [description] nvarchar(200),
  [min_degree] int,
  [max_degree] int,

  CONSTRAINT CHK_Course_Degrees CHECK (max_degree >= min_degree)
);
GO

CREATE TABLE [Instructor_Course] (
  [instructor_id] int,
  [course_id] int,
  [year] int,
  PRIMARY KEY ([instructor_id], [course_id], [year])
);
GO

CREATE TABLE [Question] (
  [question_id] int PRIMARY KEY IDENTITY(1, 1),
  [course_id] int,
  [question_text] nvarchar(MAX) NOT NULL, 
  [question_type] nvarchar(20) NOT NULL,
  [correct_answer] nvarchar(255),
  
  
  CONSTRAINT CHK_Question_Type CHECK (question_type IN ('MCQ', 'TF'))
);
GO

CREATE TABLE [Question_MC] (
  [question_id] int PRIMARY KEY,
  [choice1] nvarchar(60) NOT NULL,
  [choice2] nvarchar(60) NOT NULL,
  [choice3] nvarchar(60) NOT NULL,
  [choice4] nvarchar(60) NOT NULL
);
GO

CREATE TABLE [Exam] (
  [exam_id] int PRIMARY KEY IDENTITY(1, 1),
  [course_id] int,
  [instructor_id] int,
  [exam_type] nvarchar(20) NOT NULL,
  [start_time] datetime,
  [end_time] datetime,
  [total_time] int,
  [year] int,
  
  CONSTRAINT CHK_Exam_Type CHECK (exam_type IN ('Exam', 'Corrective')),
  CONSTRAINT CHK_Exam_Time CHECK (end_time > start_time),
  CONSTRAINT CHK_Exam_Year_4Digits CHECK ([year] >= 1000 AND [year] <= 9999)
);
GO

CREATE TABLE [Exam_Options] (
  [exam_id] int,
  [option_name] nvarchar(120),
  PRIMARY KEY ([exam_id], [option_name])
);
GO

CREATE TABLE [Exam_Question] (
  [exam_id] int,
  [question_id] int,
  [question_degree] int NOT NULL CHECK (question_degree > 0),
  [sequence_number] int NOT NULL CHECK (sequence_number > 0),
  PRIMARY KEY ([exam_id], [question_id])
);
GO

CREATE TABLE [Student_Exam] (
  [student_id] int,
  [exam_id] int,
  [start_time] datetime,
  [submit_time] datetime,
  [is_reviewed] bit DEFAULT 0,
  PRIMARY KEY ([student_id], [exam_id])
);
GO

-- 3. Add Foreign Key Relationships

ALTER TABLE [User] ADD CONSTRAINT FK_User_Role 
FOREIGN KEY ([role_id]) REFERENCES [Role] ([role_id]);
GO

ALTER TABLE [Student] ADD CONSTRAINT FK_Student_User 
FOREIGN KEY ([student_id]) REFERENCES [User] ([user_id]);
GO

ALTER TABLE [Student] ADD CONSTRAINT FK_Student_Track 
FOREIGN KEY ([track_id]) REFERENCES [Track] ([track_id]);
GO

ALTER TABLE [Instructor] ADD CONSTRAINT FK_Instructor_User 
FOREIGN KEY ([instructor_id]) REFERENCES [User] ([user_id]);
GO

ALTER TABLE [Training_Manager] ADD CONSTRAINT FK_Manager_User 
FOREIGN KEY ([manager_id]) REFERENCES [User] ([user_id]);
GO

ALTER TABLE [Track] ADD CONSTRAINT FK_Track_Branch 
FOREIGN KEY ([branch_id]) REFERENCES [Branch] ([branch_id]);
GO

ALTER TABLE [Instructor_Course] ADD CONSTRAINT FK_InstCourse_Instructor 
FOREIGN KEY ([instructor_id]) REFERENCES [Instructor] ([instructor_id]);
GO

ALTER TABLE [Instructor_Course] ADD CONSTRAINT FK_InstCourse_Course 
FOREIGN KEY ([course_id]) REFERENCES [Course] ([course_id]);
GO

ALTER TABLE [Question] ADD CONSTRAINT FK_Question_Course 
FOREIGN KEY ([course_id]) REFERENCES [Course] ([course_id]);
GO

ALTER TABLE [Question_MC] ADD CONSTRAINT FK_QuestionMC_Question 
FOREIGN KEY ([question_id]) REFERENCES [Question] ([question_id]);
GO

ALTER TABLE [Exam] ADD CONSTRAINT FK_Exam_Course 
FOREIGN KEY ([course_id]) REFERENCES [Course] ([course_id]);
GO

ALTER TABLE [Exam] ADD CONSTRAINT FK_Exam_Instructor 
FOREIGN KEY ([instructor_id]) REFERENCES [Instructor] ([instructor_id]);
GO

ALTER TABLE [Exam_Options] ADD CONSTRAINT FK_ExamOptions_Exam 
FOREIGN KEY ([exam_id]) REFERENCES [Exam] ([exam_id]);
GO

ALTER TABLE [Exam_Question] ADD CONSTRAINT FK_ExamQuestion_Exam 
FOREIGN KEY ([exam_id]) REFERENCES [Exam] ([exam_id]);
GO

ALTER TABLE [Exam_Question] ADD CONSTRAINT FK_ExamQuestion_Question 
FOREIGN KEY ([question_id]) REFERENCES [Question] ([question_id]);
GO

ALTER TABLE [Student_Exam] ADD CONSTRAINT FK_StudentExam_Student 
FOREIGN KEY ([student_id]) REFERENCES [Student] ([student_id]);
GO

ALTER TABLE [Student_Exam] ADD CONSTRAINT FK_StudentExam_Exam 
FOREIGN KEY ([exam_id]) REFERENCES [Exam] ([exam_id]);
GO

ALTER TABLE [Exam] ADD CONSTRAINT CHK_Exam_Year_4Digits
CHECK ([year] >= 1000 AND [year] <= 9999)

ALTER TABLE [Instructor_Course] ADD CONSTRAINT CHK_InstCourse_Year 
CHECK ([year] >= 1000 AND [year] <= 9999)

ALTER TABLE [Student_Exam] ADD CONSTRAINT CHK_StudentExam_Time 
CHECK ([submit_time] > [start_time]);

ALTER TABLE [Course] ADD CONSTRAINT CHK_Course_Positive_Degrees 
CHECK (min_degree >= 0);

ALTER TABLE [Exam] ADD CONSTRAINT CHK_Exam_TotalTime 
CHECK (total_time > 0);