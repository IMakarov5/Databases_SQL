/*
Базы данных и SQL (семинары)
Урок 6. SQL – Транзакции. Временные таблицы, управляющие конструкции, циклы

Для решения задач используйте базу данных lesson4
(скрипт создания, прикреплен к 4 семинару).
*/

-- используем БД, созданную в Homework_4 
USE Homework_4;

/*
Задание 1 

Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить 
любого (одного) пользователя из таблицы users в таблицу users_old. 

(использование транзакции с выбором commit или rollback – обязательно).
*/

-- Создайте таблицу users_old, аналогичную таблице users.
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

-- Процедура, которая может переместить любого (одного) пользователя
DROP PROCEDURE IF EXISTS sp_user_move;
DELIMITER //
CREATE PROCEDURE sp_user_move(
IDUser bigint,
OUT  tran_result varchar(100))
BEGIN
	
	DECLARE `_rollback` BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;

	START TRANSACTION;
  

   INSERT INTO users_old (firstname, lastname, email)
	 SELECT u.firstname, u.lastname, u.email from users u WHERE u.id = IDUser ;
	
	DELETE FROM users WHERE id = IDUser;
	

	IF `_rollback` THEN
		SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'O K';
		COMMIT;
	END IF;
END//
DELIMITER ;


CALL sp_user_move(1, @tran_result); 
SELECT @tran_result;

SELECT * FROM users_old;


/*
Задание 2 

Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 

С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(50) READS SQL DATA 
BEGIN
	DECLARE hello_r VARCHAR(50); 

	SET hello_r = (
	SELECT 
    CASE 
		WHEN HOUR(CURTIME()) BETWEEN 0 AND 6 THEN 'Доброй ночи'
	    WHEN HOUR(CURTIME()) BETWEEN 6 AND 12 THEN 'Доброе утро'
		WHEN HOUR(CURTIME()) BETWEEN 12 AND 18 THEN 'Добрый день'
		ELSE 'Добрый вечер'
	END AS hello
	);

	RETURN hello_r;
END//
DELIMITER ;

-- вызов функции
SELECT hello();


/*
Задание 3 

(по желанию)* Создайте таблицу logs типа Archive. Пусть при 
каждом создании записи в таблицах users, communities и messages 
в таблицу logs помещается 
время и дата создания записи, 
название таблицы, 
идентификатор первичного ключа.
*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id SERIAL, 
    add_datetime DATETIME DEFAULT NOW(), -- время и дата создания записи
    table_name ENUM('users', 'communities', 'messages'), -- название таблицы
    pri_key bigint NOT NULL -- идентификатор первичного ключа
);

SELECT * FROM logs;



-- триггер для users
DROP TRIGGER if exists archive_users_after_insert;
DELIMITER //
CREATE TRIGGER archive_users_after_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs(table_name, pri_key) 
    VALUES ('users', NEW.ID);
	
END//
DELIMITER ;

-- триггер для communities
DROP TRIGGER if exists archive_communities_after_insert;
DELIMITER //
CREATE TRIGGER archive_communities_after_insert AFTER INSERT ON communities
FOR EACH ROW
BEGIN
    INSERT INTO logs(table_name, pri_key) 
    VALUES ('communities', NEW.ID);
	
END//
DELIMITER ;

-- триггер для messages
DROP TRIGGER if exists archive_messages_after_insert;
DELIMITER //
CREATE TRIGGER archive_messages_after_insert AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    INSERT INTO logs(table_name, pri_key) 
    VALUES ('messages', NEW.ID);
	
END//
DELIMITER ;

-- Проверка триггеров

SELECT * FROM users;

INSERT INTO users (id, firstname, lastname, email) VALUES 
(11, 'Reuben', 'Nienow', 'arlo501@example.org'),
(21, 'Frederik', 'Upton', 'terrence.cartwright1@example.org');

SELECT * FROM communities;

INSERT INTO `communities` (name) 
VALUES ('atque1'), ('beatae1'), ('est1'), ('eum1'), ('hic1');

SELECT * FROM messages;

INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(11, 21, 'Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(21, 11, 'Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',  DATE_ADD(NOW(), INTERVAL 3 MINUTE)),
(21, 11, 'Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.',  DATE_ADD(NOW(), INTERVAL 5 MINUTE)),
(21, 11, 'Quod dicta omnis placeat id et officiis et. Beatae enim aut aliquid neque occaecati odit. Facere eum distinctio assumenda omnis est delectus magnam.',  DATE_ADD(NOW(), INTERVAL 11 MINUTE));

SELECT * FROM logs;
