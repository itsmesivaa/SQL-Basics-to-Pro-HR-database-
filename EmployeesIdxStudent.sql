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


