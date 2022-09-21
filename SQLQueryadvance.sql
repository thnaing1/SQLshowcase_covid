-- CTE common table expression like sub querie

WITH CTE_employee AS 
(
SELECT first_name, last_name, gender, salary, COUNT(gender) OVER(PARTITION BY gender) as total_gender,
AVG(salary) OVER(PARTITION BY gender) AS avg_salary
FROM sql_tutorial.dbo.employee_demographics AS demo
JOIN sql_tutorial.dbo.employee_salary AS sal
	ON demo.employee_id = sal.employee_id
WHERE salary > '45000'
)

SELECT *
FROM CTE_employee;
-- CTE not saved in database so it must be ran everytime
-- CTEs allow you to do multilevel aggregations which are not directly supported by sql

CREATE TABLE #temp_employee
(employee_id INT,
job_title varchar(30),
salary INT);

SELECT *
FROM #temp_employee;

INSERT INTO #temp_employee VALUES(
'1001', 'HR', '45000');

INSERT INTO #temp_employee
SELECT *
FROM sql_tutorial.dbo.employee_salary;



DROP TABLE IF EXISTS #temp_employee2
CREATE TABLE #temp_employee2
(job_title varchar(30),
employees_per_job INT,
AVG_age INT,
avg_salary INT)

INSERT INTO #temp_employee2
SELECT job_title, COUNT(job_title), AVG(age), AVG(salary)
FROM sql_tutorial.dbo.employee_demographics DEMO
JOIN sql_tutorial.dbo.employee_salary SAL
	ON DEMO.employee_id = SAL.employee_id
GROUP BY job_title

SELECT *
FROM #temp_employee2; --TEMP TABLE will allow you to save a lot of processing power and run time
-- you can simply store values that you already ran once to the temp table instead of running it every time and without storing 
-- it inside of a database 




--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

INSERT INTO EmployeeErrors VALUES
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using TRIM, LTRIM, RTRIM

SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM -- gets rid of spaces on both sides
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) AS LIDTRIM -- gets rid of spaces on the left hand side of value
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) AS RIDTRIM -- gets rid of spaces on the right hand side of value
FROM EmployeeErrors

-- USING replace

SELECT LastName, REPLACE(LastName, ' - Fired', '') AS LastNameFixed
FROM EmployeeErrors

-- using substring

SELECT SUBSTRING(FirstName, 1, 3) -- firstname is column, 1 is the starting letter, 3 is the number of letters to the right including the first
FROM EmployeeErrors

ALEX

ALEXANDER

SELECT err.FirstName, SUBSTRING(err.FirstName, 1, 3), DEMO.first_name, SUBSTRING(DEMO.first_name, 1 , 3)
FROM EmployeeErrors as err
JOIN employee_demographics AS DEMO
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(DEMO.first_name, 1, 3)

-- GENDER
-- LASTNAME
-- AGE
-- DOB

-- USING upper and lower


SELECT FirstName, LOWER(FirstName)
FROM EmployeeErrors

SELECT FirstName, UPPER(FirstName)
FROM EmployeeErrors

-- STORED Procedures

CREATE PROCEDURE TEST
AS
SELECT *
FROM employee_demographics


EXEC TEST

CREATE PROCEDURE temp_employee
AS
CREATE TABLE #temp_employee (
job_title varchar(30),
employees_per_job INT,
AVG_age INT,
avg_salary INT)

INSERT INTO #temp_employee
SELECT job_title, COUNT(job_title), AVG(age), AVG(salary)
FROM sql_tutorial.dbo.employee_demographics DEMO
JOIN sql_tutorial.dbo.employee_salary SAL
	ON DEMO.employee_id = SAL.employee_id
GROUP BY job_title

SELECT *
FROM #temp_employee


EXEC temp_employee @job_title = 'Salesman'

SELECT *
FROM employee_salary


-- Subquery - used to return data that will be used in the main query


-- Subquery in SELECT


SELECT employee_id, salary, (SELECT AVG(salary) FROM employee_salary) AS all_avg_salary
FROM employee_salary

-- How to do it with Partition By

SELECT employee_id, salary, AVG(salary) OVER () AS all_avg_salary
FROM employee_salary

-- Why group by doesn't work

SELECT employee_id, salary, AVG(salary) AS all_avg_salary
FROM employee_salary
GROUP BY employee_id, salary
ORDER 1,2

-- Subquery in from

SELECT a.employee_id, all_avg_salary
FROM (SELECT employee_id, salary, AVG(salary) OVER () AS all_avg_salary
FROM employee_salary) AS a

-- Subquery in WHERE

SELECT employee_id, job_title, salary
FROM employee_salary
WHERE employee_id IN (
	SELECT employee_id
	FROM employee_demographics
	WHERE age > 30)