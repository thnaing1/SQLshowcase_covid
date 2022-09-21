INSERT INTO sql_tutorial.dbo.employee_demographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

INSERT INTO sql_tutorial.dbo.employee_salary VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)


SELECT *
FROM sql_tutorial.dbo.employee_demographics

SELECT *
FROM sql_tutorial.dbo.employee_salary

-- V Inner Join means that the data must be present in both tables in order for it to be included in the results
SELECT*
FROM sql_tutorial.dbo.employee_demographics
INNER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id

-- V Outer join means that the result will be included whether the data is in the left or right table; if the data is in
-- only on one side the cells on the other side will be set as null
SELECT*
FROM sql_tutorial.dbo.employee_demographics
OUTER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id

-- V Left outer join is very similar to the full outer join except that only the left table as well as the matching, will be
-- included in the result
SELECT*
FROM sql_tutorial.dbo.employee_demographics
LEFT OUTER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id

-- V right outer join is very similar to the full outer join except that only the right table as well as the matching, will be
-- included in the result
SELECT*
FROM sql_tutorial.dbo.employee_demographics
RIGHT OUTER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id


SELECT employee_demographics.employee_id,first_name, last_name, job_title, salary
FROM sql_tutorial.dbo.employee_demographics
INNER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id

SELECT employee_demographics.employee_id,first_name, last_name, job_title, salary
FROM sql_tutorial.dbo.employee_demographics
RIGHT OUTER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id

SELECT job_title, AVG(salary)
FROM sql_tutorial.dbo.employee_demographics
INNER JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id
WHERE job_title = 'Salesman'
GROUP BY job_title

CREATE TABLE sql_tutorial.dbo.warehouse_employee_demographics
(employee_id INT, 
first_name varchar(50), 
last_name varchar(50), 
age INT, 
gender varchar(50)
)

INSERT INTO sql_tutorial.dbo.warehouse_employee_demographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

SELECT *
FROM sql_tutorial.dbo.employee_demographics --accessing of the database
FULL OUTER JOIN sql_tutorial.dbo.warehouse_employee_demographics --function you want to perform
	ON employee_demographics.employee_id = warehouse_employee_demographics.employee_id -- the input for the function

SELECT employee_id, first_name, age
FROM sql_tutorial.dbo.employee_demographics
UNION --for union to work the columns must be the same and they must have the same data type
SELECT employee_id, job_title, salary
FROM sql_tutorial.dbo.employee_salary
ORDER BY employee_id

-- Case statement allows you to specify a condition and what you want returned when that condition is met

SELECT first_name, last_name, age,
CASE 
	WHEN age >30 THEN 'Old' -- BOOLEAN runs statment if TRUE but if it is FALSE it RUNS the statement below it and etc.
	WHEN age = 38 THEN 'Stanley' -- Stanley is already set to Old 
	ELSE 'Baby'
END
FROM sql_tutorial.dbo.employee_demographics
WHERE age is NOT NULL
ORDER BY age

SELECT first_name, last_name, age,
CASE 
	WHEN age = 38 THEN 'Stanley' -- this CASE statement is ran first and that is why the table is different
	WHEN age >30 THEN 'Old' -- order of CASE statement matters 
	ELSE 'Baby'
END
FROM sql_tutorial.dbo.employee_demographics
WHERE age is NOT NULL
ORDER BY age

SELECT first_name, last_name, job_title, salary,
CASE 
	WHEN job_title = 'Salesman' THEN salary + (salary*.10)
	WHEN job_title = 'Accountant' THEN salary + (salary*.05)
	WHEN job_title = 'HR' THEN salary + (salary*.000001)
	ELSE salary + (salary*.03)
END AS salary_after_raise
FROM sql_tutorial.dbo.employee_demographics -- Left table
JOIN sql_tutorial.dbo.employee_salary -- right table
	ON employee_demographics.employee_id = employee_salary.employee_id

SELECT job_title, COUNT(job_title)
FROM sql_tutorial.dbo.employee_demographics
JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id
GROUP BY job_title
HAVING COUNT(job_title) > 1

-- WHERE clause introduces a condition on individual rows. HAVING clause introduces a condition on aggregations, i.e. results of 
-- selection where a single result, such as count, average, min, max, or sum, has been produced from multiple rows

SELECT job_title, AVG(salary)
FROM sql_tutorial.dbo.employee_demographics
JOIN sql_tutorial.dbo.employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id
GROUP BY job_title
HAVING AVG(salary) > 45000
ORDER BY AVG(salary)

SELECT *
FROM sql_tutorial.dbo.employee_demographics

UPDATE sql_tutorial.dbo.employee_demographics
SET age = 31, gender = 'Female'
WHERE first_name = 'Holly' AND last_name = 'Flax'

SELECT *         --DELETE 
FROM sql_tutorial.dbo.employee_demographics -- using the select statement is a good way to make sure you know what you will delete
WHERE employee_id = 1004

DELETE 
FROM sql_tutorial.dbo.employee_demographics
WHERE employee_id = 1004

-- Aliasing- temporaraly changing the column name or table name; used for the readability of your script

SELECT first_name + ' ' + last_name AS full_name
FROM sql_tutorial.dbo.employee_demographics

SELECT AVG(age) AS avgage
FROM sql_tutorial.dbo.employee_demographics

SELECT DEMO.employee_id, SAL.salary
FROM sql_tutorial.dbo.employee_demographics AS DEMO
JOIN sql_tutorial.dbo.employee_salary as SAL
	ON DEMO.employee_id = SAL.employee_id
ORDER BY salary DESC

SELECT DEMO.employee_id, DEMO.first_name, SAL.job_title, WARE.age
FROM sql_tutorial.dbo.employee_demographics AS DEMO
LEFT JOIN sql_tutorial.dbo.employee_salary as SAL
	ON DEMO.employee_id = SAL.employee_id
LEFT JOIN sql_tutorial.dbo.warehouse_employee_demographics as WARE
	ON DEMO.employee_id = WARE.employee_id

SELECT first_name, last_name, gender, salary, --if it was a group by statement then you have to select gender, COUNT(gender)
COUNT(gender) OVER(PARTITION BY gender) AS total_gender -- then GROUP BY gender statement in order to get only column 5
FROM sql_tutorial.dbo.employee_demographics AS DEMO -- but the PARTITION BY allows you to display other results as well
JOIN sql_tutorial.dbo.employee_salary AS SAL
	ON DEMO.employee_id = SAL.employee_id

SELECT gender , COUNT(gender) 
FROM sql_tutorial.dbo.employee_demographics AS DEMO
JOIN sql_tutorial.dbo.employee_salary AS SAL
	ON DEMO.employee_id = SAL.employee_id
GROUP BY gender
