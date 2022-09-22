-- Zelenkov V.
-- SQL Exercises. Week 3

-------------------------------------------------------------------------
/* 1. For the current maximum annual wage in the company, SHOW the full name of an employee, department, current position, 
for how long the current position is held, and total years of service in the company. USE common table expression this time. */

WITH CTE_ee AS
	(SELECT * FROM employees.employees WHERE emp_no = 
		(SELECT emp_no FROM employees.salaries WHERE salary = 
			(SELECT MAX(salary) FROM employees.salaries WHERE to_date > CURDATE()))),
CTE_de AS
	(SELECT * FROM employees.dept_emp WHERE emp_no = 
		(SELECT emp_no FROM employees.salaries WHERE salary = 
			(SELECT MAX(salary) FROM employees.salaries WHERE to_date > CURDATE()))
	AND to_date > CURDATE()),
CTE_t AS
	(SELECT *, (TO_DAYS(CURDATE()) - TO_DAYS(from_date)) DIV 365 AS years_curr_position FROM employees.titles WHERE emp_no = 
		(SELECT emp_no FROM employees.salaries WHERE salary = 
			(SELECT MAX(salary) FROM employees.salaries WHERE to_date > CURDATE()))
	AND to_date > CURDATE())
SELECT (SELECT MAX(salary) FROM employees.salaries WHERE to_date > CURDATE()) AS curr_max_wage,
	CONCAT(first_name, ' ', last_name) AS full_name, 
    (SELECT dept_name FROM employees.departments WHERE CTE_de.dept_no = departments.dept_no) AS dept_name,
    title,
    years_curr_position,
    (TO_DAYS(CURDATE()) - TO_DAYS(hire_date)) DIV 365 AS years_in_company
FROM CTE_ee, CTE_de, CTE_t;
-------------------------------------------------------------------------
/* 2. From MySQL documentation check how ABS() function works. 
https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_abs */

SELECT ABS(-123.45);

-- Returns the absolute value of a number.
-------------------------------------------------------------------------
/* 3. Show all information about the employee, salary year, and the difference between salary and average salary in the company overall. 
For the employee, whose salary was assigned latest from salaries that are closest to mean salary overall (doesn’t matter higher or lower). 
Here you need to find the average salary overall and then find the smallest difference of someone’s salary with an average salary. */

SELECT *, 
	(SELECT AVG(salary) FROM employees.salaries) AS mean_sal_overall,    
    ABS(salary - (SELECT AVG(salary) FROM employees.salaries)) AS abs_sal_diff_to_mean_sal,
    YEAR (es.from_date) AS sal_year
FROM employees.salaries AS es
	INNER JOIN employees.employees AS ee USING (emp_no)
    INNER JOIN employees.titles AS et USING (emp_no)
    INNER JOIN employees.dept_emp AS ede USING (emp_no)
ORDER BY abs_sal_diff_to_mean_sal ASC, es.from_date DESC
LIMIT 1;

-- Showed the information about the employee, except his managers.
-------------------------------------------------------------------------
/* 4. Select the details, title, and salary of the employee with the highest salary who is not employed in the company anymore. */

SELECT ede.emp_no, ede.dept_no, ede.from_date, ede.to_date, 
    es.salary, es.from_date, es.to_date, 
    et.title, et.from_date, et.to_date
FROM employees.dept_emp AS ede
	INNER JOIN employees.salaries AS es ON (ede.emp_no = es.emp_no)
	INNER JOIN employees.titles AS et ON (es.emp_no = et.emp_no)
WHERE es.salary = 
	(SELECT MAX(es.salary)
	FROM employees.salaries AS es 
		LEFT  JOIN employees.dept_emp AS ede2 
			ON (es.emp_no = ede2.emp_no 
			AND NOW() BETWEEN ede2.from_date AND ede2.to_date)
	WHERE ede2.emp_no IS NULL);
-------------------------------------------------------------------------
/* 5. Show Full Name, salary, and year of the salary for top 5 employees that have the highest one-time raise in salary (in absolute numbers). 
Also, attach the top 5 employees that have the highest one-time raise in salary (in percent).  
One-time rise here means the biggest difference between the two consecutive years. */

SELECT * FROM 
	(SELECT emp_no,
		CONCAT(first_name, ' ', last_name) AS '___top_5_by___----->',
		LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) - salary AS max_raise_in_abs_numb,		
        LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS raised_salary,
		YEAR(to_date) AS year_of_raise
	FROM salaries
		INNER JOIN employees USING (emp_no)
	ORDER BY max_raise_in_abs_numb DESC, emp_no ASC
	LIMIT 5) AS first_query
UNION ALL
SELECT '', '___top_5_by___----->', 'max_raise_in_percent', '', ''
UNION ALL
SELECT * FROM 
	(SELECT emp_no,
		CONCAT(first_name, ' ', last_name) AS full_name,
		ROUND((LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) - salary) / salary * 100 , 1) AS max_raise_in_percent,
        LEAD(salary) OVER (PARTITION BY emp_no ORDER BY from_date) AS raised_salary,
		YEAR(to_date) AS year_of_raise
	FROM salaries
		INNER JOIN employees USING (emp_no)
	ORDER BY max_raise_in_percent DESC, emp_no ASC
	LIMIT 5) AS second_query;
-------------------------------------------------------------------------
-- 6. Generate a sequence of square numbers till 9 (1^2, 2^2... 9^2)

WITH RECURSIVE sequence (number, value) AS
	(SELECT 1, 1 
		UNION
    SELECT number + 1, (number + 1) * (number + 1)
    FROM sequence
    WHERE number < 9)
SELECT * FROM sequence;
-------------------------------------------------------------------------
