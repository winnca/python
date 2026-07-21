-- 1. Вывести имена всех людей, которые есть в базе данных авиакомпаний.

SELECT name
FROM Passenger

-- 2. Вывести названия всеx авиакомпаний.

SELECT name
FROM Company

-- 3. Вывести все рейсы, совершенные из Москвы.

SELECT *
FROM Trip
WHERE town_from LIKE 'Moscow'

-- 4. Вывести имена людей, которые заканчиваются на "man".

SELECT name
FROM Passenger
WHERE name LIKE '%man'

-- 5. Вывести количество рейсов, совершенных на TU-134.

SELECT COUNT(*) AS count
FROM Trip
WHERE plane LIKE 'TU-134'

-- 6. Какие компании совершали перелеты на Boeing.

SELECT DISTINCT name
FROM Company
JOIN Trip ON Company.id=Trip.company
WHERE plane LIKE 'Boeing%'

-- 7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow).

SELECT DISTINCT plane
FROM Trip
WHERE town_to LIKE 'Moscow'

-- 8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт? Формат для вывода времени: HH:MM:SS

SELECT town_to,
	TIMEDIFF(time_in, time_out) AS flight_time
FROM Trip
WHERE town_from LIKE 'Paris'

-- 9. Какие компании организуют перелеты из Владивостока (Vladivostok)?

SELECT name
FROM Company
JOIN Trip ON Company.id=Trip.company
WHERE town_from LIKE 'Vladivostok'

-- 10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.

SELECT *
FROM Trip
WHERE time_out BETWEEN '1900-01-01 10:00:00' AND '1900-01-01 14:00:00'

-- 11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.

SELECT name
FROM Passenger
WHERE LENGTH(name) = (
		SELECT LENGTH(MAX(name))
		FROM Passenger
	)

-- 12. Выведите идентификаторы всех рейсов и количество пассажиров на них. Обратите внимание, что на каких-то рейсах пассажиров может не быть. В этом случае выведите число "0".

SELECT Trip.id AS id,
	COALESCE(COUNT(Pass_in_trip.passenger), 0) AS COUNT
FROM Trip
	LEFT JOIN Pass_in_trip ON Trip.id = Pass_in_trip.Trip
GROUP BY Trip.id

-- 13. Вывести имена людей, у которых есть полный тёзка среди пассажиров.

SELECT name
FROM Passenger
GROUP BY name
HAVING COUNT(*)>1

-- 14. В какие города летал Bruce Willis.

SELECT town_to
FROM Trip
	JOIN Pass_in_trip ON Trip.id = Pass_in_trip.Trip
	JOIN Passenger ON Pass_in_trip.passenger = Passenger.id
WHERE name LIKE 'Bruce Willis'

-- 15. Выведите идентификатор пассажира Стив Мартин (Steve Martin) и дату и время его прилёта в Лондон (London).

SELECT Passenger.id,
	Trip.time_in
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE name LIKE 'Steve Martin'
	AND town_to LIKE 'London'

-- 16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.

SELECT name,
	COUNT(Pass_in_trip.id) AS COUNT
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
GROUP BY name
HAVING COUNT > 0
ORDER BY COUNT DESC,
	name ASC

-- 17. Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.

SELECT member_name,
	STATUS,
	SUM(amount * unit_price) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(date) = 2005
GROUP BY member_name,
	STATUS

-- 18. Выведите имя самого старшего человека. Если таких несколько, то выведите их всех.

SELECT member_name
FROM FamilyMembers
ORDER BY birthday ASC
LIMIT 1
SELECT member_name
FROM FamilyMembers
WHERE birthday = (
		SELECT MIN(birthday)
		FROM FamilyMembers
	)

-- 19. Определить, кто из членов семьи покупал картошку (potato).

SELECT DISTINCT status
FROM FamilyMembers
  JOIN Payments ON FamilyMembers.member_id=Payments.family_member
  JOIN Goods ON Payments.good=Goods.good_id
WHERE good_name LIKE 'potato'

-- 20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму.

SELECT STATUS,
	member_name,
	SUM(unit_price * amount) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
	JOIN Goods ON Payments.good = Goods.good_id
	JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE good_type_name LIKE 'entertainment'
GROUP BY STATUS,
	member_name

-- 21. Определить товары, которые покупали более 1 раза.

SELECT good_name
FROM Goods
  JOIN Payments ON Goods.good_id=Payments.good
