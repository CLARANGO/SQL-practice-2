--EX1
SELECT name
FROM students
WHERE marks > 75
ORDER BY RIGHT(name,3), ID 


--EX2
SELECT user_id,
CONCAT(UPPER(LEFT (name,1)),LOWER (RIGHT (name,LENGTH(name)-1))) AS name
FROM users
ORDER BY user_id
/
SELECT user_id,
CONCAT(UPPER(LEFT (name,1)),LOWER(SUBSTRING(name,2))) AS name
FROM users
ORDER BY user_id

--EX3
SELECT manufacturer,
'$' || ROUND(SUM(total_sales)/1000000)||' '||'million'
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales)	DESC, manufacturer;

--EX4
SELECT EXTRACT(month FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars)::DECIMAL,2) AS avg_stars
FROM reviews
GROUP BY product,mth
ORDER BY mth, product

--EX5
SELECT sender_id,
COUNT(sender_id) as total_mess_sent
FROM messages
WHERE TO_CHAR(sent_date, 'mm-yyyy') = '08-2022' 
GROUP BY sender_id
ORDER BY total_mess_sent DESC
LIMIT 2;

--EX6
SELECT tweet_id
FROM tweets
WHERE LENGTH(content) >15

--EX7
SELECT DISTINCT activity_date as day,
COUNT(DISTINCT user_id) AS active_users
FROM activity
WHERE activity_date BETWEEN '2019-06-27' AND '2019-07-27'
GROUP BY activity_date

--EX8
select 
POSITION('a' IN first_name)
from worker
WHERE first_name = 'Amitah';

--EX9
select 
COUNT (id)
from employees
WHERE TO_CHAR(joining_date,'mm-yyyy')BETWEEN '01-2022' AND '07-2022'


--EX10
select SUBSTRING(title,LENGTH(winery)+2,4)
from winemag_p2
WHERE country= 'Macedonia'
;
