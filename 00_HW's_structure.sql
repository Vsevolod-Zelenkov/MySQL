


-- HW 1 -- SELECT COUNT DISTINCT FROM WHERE GROUP BY HAVING ORDER BY
---------------------------------------------------------------------------------------------------------------------------------
-- Task 1. -- List all female employees who joined at 01/01/1990 or at 01/01/2000.
-- Task 2. -- Show the name of all employees who have an equal first and last name.
-- Task 3. -- Show employees numbers 10001,10002,10003 and 10004, select columns first_name, last_name, gender, hire_date.
-- Task 4. -- Select the names of all departments whose names have ‘a’ character on any position or ‘e’ on the second place.
-- Task 5. -- Show employees who satisfy the following description: He(!) was 45 when hired, born in October and was hired on Sunday.
-- Task 6. -- Show the maximum annual salary in the company after 01/06/1995.
-- Task 7. 	-- In the dept_emp table, show the quantity of employees by department (dept_no).
			-- To_date must be greater than current_date.
			-- Show departments with more than 13,000 employees.
			-- Sort by quantity of employees.
-- Task 8. -- Show the minimum and maximum salaries by employee.
---------------------------------------------------------------------------------------------------------------------------------



-- HW 2 -- TO_DAYS JOIN ROUND DAYNAME CASE WHEN UNION
---------------------------------------------------------------------------------------------------------------------------------
/* 1. For the current maximum annual wage in the company, SHOW the full name of the employee, department, current position,
for how long the current position is held, and total years of service in the company. */
# 2. For each department, show its name and current manager’s name, last name, and current salary.
# 3. Show for each employee, their current salary and their current manager’s current salary.
# 4. Show all employees that currently earn more than their managers.
# 5. Show how many employees currently hold each title, sorted in descending order by the number of employees.
# 6. Show the full name of all employees who were employed in more than one department.
# 7. Show the average salary and maximum salary in thousands of dollars for every year.
# 8. Show how many employees were hired on weekends (Saturday + Sunday), split by gender.
/* 9. Fulfill the script below to achieve the following data:
Group all employees according to their age at January 1st, 1995 into four groups:
30 or younger, 31-40, 41-50 and older. Show average salary for each group and gender,
8 categories in total. Also add subtotals and grand total. */
---------------------------------------------------------------------------------------------------------------------------------



-- HW 3 -- WITH CTE AS ABS JOIN LEAD() OVER (PARTITION BY - ORDER BY - ) UNION WITH RECURSIVE
---------------------------------------------------------------------------------------------------------------------------------
/* 1. For the current maximum annual wage in the company, SHOW the full name of an employee, department, current position, 
for how long the current position is held, and total years of service in the company. USE common table expression this time. */
/* 2. From MySQL documentation check how ABS() function works. 
https://dev.mysql.com/doc/refman/8.0/en/mathematical-functions.html#function_abs */
/* 3. Show all information about the employee, salary year, and the difference between salary and average salary in the company overall. 
For the employee, whose salary was assigned latest from salaries that are closest to mean salary overall (doesn’t matter higher or lower). 
Here you need to find the average salary overall and then find the smallest difference of someone’s salary with an average salary. 
Покажите всю информацию о сотруднике, зарплату за год и разницу между зарплатой и средней зарплатой в целом по компании. 
Для сотрудника, чья зарплата была назначена последней из зарплат, наиболее близких к средней зарплате в целом (неважно, выше или ниже). 
Здесь нужно найти среднюю зарплату в целом, а затем найти наименьшую разницу чьей-то зарплаты со средней зарплатой. */
/* 4. Select the details, title, and salary of the employee with the highest salary who is not employed in the company anymore.
Выберите данные, должность и зарплату сотрудника с самой высокой зарплатой, который больше не работает в компании. */
/* 5. Show Full Name, salary, and year of the salary for top 5 employees that have the highest one-time raise in salary (in absolute numbers). 
Also, attach the top 5 employees that have the highest one-time raise in salary (in percent).  
One-time rise here means the biggest difference between the two consecutive years.
Укажите ФИО, размер заработной платы и год, в котором она была повышена, для 5 лучших сотрудников, которые имеют наибольшее единовременное повышение заработной платы (в абсолютных цифрах). 
Также укажите 5 лучших сотрудников, у которых наибольшее единовременное повышение зарплаты (в процентах).  
Единовременное повышение здесь означает наибольшую разницу между двумя последовательными годами. */
/* 6. Generate a sequence of square numbers till 9 (1^2, 2^2... 9^2)
Сгенерируйте последовательность квадратных чисел до 9 (1^2, 2^2... 9^2) */
---------------------------------------------------------------------------------------------------------------------------------



