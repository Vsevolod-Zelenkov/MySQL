-- Zelenkov V.
-- SQL HW 7 INDEX.

---------------------------------------------------------------------------------------------------------------------------------
/* 1. В схеме temp_db создать таблицу dept_emp с делением по партициям по полю from_date. 
Для этого:
- Из базы данных employees таблицы dept_emp → из Info-Table inspector-DDL взять и скопировать код по созданию той таблицы.
- Убрать из DDL кода упоминание про KEY и CONSTRAINT.
- И добавить код для секционирования по полю from_date с 1985 года до 2002. Партиции по каждому году.
HINT: CREATE TABLE... PARTITION BY RANGE (YEAR(from_date)) (PARTITION...) */

DROP DATABASE IF EXISTS temp_db;
CREATE DATABASE temp_db;
USE temp_db;

CREATE TABLE dept_emp (
	emp_no 		INT 		NOT NULL,
	dept_no 	CHAR(4)		NOT NULL,
	from_date	DATE 		NOT NULL,
	to_date 	DATE 		NOT NULL  
) PARTITION BY RANGE (year(from_date))
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
---------------------------------------------------------------------------------------------------------------------------------
# 2. Создать индекс на таблицу temp_db.dept_emp по полю dept_no.

CREATE INDEX index_dept_no ON temp_db.dept_emp(dept_no);
---------------------------------------------------------------------------------------------------------------------------------
# 3. Из таблицы temp_db.dept_emp выбрать данные только за 1990 год.

INSERT INTO temp_db.dept_emp
	SELECT * FROM employees.dept_emp;

SELECT * FROM temp_db.dept_emp
WHERE YEAR(from_date) = 1990;

SELECT * FROM dept_emp PARTITION (p6);
---------------------------------------------------------------------------------------------------------------------------------
# 4. На основе предыдущего задания, через explain убедиться что сканирование данных идет только по одной секции. Зафиксировать в виде комментария через /* вывод из explain */.
-- HINT: EXPLAIN SELECT ... FROM ... WHERE ...

EXPLAIN
SELECT * FROM temp_db.dept_emp
WHERE YEAR(from_date) = 1990;
/* # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'dept_emp', 'p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17', 'ALL', NULL, NULL, NULL, NULL, '328603', '100.00', 'Using where' */

EXPLAIN
SELECT * FROM dept_emp PARTITION (p6);
/* # id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'dept_emp', 'p6', 'ALL', NULL, NULL, NULL, NULL, '20963', '100.00', NULL */

-- С помощью секционирования (партиционирования) на этапе создания таблицы, такой запрос обрабатывается около 6.5 раз быстрее.
---------------------------------------------------------------------------------------------------------------------------------
# 5. Загрузить свой любой CSV файл в схему temp_db.
-- HINT: LOAD DATA INFILE ... INTO TABLE ...

SELECT * FROM temp_db.sales_07_22;

/* Получилось только через Table Data Import Wizard.

Результат SELECT:
# date, client, product, quantity, price, sum, invoice
'2022-07-01 00:00:00', 'Bond', '315/80 R22.5 156/150L DSR 08A DoubleStar', '1', '9200', '9200', '561'
'2022-07-01 00:00:00', 'Vintech', '315/80 R22.5 156/150L DSR 08A DoubleStar', '4', '9200.005', '36800.02', '562'
'2022-07-04 00:00:00', 'Epic', '315/70 R22.5 156/150L TL AVANT 5 HL 3PSF Sava', '2', '15500.005', '31000.01', '563'
'2022-07-04 00:00:00', 'E-Club', '315/70 R22.5 156/150L TL AVANT 5 HL 3PSF Sava', '2', '15500.005', '31000.01', '565'

EXPLAIN SELECT:
# id, select_type, table, partitions, type, possible_keys, key, key_len, ref, rows, filtered, Extra
'1', 'SIMPLE', 'sales_07_22', NULL, 'ALL', NULL, NULL, NULL, NULL, '4', '100.00', NULL

DDL:
CREATE TABLE `sales_07_22` (
  `date` datetime DEFAULT NULL,
  `client` text,
  `product` text,
  `quantity` int DEFAULT NULL,
  `price` double DEFAULT NULL,
  `sum` double DEFAULT NULL,
  `invoice` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci */
---------------------------------------------------------------------------------------------------------------------------------
