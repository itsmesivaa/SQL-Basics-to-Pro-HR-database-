USE [Human_Resources];

--INNER JOINs
--Exercise 12.1 The CEO is looking at the position history of the managers. Thus requires an ordered list of managers that shows the date of start and to date of their position.
--The list should include emp no,first name, last name, position from date and position to date
--The list should be ordered by the position from date

--But the CEO has subsequently asked for the time in months they have been in the job
--Hint: Use Datediff() for months in job(We covered this in Chapter 10)
SELECT 
	EPH.[emp_no] AS 'Employee#',
	EMP.[first_name] AS 'First_Name',
	EMP.[last_name] AS 'Last_Name',
	EPH.[position] AS 'Position',
	EPH.[pos_from_date] AS 'Position_From_Date',
	EPH.[pos_to_date] AS 'Position_To_Date',
	EMP.[hire_date] AS 'Hire_Date',
	DATEDIFF(MONTH,EPH.[pos_from_date],EPH.[pos_to_date]) AS 'Time_In_Months'
FROM 
	[dbo].[Managers] MGR 
INNER JOIN 
	[dbo].[Employee_Position_History] EPH
ON (MGR.[sid_Employee] = EPH.[sid_Employee])
INNER JOIN
	[dbo].[Employees] EMP
ON (EPH.[emp_no] = EMP.[emp_no])
ORDER BY EMP.[emp_no],EPH.[pos_from_date]

--************************************************************************************************************************************

--We have been tasked with a request to validate the employee locations have the correct postal code assigned.
--This is a validation against the Geography table as it is the source of truth for mapping(GEO) and location tracking for our employees!
--The task is a prelude to the visual team building a heat map (GEO) to show where the employees are concentrated geographically.
--Note: That we nust be cognizant of the data model to ensure the query does not inadvertently exclude data during our query tasks.

SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[birth_date] AS 'Birthday',
	EMP.[first_name] AS 'FirstName',
	EMP.[last_name] AS 'LastName',
	EMP.[gender] AS 'Gender',
	EMPL.[sid_Location] AS 'Location',
	EMPL.[City] AS 'City',
	EMPL.[StateProvinceName] AS 'StateProvince',
	EMPL.[PostalCode] AS 'PostalCode',
	EMPL.[CountryRegionName] AS 'CountryRegion',
	GEO.[PostalCode] AS 'GEOPostalCode'
FROM
	[dbo].[Employees] EMP 
INNER JOIN 
	[dbo].[Employee_Location] EMPL
ON (EMP.[emp_no] = EMPL.[emp_no])
LEFT JOIN
[dbo].[Geography] GEO
ON 
	EMPL.[PostalCode] = GEO.[PostalCode]
	AND
	EMPL.[CountryRegionName] = GEO.[CountryRegionName]
ORDER BY GEO.[PostalCode]

--Exercise 12.2 The HR manager is looking at Employee movement through departments and has requested a 
--data validation check should be performed on the movements data to ensure the recorded department is correct.

--A list of incorrect department number values is required, the list should reveal emp no, first name, last name, department number currently recorded for the employee
SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[first_name] AS 'First_Name',
	EMP.[last_name] AS 'Last_Name',
	EMH.[dept_no] AS 'Dept_No'
FROM
	[dbo].[Employees] EMP
INNER JOIN
	[dbo].[Employee_Movements_History] EMH
ON EMP.[sid_Employee] = EMH.[sid_Employee]
LEFT JOIN
	[dbo].[Departments] DPT
ON EMH.[dept_no] = DPT.[dept_no]
WHERE DPT.[dept_no] IS NULL


--Exercise 12.3 The hiring manager has requested an ordered list of the top 10,000 employees detailing employees hired on the same date as well as how many years have been with the company.

--Include: Create a full name colulmn (i.e., First and last)

--Tip: Ensure the Top(n) is used otherwise your query will take a very long time.
-- If you find that you have not used the Top(n) and query will not complete you can cease the query by clicking the cancel executing query button (next to execute button)

SELECT TOP 10000 
CONCAT(e1.[first_name],' ',e1.[last_name]) AS 'e1EmployeeName',
e1.[hire_date] AS 'E1HireDate',
DATEDIFF(YEAR,e1.[hire_date],GETDATE()) AS 'e1NumberofYears',
CONCAT(e2.[first_name],' ',e2.[last_name]) AS 'e2EmployeeName',
e2.[hire_date] AS 'E2HireDate',
DATEDIFF(YEAR,e2.[hire_date],GETDATE()) AS 'e2NumberofYears'
FROM 
	[dbo].[Employees](NOLOCK)  e1 
LEFT JOIN
	[dbo].[Employees](NOLOCK) e2
ON 
	e1.[emp_no] <> e2.[emp_no]
AND
	e1.[hire_date] = e2.[hire_date]
ORDER BY e1.emp_no