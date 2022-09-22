-- Zelenkov V.
-- SQL HW 6.

---------------------------------------------------------------------------------------------------------------------------------
/* 1. Создать таблицу client с полями:
• clnt_no ( AUTO_INCREMENT первичный ключ)
• cnlt_name (нельзя null значения)
• clnt_tel (нельзя null значения)
• clnt_region_no */

DROP DATABASE IF EXISTS hw_6;
CREATE DATABASE hw_6;
USE hw_6;

CREATE TABLE client (
    clnt_no			INT         	AUTO_INCREMENT,
    clnt_name		VARCHAR(14)		NOT NULL,
    clnt_tel		VARCHAR(13)		NOT NULL,
    clnt_region_no	CHAR(5)     	NOT NULL,
    PRIMARY KEY (clnt_no)
);
---------------------------------------------------------------------------------------------------------------------------------
/* 2. Создать таблицу sales с полями:
• clnt_no (внешний ключ на таблицу client поле clnt_no; режим RESTRICT для
update и delete)
• product_no (нельзя null значения)
• date_act (по умолчанию текущая дата) */

CREATE TABLE sales (
    clnt_no		INT				NOT NULL,
    product_no	VARCHAR(10)		NOT NULL,
    date_act	DATE			NOT NULL	DEFAULT (DATE(CURRENT_TIMESTAMP)),
    FOREIGN KEY (clnt_no) 
		REFERENCES client (clnt_no) 
			ON UPDATE RESTRICT 
            ON DELETE RESTRICT
);
---------------------------------------------------------------------------------------------------------------------------------
# 3. Добавить 5 клиентов (тестовые данные на свое усмотрение) в таблицу client.

INSERT INTO client (clnt_name, clnt_tel, clnt_region_no) VALUES
	('name_1', '+380990000001', '03141'),
    ('name_2', '+380990000002', '03142'),
    ('name_3', '+380990000003', '03143'),
    ('name_4', '+380990000004', '03144'),
    ('name_5', '+380990000005', '03145');
---------------------------------------------------------------------------------------------------------------------------------
# 4. Добавить по 2 продажи для каждого сотрудника (тестовые данные на свое усмотрение ) в таблицу sales.

INSERT INTO sales (clnt_no, product_no) VALUES
	(1, '01001'),
    (1, '01002'),
    (2, '02001'),
    (2, '02002'),
    (3, '03001'),
    (3, '03002'),
    (4, '04001'),
    (4, '04002'),
    (5, '05001'),
    (5, '05002');
---------------------------------------------------------------------------------------------------------------------------------
# 5. Из таблицы client, попробовать удалить клиента с clnt_no=1 и увидеть ожидаемую ошибку. Ошибку зафиксировать в виде комментария через /* ошибка */.

DELETE 
FROM client
WHERE clnt_no = 1;

/* Error Code: 1451. Cannot delete or update a parent row: 
a foreign key constraint fails (`hw_6`.`sales`, CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`clnt_no`) REFERENCES `client` (`clnt_no`) ON DELETE RESTRICT ON UPDATE RESTRICT) */
---------------------------------------------------------------------------------------------------------------------------------
# 6. Удалить из sales клиента по clnt_no=1, после чего повторить удаление из client по clnt_no=1 (ошибки в таком порядке не должно быть).

DELETE 
FROM sales
WHERE clnt_no = 1;

DELETE 
FROM client
WHERE clnt_no = 1;
---------------------------------------------------------------------------------------------------------------------------------
# 7. Из таблицы client удалить столбец clnt_region_no.

ALTER TABLE client
	DROP COLUMN clnt_region_no;
---------------------------------------------------------------------------------------------------------------------------------
# 8. В таблице client переименовать поле clnt_tel в clnt_phone.

ALTER TABLE client
	RENAME COLUMN clnt_tel TO clnt_phone;
---------------------------------------------------------------------------------------------------------------------------------
# 9. Удалить данные в таблице departments_dup с помощью DDL оператора truncate.

CREATE TABLE departments_dup LIKE employees.departments;

INSERT INTO departments_dup
	SELECT * FROM employees.departments;

TRUNCATE departments_dup;
---------------------------------------------------------------------------------------------------------------------------------
