
DECLARE @MYTABLE TABLE (WEEKNUM INT, WEEKSTARTEDON DATE)

DECLARE @N AS INT = 1
DECLARE @FIRSTDATE AS DATE = '2018-12-31'

WHILE (@N>0)
BEGIN
	INSERT INTO @MYTABLE (WEEKNUM,WEEKSTARTEDON)
	SELECT @N,DATEADD(WEEK,@N,@FIRSTDATE)
	SET @N= @N+1
	SELECT @N
	IF(@N>52)
		BREAK;
END
SELECT * FROM @MYTABLE

SELECT * FROM [dbo].[Salary_History]
WHERE YEAR(sal_from_date) = 2016
AND YEAR(sal_to_date) = 2016
AND sid_Employee = 16577

/*--Exercise 20.1
Scenario The DA team leader has requested a TABLE function to be created

Requirements for the Table function...

1: A single date input param for MonthEnd e.g. 2016-1-31 Parameter name suggested e.g. @MonthEnd

2: A single column that is the Sum of Salary (in dollars) from the Salary history table, the Column Name suggested e.g. TotalSalary

3: The selection predication for the query...
	a) MonthEnd (as this is supplied by the caller) & you'll need to use EOMONTH() for the condition
The date field to test the month end must be the salary from date

	b) The year() of salary from date = 2016 and year() of salary to date = 2016	--We are only interested in 2016 overall i.e., Salary levels for 2016

Tip: Build up a query first of all then tackle the Table function then if anything doesn't work properly atleast you know its not the query component.
Hint: If your rowset matches the below then you are solving the requirement

*/
GO;

DECLARE @SALARYDETAILS AS TABLE (MONTHDETAILS DATE, TOTALSALARYPAID NVARCHAR(30))
DECLARE @MonthEnd AS DATE = '2016-1-31';
DECLARE @N AS INT = 1;

WHILE (@N >= MONTH(@MonthEnd))
BEGIN 
	INSERT INTO @SALARYDETAILS(MONTHDETAILS,TOTALSALARYPAID)
		SELECT 
			EOMONTH([sal_from_date]) AS MONTHENDED,
			CAST(FORMAT(SUM(CURRENT_SALARY) ,'C0') AS NVARCHAR) AS TOTALSALARY
		FROM 
			[dbo].[Salary_History]
		WHERE 
			(YEAR([sal_from_date]) = 2016 AND YEAR([sal_to_date]) = 2016)
		AND
			MONTH([sal_from_date]) = @N
		GROUP BY 	
			EOMONTH([sal_from_date])
		ORDER BY 1
	SET @N = @N+1
	IF @N > 12	--Validating @N to parse 12 months breaking this loop once December (12) reaches;
		BREAK;
END
SELECT * FROM @SALARYDETAILS


--Exercise EXISTS function
--Scenario: The company career strategy consultant has requested a list of employees who have held more that one position during their career with the company.

SELECT 
	EMP.[emp_no],
	EMP.[first_name],
	EMP.[last_name],
	EMP.[gender],
	EMP.[hire_date]
FROM
[dbo].[Employees] EMP
WHERE EXISTS (SELECT COUNT([position])  FROM [dbo].[Employee_Position_History] WHERE [sid_Employee] = EMP.[sid_Employee]
				HAVING COUNT([position]) > 1)
ORDER BY 1				

--Exercise 20.3
--Scenario: The CEO has requested insight to the employees that have had more than 3 salary movements

--List the emp_no, full name, salary, start and end dates, salary amount in $

--Ordered by employee numbr (or ID) and Salary Start Date descending so that we can see the highest salary first

SELECT 
	EMP.[emp_no] AS EMPLOYEENO,
	EMP.[first_name]+' '+EMP.[last_name] AS FULLNAME,
	SH.[sal_from_date] AS STARTDATE,
	SH.[sal_to_date] AS ENDDATE,
	FORMAT(SH.[current_salary],'C0') AS CURRENTSALARY
FROM
[dbo].[Employees] EMP
INNER JOIN
[dbo].[Salary_History] SH ON
EMP.[sid_Employee] = SH.[sid_Employee]
WHERE
EXISTS
	(	SELECT COUNT(DISTINCT [current_salary])
		FROM [dbo].[Salary_History] SH
		WHERE [sid_Employee] = EMP.[sid_Employee]
		HAVING COUNT(DISTINCT [current_salary]) > 3) 
GROUP BY 
	EMP.[emp_no],
	EMP.[first_name]+' '+EMP.[last_name],
	SH.[sal_from_date],
	SH.[sal_to_date],
	SH.[current_salary]
ORDER BY 1, STARTDATE DESC





