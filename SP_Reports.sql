-----------Reports Stored Procedures-------------


------Student's Info by Department Id-------

create proc SP_Students_in_Department @track_id int
as
begin
	declare @id int
	select @id=track_id
	from Tracks
	where track_id=@track_id
	if @id is null 
		begin 
		print'Track not found '
		return;
		end 
	select *
	from Students
	where track_id=@track_id
end

------Student's Grades in all Courses-------

create proc SP_Student_Grades_All_Courses @Stu_id int
as
begin
	declare @id int
	select @id=student_id
	from Student_Course_Enrollment
	where student_id=@Stu_id
	if @id is null 
		begin 
		print'Student not found '
		return;
		end 
	select *
	from Student_Course_Enrollment
	where student_id=@Stu_id
end

------Courses Teached by an Instructor and number of Students in each-------

create proc SP_Instructor_Courses @inst_id int
	as
begin
	declare @id int
	select @id=instructor_id
	from Instructors
	where instructor_id=@inst_id
	if @id is null 
		begin 
		print'Instructor not found '
		return;
		end
	select C.course_name, COUNT(student_id) as [Number of Students]
	from Courses C left join Student_Course_Enrollment SC
	on C.course_id= SC.course_id 
	where C.instructor_id=@inst_id
	group by C.course_id, C.course_name
end

------Course's Topics-------

create proc SP_Course_Topics @crs_id int
	as
begin
	declare @id int
	select @id=course_id
	from Courses
	where course_id=@crs_id
	if @id is null 
		begin 
		print'Course not found '
		return;
		end
	select topic_id,topic_name
	from Course_Topics
	where course_id=@crs_id
end


------Exam questions and Choices-------

create proc SP_Exam_Questions_Choices @exam_id int
	as
begin
	declare @id int
	select @id=exam_id
	from Exams
	where exam_id=@exam_id
	if @id is null 
		begin 
		print'Exam not found '
		return;
		end
	SELECT Q.question_id, Q.question_text, Q.question_type, STRING_AGG(C.choice_text, ' - - ') AS choices
	FROM Exam_Questions EQ, Questions Q, Answer_Choices C
	WHERE EQ.question_id=Q.question_id and C.question_id=Q.question_id and EQ.exam_id = @exam_id
	GROUP BY Q.question_id, Q.question_text, Q.question_type;
end

------Student Answers in an Exam-------

create proc SP_Student_Exam_Answers @exam_id int, @stu_id int
	as
begin
	declare @I_id int, @S_id int
	select @I_id=exam_id
	from Exams
	where exam_id=@exam_id

	select @S_id=student_id
	from Students
	where student_id=@stu_id

	if @I_id is null 
		begin 
		print'Exam not found '
		return;
		end
	
	if @S_id is null 
		begin 
		print'Student not found '
		return;
		end

	SELECT Q.question_id, Q.question_text, Q.question_type, C.choice_text as [Student's Answer]
	FROM Exam_Questions EQ, Questions Q, Answer_Choices C, Student_Exam_Answers SEA
	WHERE EQ.question_id=Q.question_id and Q.question_id=C.question_id and C.choice_id=SEA.selected_choice_id and EQ.exam_id = @exam_id and SEA.student_id=@stu_id
end
