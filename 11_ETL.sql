-- Zelenkov V. 
-- ETL Exercises 1


-- ==============================================================================================================================
/* 1. Создать процедуру добавления нового сотрудника, с нужным перечнем входящий параметров. 
После успешной работы процедуры данные должны попасть в таблицы employees, dept_emp, salaries и titles; 
Вычисление emp_no, вычисляем по формуле max(emp_no)+1. 
Если передана не существующая должность, тогда показать ошибку с нужным текстом. 
Если передана зарплата меньше 30000, тогда показать ошибку с нужным текстом. */

DELIMITER //
CREATE PROCEDURE add_new_emp	(IN pr_emp_no INT,
								IN pr_birth_date DATE,
								IN pr_first_name VARCHAR(14),
								IN pr_last_name VARCHAR(16),
								IN pr_gender ENUM('M','F'),
								IN pr_dept_no CHAR(4),
								IN pr_salary INT,
								IN pr_title VARCHAR(50))
	BEGIN
		IF pr_title NOT IN (SELECT et.title FROM employees.titles AS et)
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Title does not exist';
		END IF;

		IF pr_salary < 30000
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Salary less then 30000';
		END IF;

		INSERT INTO employees.employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
			VALUES(pr_emp_no, pr_birth_date, pr_first_name, pr_last_name, pr_gender, CURDATE());
            
		INSERT INTO employees.dept_emp (emp_no, dept_no, from_date, to_date)
			VALUES(pr_emp_no, pr_dept_no, CURDATE(), '9999-01-01');
            
		INSERT INTO employees.salaries (emp_no, salary, from_date, to_date)
			VALUES(pr_emp_no, pr_salary, CURDATE(), '9999-01-01');
            
		INSERT INTO employees.titles (emp_no, title, from_date, to_date)
			VALUES(pr_emp_no, pr_title, CURDATE(), '9999-01-01');
	END;
//

# CALL employees.add_new_emp ((SELECT MAX(emp_no)+1 FROM employees.employees), '1975-12-25', 'First_t3', 'Last_t3', 'M', 'd004', 55000, 'Engineer');
-- ==============================================================================================================================
/* 2. Создать процедуру для обновления зарплаты по сотруднику.
При обновлении зарплаты, нужно закрыть последнюю активную запись текущей датой, и создавать новую историческую запись текущей датой. 
Если передан не существующий сотрудник, тогда показать ошибку с нужным текстом. */

DELIMITER //
CREATE PROCEDURE update_salary	(IN pr_emp_no INT,
                                IN pr_salary INT)
	BEGIN
		IF pr_emp_no NOT IN (SELECT es.emp_no FROM employees.salaries AS es)
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Employee does not exist';
		END IF;

		UPDATE employees.salaries
			SET to_date = CURDATE()
		WHERE emp_no = pr_emp_no
		ORDER BY to_date DESC LIMIT 1; 
        
		INSERT INTO employees.salaries (emp_no, salary, from_date, to_date)
			VALUES (pr_emp_no, pr_salary, CURDATE(), '9999-01-01');
	END;
//

# CALL employees.update_salary (500002, 56000);
-- ==============================================================================================================================
/* 3. Создать процедуру для увольнения сотрудника, закрытия исторических записей в таблицах dept_emp, salaries и titles. 
Если передан несуществующий номер сотрудника, показать ошибку с нужным текстом. */

DELIMITER //
CREATE PROCEDURE employee_dismissal	(IN pr_emp_no INT)
	BEGIN
		IF pr_emp_no NOT IN (SELECT es.emp_no FROM employees.salaries AS es)
			THEN
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Employee does not exist';
		END IF;

		UPDATE employees.salaries
			SET to_date = CURDATE()
		WHERE emp_no = pr_emp_no
		ORDER BY to_date DESC LIMIT 1;
        
        UPDATE employees.dept_emp
			SET to_date = CURDATE()
		WHERE emp_no = pr_emp_no
		ORDER BY to_date DESC LIMIT 1;
        
        UPDATE employees.titles
			SET to_date = CURDATE()
		WHERE emp_no = pr_emp_no
		ORDER BY to_date DESC LIMIT 1;        
	END;
//

# CALL employees.employee_dismissal (500002);
-- ==============================================================================================================================
# 4. Создать функцию, которая выводила бы текущую зарплату по сотруднику.

DELIMITER //
CREATE FUNCTION get_curr_salary	(f_emp_no INT )
	RETURNS INT DETERMINISTIC
BEGIN
	DECLARE f_curr_salary INT;
	
	SELECT es.salary
	INTO f_curr_salary
	FROM employees.salaries AS es 
	WHERE CURDATE() BETWEEN es.from_date AND es.to_date
		AND f_emp_no = es.emp_no;
	
	RETURN f_curr_salary;
 END
 //
 
/* SELECT *, get_curr_salary (emp_no)
FROM employees.employees
ORDER BY emp_no DESC;

SELECT get_curr_salary (500002); */
-- ==============================================================================================================================
