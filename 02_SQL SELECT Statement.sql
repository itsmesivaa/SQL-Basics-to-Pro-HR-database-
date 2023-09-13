use [Human_Resources];

--Exercise 9.1 Basic Select Display the values of Gender name from Gender table

SELECT 
	[gender_name]
FROM 
	[dbo].[Gender]



SELECT 
	[emp_no],
	[City],
	[StateProvinceName]
FROM 
	[dbo].[Employee_Location]
WHERE
	[PostalCode] = '98107'

--Exercise 9.2 Basic Select with WHERE Clause extract a set of data from employee position history that are engineers

SELECT 
	[emp_no],
	[pos_from_date],
	[pos_to_date]
FROM
	[dbo].[Employee_Position_History]
WHERE [position] = 'Engineer'


SELECT * FROM [dbo].[Position_Title]

SELECT * FROM [dbo].[Employee_Position_History] WHERE sid_Position = 2


--Exercise 9.3 Extract a set of data from the current personnel table listing employees that have a salary > $50,000 and are relocated in Beverly Hills (AND operator)

SELECT
[emp_no],
[current_salary],
[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	[current_salary] > 50000
AND
	[current_location] = 'Beverly Hills'

--Exercise 9.4 Our user wants to know how many (total count that is) employees have a salary < 45000 and are located in Springwood, Salem, Roncq she also wants to know what is the lowest salary for Springwood
--OR operator
SELECT 
[emp_no],
[current_salary],
[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	[current_salary] < 45000
AND
([current_location] = 'Salem'
OR
[current_location] = 'Springwood'
OR
[current_location] = 'Roncq')
ORDER BY [current_salary],[current_location]

--Exercise 9.5 IN or OR Operator

SELECT 
[emp_no],
[current_salary],
[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	[current_salary] < 45000
AND
	[current_location] IN ('Salem','Springwood','Roncq')
ORDER BY [current_salary],[current_location]



SELECT 
[emp_no],
[current_salary],
[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	--[current_salary] < 45000
--AND
	[current_location] IN (SELECT [City] FROM  [dbo].[Geography])
ORDER BY [current_salary],[current_location]


--Exercise 9.5 IN operator Task The HR manager has asked us to test the Current Personnel employees have a corresponding entry in the Employees table
--(Note: emp_no is common to these tables and Employees is the source of truth)

SELECT 
	[emp_no]
FROM	
	[dbo].[Current_Personnel]
WHERE 
	[emp_no] IN (SELECT [emp_no] FROM [dbo].[Employees])


--Exercise 9.6 BETWEEN operator
--Exercise 9.6 The HR manager has asked us to supply a list of Female Employees that were hired between 31st Dec 2014 and 31st Dec 2016
--The list should include: emp_no, Gender, First Name, Last Name, Hire Date and sorted by Last Name

SELECT 
	[emp_no],
[gender],
[first_name],
[last_name],
[hire_date]
FROM	
	[dbo].[Employees]
WHERE [gender] = 'F'
AND
[hire_date] BETWEEN '2014-12-31' AND '2016-12-31'
ORDER BY 
	[last_name]
	

--Exercise 9.7 NULL operator The Data Manager is executing a project to check the data integrity of our database 
--The task is to check the employee location tables does not have nulls where value is expected in the sid_employee column


SELECT 
	[emp_no]
FROM
	[dbo].[Employee_Location]
WHERE 
	[sid_Employee] IS NULL


--Exercise 9.8 The Data Analyst is searching for all males with a first name that begins with Elv

--List all the males in Employees with a first name beginning with 'Elv'

SELECT
	[emp_no],
	[first_name],
	[last_name],
	[gender]
FROM
	[dbo].[Employees]
WHERE 
	[gender] = 'M'
AND
	[first_name] LIKE 'Elv%'



SELECT
* 
FROM
	[dbo].[Employees]
WHERE 
	[gender] = 'M'
AND
	[first_name] LIKE 'Wil[a-s]%'


--Exercise 9.9 The Payroll Analyst requires a data set of all employees with a salary of 55000 to 60000 inclusive

SELECT
	[emp_no],
	[current_salary],
	[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	[current_salary] BETWEEN 55000 AND 60000
ORDER BY [current_salary]


SELECT
	[emp_no],
	[current_salary],
	[current_location]
FROM
	[dbo].[Current_Personnel]
WHERE 
	[current_salary] > =55000 
	AND 
	[current_salary] <=60000
ORDER BY [current_salary]

--Exercise 9.10 The HR manager requires a list of distinct First and Last names from the employees table orderd by First Name, Last Name

SELECT 
DISTINCT
	[first_name],
	[last_name]
FROM
	[dbo].[Employees]
ORDER BY 
	[first_name],
	[last_name]

--Alias name 

--Exercise 9.11 The Data visualisation analyst has requested a list of Cities and State Provinces are extracted from the Geography table, 
--the output name for State Province should be aliased to State and the output table aliased to dimGeo, the list should be ordered by Country

SELECT 
	[City],
	[StateProvinceName] AS 'State'
FROM
	[dbo].[Geography] AS dimGeo
ORDER BY [CountryRegionName]

--Exercise 9.12 The DBA has requested you test your query against the Salary History table, she says it takes many seconds and 
--requires that the query uses a reduced row set e.g. 50000 what times did you observe between the raw query and top n query?

SELECT 
	TOP 50000 [current_salary]
FROM

[dbo].[Salary_History]