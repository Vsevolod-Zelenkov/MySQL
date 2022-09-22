-- Student Zelenkov V.
-- SQL Exercises. Week 2.

---------------------------------------------------------------------------------------
/* 1. For the current maximum annual wage in the company,
SHOW the full name of the employee, department, current position,
for how long the current position is held,
and total years of service in the company. */

SELECT es.salary AS curr_max_wage,
    CONCAT(ee.first_name, ' ', ee.last_name) AS emp_full_name,
    ed.dept_name AS department,
    et.title AS curr_position,
    (TO_DAYS(CURDATE()) - TO_DAYS(et.from_date)) DIV 365 AS years_curr_position,
    (TO_DAYS(CURDATE()) - TO_DAYS(ee.hire_date)) DIV 365 AS years_in_the_company
FROM employees.salaries AS es
	INNER JOIN employees.employees AS ee ON (es.emp_no = ee.emp_no)
	LEFT JOIN employees.dept_emp AS ede ON (es.emp_no = ede.emp_no)
	INNER JOIN employees.departments AS ed ON (ede.dept_no = ed.dept_no)
	LEFT JOIN employees.titles AS et ON (es.emp_no = et.emp_no)
WHERE es.to_date > CURDATE()
	AND ede.to_date > CURDATE()
    AND et.to_date > CURDATE()
ORDER BY es.salary DESC
LIMIT 1;

/* 1.1. DIV 365 -- does not take into account leap years.
1.2. WHERE ***.to_date > CURDATE() -- open contract (current figures). */
---------------------------------------------------------------------------------------
# 2. For each department, show its name and current manager’s name, last name, and current salary.

SELECT ed.dept_name, ee.first_name AS manager_name, ee.last_name, es.salary AS curr_wage
FROM employees.departments AS ed
	LEFT JOIN employees.dept_manager AS edm ON (ed.dept_no = edm.dept_no)
    INNER JOIN employees.employees AS ee ON (edm.emp_no = ee.emp_no)
    LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE edm.to_date > CURDATE()
	AND es.to_date > CURDATE()
ORDER BY curr_wage DESC;
---------------------------------------------------------------------------------------
# 3. Show for each employee, their current salary and their current manager’s current salary.

SELECT ee.emp_no,
    CONCAT(ee.first_name, ' ', ee.last_name) AS emp_full_name,
    es.salary AS emp_curr_wage,
    es2.salary AS curr_manager_wage,
    CONCAT(ee2.first_name, ' ', ee2.last_name) AS manager_full_name
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
    LEFT JOIN employees.dept_emp AS ede ON (ee.emp_no = ede.emp_no)
    LEFT JOIN employees.dept_manager AS edm ON (ede.dept_no = edm.dept_no)
    LEFT JOIN employees.salaries AS es2 ON (edm.emp_no = es2.emp_no)
    INNER JOIN employees.employees AS ee2 ON (edm.emp_no = ee2.emp_no)
WHERE es.to_date > CURDATE()
	AND ede.to_date > CURDATE()
    AND edm.to_date > CURDATE()
    AND es2.to_date > CURDATE()
ORDER BY ee.emp_no ASC;
---------------------------------------------------------------------------------------
# 4. Show all employees that currently earn more than their managers.

SELECT ee.emp_no,
    CONCAT(ee.first_name, ' ', ee.last_name) AS emp_full_name,
    es.salary AS emp_curr_wage,
    es2.salary AS curr_manager_wage,
    CONCAT(ee2.first_name, ' ', ee2.last_name) AS manager_full_name,
    es.salary - es2.salary AS wage_gap
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
    LEFT JOIN employees.dept_emp AS ede ON (ee.emp_no = ede.emp_no)
    LEFT JOIN employees.dept_manager AS edm ON (ede.dept_no = edm.dept_no)
    LEFT JOIN employees.salaries AS es2 ON (edm.emp_no = es2.emp_no)
    INNER JOIN employees.employees AS ee2 ON (edm.emp_no = ee2.emp_no)
WHERE es.to_date > CURDATE()
	AND ede.to_date > CURDATE()
    AND edm.to_date > CURDATE()
    AND es2.to_date > CURDATE()
HAVING es.salary > es2.salary
ORDER BY wage_gap DESC;
---------------------------------------------------------------------------------------
# 5. Show how many employees currently hold each title, sorted in descending order by the number of employees.

SELECT title, COUNT(emp_no) AS emp_quantity
FROM employees.titles
WHERE to_date > CURDATE()
GROUP BY title
ORDER BY emp_quantity DESC;
---------------------------------------------------------------------------------------
# 6. Show the full name of all employees who were employed in more than one department.

SELECT et.emp_no,
    CONCAT(ee.first_name, ' ', ee.last_name) AS emp_full_name,
    COUNT(et.title) AS dep_quantity
FROM employees.titles AS et
	INNER JOIN employees.employees AS ee ON (et.emp_no = ee.emp_no)
GROUP BY et.emp_no
HAVING dep_quantity > 1
ORDER BY dep_quantity DESC, et.emp_no ASC;
---------------------------------------------------------------------------------------
# 7. Show the average salary and maximum salary in thousands of dollars for every year.

