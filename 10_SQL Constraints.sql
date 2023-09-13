SELECT * FROM 

[dbo].[Departments]

BEGIN TRAN

DELETE FROM [dbo].[Departments]
	WHERE [dept_name] = 'Customer Service'

	ROLLBACK TRAN

SELECT * FROM [dbo].[Current_Personnel]
WHERE [sid_Department] = '9'


--Exercise 17.3 The HR manager has request the following new employee is added to the Employees table
--EmpNo = 500000, birthdate = '1970-10-04', lastname = 'Jones', gender = 'M'

--Note: The HR manager did not specify the FirstName and HireDate as she was in hurry

--As such you have decided to specify a DEFAULT constraint to place a value in these columns you have decided the DEFAULT for FirstName = 'Not Provided'
--and the HireDate = 'Today'

--Tip: Ignore sid_Employee in your INSERT as this will be created by the system
--Ignore the sid_date value for now unless see below.

--Extracurricular: If you like to practice and who doesn't then update the sid_Date value by building a JOIN in the INSERT as we have seen in 
--Advanced Inserts to the calendar table for todays date and share your code with the class cohort in lecture solution Q&A, showcase your skills

ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT first_name DEFAULT 'Not Provided' FOR [first_name] 


ALTER TABLE [dbo].[Employees]
ADD CONSTRAINT hire_date DEFAULT getdate() FOR[hire_date] 

select * From [dbo].[Calendar] WHERE CAL_DATE = CONVERT(date, GETDATE())


select * from [dbo].[Employees]

INSERT INTO EMPLOYEES([emp_no],[birth_date],[last_name],[gender],[sid_Date])
SELECT '500000',
	CAST('1970-10-04' AS DATE) ,
	CAST('Jones' AS VARCHAR(16)),
	'M',
	(SELECT [sid_Date] FROM [dbo].[Calendar] WHERE CAL_DATE = CONVERT(date, GETDATE()))

	SELECT DATEPART(DD,GETDATE())

SELECT * FROM [dbo].[Employees]
WHERE [emp_no] = 500000

--Exercise 17.4 The data manager has requested there is a business rule applied to the table CurrentPersonnel to ensure the Current Salary doesn't exceed $200000

--The new employee 300025 should be added to the Current Personnel with the following detail
--Emp No = 500000, Current Salary = 150000, sid_Department = 12

--Outcome?

ALTER TABLE [dbo].[Current_Personnel]
ADD CONSTRAINT chk_CHECK CHECK ([current_salary] <=200000)

INSERT INTO [dbo].[Current_Personnel] ([emp_no],[current_salary],[sid_Department])
VALUES(300025,150000,12)