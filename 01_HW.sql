-- Student Zelenkov V.
-- SQL HW 1.


-- Task 1.
 -- List all female employees who joined at 01/01/1990 or at 01/01/2000.
SELECT *
FROM employees.employees
WHERE gender = 'F'
 AND hire_date IN ('1990-01-01' , '2000-01-01')
ORDER BY emp_no;

-- Task 2.
 -- Show the name of all employees who have an equal first and last name.
SELECT first_name,
       last_name,
       emp_no
FROM employees.employees
WHERE first_name = last_name
ORDER BY first_name;

-- Task 3.
 -- Show employees numbers 10001,10002,10003 and 10004, select columns first_name, last_name, gender, hire_date.
SELECT emp_no,
       first_name,
       last_name,
       gender,
       hire_date
FROM employees.employees
WHERE emp_no BETWEEN 10001 AND 10004
ORDER BY emp_no;

-- Task 4.
 -- Select the names of all departments whose names have ‘a’ character on any position or ‘e’ on the second place.
SELECT *
FROM employees.departments
WHERE dept_name LIKE '%a%'
 OR dept_name LIKE '_e%'
ORDER BY dept_no;

-- Task 5.
 -- Show employees who satisfy the following description: He(!) was 45 when hired, born in October and was hired on Sunday.
SELECT *,
       DAYNAME (hire_date) AS hire_weekday,
       DATEDIFF (birth_date, hire_date) / 365
FROM employees.employees
WHERE gender = 'M'
 AND YEAR (hire_date) - YEAR (birth_date) = 45 /*
  An approximate figure, since the year of hire minus the year of birth does not always equal full age. 
  A more accurate calculation is necessary. */
 AND MONTH (birth_date) = 10
 AND DAYNAME (hire_date) = 6;

-- Task 6.
 -- Show the maximum annual salary in the company after 01/06/1995.
SELECT MAX(salary) AS max_salary,
       from_date,
       emp_no
FROM employees.salaries
WHERE from_date > '1995-06-01';

-- Task 7.
 -- In the dept_emp table, show the quantity of employees by department (dept_no).
 -- To_date must be greater than current_date.
 -- Show departments with more than 13,000 employees.
 -- Sort by quantity of employees.
SELECT dept_no,
       COUNT(DISTINCT(emp_no)) AS 'emp_quantity'
FROM employees.dept_emp
WHERE to_date > CURDATE()
GROUP BY dept_no
HAVING emp_quantity > 13000
ORDER BY emp_quantity DESC;

-- Task 8.
 -- Show the minimum and maximum salaries by employee.
SELECT emp_no,
       MIN(salary) AS min_salary,
	   MAX(salary) AS max_salary,
       ROUND(AVG(salary), 0) AS avg_salary,
       SUM(salary) AS sum_salary
FROM employees.salaries
GROUP BY emp_no
ORDER BY avg_salary DESC;
