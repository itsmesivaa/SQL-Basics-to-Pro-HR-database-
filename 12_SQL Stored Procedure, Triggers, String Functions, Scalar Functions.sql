--SQL Variables

--Exercise 19.1 - Create 2 local variables
--	1: Country - Datatype varchar(50) value = 'Australia'
--	2: Gender - Datatype char(1)
--	SET value = 'M'

DECLARE @COUNTRY VARCHAR(50) = 'Australia'
DECLARE @GENDER CHAR(1)
SET @GENDER = 'M'
SELECT @COUNTRY AS 'Country', @GENDER as 'Gender'

--Exercise 19.2 Refer to your exercise 18.1(Section 18) and create a stored procedure and adapt the code from that exercise to accept parameter
--Do not use direct value inputs! Use variables instead
--Test the stored procedures by executing it

--Exercise 18.1 The HR manager requires insight to the Male employees working in the United States by City and State
GO;
--Tip use your knowlege gained for Joins
CREATE PROCEDURE EMPLOYEEDETAILS_CITYWISE (@GENDER VARCHAR(10),@COUNTRY VARCHAR(20))
AS
SELECT 
	COUNT(EMP.[emp_no]) AS Emp_Count,
	[City] AS City,
	[StateProvinceName] AS [State]
FROM
	[dbo].[Employees] EMP
LEFT JOIN [dbo].[Gender] GEN 
ON 
	EMP.[gender] = GEN.[gender]
INNER JOIN [dbo].[Employee_Location] EMPL
ON EMP.[emp_no] = EMPL.[emp_no]
WHERE 
	GEN.[gender_name] = @GENDER
AND [CountryRegionName] = @COUNTRY
GROUP BY 
	[City],
	[StateProvinceName]
ORDER BY 1 DESC,2 DESC,3 DESC
GO;

DECLARE @GENDER_INP AS VARCHAR(10)
DECLARE @COUNTRY_INP AS VARCHAR(20)
SET @GENDER_INP = 'FEMALE'
SET @COUNTRY_INP = 'australia'
EXEC EMPLOYEEDETAILS_CITYWISE @GENDER = @GENDER_INP, @COUNTRY = @COUNTRY_INP


/*
Note: The SQL Schema is defined as logical collection of database objects.

CREATE SCHEMA SCHEMA_NAME AUTHORIZATION database_user
	CREATE TABLE (...)
	GRANT SELECT ON SCHEMA:: SCHEMA_NAME TO USERNAME
	DENY SELECT ON SCHEMA:: SCHEMA_NAME TO USERNAME
GO;

Security
---------
	User - Staff_Audit
	User - Staff_Biz
*/
GO;


CREATE SCHEMA SECURE_AUDIT AUTHORIZATION DBO

go;

CREATE TABLE EMPLOYEES_AUDIT ([sid_Employee] INT NOT NULL)

GRANT SELECT ON SCHEMA:: SECURE_AUDIT TO Staff_Audit
DENY SELECT ON SCHEMA:: SECURE_AUDIT TO Staff_Biz

--Step1: Modify the Employees_Audit table ready to receive event rows from DML actions on Employees table

ALTER TABLE [SECURE_AUDIT].[EMPLOYEES_AUDIT]
ADD	[emp_no] INT NOT NULL,
	[birth_date] DATE NOT NULL,
	[first_name] VARCHAR(14) NOT NULL,
	[last_name] VARCHAR(16) NOT NULL,
	[gender] CHAR(1) NOT NULL,
	[sid_Date] INT,
	[hire_date] DATE NOT NULL,
	/*
	The below columns are audit tracking details to use when/if an investigation into changes are required or for other analysis etc
	*/
	[Operation] CHAR(3) NOT NULL,		--What action is recorded INS, UPD, DEL
	[Username] VARCHAR(16) NOT NULL,	--Populated by security function Username() in the trigger
	[AuditDate] DATETIME NOT NULL,		--When Date & Time the action took place
	[AuditID] INT IDENTITY,				--An ID for tracking a sequence of events
	CHECK([Operation] = 'UPD' OR [Operation] = 'INS' OR [Operation] = 'DEL');	--Ensure correct value entered via CHECK constraint
	
GO;

CREATE TRIGGER dbo.trg_Employees_Ins_Del_Audit
	ON	[dbo].[Employees]
AFTER INSERT, DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [SECURE_AUDIT].[EMPLOYEES_AUDIT]
		(	[sid_Employee],
			[emp_no],
			[birth_date],
			[first_name],
			[last_name],
			[gender],
			[sid_Date],
			[hire_date],
			[Operation],
			[Username],
			[AuditDate]
		)
	SELECT [sid_Employee],
			[emp_no],
			[birth_date],
			[first_name],
			[last_name],
			[gender],
			[sid_Date],
			[hire_date],
			'INS',
			(SELECT USER_NAME()),
			GETDATE()
	FROM INSERTED AS I

	UNION ALL

	SELECT [sid_Employee],
			[emp_no],
			[birth_date],
			[first_name],
			[last_name],
			[gender],
			[sid_Date],
			[hire_date],
			'DEL',
			(SELECT USER_NAME()),
			GETDATE()
	FROM DELETED AS D

END;
		

GO;

