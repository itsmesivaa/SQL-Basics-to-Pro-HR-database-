--Exercise 15.1 The payroll manager has profiled the NEW_PAY_RUN table and has noted the sid_Date is not correct for the Pay_Date value, she has requested it should be updated.

--Tip: Use a join to update the sid_date to the correct value.. Think like an analyst :) Use the steps!


SELECT * FROM [dbo].[NEW_PAY_RUN]

SELECT * FROM [Payroll].[Employee_Payroll]

SELECT * FROM [dbo].[Calendar] WHERE Cal_Date IN ('2019-12-07')

BEGIN TRAN

UPDATE [dbo].[NEW_PAY_RUN] 
SET [sid_Date] = CAL.[sid_Date]
from
[dbo].[NEW_PAY_RUN] NPR INNER JOIN
[dbo].[Calendar] CAL
ON
CAL.[Cal_Date] = NPR.[pay_Date]

ROLLBACK TRAN



--Exercise 15.2 The Payroll manager has reviewed the sid_Date value in the New_Pay_run table but has noted that sid_Payrun_Ref_Key is not correct and requires 
--the key to be updated for all payrun records

--Tip: Use the cast function to update the key value ensure you can cast to the correct data type of the target column

select * from [dbo].[NEW_PAY_RUN]

SELECT CAST([sid_Employee] AS VARCHAR) + CAST([sid_Date] AS VARCHAR) ,[Payrun_Ref_key],
[sid_Employee],
[Pay_Amount],
[Pay_Date],
[sid_Date]
FROM
	[dbo].[NEW_PAY_RUN]

	BEGIN TRAN

UPDATE [dbo].[NEW_PAY_RUN]
	SET [Payrun_Ref_key] = CAST((CAST([sid_Employee] AS VARCHAR) + CAST([sid_Date] AS VARCHAR)) AS BIGINT)
FROM	
	[dbo].[NEW_PAY_RUN]
COMMIT TRAN

--Exercise 15.3 The HR manager has requested all of the records in Employee location table that have a sid_location of NULL should be updated to be the value 0, 
--just before the change is made we should call him and get the go ahead for the change!

--HR Manager made an error and requested it should not be changed after all

SELECT * FROM [dbo].[Employee_Location] 
WHERE 
	[sid_Location] IS NULL

BEGIN TRAN

UPDATE [dbo].[Employee_Location]
	SET [sid_Location] = 0
WHERE 
	[sid_Location] IS NULL

	COMMIT TRAN
	ROLLBACK TRAN