-- HW 4 -- JOIN UNION SUBQUERY
---------------------------------------------------------------------------------------------------------------------------------
# 1. Показать для каждого сотрудника его текущую зарплату и текущую зарплату текущего руководителя.
# 2. Показать всех сотрудников, которые в настоящее время зарабатывают больше, чем их руководители.
/* 3. Из таблицы dept_manager 
первым запросом выбрать данные по актуальным менеджерам департаментов и сделать свой столбец “checks” со значением ‘actual’.
Вторым запросом из этой же таблицы dept_manager выбрать НЕ актуальных менеджеров департаментов и сделать свой столбец “checks” со значением ‘old’.
Объединить результат двух запросов через union. */
# 4. К результату всех строк таблицы departments, добавить еще две строки со значениями “d010”, “d011” для dept_no и “Data Base”, “Help Desk” для dept_name.
# 5. Найти emp_no актуального менеджера из департамента ‘d003’, далее через подзапрос из таблицы сотрудников вывести по нему информацию.
# 6. Найти максимальную дату приема на работу, далее через подзапрос из таблицы сотрудников вывести по этой дате информацию по сотрудникам.
---------------------------------------------------------------------------------------------------------------------------------



-- HW 5 -- SUBQUERY WHERE EXISTS CREATE TABLE DELETE UPDATE INSERT INTO
---------------------------------------------------------------------------------------------------------------------------------
# 1. Отобразить информацию из таблицы сотрудников и через подзапрос добавить его текущую должность.
# 2. Отобразить информацию из таблицы сотрудников, которые в прошлом были с должностью 'Engineer'. (exists)
# 3. Отобразить информацию из таблицы сотрудников, у которых актуальная зарплата от 50 тысяч до 75 тысяч. (in)
# 4. Создать копию таблицы employees с помощью этого SQL скрипта: create table employees_dub as select * from employees;
# 5. Из таблицы employees_dub удалить сотрудников которые были наняты в 1985 году.
# 6. В таблице employees_dub сотруднику под номером 10008 изменить дату приема на работу на ‘1994-09-01’.
# 7. В таблицу employees_dub добавить двух произвольных сотрудников.
---------------------------------------------------------------------------------------------------------------------------------



-- HW 6 -- DROP DATABASE CREATE PRIMARY KEY FOREIGN KEY REFERENCES DROP COLUMN RENAME TRUNCATE
---------------------------------------------------------------------------------------------------------------------------------
/* 1. Создать таблицу client с полями:
• clnt_no ( AUTO_INCREMENT первичный ключ)
• cnlt_name (нельзя null значения)
• clnt_tel (нельзя null значения)
• clnt_region_no */
/* 2. Создать таблицу sales с полями:
• clnt_no (внешний ключ на таблицу client поле clnt_no; режим RESTRICT для
update и delete)
• product_no (нельзя null значения)
• date_act (по умолчанию текущая дата) */
# 3. Добавить 5 клиентов (тестовые данные на свое усмотрение) в таблицу client.
# 4. Добавить по 2 продажи для каждого сотрудника (тестовые данные на свое усмотрение ) в таблицу sales.
# 5. Из таблицы client, попробовать удалить клиента с clnt_no=1 и увидеть ожидаемую ошибку. Ошибку зафиксировать в виде комментария через /* ошибка */.
# 6. Удалить из sales клиента по clnt_no=1, после чего повторить удаление из client по clnt_no=1 (ошибки в таком порядке не должно быть).
# 7. Из таблицы client удалить столбец clnt_region_no.
# 8. В таблице client переименовать поле clnt_tel в clnt_phone.
# 9. Удалить данные в таблице departments_dup с помощью DDL оператора truncate.
---------------------------------------------------------------------------------------------------------------------------------



