/*
Базы данных и SQL (семинары)
Урок 5. SQL – оконные функции

Для решения задач используйте базу данных lesson_4
(скрипт создания, прикреплен к 4 семинару).
*/


USE Homework_4;

/*
Задание 1 

Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
город и пол), которые не старше 20 лет.
*/

CREATE OR REPLACE VIEW v_users_until_20 AS
(SELECT 
firstname,
lastname,
hometown,
gender
FROM
users u 
JOIN profiles p ON u.id =p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 20);

SELECT * FROM v_users_until_20;


/*
Задание 2 

Найдите кол-во, отправленных сообщений каждым пользователем и выведите
ранжированный список пользователей, указав имя и фамилию пользователя, количество
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
количеством сообщений) . (используйте DENSE_RANK)
*/


SELECT 
firstname,
lastname,
COUNT(m.id) as count_messages,
DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS rank_messages
FROM 
messages m 
RIGHT JOIN users u ON m.from_user_id = u.id
GROUP BY u.id;


/*
Задание 3 

Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
(created_at) и найдите разницу дат отправления между соседними сообщениями,
получившегося списка. (используйте LEAD или LAG)
*/


SELECT 
m.id ,
m.from_user_id ,
m.to_user_id ,
m.body ,
TIMEDIFF(m.created_at, (LAG(m.created_at, 1, 0) OVER w) ) as deff_prev_created_at,
TIMEDIFF(m.created_at, (LEAD(m.created_at, 1, 0) OVER w)) as deff_last_created_at
FROM 
messages m
WINDOW w AS (ORDER BY m.created_at);
