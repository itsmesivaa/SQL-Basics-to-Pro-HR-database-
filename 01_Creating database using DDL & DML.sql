CREATE DATABASE A_Database;

--6.1 Exercise - Create a database using DDL named Ch6_Database

CREATE DATABASE Ch6_Database;

--How to add database table using DDL

use Ch6_Database;

CREATE TABLE TableSetA(Fruit varchar(12));

--6.2 Exercise - Create a table using DDL (Table name TableSetB with Column Fruit with datatype varchar(12))

CREATE TABLE TableSetB(Fruit varchar(12));

--How to insert data in to a table using DML using singular record then multiple record(i.e., list)

insert into [dbo].[TableSetA](Fruit)
values('Banana')

insert into [dbo].[TableSetA](Fruit)
values('Orange'), ('Apple')

select * From TableSetA

--6.3 Exercise - Add data to a different table 

insert into [dbo].[TableSetB] (Fruit)
values('Orange'), ('Apple'),('Plums'),('Almonds');

select * from TableSetB;

--How to update data based on WHERE clause

UPDATE 
	[dbo].[TableSetA] 
		SET [Fruit] = 'Oranges'
	WHERE 
		[Fruit] = 'Orange'


select * from TableSetA;

--6.4 Exercise - Update data to set fruit name from Plural to Non-Plural

UPDATE [dbo].[TableSetB]
	SET [Fruit] = 'Plum'
WHERE [Fruit] = 'Plums'

UPDATE [dbo].[TableSetB]
	SET [Fruit] = 'Almond'
WHERE [Fruit] = 'Almonds'


UPDATE 
	[dbo].[TableSetA] 
		SET [Fruit] = 'Orange'
	WHERE 
		[Fruit] = 'Oranges'

	
--How to change database name using DDL (ALTER Database) and fix

use master;

ALTER DATABASE [Ch6_Database] MODIFY NAME = CH_6_Database

--6.5 Exercise - Change the Database Name

USE master;

 ALTER DATABASE [CH_6_Database] MODIFY NAME = Chapter_6_Database;

--Add new column to TableSetA -- Introducing the Identity Field, these can be used as surrogate keys where uniqueness is required.

USE [Chapter_6_Database];

ALTER TABLE [dbo].[TableSetA]
	ADD sid_A_Key INT IDENTITY(1,5);

--6.6 Exercise - Add a new column to a table TableSetB add new Identity column sid_B_key arguments for identity 10,10

ALTER TABLE [dbo].[TableSetB]
	ADD sid_B_Key INT IDENTITY(10,10);


	select * from TableSetB;

--Alter a column using SQL

ALTER TABLE [dbo].[TableSetA] ALTER COLUMN [Fruit] CHAR(8);

SELECT * FROM [dbo].[TableSetA] 

--6.7 Exercise - Alter Database table and change column Fruit data type to Text (Hint: Text doesn't get into size)

ALTER TABLE [dbo].[TableSetB]
	ALTER COLUMN [Fruit] CHAR(8);


--Set Theory

--UNION PULL ALL DATA THAT PRESENT IN TWO TABLES BY EXCLUDING DUPLICATES 
SELECT [Fruit] FROM [dbo].[TableSetA]
UNION
SELECT [Fruit] FROM [dbo].[TableSetB]

--UNION ALL PULL ALL DATA INCLUDES DUPLICATES RECORDS
SELECT [Fruit] FROM [dbo].[TableSetA]
UNION ALL
SELECT [Fruit] FROM [dbo].[TableSetB]


--INTERSECT RETURNS COMMON VALUES FROM BOTH TABLES

SELECT [Fruit] FROM [dbo].[TableSetA]
INTERSECT
SELECT [Fruit] FROM [dbo].[TableSetB]


SELECT 
F1.Fruit AS SETA_FRUIT,
F2.Fruit AS SETB_FRUIT
FROM [dbo].[TableSetA] F1, [dbo].[TableSetB] F2
WHERE F1.Fruit = F2.Fruit

--EXCEPT RETURNS UNIQUE VALUES FROM BOTH TABLES

SELECT [Fruit] FROM [dbo].[TableSetA]
EXCEPT
SELECT [Fruit] FROM [dbo].[TableSetB]


SELECT 
F1.Fruit AS SETA_FRUIT
FROM [dbo].[TableSetA] F1
WHERE F1.Fruit NOT IN (SELECT FRUIT FROM [dbo].[TableSetB])


SELECT [Fruit] FROM [dbo].[TableSetB]
EXCEPT
SELECT [Fruit] FROM [dbo].[TableSetA]


SELECT 
F2.Fruit AS SETA_FRUIT
FROM [dbo].[TableSetB] F2
WHERE F2.Fruit NOT IN (SELECT FRUIT FROM [dbo].[TableSetA])