SELECT YEAR(to_date) AS year,
    ROUND((AVG(salary) / 1000), 2) AS avg_wage,
    ROUND((MAX(salary) / 1000), 2) AS max_wage
FROM employees.salaries
GROUP BY year
ORDER BY year DESC;
---------------------------------------------------------------------------------------
# 8. Show how many employees were hired on weekends (Saturday + Sunday), split by gender.

SELECT gender, COUNT(emp_no) AS hired_on_weekends
FROM employees.employees
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
GROUP BY gender;
---------------------------------------------------------------------------------------
/* 9. Fulfill the script below to achieve the following data:
Group all employees according to their age at January 1st, 1995 into four groups:
30 or younger, 31-40, 41-50 and older. Show average salary for each group and gender,
8 categories in total. Also add subtotals and grand total.

SELECT CASE -- let’s create age categories first
WHEN (datediff('1995-01-01', ... )THEN '30 and below'
...
END AS category,
...,
...
FROM employees e
INNER JOIN ...
WHERE ... -- filter out those employees, who were not employed at that date yet.
AND (SELECT MAX(to_date) FROM dept_emp de WHERE de.emp_no = e.emp_no
GROUP BY de.emp_no) > '1995-01-01' -- this subquery filters out employees,
-- who already left the company by that date (think
– about how it works)
GROUP BY ... ... ...; -- don’t forget to add totals. */

SELECT COUNT(DISTINCT ee.emp_no) AS emp_quantity, ROUND(AVG(es.salary), 2) AS avg_wage,
	CASE
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) <= 30 AND ee.gender = 'M') THEN '01. 30 and below, male'
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) <= 30 AND ee.gender = 'F') THEN '02. 30 and below, female'
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) BETWEEN 31 AND 40 AND ee.gender = 'M') THEN '03. 31-40, male'
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) BETWEEN 31 AND 40 AND ee.gender = 'F') THEN '04. 31-40, female'
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) BETWEEN 41 AND 50 AND ee.gender = 'M') THEN '05. 41-50, male'
		WHEN ((DATEDIFF('1995-01-01', ee.birth_date) DIV 365) BETWEEN 41 AND 50 AND ee.gender = 'F') THEN '06. 41-50, female'
		ELSE '51 and older'
	END AS category
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.hire_date < '1995-01-01'
    AND es.from_date < '1995-01-01'
GROUP BY (category)

UNION ALL
SELECT COUNT(DISTINCT ee.emp_no) AS emp_quantity, ROUND(AVG(es.salary), 2) AS avg_wage, '07. subtotal male' AS category
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.hire_date < '1995-01-01'
    AND es.from_date < '1995-01-01'
    AND ee.gender = 'M'

UNION ALL
SELECT COUNT(DISTINCT ee.emp_no) AS emp_quantity, ROUND(AVG(es.salary), 2) AS avg_wage, '08. subtotal female' AS category
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.hire_date < '1995-01-01'
    AND es.from_date < '1995-01-01'
    AND ee.gender = 'F'

UNION ALL
SELECT COUNT(DISTINCT ee.emp_no) AS emp_quantity, ROUND(AVG(es.salary), 2) AS avg_wage,
	CASE
		WHEN DATEDIFF('1995-01-01', ee.birth_date) DIV 365 <= 30 THEN '09. subtotal 30 and below'
		WHEN DATEDIFF('1995-01-01', ee.birth_date) DIV 365 BETWEEN 31 AND 40 THEN '10. subtotal 31-40'
		WHEN DATEDIFF('1995-01-01', ee.birth_date) DIV 365 BETWEEN 41 AND 50 THEN '11. subtotal 41-50'
	END AS category
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.hire_date < '1995-01-01'
    AND es.from_date < '1995-01-01'
GROUP BY (category)

UNION ALL
SELECT COUNT(DISTINCT ee.emp_no) AS emp_quantity, ROUND(AVG(es.salary), 2) AS avg_wage, '12. grand total' AS category
FROM employees.employees AS ee
	LEFT JOIN employees.salaries AS es ON (ee.emp_no = es.emp_no)
WHERE ee.hire_date < '1995-01-01'
    AND es.from_date < '1995-01-01'

ORDER BY category ASC;

/* 9.1. As of January 1st, 1995, there are no employees in the "51 and older" category, so we only have 6 main categories.
9.2. The average salary is calculated for the entire period before January 1, 1995, because the task does not specify a certain period.
9.3. The script that is written in the task uses INNER JOIN, I use LEFT JOIN to get all the annual salaries of a certain employee for our estimated period.
9.4. ""AND (SELECT MAX(to_date) FROM dept_emp de WHERE de.emp_no = e.emp_no
GROUP BY de.emp_no) > '1995-01-01' -- this subquery filters out employees,
who already left the company by that date (think about how it works)""
  -- there is no need for such a subquery when we can do the same thing simply by giving the condition:
the start date of the contract must be less than January 1, 1995. */
---------------------------------------------------------------------------------------
