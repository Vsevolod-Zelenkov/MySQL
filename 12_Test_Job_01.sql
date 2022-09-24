/* Есть 3 таблицы:

“Installs” - таблица, содержащая информацию об установках с полями:
`app_id`		varchar(100) 
`sum`			varchar(50) 
`install_time	timestamp
`country_code` 	varchar(255) 
`user_id`		varchar(255) 
`os_version`	varchar(255) 

“Visits” - таблица с визитами:
`id`			int(10) 
`user_id`		VARCHAR(255) 
`visit_time`	timestamp
`source`		VARCHAR(2000)
`ip`			VARCHAR(255) 

“Payments” - таблица с информацией о платежах:
`id`			INT(10) 
`user_id`		VARCHAR(255) 
`payment_time` 	TIMESTAMP
`product_id`	VARCHAR(255)
`payment_sum` 	decimal(19,4) */

/* Нужно написать SQL-запросы для расчета:
1. Конверсию во 2-й платеж в течение 14 дней с момента установки для пользователей, установивших приложение в последние 30 дней. 
2. Средний ARPDAU пользователей, установивших приложение в последние 30 дней.*/

-- ==============================================================================================
# 1. Конверсия во 2-й платеж в течение 14 дней с момента установки для пользователей, установивших приложение в последние 30 дней. 
WITH cte_1 AS
	(SELECT COUNT(user_id) AS users_with_1st_payment
	FROM	(SELECT wp.user_id,
				ROW_NUMBER() OVER(PARTITION BY wp.user_id ORDER BY payment_time ASC) AS 1st_or_2nd_payment            
			FROM whaleapp.payments AS wp
				LEFT JOIN whaleapp.installs AS wi_2 ON (wi_2.user_id = wp.user_id AND wi_2.app_id = 'app_1')
			WHERE DATE(payment_time) >	(SELECT MIN(DATE(install_time))
										FROM whaleapp.installs AS wi_1
										WHERE DATE(install_time) > DATE_SUB(CURDATE(), INTERVAL 30 DAY)
											AND app_id = 'app_1')
			AND product_id = 'product_1'
			AND DATE(payment_time) - DATE(install_time) < 14) AS s_wp
	WHERE 1st_or_2nd_payment = 1),
cte_2 AS 
	(SELECT COUNT(user_id) AS users_with_2nd_payment
	FROM	(SELECT wp.user_id,
				ROW_NUMBER() OVER(PARTITION BY wp.user_id ORDER BY payment_time ASC) AS 1st_or_2nd_payment            
			FROM whaleapp.payments AS wp
				LEFT JOIN whaleapp.installs AS wi_2 ON (wi_2.user_id = wp.user_id AND wi_2.app_id = 'app_1')
			WHERE DATE(payment_time) >	(SELECT MIN(DATE(install_time))
										FROM whaleapp.installs AS wi_1
										WHERE DATE(install_time) > DATE_SUB(CURDATE(), INTERVAL 30 DAY)
											AND app_id = 'app_1')	
			AND product_id = 'product_1'
			AND DATE(payment_time) - DATE(install_time) < 14) AS s_wp
	WHERE 1st_or_2nd_payment = 2)
SELECT ROUND(users_with_2nd_payment / users_with_1st_payment * 100, 1) AS сonversion_from_1st_to_2nd_payment
FROM cte_1, cte_2;
-- ==============================================================================================
# 2. Средний ARPDAU пользователей, установивших приложение в последние 30 дней.
-- ARPU = Revenue / Active users
-- ARPDAU: ARPU, рассчитанный за один день, т.е. доход одного дня делится на количество активных пользователей в этот день (DAU). 

-- таблица ARPDAU по дням:
SELECT
	DATE(payment_time) AS date, 
	SUM(payment_sum) AS revenue,
    dau,
    ROUND(SUM(payment_sum) / dau, 4) AS arpdau    
