/* Zelenkov V. SQL степ-проект.
стр. 7 - Запросы
стр. 167 - Дизайн базы данных */



-- ===================================================== Запросы: ===============================================================
-- ==============================================================================================================================
/* 1. Покажите среднюю зарплату сотрудников за каждый год
(средняя заработная плата среди тех, кто работал в отчетный период - статистика с начала до 2005 года). */

SELECT YEAR(from_date) AS year, 
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees.salaries
WHERE YEAR(from_date) < 2005
GROUP BY year
ORDER BY year ASC;

-- ==============================================================================================================================
/* 2. Покажите среднюю зарплату сотрудников по каждому отделу. 
Примечание: принять в расчет только текущие отделы и текущую заработную плату. */

SELECT dept_no, dept_name,
	ROUND(AVG(salary), 2) AS avg_salary
FROM employees.dept_emp AS ede
	LEFT JOIN employees.salaries AS es USING (emp_no)
    INNER JOIN employees.departments AS ed USING (dept_no)
WHERE CURDATE() BETWEEN ede.from_date AND ede.to_date
	AND CURDATE() BETWEEN es.from_date AND es.to_date
GROUP BY dept_no    
ORDER BY dept_no ASC;

-- ==============================================================================================================================
/* 3. Покажите среднюю зарплату сотрудников по каждому отделу за каждый год. 
Примечание: для средней зарплаты отдела X в году Y нам нужно взять среднее значение всех зарплат в году Y сотрудников, которые были в отделе X в году Y. */

-- 3. Вариант 1:
SELECT dept_no, year, avg_salary 
FROM 	(SELECT dept_no, year,
			ROUND(AVG(salary) OVER (PARTITION BY dept_no, year), 2) AS avg_salary,
			ROW_NUMBER() OVER (PARTITION BY dept_no, year) AS row_numb
		FROM 	(SELECT ede.emp_no, ede.dept_no, es.salary, YEAR(es.from_date) AS year
				FROM employees.salaries AS es
					LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no 
						AND es.from_date BETWEEN ede.from_date AND ede.to_date)) AS s_1) AS s_2
WHERE row_numb = 1
ORDER BY dept_no, year ASC;

