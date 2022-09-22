-- Zelenkov V.
-- SQL HW 4.

---------------------------------------------------------------------------------------------------------------------------------
# 1. Показать для каждого сотрудника его текущую зарплату и текущую зарплату текущего руководителя.

SELECT ee.emp_no, es.salary, edm.emp_no AS man_emp_no, es2.salary
FROM employees.employees AS ee
	INNER JOIN salaries AS es ON (ee.emp_no = es.emp_no)
	INNER JOIN dept_emp AS ede ON (ee.emp_no = ede.emp_no)
	INNER JOIN dept_manager AS edm ON (ede.dept_no = edm.dept_no)
	INNER JOIN salaries AS es2 ON (edm.emp_no = es2.emp_no)
WHERE es.to_date > CURDATE()
	AND ede.to_date > CURDATE()
	AND edm.to_date > CURDATE()
    AND es2.to_date > CURDATE()
ORDER BY ee.emp_no ASC;
---------------------------------------------------------------------------------------------------------------------------------
# 2. Показать всех сотрудников, которые в настоящее время зарабатывают больше, чем их руководители.

SELECT ee.emp_no, es.salary, edm.emp_no AS man_emp_no, es2.salary
FROM employees.employees AS ee
	INNER JOIN salaries AS es ON (ee.emp_no = es.emp_no)
	INNER JOIN dept_emp AS ede ON (ee.emp_no = ede.emp_no)
	INNER JOIN dept_manager AS edm ON (ede.dept_no = edm.dept_no)
	INNER JOIN salaries AS es2 ON (edm.emp_no = es2.emp_no)
WHERE es.to_date > CURDATE()
	AND ede.to_date > CURDATE()
	AND edm.to_date > CURDATE()
    AND es2.to_date > CURDATE()
		AND es.salary > es2.salary
ORDER BY ee.emp_no ASC;
---------------------------------------------------------------------------------------------------------------------------------
/* 3. Из таблицы dept_manager 
первым запросом выбрать данные по актуальным менеджерам департаментов и сделать свой столбец “checks” со значением ‘actual’.
Вторым запросом из этой же таблицы dept_manager выбрать НЕ актуальных менеджеров департаментов и сделать свой столбец “checks” со значением ‘old’.
Объединить результат двух запросов через union. */

SELECT *, (SELECT 'actual') AS checks
FROM employees.dept_manager
WHERE to_date > CURDATE()
	UNION
SELECT *, (SELECT 'old') AS checks
FROM employees.dept_manager
WHERE to_date < CURDATE();
---------------------------------------------------------------------------------------------------------------------------------
# 4. К результату всех строк таблицы departments, добавить еще две строки со значениями “d010”, “d011” для dept_no и “Data Base”, “Help Desk” для dept_name.

SELECT * FROM employees.departments
	UNION 
SELECT 'd010', 'Data Base'
	UNION 
SELECT 'd011', 'Help Desk'
ORDER BY dept_no;
---------------------------------------------------------------------------------------------------------------------------------
# 5. Найти emp_no актуального менеджера из департамента ‘d003’, далее через подзапрос из таблицы сотрудников вывести по нему информацию.

SELECT * 
FROM employees.employees
WHERE emp_no = 
	(SELECT emp_no 
	FROM employees.dept_manager
	WHERE dept_no = 'd003'
		AND to_date > CURDATE());
---------------------------------------------------------------------------------------------------------------------------------
# 6. Найти максимальную дату приема на работу, далее через подзапрос из таблицы сотрудников вывести по этой дате информацию по сотрудникам.

SELECT * 
FROM employees.employees
WHERE hire_date = 
	(SELECT MAX(hire_date)
	FROM employees.employees);
---------------------------------------------------------------------------------------------------------------------------------
