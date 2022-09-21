SELECT *
FROM employee_demographics

SELECT first_name, last_name
FROM employee_demographics

SELECT TOP 5 *
FROM employee_demographics

SELECT DISTINCT(employee_id)
FROM employee_demographics

SELECT DISTINCT(gender)
FROM employee_demographics

SELECT COUNT(last_name) AS last_name_count
FROM employee_demographics

SELECT MAX(salary) AS best_paid
FROM employee_salary

SELECT MIN(salary) AS worst_paid
FROM employee_salary

SELECT AVG(salary) AS average_paid
FROM employee_salary

SELECT *
FROM sql_tutorial.dbo.employee_salary

SELECT *
FROM sql_tutorial.dbo.employee_demographics

SELECT *
FROM sql_tutorial.dbo.employee_demographics
WHERE first_name IN ('Jim', 'Michael')