FROM whaleapp.payments
	LEFT JOIN 	(SELECT 
					DATE(visit_time) AS visit_date, 
                    COUNT(DISTINCT(user_id)) AS dau
				FROM whaleapp.visits
				WHERE source = 'source_1'	-- понимаем как визит в конкретное приложение по которому считаем ARPDAU
				GROUP BY visit_date) AS s_wv ON (visit_date = DATE(payment_time))
WHERE product_id = 'product_1'	-- понимаем как платеж из конкретного приложения по которому считаем ARPDAU	
	AND DATE(payment_time) > 	(SELECT MIN(DATE(install_time))
								FROM whaleapp.installs
								WHERE DATE(install_time) > DATE_SUB(CURDATE(), INTERVAL 30 DAY)
									AND app_id = 'app_1')	-- конкретное приложение	
GROUP BY date

UNION ALL
SELECT '', '', '', ''
UNION ALL
SELECT '', '', '', 'avg_arpdau'
UNION ALL

-- средний ARPDAU за последние 30 дней:
SELECT 
	'total', 
    SUM(revenue), 
    SUM(dau), 
    ROUND(SUM(revenue) / SUM(dau), 4) AS avg_arpdau
FROM 	(SELECT
			DATE(payment_time) AS date, 
			SUM(payment_sum) AS revenue,
			dau,
			ROUND(SUM(payment_sum) / dau, 4) AS arpdau    
		FROM whaleapp.payments
			LEFT JOIN 	(SELECT 
							DATE(visit_time) AS visit_date, 
							COUNT(DISTINCT(user_id)) AS dau
						FROM whaleapp.visits
						WHERE source = 'source_1'
						GROUP BY visit_date) AS s_wv ON (visit_date = DATE(payment_time))
		WHERE product_id = 'product_1'
			AND DATE(payment_time) > 	(SELECT MIN(DATE(install_time))
										FROM whaleapp.installs
										WHERE DATE(install_time) > DATE_SUB(CURDATE(), INTERVAL 30 DAY)
											AND app_id = 'app_1')
		GROUP BY date) AS s_arpdau;
-- ==============================================================================================







-- ==============================================================================================
CREATE DATABASE whaleapp;
USE whaleapp;

CREATE TABLE installs (
	app_id			VARCHAR(100),
	sum				VARCHAR(50),
	install_time	TIMESTAMP,
	country_code 	VARCHAR(255), 
	user_id			VARCHAR(255), 
	os_version		VARCHAR(255), 
	PRIMARY KEY		(user_id)
);

INSERT INTO installs VALUES 
	('app_1', '100', '2022-08-05 10:23:24', 'ua', 'user_1', 'android'),
	('app_1', '100', '2022-08-13 10:23:24', 'ua', 'user_2', 'android'),
	('app_2', '200', '2022-08-13 10:23:24', 'ua', 'user_3', 'android'),
	('app_1', '100', '2022-08-13 10:23:24', 'ua', 'user_4', 'android'),
	('app_1', '100', '2022-08-18 10:23:24', 'ua', 'user_5', 'android'),
	('app_1', '100', '2022-08-23 10:23:24', 'ua', 'user_6', 'android'),
	('app_1', '100', '2022-08-23 10:23:24', 'ua', 'user_7', 'android'),
	('app_1', '100', '2022-08-23 10:23:24', 'ua', 'user_8', 'android'),
	('app_1', '100', '2022-08-27 10:23:24', 'ua', 'user_9', 'android'),
	('app_1', '100', '2022-09-03 10:23:24', 'ua', 'user_10', 'android'),
	('app_1', '100', '2022-09-08 10:23:24', 'ua', 'user_11', 'ios');
    
INSERT INTO installs VALUES 
	('app_1', '100', '2022-08-15 10:23:24', 'ua', 'user_12', 'android'),
	('app_1', '100', '2022-08-15 10:23:24', 'ua', 'user_13', 'android'),
	('app_1', '100', '2022-08-25 10:23:24', 'ua', 'user_14', 'android'),
	('app_1', '100', '2022-08-25 10:23:24', 'ua', 'user_15', 'android');