GROUP BY good_name
HAVING COUNT(*)>1

-- 22. Найти имена всех матерей (mother).

SELECT member_name
FROM FamilyMembers
WHERE status LIKE 'mother'

-- 23. Найдите самый дорогой деликатес (delicacies) и выведите его цену.

SELECT good_name,
	unit_price
FROM Goods
	JOIN Payments ON Goods.good_id = Payments.good
WHERE unit_price =(
		SELECT MAX(unit_price)
		FROM Payments
			JOIN Goods ON Payments.good = Goods.good_id
			JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
		WHERE good_type_name LIKE 'delicacies'
	)

-- 24. Определить, кто и сколько потратил в июне 2005.

SELECT member_name,
	SUM(unit_price * amount) AS costs
FROM FamilyMembers
	JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE Payments.date BETWEEN '2005-06-01' AND '2005-06-30'
GROUP BY member_name

-- 25. Определить, какие товары не покупались в 2005 году.

SELECT good_name
FROM Goods
WHERE good_id NOT IN(
		SELECT good
		FROM Payments
		WHERE YEAR(date) = 2005
	)

-- 26. Определить группы товаров, которые не приобретались в 2005 году.

SELECT DISTINCT good_type_name
FROM GoodTypes
WHERE good_type_id NOT IN (
		SELECT good_type_id
		FROM GoodTypes
			JOIN Goods ON GoodTypes.good_type_id = Goods.type
			JOIN Payments ON Goods.good_id = Payments.good
		WHERE date BETWEEN '2005-01-01' AND '2005-12-31 '
	)

-- 27. Cколько было потрачено на каждую из групп товаров в 2005 году. Выведите название группы и потраченную на неё сумму.

SELECT good_type_name,
	SUM(unit_price * amount) AS costs
FROM GoodTypes
	JOIN Goods ON GoodTypes.good_type_id = Goods.type
	JOIN Payments ON Goods.good_id = Payments.good
WHERE date BETWEEN '2005-01-01' AND '2005-12-31'
GROUP BY good_type_name

-- 28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow) ?

SELECT COUNT(*)
FROM Trip
WHERE town_from LIKE 'Rostov'
	AND town_to LIKE 'Moscow'

-- 29. Выведите имена пассажиров, улетевших в Москву (Moscow) на самолете TU-134. В ответе не должно быть дубликатов.

SELECT name
FROM Passenger
JOIN Pass_in_trip ON Passenger.id=Pass_in_trip.passenger
JOIN Trip ON Pass_in_trip.trip=Trip.id
WHERE town_to='Moscow' AND plane='TU-134'
GROUP BY name
SELECT DISTINCT name
FROM Passenger
	JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
	JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE plane like 'TU-134'
	AND town_to like 'Moscow'

-- 30. Вывести количество занятых мест по каждому рейсу из таблицы Pass_in_trip, отсортировав результат по убыванию количества занятых мест.

SELECT trip, COUNT(passenger) AS count
FROM Pass_in_trip
GROUP BY trip
ORDER BY count DESC

-- 31. Вывести всех членов семьи с фамилией Quincey.

SELECT *
FROM FamilyMembers
WHERE member_name LIKE '%Quincey%'

-- 32. Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.

SELECT FLOOR(AVG(YEAR(CURRENT_DATE) - YEAR(birthday))) AS age
FROM FamilyMembers

-- 33. Найдите среднюю цену икры на основе данных, хранящихся в таблице Payments. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar). В ответе должна быть одна строка со средней ценой всей купленной когда-либо икры.

SELECT AVG(unit_price) AS cost
FROM Payments
	JOIN Goods ON Payments.good = Goods.good_id
WHERE good_name LIKE '%caviar'

-- 34. Сколько всего 10-ых классов?

SELECT COUNT(name) AS COUNT
FROM Class
WHERE name LIKE '10%'

-- 35. Сколько различных кабинетов школы использовались 2 сентября 2019 года для проведения занятий?

SELECT COUNT(DISTINCT classroom) AS count
FROM Schedule
WHERE DATE(date) = '2019-09-02'

-- 36. Выведите информацию об обучающихся, живущих на улице Пушкина (ul. Pushkina)?

SELECT *
FROM Student
WHERE address LIKE '%Pushkina%'

-- 37. Сколько лет самому молодому обучающемуся ?