CREATE TRIGGER trg_Employees_Upd_Audit1
ON [dbo].[Employees]
AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [SECURE_AUDIT].[EMPLOYEES_AUDIT]
		(	[sid_Employee],
			[emp_no],
			[birth_date],
			[first_name],
			[last_name],
			[gender],
			[sid_Date],
			[hire_date],
			[Operation],
			[Username],
			[AuditDate]
		)
	SELECT [sid_Employee],
		[emp_no],
		[birth_date],
		[first_name],
		[last_name],
		[gender],
		[sid_Date],
		[hire_date],
		'UPD',
		(SELECT USER_NAME()),
		GETDATE()
	FROM DELETED AS D
		
		UNION ALL

	SELECT [sid_Employee],
			[emp_no],
			[birth_date],
			[first_name],
			[last_name],
			[gender],
			[sid_Date],
			[hire_date],
			'UPD',
			(SELECT USER_NAME()),
			GETDATE()
	FROM INSERTED AS I

END;

Go;

--Exercise 19.3  --Senior auditor has requested an Audit Tracking table be constructed to track if updates are performed on the Current Personnel table

--Change to track is Updates to Current_Salary
--Attributes to include in the CUrrent_Personnel_Audit table are...

--	sid_Employee, emp_no, current_salary, the tracking attributes as shown in previous lecture

--Tip: Right mouse click on Current Personnel to generate a create table script for the basis of CREATE table code

--Make sure you replace the dbo. schema with SECURE_AUDIT schema in the create table code!

--Creating a audit table under SECURE_AUDIT schema

CREATE TABLE SECURE_AUDIT.[Current_Personnel_Audit] 
		(	[sid_Employee] INT NULL,
			[emp_no] INT NOT NULL,
			[current_salary] INT NOT NULL,
			[current_location] NVARCHAR(30),
			[sid_Department] INT,
			[sid_Location] INT,
			[sid_position] INT,
/*	The below columns are audit tracking details to use when/if an investigation into changes are required or for other analysis etc*/			
			[Operation] CHAR(3) NOT NULL,		--What action is recorded INS, UPD, DEL
			[Username] VARCHAR(16) NOT NULL,	--Populated by security function Username() in the trigger
			[AuditDate] DATETIME NOT NULL,		--When Date & Time the action took place
			[AuditID] INT IDENTITY,				--An ID for tracking a sequence of events
			CHECK([Operation] = 'UPD' OR [Operation] = 'INS' OR [Operation] = 'DEL')	--Ensure correct value entered via CHECK constraint
		)

GO;

--Creating a Audit trigger for [dbo].[Current_Personnel] table whenever an DML actions happens.

CREATE TRIGGER Current_Personnel_Ins_Del_Audit
ON [dbo].[Current_Personnel]
AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO SECURE_AUDIT.[Current_Personnel_Audit] 
		(	[sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			[Operation],
			[Username],
			[AuditDate]
		)
	SELECT [sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			'INS',
			(SELECT USER_NAME()),
			GETDATE()
	FROM INSERTED AS I

	UNION ALL

	SELECT [sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			'DEL',
			(SELECT USER_NAME()),
			GETDATE()
	FROM DELETED AS D
END


GO;

CREATE TRIGGER Current_Personnel_Upd_Audit
ON [dbo].[Current_Personnel]
AFTER UPDATE
AS
BEGIN
SET NOCOUNT ON;
	INSERT INTO SECURE_AUDIT.[Current_Personnel_Audit] 
		(	[sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			[Operation],
			[Username],
			[AuditDate]
		)
	SELECT [sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			'UPD',
			(SELECT USER_NAME()),
			GETDATE()
	FROM DELETED AS d

	UNION ALL

	SELECT [sid_Employee],
			[emp_no],
			[current_salary],
			[current_location],
			[sid_Department],
			[sid_Location],
			[sid_position],
			'UPD',
			(SELECT USER_NAME()),
			GETDATE()
	FROM INSERTED AS I
END

SELECT * fROM SECURE_AUDIT.[Current_Personnel_Audit] 

--String Functions LEN(), LEFT(), Charindex(), REPLACE()
--Exercise 19.4 The team leader has requested a udf to be created that calculates the number of years the employee has worked for the company

--Hint: Employee Hire date
GO;
CREATE FUNCTION dbo.EmpWorkYears(@Hire_date date)
	RETURNS INT
	AS
	BEGIN
		RETURN(DATEDIFF(YEAR,@Hire_date,GETDATE())) 
	END

GO;

SELECT 
	[emp_no] AS Employee# ,
	[hire_date] AS HireDate,
	dbo.EmpWorkYears([hire_date]) AS NumberofYears	--Calling the User defined functions to return no of years... 
FROM
	[dbo].[Employees]
ORDER BY 3 DESC

--Exercise 19.5 
GO;
CREATE FUNCTION udf_emp_city_gender(@countryregionname nvarchar(50),@gender char(3))
	RETURNS TABLE
	AS
	
	RETURN(SELECT
	  city,
	  stateprovincename,
	  COUNT(e1.sid_employee) AS Emp_count
	FROM Employee_Location e1
	INNER JOIN Employees emp
	  ON e1.sid_Employee = emp.sid_Employee
	WHERE countryregionname = @countryregionname
	AND emp.gender = @gender
	GROUP BY city,
			 stateprovincename)

GO;

select * from dbo.udf_emp_city_gender('France','M') 