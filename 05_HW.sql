-- Zelenkov V.
-- SQL HW 5.

---------------------------------------------------------------------------------------------------------------------------------
# 1. Отобразить информацию из таблицы сотрудников и через подзапрос добавить его текущую должность.

SELECT *, 
	(SELECT title FROM employees.titles AS et
	WHERE to_date > CURDATE() 
		AND ee.emp_no = et.emp_no) AS curr_title
FROM employees.employees AS ee
WHERE 
	(SELECT title FROM employees.titles AS et
	WHERE to_date > CURDATE() 
		AND ee.emp_no = et.emp_no) NOT LIKE 'NULL';
        
-- NOT LIKE 'NULL' - убрал сотрудников которые "сейчас" без должности.
---------------------------------------------------------------------------------------------------------------------------------
# 2. Отобразить информацию из таблицы сотрудников, которые в прошлом были с должностью 'Engineer'. (exists)

SELECT *
FROM employees.employees AS ee
WHERE EXISTS 
	(SELECT title 
    FROM employees.titles AS et 
    WHERE ee.emp_no = et.emp_no 
		AND title IN ('Engineer'));
---------------------------------------------------------------------------------------------------------------------------------
# 3. Отобразить информацию из таблицы сотрудников, у которых актуальная зарплата от 50 тысяч до 75 тысяч. (in)

SELECT *
FROM employees.employees AS ee
WHERE emp_no IN 
	(SELECT emp_no 
    FROM employees.salaries AS es 
    WHERE ee.emp_no = es.emp_no 
		AND salary BETWEEN 50000 AND 75000
        AND to_date > CURDATE());
---------------------------------------------------------------------------------------------------------------------------------
# 4. Создать копию таблицы employees с помощью этого SQL скрипта: create table employees_dub as select * from employees;

CREATE TABLE IF NOT EXISTS employees_dub AS SELECT * FROM employees;
---------------------------------------------------------------------------------------------------------------------------------
# 5. Из таблицы employees_dub удалить сотрудников которые были наняты в 1985 году.

DELETE 
FROM employees.employees_dub
WHERE YEAR(hire_date) = '1985';
---------------------------------------------------------------------------------------------------------------------------------
# 6. В таблице employees_dub сотруднику под номером 10008 изменить дату приема на работу на ‘1994-09-01’.

UPDATE employees.employees_dub SET 
	hire_date = '1994-09-01' WHERE emp_no = 10008;
---------------------------------------------------------------------------------------------------------------------------------
# 7. В таблицу employees_dub добавить двух произвольных сотрудников.

INSERT INTO employees.employees_dub VALUES
	(10000, '1983-10-03', 'Georgrina', 'Facello', 'F', CURDATE(), '2'),
    ( 9999, '1993-11-02', 'Annek'    , 'Preusig', 'M', CURDATE(), '1');
---------------------------------------------------------------------------------------------------------------------------------