SELECT TIMESTAMPDIFF(YEAR, birthday, current_date) AS year 
FROM Student
ORDER BY birthday DESC 
LIMIT 1
SELECT MIN(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS year 
FROM Student

-- 38. Сколько учениц с именем Анна (Anna) учится в школе?

SELECT COUNT(*) AS COUNT
FROM Student
WHERE first_name = 'Anna'

-- 39. Сколько обучающихся в 10 B классе ?

SELECT COUNT(student) AS COUNT
FROM Student_in_class
	JOIN Class ON Student_in_class.class = Class.id
WHERE name = '10 B'
SELECT COUNT(student) AS COUNT
FROM Student_in_class
WHERE class = (
		SELECT id
		FROM Class
		WHERE name = '10 B'
	)

-- 40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.). Обратите внимание, что в базе данных есть несколько учителей с такой фамилией.

SELECT name AS subjects
FROM Subject
	JOIN Schedule ON Subject.id = Schedule.subject
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE first_name LIKE 'P%'
	AND middle_name LIKE 'P%'
	AND last_name LIKE 'Romashkin'

-- 41. Выясните, во сколько по расписанию начинается четвёртое занятие.

SELECT DISTINCT start_pair
FROM Timepair
	JOIN Schedule ON Timepair.id = Schedule.number_pair
WHERE number_pair = 4

-- 42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?

SELECT DISTINCT TIMEDIFF(
		(
			SELECT end_pair
			FROM Timepair
			WHERE id = 4
		),
		(
			SELECT start_pair
			FROM Timepair
			WHERE id = 2
		)
	) AS time
FROM Timepair

-- 43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей по фамилии в алфавитном порядке.

SELECT last_name
FROM Teacher
	JOIN Schedule ON Teacher.id = Schedule.teacher
	JOIN Subject ON Schedule.subject = Subject.id
WHERE name LIKE 'Physical Culture'
ORDER BY last_name ASC

-- 44. Найдите максимальный возраст (количество лет) среди обучающихся 10 классов на сегодняшний день. Для получения текущих даты и времени используйте функцию NOW().

SELECT MAX(TIMESTAMPDIFF(YEAR, birthday, CURRENT_DATE)) AS max_year
FROM Student
	JOIN Student_in_class ON Student.id = Student_in_class.student
	JOIN Class ON Student_in_class.class = Class.id
WHERE name LIKE '10%'

-- 45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.

SELECT classroom
FROM Schedule
	JOIN Class ON Schedule.class = Class.id
	JOIN Timepair ON Schedule.number_pair = Timepair.id
	JOIN Teacher ON Schedule.teacher = Teacher.id
	JOIN Subject ON Schedule.subject = Subject.id
GROUP BY classroom
ORDER BY COUNT(classroom) DESC
LIMIT 3
SELECT classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(*) = (
		SELECT MAX(count)
		FROM (
				SELECT COUNT(*) AS count
				FROM Schedule
				GROUP BY classroom
			) AS counts
	)

-- 46. В каких классах введет занятия преподаватель "Krauze" ?

SELECT name
FROM Class
	JOIN Schedule ON Class.id = Schedule.class
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE last_name LIKE 'Krauze'
GROUP BY name

-- 47. Сколько занятий провел Krauze 30 августа 2019 г.?

SELECT COUNT(date) AS COUNT
FROM Schedule
	JOIN Teacher ON Schedule.teacher = Teacher.id
WHERE last_name LIKE 'Krauze'
	AND date = '2019-08-30'

-- 48. Выведите заполненность классов в порядке убывания.

SELECT name,
	COUNT(student) AS COUNT
FROM Class
	JOIN Student_in_class ON Class.id = Student_in_class.class
GROUP BY name
ORDER BY COUNT(student) DESC

-- 49. Какой процент обучающихся учится в "10 A" классе? Выведите ответ в диапазоне от 0 до 100 с округлением до четырёх знаков после запятой, например, 96.0201.

WITH a_10 AS (
	SELECT COUNT(class) AS count_10
	FROM Student_in_class
		JOIN Class ON Student_in_class.class = Class.id
	WHERE name = '10 A'
), all_10 AS (
	SELECT COUNT(class) AS count_all
	FROM Student_in_class
)
SELECT (count_10 / count_all) * 100 AS percent
FROM a_10,
	all_10

-- 50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.

