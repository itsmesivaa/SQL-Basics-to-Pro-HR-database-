

--Exercise 10.1 Task Using CASE Statement

--The HR manager requires expansion of the previous salary status by adding 2 more conditions
--1. Salary between 30000 and 50000 will be Paid Junior
--2. Salary betweewn 50001 and 99999 will be Paid Senior

USE [Human_Resources];

SELECT 
	[emp_no],
	[current_salary],
CASE
	WHEN [current_salary] BETWEEN 30000 AND 50000 THEN 'Paid Junior'
	WHEN [current_salary] < 99999 THEN 'Paid Senior'
ELSE	
	'Not Specified'
END AS 'Previous_Salary_Status'
FROM
	[dbo].[Current_Personnel]
ORDER BY 
	[current_salary]

--Exercise 10.2 Task Using DATE Functions

--Exercise 10.2 The hiring manager has requested a list of employees from the employee table that was hired between 2013 and 2016 so she can conduct a review of hiring trends. The list should be ordered by year.

SELECT 
	[emp_no],
	[first_name],
	[last_name],
	[gender],
	[hire_date]
FROM
	[dbo].[Employees]
WHERE
	YEAR([hire_date]) BETWEEN 2013 AND 2016
ORDER BY 
	YEAR([hire_date]) DESC

--Exercise 10.3 Task Using DATEPART() Functions
--Exercise 10.3 The hiring manager is reviewing the Employee Position History and requires an ordered list of employees made up of emp_no, position, 
--pos_from_date, Year of Position, Week of Position.Sorted by Year and Week.

SET DATEFIRST 7

SELECT 
	[emp_no],
	[position],
	[pos_from_date] AS 'Position_From_Date',
	[pos_to_date] AS 'Position_To_date',
	DATEPART(YEAR,[pos_from_date]) AS 'Year_of_Position',
	DATEPART(WEEK,[pos_from_date]) AS 'Week_of_Position',
	DATENAME(DW,[pos_from_date]) AS 'Day_Name'
FROM
	[dbo].[Employee_Position_History]
ORDER BY 
	DATEPART(YEAR,[pos_from_date]),
	DATEPART(WEEK,[pos_from_date])

--Exercise 10.4 Task Using DATEDIFF() Functions
--Exercise 10.4 As the value of difference in Job Position Start & End in many record is 0 then HR manager has asked for a value to be added to another time in the job.

SELECT
	[emp_no],
	[position],
	[pos_from_date] AS 'Position_From_Date',
	[pos_to_date] AS 'Position_To_date',
	DATEDIFF(YEAR,[pos_from_date],[pos_to_date]) AS 'Number_of_Years',
	DATEDIFF(DAY,[pos_from_date],[pos_to_date]) AS 'Number_of_Days',
	DATEDIFF(Month,[pos_from_date],[pos_to_date]) AS 'Number_of_Months',
	DATEDIFF(QUARTER,[pos_from_date],[pos_to_date]) AS 'Number_of_Quarters',
	DATEDIFF(Week,[pos_from_date],[pos_to_date]) AS 'Number_of_Weeks'
FROM
	[dbo].[Employee_Position_History]

--Exercise 10.5 Tasks using DATEADD()
--The Payroll Analyst would like to see the payroll transactions for the months between Jan & Mar and the ordered list should include the Employee ID, Pay Amount, Pay Date, Next Pay Date, Previous Pay Date
--order by Previous Pay Date
--Only use DatePart() to test the months for extraction


--Monthly Payouts
SELECT 
[Pay_Amount],
[Pay_Date], 
DATEPART(MM,[Pay_Date]) AS Paydate_Month,
DATEADD(MM,-1,[Pay_Date]) AS Previous_Pay_Date,
DATEADD(MM,+1,[Pay_Date]) AS Next_Pay_Date,
DATENAME(MM,[Pay_Date]) AS Month_day
FROM
	[Payroll].[Employee_Payroll]
WHERE DATEPART(MM,[Pay_Date]) <= 3
ORDER BY Previous_Pay_Date

--Weekly Payout
SELECT 
[Pay_Amount],
[Pay_Date], 
DATEPART(MM,[Pay_Date]) AS Paydate_Month,
DATEADD(dd,-7,[Pay_Date]) AS Previous_Pay_WeekDate,
DATEADD(dd,7,[Pay_Date]) AS Next_Pay_WeekDate,
DATENAME(MM,[Pay_Date]) AS Month_day
FROM
	[Payroll].[Employee_Payroll]
WHERE DATEPART(MM,[Pay_Date]) <= 3
ORDER BY Previous_Pay_WeekDate


--Exercise 10.6 FORMAT() function


SELECT 
FORMAT([Pay_Amount],'C0','EN-US') AS CurrencyPay,
[Pay_Date], 
DATEPART(MM,[Pay_Date]) AS Paydate_Month,
DATEADD(dd,-7,[Pay_Date]) AS Previous_Pay_WeekDate,
DATEADD(dd,7,[Pay_Date]) AS Next_Pay_WeekDate,
DATENAME(MM,[Pay_Date]) AS Month_day
FROM
	[Payroll].[Employee_Payroll]
WHERE DATEPART(MM,[Pay_Date]) <= 3
ORDER BY Previous_Pay_WeekDate

--Exercise 10.6 The Payroll analyst has requested changes to the pay list generated in the last exercise and requires the following Pay_Amount to be UK Pounds, Pay_Date to be UK Date Format

-- The Changes should be applied to the Next Pay Date and Prev Pay Date
--To find locale for UK you will need to review the documentation via the link in this lecture resources

SELECT 
	[Pay_Amount] AS PayAmount,
	[Pay_Date] AS PayDate,
	FORMAT([Pay_Amount],'C0','en-gb') AS PayAmount_UK_Format,
	FORMAT([Pay_Date],'d','en-gb') AS PayDate_UK_Format,
	FORMAT(DATEADD(dd,7,[Pay_Date]),'d','en-gb') AS NextPayDate,
	FORMAT(DATEADD(dd,-7,[Pay_Date]),'d','en-gb') AS PreviousPayDate	
FROM 
	[Payroll].[Employee_Payroll]


--Exercise 10.7 The data viz team has been asked to provide a prototype to tell a brief story of employees e.g. 10 Employees 

--Use the Employees table as the data source and describe the employee with attributes including Name, Birthday, Gender how long ago they were hired to work here.

SELECT TOP 100
[first_name] AS First_Name,
[last_name] AS Last_Name,
[birth_date] AS Birthday,
[gender] AS Gender,
CONCAT('Employee# ',[emp_no], ' named ',[first_name],' ',[last_name],CASE WHEN [gender] = 'M' THEN ' MALE' WHEN [gender] = 'F' THEN ' FEMALE' ELSE 'NA' END,' who joined our company on ','"', 
		[hire_date],'"',' has been working in company for ',DATEDIFF(DD,[hire_date],GETDATE()),' days') AS EmpBio
FROM
	[dbo].[Employees]
ORDER BY
	DATEDIFF(DD,[hire_date],GETDATE()) DESC
