--Exercise 18.1 The HR manager requires insight to the Male employees working in the United States by City and State

--Tip use your knowlege gained for Joins

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
	GEN.[gender_name] = 'Male'
AND [CountryRegionName] = 'United States'
GROUP BY 
	[City],
	[StateProvinceName]
ORDER BY 1 DESC,2 DESC,3 DESC

SELECT DISTINCT [City], [StateProvinceName],[CountryRegionName] FROM [dbo].[Employee_Location]

--Exercise 18.2 The Data Architect would like to view the unique counts of departments in the Employee Movements History 
--compared to the department count in the departments table as he suspects dirty data exists

--Tip: 	a) A join is required.
--		b) The departments sid_Department count will behave not as you expect it to

SELECT 
	COUNT(DISTINCT EMH.[dept_no]),
	COUNT(DISTINCT DEPT.[dept_no])
	--EMH.[dept_no]
FROM 
[dbo].[Employee_Movements_History] EMH 
INNER JOIN [dbo].[Departments] DEPT
ON EMH.[sid_Department] = DEPT.[sid_Department]
--GROUP BY EMH.[dept_no]
--ORDER BY EMH.[dept_no]


select count([sid_Department]) from [dbo].[Departments]
select * from [dbo].[Departments]

--Exercise 18.3 The payroll manager has requested insight into the California (United States) Payroll for July, August, September that details Full Employee Name, Pay Amount in $

--Tip: The data in Employee Payroll is for the year 2019 hence no requirement to specify a year for these months.

--Pay Attention to the Group by Clause as it doesn't behave like the order by column reference


SELECT  
	emp.[first_name] + ' ' +emp.[last_name] AS 'EmployeeName',
	FORMAT(SUM(emp_pay.[Pay_Amount]),'C0','EN-US') AS 'Pay_Amount'

FROM 
	[dbo].[Employees] emp
INNER JOIN 
	[Payroll].[Employee_Payroll] emp_pay
ON
	emp.[sid_Employee] = emp_pay.[sid_Employee]
INNER JOIN [dbo].[Employee_Location] empl
--ON emp.[emp_no] = empl.[emp_no]
ON emp.[sid_Employee] = empl.[sid_Employee]
WHERE 
	DATEPART(M,[Pay_Date]) BETWEEN 7 AND 9
AND EMPL.[StateProvinceName] = 'CALIFORNIA'
GROUP BY 
	emp.[first_name] + ' ' +emp.[last_name] 
ORDER BY 1

	
SELECT * FROM [dbo].[Employee_Location]
WHERE CountryRegionName = 'United States'
AND StateProvinceName = 'California'


--Exercise 18.4 The Payroll Analyst has requested insight about the average salary across ALL Countries & States 
--Insight should be ordered by Country and Average Salary

SELECT 
FORMAT(AVG(CAST(cp.[current_salary] AS DECIMAL(18,2))),'C0') AS 'Average_Salary',
[CountryRegionName] AS 'Country',
[StateProvinceName] AS 'State'
FROM
	[dbo].[Current_Personnel] cp
INNER JOIN 
	[dbo].[Employee_Location] EMPL
ON 
	cp.[sid_Employee] = EMPL.[sid_Employee]
GROUP BY 
	[CountryRegionName],
	[StateProvinceName]
ORDER BY 
	[CountryRegionName],
	1

--Salary by Department wise
SELECT 
	DPT.[dept_name],
	FORMAT(SUM(EMP_PAY.[Pay_Amount]),'C0')
FROM 
[Payroll].[Employee_Payroll] EMP_PAY
INNER JOIN
[dbo].[Current_Personnel] CP
ON 
	EMP_PAY.[sid_Employee] = CP.[sid_Employee]
RIGHT JOIN
[dbo].[Departments] DPT 
ON
	CP.[sid_Department] = DPT.[sid_Department]
GROUP BY
	DPT.[dept_name]
ORDER BY 2 DESC


--Exercise 18.5 The CEO requires insight about historical salary range and movement for the managers of the organization this insight must include the employee full name 
--and ordered by the movement high to low.

--The CEO also requested an indicator be provided to class the movement into buckets i.e. also know as Discretization

--The rules for the buckets are <=3000 as LowGrowth
-- > 3000 and <=5000 as Medium Growth
-- > 5000 as Best Growth

--Tip: Joins are required ensure you are profiling which tables to use
--Case statement to test the range to arrive at the bucket(s) (Lecture 95 covered this topic)

select * from [dbo].[Employee_Movements_History]
select * from [dbo].[Current_Personnel]

SELECT 
	EMP.[emp_no] AS 'Employee#',
	EMP.[first_name] + ' ' + [last_name] AS 'Employee_Name',
	MIN(SH.[current_salary]) AS 'MINSalary',
	MAX(SH.[current_salary]) AS 'MAXSalary',
	(MAX(SH.[current_salary]) - MIN(SH.[current_salary])) AS 'Movement',
	CASE 
		WHEN (MAX(SH.[current_salary]) - MIN(SH.[current_salary])) <= 3000 THEN 'LowGrowth'
		WHEN (MAX(SH.[current_salary]) - MIN(SH.[current_salary])) <= 5000 THEN 'MediumGrowth'
		WHEN (MAX(SH.[current_salary]) - MIN(SH.[current_salary])) > 5000 THEN  'BestGrowth'
	END AS 'SalaryRange'
FROM
	[dbo].[Employees] EMP
INNER JOIN 
	[dbo].[Managers] MGR
ON
	EMP.[sid_Employee] = MGR.[sid_Employee]
INNER JOIN [dbo].[Salary_History] SH
ON
	EMP.[sid_Employee] = SH.[sid_Employee]
GROUP BY 
	EMP.[emp_no],
	EMP.[first_name] + ' ' + [last_name] 
ORDER BY 1
	
	select * From [dbo].[Salary_History]


--Exercise 18.6 As a part of data audit the managing auditor has requested a check of the Employees table to ensure no duplicates are present

SELECT 
 [sid_Employee],
 COUNT([sid_Employee])
FROM 
	[dbo].[Employees]
GROUP BY 
 [sid_Employee]
 HAVING COUNT([sid_Employee]) > 1

 SELECT 
 [emp_no],
 COUNT([emp_no])
FROM 
	[dbo].[Employees]
GROUP BY 
 [emp_no]
 HAVING COUNT([emp_no]) > 1