WITH a_2000 AS (
	SELECT COUNT(*) AS count_10
	FROM Student
	WHERE YEAR(birthday) = 2000
), all_10 AS (
	SELECT COUNT(*) AS count_all
	FROM Student
)
SELECT 
    FLOOR(count_10 * 100.0 / count_all) AS percent
FROM a_2000, all_10

-- 51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).

INSERT INTO Goods (good_id, good_name, type)
VALUES(
		(
			SELECT MAX(good_id) + 1
			FROM (SELECT * FROM Goods) AS temp
		),
		'Cheese',
		(
			SELECT good_type_id
			FROM GoodTypes
			WHERE good_type_name = 'food'
		)
	)

-- 52. Добавьте в список типов товаров (GoodTypes) новый тип "auto".

INSERT INTO GoodTypes
VALUES(
		(
			SELECT MAX(good_type_id) + 1
			FROM (
					SELECT *
					FROM GoodTypes
				) AS temp
		),
		'auto'
	)

-- 53. Измените имя "Andie Quincey" на новое "Andie Anthony".

UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey'

-- 54. Удалить всех членов семьи с фамилией "Quincey".

DELETE FROM FamilyMembers
WHERE member_name LIKE '%Quincey'

-- 55. Удалить компании, совершившие наименьшее количество рейсов.

WITH trips AS (
	SELECT company,
		COUNT(*) AS count_
	FROM Trip
	GROUP BY company
)
DELETE FROM Company
WHERE id IN (
		SELECT company
		FROM trips
		WHERE count_ =(
				SELECT MIN(count_)
				FROM trips
			)
	)

-- 56. Удалить все перелеты, совершенные из Москвы (Moscow).

DELETE FROM Trip
WHERE town_from = 'Moscow'

-- 57. Перенести расписание всех занятий на 30 мин. вперед.

UPDATE Timepair
SET start_pair = TIMESTAMPADD(MINUTE, 30, start_pair),
	end_pair = TIMESTAMPADD(MINUTE, 30, end_pair)

-- 58. Добавить отзыв от George Clooney. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney". В качестве первичного ключа (id) укажите количество записей в таблице + 1. Резервация комнаты, на которую вам нужно оставить отзыв, уже была сделана, нужно лишь ее найти.

INSERT INTO Reviews
VALUES(
		(
			SELECT MAX(id) + 1
			FROM (
					SELECT *
					FROM Reviews
				) AS temp
		),
		(
			SELECT id
			FROM (
					SELECT *
					FROM Reservations
					WHERE user_id = (
							SELECT id
							FROM Users
							WHERE name = 'George Clooney'
						)
						AND room_id = (
							SELECT id
							FROM Rooms
							WHERE address LIKE '11218, Friel Place, New York'
						)
				) AS temps
		), 5
	)

-- 59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.

SELECT *
FROM Users
WHERE phone_number LIKE '+375%'

-- 60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов.

SELECT teacher
FROM Schedule
	JOIN Class ON Schedule.class = Class.id
WHERE name LIKE '11%'
GROUP BY teacher
HAVING COUNT(DISTINCT name) = 2

-- 61. Выведите список комнат, которые были зарезервированы хотя бы на одни сутки в 12-ую неделю 2020 года. В данной задаче в качестве одной недели примите период из семи дней, первый из которых начинается 1 января 2020 года. Например, первая неделя года — 1–7 января, а третья — 15–21 января. Поля в результирующей таблице: Rooms.*.

SELECT Rooms.*
FROM Rooms
	JOIN Reservations ON Rooms.id = Reservations.room_id
WHERE WEEK(start_date, 1) = 12
	AND YEAR(start_date) = 2020

-- 62. Вывести в порядке убывания популярности доменные имена 2-го уровня, используемые пользователями для электронной почты. Полученный результат необходимо дополнительно отсортировать по возрастанию названий доменных имён. Для эл. почты index@gmail.com доменным именем 2-го уровня будет gmail.com. Поля в результирующей таблице: domain, count.

SELECT SUBSTRING(email, LOCATE('@', email) + 1) AS domain,
	COUNT(SUBSTRING(email, LOCATE('@', email) + 1)) AS count
FROM Users
GROUP BY domain
Order BY count DESC,
	domain ASC

-- 63. Выведите отсортированный список (по возрастанию) фамилий и имен студентов в виде Фамилия.И. Поля в результирующей таблице: name.

SELECT CONCAT(
		CONCAT(last_name, '.'),
		CONCAT(SUBSTRING(first_name, 1, 1), '.')
	) AS name
