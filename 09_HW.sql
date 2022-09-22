-- Zelenkov V.
-- SQL HW 9 WINDOW FUNCTIONS.

---------------------------------------------------------------------------------------------------------------------------------
# 1. Отобразить сотрудников и напротив каждого, показать информацию о разнице текущей и первой зарплаты.

SELECT
	es.emp_no,
    CONCAT(ee.first_name, ' ', ee.last_name) AS full_name,
	FIRST_VALUE(es.salary) OVER (PARTITION BY es.emp_no ORDER BY es.from_date ASC) AS first_sal,
    es2.salary AS curr_sal,
    es2.salary - FIRST_VALUE(es.salary) OVER (PARTITION BY es.emp_no ORDER BY es.from_date ASC) AS diff_between_sal
FROM employees.salaries AS es
	INNER JOIN employees.salaries AS es2 ON (es2.emp_no = es.emp_no AND CURDATE() BETWEEN es2.from_date AND es2.to_date)
	INNER JOIN employees.employees AS ee ON (es.emp_no = ee.emp_no)
GROUP BY es.emp_no;

-- Отображены только те сотрудники которые имеют текущую зарплату.
---------------------------------------------------------------------------------------------------------------------------------
# 2. Отобразить департаменты и сотрудников, которые получают наивысшую зарплату в своем департаменте.

SELECT * FROM
	(SELECT es.emp_no, es.salary, ede.dept_no,
		ROW_NUMBER () OVER (PARTITION BY ede.dept_no ORDER BY es.salary DESC) AS dept_salary_rate
	FROM employees.salaries AS es
		LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND CURDATE() BETWEEN ede.from_date AND ede.to_date)
	WHERE CURDATE() BETWEEN es.from_date AND es.to_date) AS select_all_curr_emp
WHERE dept_salary_rate IN (1);
---------------------------------------------------------------------------------------------------------------------------------
# 3. Из таблицы должностей, отобразить сотрудника с его текущей должностью и предыдущей.
-- HINT OVER(PARTITION BY ... ORDER BY ... ROWS 1 preceding)

SELECT * FROM
	(SELECT *,
		NTH_VALUE(title, 2) OVER (PARTITION BY emp_no ORDER BY to_date DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS previous_title
	FROM employees.titles) AS select_all_titles
WHERE CURDATE() BETWEEN from_date AND to_date;

-- NULL means there was no previous title.
---------------------------------------------------------------------------------------------------------------------------------
# 4. Из таблицы должностей, посчитать интервал в днях - сколько прошло времени от первой должности до текущей.

SELECT *, CASE 
	WHEN first_title_finish > curr_title_start THEN 'just one title'
	WHEN first_title_finish < curr_title_start THEN TO_DAYS(curr_title_start) - TO_DAYS(first_title_finish)
    ELSE 'without intermediate titles'
	END AS 'days_diff'
FROM
	(SELECT *,
		FIRST_VALUE(from_date) OVER (PARTITION BY emp_no ORDER BY from_date DESC) AS curr_title_start,
		FIRST_VALUE(to_date) OVER (PARTITION BY emp_no ORDER BY to_date ASC) AS first_title_finish
	FROM employees.titles) AS select_all_titles
WHERE CURDATE() BETWEEN from_date AND to_date;
---------------------------------------------------------------------------------------------------------------------------------
/* 5. Выбрать сотрудников и отобразить их рейтинг по году принятия на работу. Попробуйте разные типы рейтингов. 
Как вариант можно SELECT с оконными функциями вставить как подзапрос в FROM.
SELECT subq.a - subq.b AS value_diff
FROM (SELECT a,
			FIRST_VALUE(col1) OVER(PARTITION BY ... ORDER BY ...) AS b
		FROM table1) AS subq
WHERE subq.date > now();
SELECT subq.*, DATEDIFF(subq.c-subq.d) AS date_diff
FROM (SELECT *,
			FIRST_VALUE(date_col1) OVER(PARTITION BY ... ORDER BY ...) AS d
		FROM table1) AS subq
WHERE subq.date > now() */

-- Rating for years with highest number of hired employees
SELECT
	YEAR(hire_date) AS hire_year,
    COUNT(emp_no) AS emp_quantity,
    ROW_NUMBER () OVER (ORDER BY COUNT(emp_no) DESC) AS year_emp_quant_rate
FROM employees.employees
GROUP BY hire_year;

-- Rating for years by share of men in total number of hired employees
SELECT *,
	ROW_NUMBER () OVER (ORDER BY share_of_men DESC) AS year_share_of_men_rate
FROM (
	WITH cte_1 AS (SELECT YEAR(hire_date) AS hire_year, COUNT(emp_no) AS emp_quantity
		FROM employees.employees
		GROUP BY hire_year),
	cte_2 AS (SELECT YEAR(hire_date) AS hire_year, COUNT(emp_no) AS male_quantity
		FROM employees.employees
		WHERE gender = 'M'
		GROUP BY hire_year),
	cte_3 AS (SELECT YEAR(hire_date) AS hire_year, COUNT(emp_no) AS female_quantity
		FROM employees.employees
		WHERE gender = 'F'
		GROUP BY hire_year)
	SELECT cte_1.hire_year, emp_quantity, male_quantity, female_quantity, 
		emp_quantity - male_quantity - female_quantity AS 'check',
        ROUND(male_quantity / emp_quantity * 100, 1) AS share_of_men		
	FROM cte_1, cte_2, cte_3
	WHERE cte_1.hire_year = cte_2.hire_year AND cte_2.hire_year = cte_3.hire_year
	ORDER BY share_of_men DESC) AS select_for_rate;
---------------------------------------------------------------------------------------------------------------------------------
