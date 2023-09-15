/* 

Базы данных и SQL (семинары)
Урок 1. Установка СУБД, подключение к БД, просмотр и создание таблиц


Задание 1
 
Создайте таблицу с мобильными телефонами (mobile_phones),
используя графический интерфейс. Заполните БД данными.
Добавьте скриншот на платформу в качестве ответа на ДЗ

+----+--------------+--------------+---------------+-------+
| id | product_name | manufacturer | product_count | price |
+----+--------------+--------------+---------------+-------+
|  1 | iPhone X     | Apple        |             3 | 76000 |
|  2 | iPhone 8     | Apple        |             2 | 51000 |
|  3 | Galaxy S9    | Samsung      |             2 | 56000 |
|  4 | Galaxy S8    | Samsung      |             1 | 41000 |
|  5 | P20 Pro      | Huawei       |             5 | 36000 |
+----+--------------+--------------+---------------+-------+

*/ 

-- создаём базу данных
DROP DATABASE IF EXISTS Homework_1;
CREATE DATABASE Homework_1;
USE Homework_1;

-- создаём таблицу с мобильными телефонами (mobile_phones)
CREATE TABLE mobile_phones(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	product_name VARCHAR(45) NOT NULL, 
	manufacturer VARCHAR(45) NOT NULL,
	product_count  INT UNSIGNED,
	price BIGINT UNSIGNED
	
);

-- наполнение 
INSERT INTO mobile_phones (product_name, manufacturer, product_count, price)
VALUES 
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple' , 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8','Samsung', 1, 41000),
('P20 Pro', 'Huawei', 5, 36000);


-- Получить список с информацией обо всех мобильных
SELECT id, product_name, manufacturer, product_count, price FROM mobile_phones;


/*
Задание 2 
 
Выведите название, производителя и цену для товаров,
количество которых превышает 2
 */

-- Получить список мобильных, количество которых превышает 2
SELECT product_name, manufacturer, price FROM mobile_phones WHERE product_count > 2;


/*
Задание 3
 
Выведите весь ассортимент товаров марки “Samsung”
 */

SELECT product_name, product_count, price FROM mobile_phones WHERE manufacturer = 'Samsung';



/*

Задание 4

(по желанию)* С помощью регулярных выражений найти:

4.1. Товары, в которых есть упоминание "Iphone"

4.2. Товары, в которых есть упоминание "Samsung"

4.3. Товары, в которых есть ЦИФРЫ

4.4. Товары, в которых есть ЦИФРА "8"
 */

-- Получить товары, в которых есть упоминание "Iphone"
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones WHERE product_name LIKE '%Iphone%' OR manufacturer LIKE '%Iphone%';


-- Получить товары, в которых есть упоминание "Samsung"
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones WHERE product_name LIKE '%Samsung%' OR manufacturer LIKE '%Samsung%';

-- Получить товары, в которых есть ЦИФРЫ
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones WHERE product_name NOT LIKE '%[^0-9.]%' OR manufacturer NOT LIKE '%[^0-9.]%';

-- Получить товары, в которых есть ЦИФРА "8"
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones WHERE product_name LIKE '%8%' OR manufacturer LIKE '%8%';