FROM Student
ORDER BY name ASC

-- 64. Вывести количество бронирований по каждому месяцу каждого года, в которых было хотя бы 1 бронирование. Результат отсортируйте в порядке возрастания даты бронирования. Используйте конструкцию "as year", "as month" и "as amount" для вывода года и месяца бронирования, количества таких бронирований соответственно. Поля в результирующей таблице: year, month, amount.

SELECT YEAR(start_date) AS year,
	MONTH(start_date) AS MONTH,
	COUNT(*) AS amount
FROM Reservations
GROUP BY year,
	MONTH
ORDER BY year,
	MONTH ASC

-- 65. Необходимо вывести рейтинг для комнат, которые хоть раз арендовали, как среднее значение рейтинга отзывов округленное до целого вниз.

SELECT room_id,
	FLOOR(AVG(rating)) AS rating
FROM Reviews
	JOIN Reservations ON Reviews.reservation_id = Reservations.id
GROUP BY room_id

-- 66. Вывести список комнат со всеми удобствами (наличие ТВ, интернета, кухни и кондиционера), а также общее количество дней и сумму за все дни аренды каждой из таких комнат. Используйте конструкции "as days" и "as total_fee" для вывода количества дней и суммы аренды, соответственно. Если комната не сдавалась, то количество дней и сумму вывести как 0. Поля в результирующей таблице: home_type, address, days, total_fee.

SELECT home_type,
	address,
	COALESCE(SUM(total / Reservations.price), 0) AS days,
	-- COALESCE(SUM(total), 0) AS total_fee
	COALESCE(SUM(total), 0) AS total_fee
FROM Rooms
	LEFT JOIN Reservations ON Rooms.id = Reservations.room_id
WHERE has_air_con = 1
	AND has_internet = 1
	AND has_kitchen = 1
	AND has_tv = 1
GROUP BY home_type,
	address

-- 67. Вывести время отлета и время прилета для каждого перелета в формате "ЧЧ:ММ, ДД.ММ - ЧЧ:ММ, ДД.ММ", где часы и минуты с ведущим нулем, а день и месяц без. Используйте конструкции "as flight_time" для полученной строки с датами отлета и прилета. Поля в результирующей таблице: flight_time.

SELECT CONCAT(
		DATE_FORMAT(time_out, '%H:%i, %e.%c'),
		' - ',
		DATE_FORMAT(time_in, '%H:%i, %e.%c')
	) AS flight_time
FROM Trip

-- 68. Для каждой комнаты, которую снимали как минимум 1 раз, найдите имя человека, снимавшего ее последний раз, и дату, когда он выехал. Используйте конструкцию "as room_id" для вывода идентификатора комнаты. Поля в результирующей таблице: room_id, name, end_date.

SELECT room_id,
	name,
	end_date
FROM Users
	JOIN Reservations ON Users.id = Reservations.user_id
WHERE (room_id, end_date) IN (
		SELECT room_id,
			MAX(end_date)
		FROM Reservations
		GROUP BY room_id
	)

-- 69. Вывести идентификаторы всех владельцев комнат, что размещены на сервисе бронирования жилья и сумму, которую они заработали. Используйте конструкцию "as owner_id" и "as total_earn" для вывода идентификаторов владельцев и заработанной суммы соответственно. Поля в результирующей таблице: owner_id, total_earn.

SELECT owner_id,
	COALESCE(SUM(total), 0) AS total_earn
FROM Rooms
	LEFT JOIN Reservations ON Rooms.id = Reservations.room_id
GROUP BY owner_id

-- 70. Необходимо категоризовать жилье на economy, comfort, premium по цене соответственно <= 100, 100 < цена < 200, >= 200. В качестве результата вывести таблицу с названием категории и количеством жилья, попадающего в данную категорию. Используйте конструкцию "as category" и "as count" для вывода названия категории и количества такого жилья соответственно. Поля в результирующей таблице: category, count.

SELECT (
		CASE
			WHEN Rooms.price <= 100 THEN 'economy'
			WHEN Rooms.price BETWEEN 101 AND 199 THEN 'comfort'
			ELSE 'premium'
		END
) AS category,
COUNT(*) AS count
FROM Rooms
GROUP BY category

-- 71. Найдите какой процент пользователей, зарегистрированных на сервисе бронирования, хоть раз арендовали или сдавали в аренду жилье. Результат округлите до сотых. Используйте конструкцию "as percent" для вывода процента активных пользователей. Пример формата ответа: 65.23 Поля в результирующей таблице: percent.

