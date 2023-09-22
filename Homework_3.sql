/*
Базы данных и SQL (семинары)
Урок 3. SQL – выборка данных, сортировка, агрегатные функции

*/


-- создаём базу данных
DROP DATABASE IF EXISTS Homework_3;
CREATE DATABASE Homework_3;
USE Homework_3;


-- Создание таблицы Персонал
DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 19),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Иван', 'Иванов', 'Рабочий', '40', 30000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49);


/*
Задание 1 

Отсортируйте данные по полю заработная плата (salary) в порядке: убывания;
возрастания
*/

SELECT 
	id, 
	firstname, 
	lastname, 
	post, 
	seniority, 
	salary, 
	age 
FROM 
	staff
ORDER BY 
	salary DESC;

/*
Задание 2 
 
Выведите 5 максимальных заработных плат (salary)
*/

SELECT 
	 salary
FROM 
	staff
ORDER BY 
	salary DESC
LIMIT 5;

-- не понял задачу, возможно так нужно:
SELECT 
	 DISTINCT  salary
FROM 
	staff
ORDER BY 
	salary DESC
LIMIT 5;

/*
Задание 3
 
Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
*/

SELECT 
	post,
	SUM(salary)
FROM 
	staff
GROUP BY post;

/*
Задание 4 
 
Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до
49 лет включительно.
*/

SELECT
	post,
	count(id)
FROM 
	staff
WHERE age BETWEEN 24 AND 49
GROUP BY post;

/*
Задание 5 
 
Найдите количество специальностей
*/

SELECT 
	 Count(DISTINCT post)
FROM 
	staff;

-- или так

SELECT 
	 Count(post)
FROM 
	staff;


/*
Задание 6 
 
Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
*/


SELECT 
	post,
	AVG(age)
FROM 
	staff
GROUP BY post
HAVING AVG(age) < 30;













