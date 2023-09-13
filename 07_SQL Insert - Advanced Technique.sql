use [Human_Resources]

--Section 14 SQL Insert - Advanced Technique

--Exercise 14.1 The payroll manager would like to extract payroll data from the employee payroll for the paydate of 2019-11-30 and insert the data to a new table NEW_PAY_RUN

--As part of extract and load she wants 7 days added to the Pay_Date value

--The new table will be the same column structure as the payroll table
--Hints: Use dateadd() to calculate the new Paydate value which is replacing the 2019-11-30 value

--Ensure when building the FROM statement you specify the fully qualified name of the payroll table i.e., Select ... form payroll.Employee_Payroll

SELECT 
	[sid_Payrun_Ref_Key] AS 'Payrun_Ref_key',
	[sid_Employee] AS 'sid_Employee',
	[Pay_Amount] AS 'Pay_Amount',
	DATEADD(D,7,[Pay_Date]) AS 'Pay_Date',
	[sid_Date] AS 'sid_Date'
INTO NEW_PAY_RUN
FROM
	[Payroll].[Employee_Payroll]
WHERE 
	[Pay_Date] = '2019-11-30'





select * from Employees where emp_no = 10021

select * from [dbo].[Current_Personnel] where emp_no = 10021


insert into Current_Personnel (sid_Employee,emp_no,current_salary,current_location,sid_Department,sid_Location,sid_position)
	select
	emp.sid_Employee,
	emp.emp_no,
	(select max(current_salary) from Salary_History where emp_no = emp.emp_no) as current_salary,
	el.City,
	emh.sid_Department,
	el.sid_Location,
	eph.sid_Position
from
	Employees emp inner join
	Employee_Location el on emp.sid_Employee = el.sid_Employee inner join
	Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee inner join
	Employee_Position_History eph on emp.sid_Employee = eph.sid_Employee 
where
	emp.emp_no='10021' ;


SELECT * FROM [dbo].[Current_Personnel] WHERE emp_no = 10021

SELECT * 
FROM
	[dbo].[NEW_PAY_RUN] 


Payrun_Ref_key,	sid_Employee, Pay_Amount, Pay_Date, sid_Date

--Exercise 14.2 The Hiring manager has requested that employee 10021 is to be recorded in the NEW_PAY_RUN table ready for payroll processing.

--Tip: Use the newly created Personnel record from the previous lecture.
-- You will need 2 correlated subqueries with MAX() function.

--The sid_Payrun_Ref_Key is the concatenation of sid_Employee and sid_Date hence one of the correlated subqueries can be used to make a value for the column.

SELECT * FROM [dbo].[Current_Personnel] WHERE emp_no = 10021

SELECT * FROM Employees WHERE emp_no = 10021
SELECT * FROM [Payroll].[Employee_Payroll] 


INSERT INTO [dbo].[NEW_PAY_RUN]
([Payrun_Ref_key],[sid_Employee],[Pay_Amount],[Pay_Date],[sid_Date])
	SELECT 
		CONCAT(EMP.[sid_Employee],EMP.[sid_Date]) AS Payrun_Ref_key ,
		EMP.[sid_Employee],
		(CP.[current_salary]/12),
		(SELECT MAX(PAY_DATE) FROM [dbo].[NEW_PAY_RUN] ),
		(SELECT MAX(SID_DATE) FROM [dbo].[NEW_PAY_RUN] )
	FROM 
		[dbo].[Employees] EMP
	INNER JOIN 
		[dbo].[Current_Personnel] CP
	ON 
		EMP.[emp_no] = CP.[emp_no]
	WHERE 
		EMP.[emp_no] = 10021


SELECT * FROM [dbo].[NEW_PAY_RUN] 
WHERE sid_Employee = 21