-- HW 7 -- INDEX CREATE TABLE PARTITION BY RANGE CREATE INDEX EXPLAIN CSV
---------------------------------------------------------------------------------------------------------------------------------
/* 1. В схеме temp_db создать таблицу dept_emp с делением по партициям по полю from_date. 
Для этого:
- Из базы данных employees таблицы dept_emp → из Info-Table inspector-DDL взять и скопировать код по созданию той таблицы.
- Убрать из DDL кода упоминание про KEY и CONSTRAINT.
- И добавить код для секционирования по полю from_date с 1985 года до 2002. Партиции по каждому году.
HINT: CREATE TABLE... PARTITION BY RANGE (YEAR(from_date)) (PARTITION...) */
# 2. Создать индекс на таблицу temp_db.dept_emp по полю dept_no.
# 3. Из таблицы temp_db.dept_emp выбрать данные только за 1990 год.
# 4. На основе предыдущего задания, через explain убедиться что сканирование данных идет только по одной секции. Зафиксировать в виде комментария через /* вывод из explain */.
-- HINT: EXPLAIN SELECT ... FROM ... WHERE ...
# 5. Загрузить свой любой CSV файл в схему temp_db.
-- HINT: LOAD DATA INFILE ... INTO TABLE ...
---------------------------------------------------------------------------------------------------------------------------------



-- HW 8 -- CREATE ADD COLUMN UPDATE with CASE CREATE VIEW
---------------------------------------------------------------------------------------------------------------------------------
# 1. В схеме employees, в таблице employees добавить новый столбец - lang_no (int).
# 2. Обновить столбец lang_no значением "1" для всех у кого год прихода на работу 1985 и 1988. Остальным сотрудникам обновить значение "2".
# 3. В схеме temp_db, создать новую таблицу language с двумя полями lang_no (int) и lang_name (varchar(3)).
# 4. Добавить в таблицу temp_db.language две строки: 1 - ukr, 2 - rus.
# 5. Связать таблицы из схемы employees и temp_db чтобы показать всю информацию из таблицы employees и один столбец lang_name из таблицы language (столбцы lang_no не отображать).
# 6. На основе запроса из 5-го задания, создать вью employees_lang.
# 7. Через вью employees_lang вывести количество сотрудников в разрезе языка.
---------------------------------------------------------------------------------------------------------------------------------



-- HW 9 -- WINDOW FUNCTIONS FIRST_VALUE() OVER (PARTITION BY.. JOIN ROW_NUMBER NTH_VALUE RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING CASE WHEN 
-- SELECT ROW_NUMBER () OVER (ORDER BY) FROM (WITH cte_1.. GROUP BY WITH ROLLUP
---------------------------------------------------------------------------------------------------------------------------------
# 1. Отобразить сотрудников и напротив каждого, показать информацию о разнице текущей и первой зарплаты.
# 2. Отобразить департаменты и сотрудников, которые получают наивысшую зарплату в своем департаменте.
# 3. Из таблицы должностей, отобразить сотрудника с его текущей должностью и предыдущей.
-- HINT OVER(PARTITION BY ... ORDER BY ... ROWS 1 preceding)
# 4. Из таблицы должностей, посчитать интервал в днях - сколько прошло времени от первой должности до текущей.
/* 5. Выбрать сотрудников и отобразить их рейтинг по году принятия на работу. Попробуйте разные типы рейтингов. 
Как вариант можно SELECT с оконными функциями вставить как подзапрос в FROM. */
-- Rating for years with highest number of hired employees
-- Rating for years by share of men in total number of hired employees
---------------------------------------------------------------------------------------------------------------------------------


