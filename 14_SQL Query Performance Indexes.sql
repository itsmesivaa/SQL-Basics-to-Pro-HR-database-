/*Exercise 21.1

You want to prototype a query and test the chosen index is suitable for the production employees table, howver there is not enough data to test this on as we are on the developer server.

	1. Create a new table named EmployeesIdxStudent.
	The script file (EmployeesIdxStudent.sql) is available for download in this lecture resource hence download and run the script to create the table.
	2. The table is a copy of the Employees table, hance you need to fill it with millions of rows sourced from the Employees table
	a) Write an Insert statement that runs 10times this will fill the table to 3-million rows.
Hint: Use your knowledge of WHILE loop to do this.
	3.Use the below query to check the Estimated Execution plan
	a) Check the cost of the query
	b) Evaluate an Index to create
*/

USE Human_Resources;

--
-- Run this script to build your test index table 
-- 

CREATE TABLE EmployeesIdxStudent(
	[sid_Employee] [int] NOT NULL,
	[emp_no] [int] NOT NULL,
    [birth_date] [date] NOT NULL,
    [first_name] [varchar](14) NOT NULL,
    [last_name] [varchar](16) NOT NULL,
    [gender] [char](1) NOT NULL,
    [sid_Date] [int] NULL,
	[hire_date] [date] NOT NULL);


DECLARE @NCOUNTER AS INT = 1;
WHILE(@NCOUNTER < 11)
	BEGIN
		INSERT INTO EmployeesIdxStudent ([sid_Employee],[emp_no],[birth_date],[first_name],[last_name],[gender],[sid_Date],[hire_date])
		SELECT [sid_Employee],[emp_no],[birth_date],[first_name],[last_name],[gender],[sid_Date],[hire_date] FROM [dbo].[Employees]
		SET @NCOUNTER = @NCOUNTER + 1
	IF (@NCOUNTER > 10) 
		BREAK

	END


	SELECT COUNT(DISTINCT emp_no) FROM EmployeesIdxStudent
	WHERE hire_date > '2000-02-02'