CREATE TABLE visits (
	id				INT(10), 
	user_id			VARCHAR(255), 
	visit_time		TIMESTAMP,
	source			VARCHAR(2000),
	ip				VARCHAR(255), 
	PRIMARY KEY		(user_id),
    FOREIGN KEY		(user_id)	REFERENCES installs(user_id)
);

INSERT INTO visits VALUES 
	('001', 'user_1', '2022-08-05 10:33:24', 'source_1', '123.456.789' ),
    ('002', 'user_2', '2022-08-13 10:33:24', 'source_1', '123.456.789' ),
    ('003', 'user_3', '2022-08-13 10:33:24', 'source_2', '123.456.789' ),
    ('004', 'user_4', '2022-08-13 10:33:24', 'source_1', '123.456.789' ),
    ('005', 'user_5', '2022-08-18 10:33:24', 'source_1', '123.456.789' ),
    ('006', 'user_6', '2022-08-23 10:33:24', 'source_1', '123.456.789' ),
    ('007', 'user_7', '2022-08-23 10:33:24', 'source_1', '123.456.789' ),
    ('008', 'user_8', '2022-08-23 10:33:24', 'source_1', '123.456.789' ),
    ('009', 'user_9', '2022-08-27 10:33:24', 'source_1', '123.456.789' ),
    ('010', 'user_10', '2022-09-03 10:33:24', 'source_1', '123.456.789' ),
    ('011', 'user_11', '2022-09-08 10:33:24', 'source_1', '123.456.789' );
    
INSERT INTO visits VALUES 
	('012', 'user_12', '2022-08-15 10:33:24', 'source_1', '123.456.789' ),
    ('013', 'user_13', '2022-08-15 10:33:24', 'source_1', '123.456.789' ),
    ('014', 'user_14', '2022-08-25 10:33:24', 'source_1', '123.456.789' ),
    ('015', 'user_15', '2022-08-25 10:33:24', 'source_1', '123.456.789' );
    
CREATE TABLE payments (
	id				INT(10), 
	user_id			VARCHAR(255), 
	payment_time 	TIMESTAMP,
	product_id		VARCHAR(255),
	payment_sum 	DECIMAL(19, 4),
	FOREIGN KEY		(user_id)	REFERENCES installs(user_id)
);

INSERT INTO payments VALUES 
	('001', 'user_1', '2022-08-05 10:33:24', 'product_1', 80),
	('002', 'user_2', '2022-08-13 10:33:24', 'product_1', 90),
    ('003', 'user_3', '2022-08-14 10:33:24', 'product_2', 210),
    ('004', 'user_4', '2022-08-15 10:33:24', 'product_1', 100),
    ('005', 'user_5', '2022-08-18 10:33:24', 'product_1', 110),
    ('006', 'user_6', '2022-08-23 10:33:24', 'product_1', 120),
    ('007', 'user_7', '2022-08-23 10:33:24', 'product_1', 130),
    ('008', 'user_8', '2022-08-25 10:33:24', 'product_1', 140),
    ('009', 'user_9', '2022-08-27 10:33:24', 'product_1', 150),
    ('010', 'user_10', '2022-09-03 10:33:24', 'product_1', 170),
    ('011', 'user_11', '2022-09-08 10:33:24', 'product_1', 180);
    
INSERT INTO payments VALUES 
	('012', 'user_12', '2022-08-27 10:33:24', 'product_1', 80);
    
INSERT INTO payments VALUES -- добавлю вторые платежи
	('013', 'user_1', '2022-08-09 10:33:24', 'product_1', 80),
	('014', 'user_2', '2022-08-16 10:33:24', 'product_1', 90),
    ('015', 'user_5', '2022-08-22 10:33:24', 'product_1', 110),
    ('016', 'user_6', '2022-08-26 10:33:24', 'product_1', 120),
    ('017', 'user_8', '2022-08-26 10:33:24', 'product_1', 140),
    ('018', 'user_9', '2022-08-31 10:33:24', 'product_1', 150),
    ('019', 'user_10', '2022-09-07 10:33:24', 'product_1', 170),
    ('020', 'user_11', '2022-09-08 10:33:24', 'product_1', 180);
-- ==============================================================================================
