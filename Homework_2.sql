/*

Базы данных и SQL (семинары)
Урок 2. SQL – создание объектов, простые запросы выборки

Задание 1 

Используя операторы языка SQL,
создайте таблицу “sales”. Заполните ее данными.
Справа располагается рисунок к
первому заданию.

+----+------------+--------------+
| id | order_date | count_product|
+----+------------+--------------+
|  1 | 2022-01-01 |          156 |
|  2 | 2022-01-02 |          180 |
|  3 | 2022-01-03 |           21 |
|  4 | 2022-01-04 |          124 |
|  5 | 2022-01-05 |          341 |
+----+------------+--------------+

*/

-- создаём базу данных
DROP DATABASE IF EXISTS Homework_2;
CREATE DATABASE Homework_2;
USE Homework_2;

-- создаём таблицу "sales"
DROP TABLE IF EXISTS sales;

CREATE TABLE sales(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	order_date DATE NOT NULL, 
	count_product  INT NOT NULL
	
);

-- наполнение таблици "sales"
INSERT INTO sales (order_date, count_product)
VALUES 
('2022-01-01', 156),
('2022-01-02', 180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

-- Проверка созданной и заполненой таблици "sales"
SELECT  id, order_date, count_product FROM sales;


/*
Задание 2 

Для данных таблицы “sales” укажите
тип заказа в зависимости от кол-ва :
меньше 100 - Маленький заказ
от 100 до 300 - Средний заказ
больше 300 - Большой заказ
*/

SELECT
	id as 'id заказа',
	CASE 
		WHEN count_product < 100 THEN 'Маленький заказ'
		WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
		WHEN count_product > 300 THEN 'Большой заказ'
		ELSE 'Не определено'
	END AS 'Тип заказа'
FROM 
	sales;

/*
Задание 3

Создайте таблицу “orders”, заполните ее значениями

+----+-------------+--------+--------------+
| id | employee_id | amount | order_status |
+----+-------------+--------+--------------+
|  1 |         e03 |     15 |         OPEN |
|  2 |         e01 |   25.5 |         OPEN |
|  3 |         e05 |  100.7 |       CLOSED |
|  4 |         e02 |  22.18 |         OPEN |
|  5 |         e04 |    9.5 |    CANCELLED |
+----+-------------+--------+--------------+

Выберите все заказы. В зависимости от поля order_status выведите столбец
full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is от NULL»

*/

-- создаём таблицу "orders"
DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
	employee_id CHAR(3) NOT NULL, 
	amount  DECIMAL (5,2) NOT NULL,
	order_status VARCHAR(10) NOT NULL
	);

-- наполнение таблици "orders"
INSERT INTO orders (employee_id, amount,order_status)
VALUES 
( 'e03', 15    , 'OPEN'   ),
( 'e01', 25.5  , 'OPEN'   ),
( 'e05', 100.7 , 'CLOSED' ),
( 'e02', 22.18 , 'OPEN'   ),
( 'e04', 9.5   ,  'CANCELLED');

-- Проверка созданной и заполненой таблици "orders"
SELECT  id, employee_id, amount,order_status FROM orders;

/*
Выберите все заказы. В зависимости от поля order_status выведите столбец
full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is от NULL» 
 */

SELECT  
	id, 
	employee_id, 
	amount,
	order_status,
	CASE  order_status
		WHEN 'OPEN' THEN 'Order is in open state'
		WHEN 'CLOSED' THEN 'Order is closed'
		WHEN 'CANCELLED' THEN 'Order is от NULL'
		ELSE 'Error'
	END AS full_order_status
FROM 
	orders;


/*
Задание 4

Чем 0 отличается от NULL?
Напишите ответ в комментарии к домашнему заданию на
платформе

Ответ: 
0 - это конкретное значение, цифра ноль. 
NULL - это специальное значение, которое указывает на отсутствие значения. 

*/