/*
Базы данных и SQL (семинары)
Урок 4. SQL – работа с несколькими таблицами


*/

USE Homework_4;

/*
Задание 1 

Подсчитать общее количество лайков, которые получили пользователи
младше 12 лет.
*/


SELECT
   count(*) AS 'Количество лайков'
FROM
 likes l
JOIN media m ON l.media_id =m.id 
JOIN profiles p ON m.user_id =p.user_id 
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 12;

/*
Задание 2 

Определить кто больше поставил лайков (всего): мужчины или
женщины.
*/

SELECT
	CASE  
		WHEN p.gender='f' THEN 'Женщины'
		WHEN p.gender='m' THEN 'Мужчины'
		ELSE 'Не определено'
	END
	AS 'Пол',
	count(*) AS 'Количество лайков'
FROM
 likes l
JOIN users u ON l.user_id =u.id 
JOIN profiles p ON u.id=p.user_id
GROUP BY p.gender;

/*
Задание 3 

Вывести всех пользователей, которые не отправляли сообщения.
*/

SELECT 
 CONCAT(u.firstname, ' ', u.lastname) AS 'Пользователь'
FROM
users u 
LEFT JOIN messages m ON u.id =m.from_user_id 
WHERE m.id IS NULL;

/*
Задание 4 

(по желанию)* Пусть задан некоторый пользователь. Из всех друзей
этого пользователя найдите человека, который больше всех написал
ему сообщений.
*/

SELECT 
 friend.best_friend 
 FROM 
(SELECT 
    CONCAT(u.firstname, ' ', u.lastname) AS best_friend,
	COUNT(m.id) as count_memessages
FROM 
	messages m
	JOIN users u ON u.id = m.from_user_id 
WHERE m.from_user_id in 
	(
	SELECT initiator_user_id AS id FROM friend_requests 
		WHERE target_user_id = 1 AND status='approved' -- ID друзей, заявку которых я подтвердил () 
	UNION
	SELECT target_user_id FROM friend_requests 
		WHERE initiator_user_id = 1 AND status='approved' -- ID друзей, подтвердивших мою заявку
	) AND m.to_user_id = 1  
GROUP BY m.from_user_id
ORDER BY count_memessages DESC
LIMIT 1 ) as friend
;