-- 3. Вариант 2:
WITH cte_1 AS	(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d001 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd001' GROUP BY year),
cte_2 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d002 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd002' GROUP BY year),			
cte_3 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d003 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd003' GROUP BY year),                
cte_4 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d004 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd004' GROUP BY year),                
cte_5 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d005 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd005' GROUP BY year),                
cte_6 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d006 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd006' GROUP BY year),                
cte_7 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d007 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd007' GROUP BY year),
cte_8 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d008 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd008' GROUP BY year),                
cte_9 AS		(SELECT YEAR(es.from_date) AS year,	ROUND(AVG(salary), 2) AS d009 FROM employees.salaries AS es
				LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE dept_no = 'd009' GROUP BY year)
SELECT cte_1.year, d001, d002, d003, d004, d005, d006, d007, d008, d009, ROUND((d001 + d002 + d003 + d004 + d005 + d006 + d007 + d008 + d009) / 9, 2) AS avg
FROM cte_1, cte_2, cte_3, cte_4, cte_5, cte_6, cte_7, cte_8, cte_9 
WHERE cte_1.year = cte_2.year
	AND cte_2.year = cte_3.year
    AND cte_3.year = cte_4.year
    AND cte_4.year = cte_5.year
    AND cte_5.year = cte_6.year
    AND cte_6.year = cte_7.year
    AND cte_7.year = cte_8.year
    AND cte_8.year = cte_9.year
ORDER BY cte_1.year ASC;

-- ==============================================================================================================================
# 4. Покажите для каждого года самый крупный отдел (по количеству сотрудников в этом году) и его среднюю зарплату.

SELECT year, dept_no AS largest_dept_by_emp_q, emp_quantity, avg_salary
FROM	(SELECT dept_no, year, emp_quantity, avg_salary, 
			ROW_NUMBER() OVER (PARTITION BY year ORDER BY emp_quantity DESC) AS row_numb_2
		FROM	(SELECT dept_no, year, 
					COUNT(emp_no) OVER (PARTITION BY dept_no, year) AS emp_quantity,
                    ROUND(AVG(salary) OVER (PARTITION BY dept_no, year), 2) AS avg_salary, 
					ROW_NUMBER() OVER (PARTITION BY dept_no, year) AS row_numb_1
				FROM	(SELECT es.emp_no, es.salary, dept_no, YEAR(es.from_date) AS year	
						FROM employees.salaries AS es
							LEFT JOIN employees.dept_emp AS ede ON (ede.emp_no = es.emp_no 
								AND es.from_date BETWEEN ede.from_date AND ede.to_date)) AS s_1) AS s_2
		WHERE row_numb_1 = 1) AS s_3
WHERE row_numb_2 = 1
ORDER BY year ASC;

-- ==============================================================================================================================
# 5. Покажите подробную информацию о менеджере, который дольше всех исполняет свои обязанности на данный момент.

SELECT * 
FROM	(SELECT *, IF (years_on_curr_title = MAX(years_on_curr_title) OVER (), 'max', 'not_max') AS max_years_on_curr_title_or_not
		FROM	(SELECT
					et_1.emp_no, et_1.title AS curr_title, YEAR(CURDATE()) - YEAR(et_1.from_date) AS years_on_curr_title,
					ede.dept_no, ed.dept_name,
					ee.birth_date, CONCAT(ee.first_name, ' ', ee.last_name) AS full_name, ee.gender, ee.hire_date,
					et_2.title AS all_titles, CONCAT(et_2.from_date, ' - ', et_2.to_date) AS title_period,
					es.salary AS salaries, YEAR(es.from_date) AS year 
				FROM employees.titles AS et_1
					INNER JOIN employees.employees AS ee ON(ee.emp_no = et_1.emp_no)
					LEFT JOIN employees.titles AS et_2 ON(et_2.emp_no = et_1.emp_no)
					LEFT JOIN employees.salaries AS es ON(es.emp_no = et_2.emp_no AND es.from_date BETWEEN et_2.from_date AND et_2.to_date)
					LEFT JOIN employees.dept_emp AS ede ON(ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
					INNER JOIN employees.departments AS ed ON(ed.dept_no = ede.dept_no)
				WHERE et_1.title = 'Manager'
					AND CURDATE() BETWEEN et_1.from_date AND et_1.to_date) AS s_1) AS s_2
WHERE max_years_on_curr_title_or_not = 'max'
ORDER BY year DESC;

-- ==============================================================================================================================
# 6. Покажите топ-10 нынешних сотрудников компании с наибольшей разницей между их зарплатой и текущей средней зарплатой в их отделе.

SELECT es.emp_no, CONCAT(ee.first_name, ' ', ee.last_name) AS full_name, es.salary AS curr_salary, s_1.dept_no, ROUND(s_1.avg_salary, 0) AS dept_avg_sal,
	ROUND(ABS(es.salary - s_1.avg_salary), 0) AS abs_diff_btw_sal_and_avg_sal
FROM employees.salaries AS es
	INNER JOIN employees.employees AS ee ON(ee.emp_no = es.emp_no)
	LEFT JOIN employees.dept_emp AS ede ON(ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
    LEFT JOIN 	(SELECT dept_no, ROUND(AVG(salary), 2) AS avg_salary
				FROM employees.dept_emp AS ede LEFT JOIN employees.salaries AS es USING (emp_no)
				WHERE CURDATE() BETWEEN ede.from_date AND ede.to_date	AND CURDATE() BETWEEN es.from_date AND es.to_date
				GROUP BY dept_no) AS s_1 ON (s_1.dept_no = ede.dept_no)
WHERE CURDATE() BETWEEN es.from_date AND es.to_date
ORDER BY abs_diff_btw_sal_and_avg_sal DESC
LIMIT 10;

-- ==============================================================================================================================
/* 7. Из-за кризиса на одно подразделение на своевременную выплату зарплаты выделяется всего 500 тысяч долларов. 
Правление решило, что низкооплачиваемые сотрудники будут первыми получать зарплату. 
Показать список всех сотрудников, которые будут вовремя получать зарплату 
(обратите внимание, что мы должны платить зарплату за один месяц, но в базе данных мы храним годовые суммы). */

SELECT * 
FROM	(SELECT *, SUM(month_salary) OVER (PARTITION BY dept_no ORDER BY dept_no, month_salary, emp_no) AS cumulative_salary
		FROM	(SELECT ede.dept_no, es.emp_no, ROUND(es.salary / 12, 2) AS month_salary
				FROM employees.salaries AS es 
					LEFT JOIN employees.dept_emp AS ede ON(ede.emp_no = es.emp_no AND es.from_date BETWEEN ede.from_date AND ede.to_date)
				WHERE CURDATE() BETWEEN es.from_date AND es.to_date) AS s_1) AS s_2
WHERE cumulative_salary < 500000;

-- ==============================================================================================================================







-- ================================================ Дизайн базы данных: =========================================================
-- ==============================================================================================================================
/* 1. Разработайте базу данных для управления курсами. База данных содержит следующие сущности:
	a. students: student_no, teacher_no, course_no, student_name, email, birth_date.
	b. teachers: teacher_no, teacher_name, phone_no
	c. courses: course_no, course_name, start_date, end_date.
● Секционировать по годам, таблицу students, по полю birth_date с помощью механизма range
● В таблице students сделать первичный ключ в сочетании двух полей student_no и birth_date
● Создать индекс по полю students.email
● Создать уникальный индекс по полю teachers.phone_no */

DROP DATABASE IF EXISTS courses;
CREATE DATABASE courses;
USE courses;

CREATE TABLE students (
	student_no		INT NOT NULL,
	teacher_no		INT NOT NULL,
	course_no		INT NOT NULL,
	student_name	VARCHAR(50) NOT NULL, 
	email			VARCHAR(100) NOT NULL, 
	birth_date		DATE NOT NULL, 
	PRIMARY KEY		(student_no, birth_date)
    
) PARTITION BY RANGE (YEAR(birth_date))
	(PARTITION p0 VALUES LESS THAN (1985),
	PARTITION p1 VALUES LESS THAN (1986),
	PARTITION p2 VALUES LESS THAN (1987),
	PARTITION p3 VALUES LESS THAN (1988),
	PARTITION p4 VALUES LESS THAN (1989),
	PARTITION p5 VALUES LESS THAN (1990),
	PARTITION p6 VALUES LESS THAN (1991),
    PARTITION p7 VALUES LESS THAN (1992),
	PARTITION p8 VALUES LESS THAN (1993),
	PARTITION p9 VALUES LESS THAN (1994),
	PARTITION p10 VALUES LESS THAN (1995),
	PARTITION p11 VALUES LESS THAN (1996),
	PARTITION p12 VALUES LESS THAN (1997),
	PARTITION p13 VALUES LESS THAN (1998),
	PARTITION p14 VALUES LESS THAN (1999),
	PARTITION p15 VALUES LESS THAN (2000),
	PARTITION p16 VALUES LESS THAN (2001),  
	PARTITION p17 VALUES LESS THAN MAXVALUE);

CREATE INDEX index_student_email ON courses.students(email);

CREATE TABLE teachers (
	teacher_no		INT NOT NULL,
	teacher_name	VARCHAR(50) NOT NULL,
	phone_no		VARCHAR(50) NOT NULL
);

CREATE UNIQUE INDEX unique_index_teachers_phone ON courses.teachers(phone_no);

CREATE TABLE courses (
	course_no		INT NOT NULL,
	course_name		VARCHAR(50) NOT NULL,
	start_date		DATE NOT NULL,
	end_date		DATE NOT NULL
);

-- ==============================================================================================================================
# 2. На свое усмотрение добавить тестовые данные (7-10 строк) в наши три таблицы.

INSERT INTO students VALUES 
	(1, 10, 20, 'st_name_1', 'email_1@g.com', '1980-05-15'),
    (2, 10, 20, 'st_name_2', 'email_2@g.com', '1985-05-15'),
    (3, 10, 20, 'st_name_3', 'email_3@g.com', '1990-05-15'),
    (4, 10, 20, 'st_name_4', 'email_4@g.com', '1995-05-15'),
    (5, 11, 21, 'st_name_5', 'email_5@g.com', '2000-05-15'),
    (6, 11, 21, 'st_name_6', 'email_6@g.com', '2001-05-15'),
    (7, 11, 21, 'st_name_7', 'email_7@g.com', '2005-05-15');
    
INSERT INTO teachers VALUES 
	(10, 't_name_10', '+380-00-111-22-33'),
    (11, 't_name_11', '+380-00-111-22-44'),
    (12, 't_name_12', '+380-00-111-22-55'),
    (13, 't_name_13', '+380-00-111-22-66'),
    (14, 't_name_14', '+380-00-111-22-77'),
    (15, 't_name_15', '+380-00-111-22-88'),
    (16, 't_name_16', '+380-00-111-22-99');
    
INSERT INTO courses VALUES 
	(20, 'c_name_20', CURDATE(), CURDATE() + 7),
    (21, 'c_name_21', CURDATE(), CURDATE() + 7),
    (22, 'c_name_22', CURDATE(), CURDATE() + 7),
    (23, 'c_name_23', CURDATE(), CURDATE() + 7),
    (24, 'c_name_24', CURDATE(), CURDATE() + 14),
    (25, 'c_name_25', CURDATE(), CURDATE() + 14),
    (26, 'c_name_26', CURDATE(), CURDATE() + 14);  
    
-- ==============================================================================================================================
# 3. Отобразить данные за любой год из таблицы students и зафиксировать в виде комментария план выполнения запроса, где будет видно что запрос будет выполняться по конкретной секции.

SELECT * FROM courses.students PARTITION (p6);

/* # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'students', 'p6', 'ALL', NULL, NULL, NULL, NULL, '1', '100.00', NULL */

-- ==============================================================================================================================
/* 4. Отобразить данные учителя, по любому одному номеру телефона и зафиксировать план выполнения запроса, где будет видно, что запрос будет выполняться по индексу, а не методом ALL. 
Далее индекс из поля teachers.phone_no сделать невидимым и зафиксировать план выполнения запроса, где ожидаемый результат - метод ALL. В итоге индекс оставить в статусе - видимый. */ 

SELECT * FROM courses.teachers
WHERE phone_no = '+380-00-111-22-88';
/* # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'teachers', NULL, 'const', 'unique_index_teachers_phone', 'unique_index_teachers_phone', '202', 'const', '1', '100.00', NULL */

/* ALTER TABLE courses.teachers 
ALTER INDEX unique_index_teachers_phone INVISIBLE;
Error Code: 3522. A primary key index cannot be invisible 
По-этому использовал IGNORE INDEX */

SELECT * FROM courses.teachers IGNORE INDEX (unique_index_teachers_phone)
WHERE phone_no = '+380-00-111-22-88';
/* # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'teachers', NULL, 'ALL', NULL, NULL, NULL, NULL, '7', '14.29', 'Using where' */

SELECT * FROM courses.teachers FORCE INDEX (unique_index_teachers_phone)
WHERE phone_no = '+380-00-111-22-88';

-- ==============================================================================================================================
# 5. Специально сделаем 3 дубляжа в таблице students (добавим еще 3 одинаковые строки).

/* Одинаковые строки добавить не получится, так как существует первичный ключ в сочетании двух полей student_no и birth_date.
(Error Code: 1062. Duplicate entry '8-2005-05-20' for key 'students.PRIMARY')
Сделаем одинаковые строки за исключением даты рождения, и добавим в таблицу. */

INSERT INTO students VALUES 
	(8, 12, 22, 'st_name_8', 'email_8@g.com', '2005-05-20'),
    (8, 12, 22, 'st_name_8', 'email_8@g.com', '2005-05-21'),
    (8, 12, 22, 'st_name_8', 'email_8@g.com', '2005-05-22');
    
-- ==============================================================================================================================
# 6. Написать запрос, который выводит строки с дубляжами.

SELECT *
FROM	(SELECT *, COUNT(student_no) OVER(PARTITION BY student_no) AS doublings_quantity
		FROM courses.students) AS s_1
WHERE doublings_quantity > 1;

-- ==============================================================================================================================
