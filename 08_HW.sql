-- Zelenkov V.
-- SQL HW 8 CREATE.

---------------------------------------------------------------------------------------------------------------------------------
# 1. В схеме employees, в таблице employees добавить новый столбец - lang_no (int).

USE employees;

ALTER TABLE employees.employees
	ADD COLUMN lang_no INT NOT NULL;
---------------------------------------------------------------------------------------------------------------------------------
# 2. Обновить столбец lang_no значением "1" для всех у кого год прихода на работу 1985 и 1988. Остальным сотрудникам обновить значение "2".

UPDATE employees.employees SET
	lang_no = CASE
		WHEN YEAR(hire_date) IN ('1985', '1988') THEN 1
        ELSE 2
        END;
---------------------------------------------------------------------------------------------------------------------------------
# 3. В схеме temp_db, создать новую таблицу language с двумя полями lang_no (int) и lang_name (varchar(3)).

USE temp_db;

CREATE TABLE language (
    lang_no		INT         NOT NULL,
    lang_name	VARCHAR(3)	NOT NULL
);
---------------------------------------------------------------------------------------------------------------------------------
# 4. Добавить в таблицу temp_db.language две строки: 1 - ukr, 2 - rus.

INSERT INTO language VALUES
	(1, 'ukr'),
    (2, 'rus');
---------------------------------------------------------------------------------------------------------------------------------
# 5. Связать таблицы из схемы employees и temp_db чтобы показать всю информацию из таблицы employees и один столбец lang_name из таблицы language (столбцы lang_no не отображать).

SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, lang_name
FROM employees.employees
INNER JOIN temp_db.language USING (lang_no);
---------------------------------------------------------------------------------------------------------------------------------
# 6. На основе запроса из 5-го задания, создать вью employees_lang.

CREATE VIEW v1_employees_lang AS
	SELECT emp_no, birth_date, first_name, last_name, gender, hire_date, lang_name
	FROM employees.employees
	INNER JOIN temp_db.language USING (lang_no);
---------------------------------------------------------------------------------------------------------------------------------
# 7. Через вью employees_lang вывести количество сотрудников в разрезе языка.

SELECT lang_name, COUNT(emp_no) AS emp_quantity
FROM temp_db.v1_employees_lang
GROUP BY lang_name;
---------------------------------------------------------------------------------------------------------------------------------
