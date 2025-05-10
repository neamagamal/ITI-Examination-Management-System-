/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [course_id]
      ,[course_name]
      ,[course_duration]
      ,[instructor_id]
      ,[topic_id]
  FROM [ExaminationSystem].[dbo].[Courses]