SELECT ROUND(
		(
			SELECT COUNT(*)
			FROM (
					SELECT owner_id
					FROM Rooms
						JOIN Reservations ON Rooms.id = Reservations.room_id
					UNION
					SELECT user_id
					FROM Reservations
				) users
		) * 100 / (
			SELECT COUNT(*)
			FROM Users
		),

-- 		2

	) AS percent

-- 72. Выведите среднюю цену бронирования за сутки для каждой из комнат, которую бронировали хотя бы один раз. Среднюю цену необходимо округлить до целого значения вверх. Используйте конструкцию "as avg_price" для вывода средней стоимости бронирования для комнат. Поля в результирующей таблице: room_id, avg_price.

SELECT room_id,
	CEILING(AVG(price)) AS avg_price
FROM Reservations
GROUP BY room_id

-- 73. Выведите id тех комнат, которые арендовали нечетное количество раз. Используйте конструкцию "as count" для вывода количество сколько раз комнату брали в аренду. Поля в результирующей таблице: room_id, count.

SELECT room_id,
	COUNT(*) AS COUNT
FROM Reservations
GROUP BY room_id
HAVING COUNT % 2 != 0

-- 74. Выведите идентификатор и признак наличия интернета в помещении. Если интернет в сдаваемом жилье присутствует, то выведите «YES», иначе «NO». Используйте конструкцию "AS has_internet" для вывода признака наличия интернета в помещении. Поля в результирующей таблице: id, has_internet.

SELECT id,
	(
		CASE
			WHEN has_internet = 1 THEN 'YES'
			ELSE 'NO'
		END
	) AS has_internet
FROM Rooms
SELECT id,
		CASE
			WHEN has_internet = 1 THEN 'YES'
			ELSE 'NO'
		END AS has_internet
FROM Rooms

-- 75. Выведите фамилию, имя и дату рождения студентов, кто был рожден в мае. Поля в результирующей таблице: last_name, first_name, birthday.

SELECT last_name,
	first_name,
	birthday
FROM Student
WHERE MONTH(birthday) = 5

-- 76. Вывести имена всех пользователей сервиса бронирования жилья, а также два признака: является ли пользователь собственником какого-либо жилья (is_owner) и является ли пользователь арендатором (is_tenant). В случае наличия у пользователя признака необходимо вывести в соответствующее поле 1, иначе 0. Используйте конструкцию "AS is_owner" для отображения признака собственника жилья. Используйте конструкцию "AS is_tenant" для отображения признака арендатора. Поля в результирующей таблице: name, is_owner, is_tenant.

SELECT name,
	CASE
		WHEN EXISTS (
			SELECT 1
			FROM Rooms
			WHERE owner_id=Users.id
		) THEN 1
		ELSE 0
	END AS is_owner,
	CASE
		WHEN EXISTS (
			SELECT 1
			FROM Reservations
			WHERE user_id=Users.id
		) THEN 1
		ELSE 0
	END AS is_tenant
FROM Users

-- 77. Создайте представление с именем "People", которое будет содержать список имен (first_name) и фамилий (last_name) всех студентов (Student) и преподавателей(Teacher).

CREATE VIEW People AS
SELECT first_name,
	last_name
	FROM Student
UNION ALL
SELECT first_name,
	last_name 
FROM Teacher;
SELECT *
FROM People;

-- 78. Выведите всех пользователей с электронной почтой в «hotmail.com».

SELECT *
FROM Users
WHERE email LIKE '%@hotmail.com'

-- 79. Выведите поля id, home_type, price у всего жилья из таблицы Rooms. Если комната имеет телевизор и интернет одновременно, то в качестве цены в поле price выведите цену, применив скидку 10%. Поля в результирующей таблице: id, home_type, price.

SELECT id,
	home_type,
	(
		CASE
			WHEN has_tv = 1
			AND has_internet = 1 THEN price * 0.9
			ELSE price
		END
	) AS price
FROM Rooms

-- 80. Создайте представление «Verified_Users» с полями id, name и email, которое будет показывает только тех пользователей, у которых подтвержден адрес электронной почты.

CREATE VIEW Verified_Users AS
SELECT id,
	name,
	email
FROM Users
WHERE email_verified_at IS NOT NULL;
SELECT * FROM Verified_Users
