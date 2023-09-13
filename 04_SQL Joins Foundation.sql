--Joins

USE [Human_Resources];
GO
--Inner Joins

SELECT * FROM [dbo].[Employees]

SELECT * FROM [dbo].[Gender]

--Common columns in both tables were [gender]

SELECT 
	[emp_no] AS 'Employee#',
	[birth_date] AS 'BirthDate',
	CONCAT([first_name], ' ',[last_name]) AS 'EmployeeName',
	G.[gender_name] AS 'GenderType'
FROM [dbo].[Employees] EMP
INNER JOIN
	[dbo].[Gender] G
ON
	EMP.gender = G.gender

--Exercise 11.1 The company CEO has requested an ordered list of employees that are managers 
--i.e.,Hold a management position she requires the emp no, Firstname, Lastname, Position and the Start Date, ordered by emp no
--Hint: Understand where you are going to source the data from in the data base review the 2 tables to establish which column you are going to use for the join.
--Exercise: Create an ordered list of employees that are managers i.e., Hold a management position, Include emp no, First name, Lastname, position and the start date, ordered by emp no

--My Query
SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[first_name] AS 'EmployeeFirstName',
	EMP.[last_name] AS 'EmployeeLastName',
	EMPH.[position] AS 'Position',
	EMPH.[pos_from_date] AS 'StartDate'
FROM 
	[dbo].[Employees] EMP 
INNER JOIN
	[dbo].[Employee_Position_History] EMPH 
ON	
	EMP.[emp_no] = EMPH.[emp_no]
WHERE EMPH.[position] = 'Manager'
ORDER BY
	EMP.[emp_no]


--Actual solution in exercise

SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[first_name] AS 'EmployeeFirstName',
	EMP.[last_name] AS 'EmployeeLastName',
	MGR.[position] AS 'Position',
	MGR.[from_date] AS 'StartDate'
FROM 
	[dbo].[Employees] EMP 
INNER JOIN
	[dbo].[Managers] MGR
ON	
	EMP.[sid_Employee]= MGR.[sid_Employee]
WHERE MGR.[position] = 'Manager'
ORDER BY
	EMP.[emp_no]


select distinct position from [Employee_Position_History]

select * From Managers order by position

--LEFT JOIN

SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[first_name] AS 'EmployeeFirstName',
	EMP.[last_name] AS 'EmployeeLastName',
	MGR.[position] AS 'Position',
	MGR.[from_date] AS 'StartDate'
FROM 
	[dbo].[Employees] EMP 
LEFT JOIN
	[dbo].[Managers] MGR
ON	
	EMP.[sid_Employee]= MGR.[sid_Employee]
WHERE MGR.[position] = 'Staff'
ORDER BY
	EMP.[emp_no]


	select distinct position from Managers

--LEFT JOIN

--Exercise 11.2 The personnel manager requires a list of all current employees (Current_Personnel) including emp no, firstname, lastname, currentsalary, currentlocation 
--a special request has been made to include a status to show the employee is 'not currently employed' otherwise show the status as 'Currently Employed'

--Hint: Use your knowledge from previous lectures by combining the below...

--	a.The CASE statement
--	b.IS NULL operator
--	c.AND operator
--The column name for status should be anything you think of but not status on its own as it is a keyword as previously discussed we try not to use keywords in column names.

SELECT 
	EMP.[sid_Employee] AS 'EMP_SIDEMPLOYEE',
	EMP.[emp_no] AS 'EMP_Employee#',
	CP.[sid_Employee] AS 'CP_SIDEMPLOYEE',
	CP.[emp_no] AS 'CP_Employee#',
	EMP.[first_name] AS 'FirstName',
	EMP.[last_name] AS 'LastName',
	CP.[current_salary] AS 'CurrentSalary',
	CP.[current_location] AS 'CurrentLocation',
	CASE 
		WHEN (CP.[emp_no] IS NULL AND CP.[sid_Employee] IS NULL) THEN 'Not Currently Employed'
		WHEN (CP.[emp_no] IS NOT NULL AND CP.[sid_Employee] IS NOT NULL) THEN 'Currently Employed'
	END AS 'Status'
FROM
	[dbo].[Employees] EMP
LEFT JOIN 
	[dbo].[Current_Personnel] CP
ON 
	CP.sid_Employee = EMP.[sid_Employee]	--Equating here with SID_Employee to pull matching records
AND 
	CP.[emp_no] = EMP.[emp_no]	--Equating here with emp_no to pull matching records
ORDER BY current_salary

SELECT 
	EMP.[sid_Employee] AS 'EMP_SIDEMPLOYEE',
	EMP.[emp_no] AS 'EMP_Employee#',
	CP.[sid_Employee] AS 'CP_SIDEMPLOYEE',
	CP.[emp_no] AS 'CP_Employee#',
	EMP.[first_name] AS 'FirstName',
	EMP.[last_name] AS 'LastName',
	CP.[current_salary] AS 'CurrentSalary',
	CP.[current_location] AS 'CurrentLocation',
	CASE 
		WHEN (CP.[emp_no] IS NULL AND CP.[sid_Employee] IS NULL) THEN 'Not Currently Employed'
		--WHEN (CP.[emp_no] IS NOT NULL AND CP.[sid_Employee] IS NOT NULL) THEN 'Currently Employed'
	ELSE 'Currently Employed'
	END AS 'Status'
FROM
	[dbo].[Employees] EMP
LEFT JOIN 
	[dbo].[Current_Personnel] CP
ON 
	CP.[sid_Employee] = EMP.[sid_Employee]	--Equating here with SID_Employee to pull matching records
AND 
	CP.[emp_no] = EMP.[emp_no]	--Equating here with emp_no to pull matching records
ORDER BY current_salary


--RIGHT JOIN EXERCISE
--Exercise 11.3 The CEO has a feeling we are under staffed in some departmnets and wants an ordered list (by EMP NO) of current employees showing Department Name (Departments), emp no and current location

--Once this list is generated the CEO will be shocked with the result and demand to know why it is so!


SELECT	
	dpt.[dept_name] AS 'Department_Name',
	CP.[emp_no] AS 'Employee#',
	CP.[current_location] AS 'Current_Location'
FROM 
	[dbo].[Current_Personnel] AS CP
RIGHT JOIN 
	[dbo].[Departments] AS DPT
ON
	DPT.[sid_Department] = CP.[sid_Department]
ORDER BY 
	CP.[emp_no]


--FULL JOIN
--Exercise 11.4 We are currently sitting with our client and query for profiling the Current Personnel against Geography is going well 
--but the client is frustrated that i'am scrolling around so much to demenstrated the issues in the data. 

-- He wants me to remove all the matched records from the row set and display the sorted T1 and T2 un-matched records which is the primary reason for this profiling.

SELECT 
	[emp_no] AS 'EMPLOYEE#',
	[City] AS 'City',
	[CountryRegionName] AS 'Country_Region_Name'
FROM 
	[dbo].[Current_Personnel] CP
FULL JOIN  
	[dbo].[Geography] GEO
ON
	CP.[sid_Location] = GEO.[sid_Location]
WHERE 
	CP.[emp_no] IS NULL 
OR 
	(GEO.[City] IS NULL
	AND
	GEO.[CountryRegionName] IS NULL)
	
ORDER BY 
	[emp_no],[City]