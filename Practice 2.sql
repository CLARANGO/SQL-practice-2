--EX1
SELECT DISTINCT city
FROM station
WHERE id%2=0
GROUP BY city 

--EX2
SELECT 
COUNT(city) - COUNT(DISTINCT city) AS difference
FROM station

--EX3
SELECT
CEILING (AVG (salary) - AVG (REPLACE(salary,0,'')) )
FROM employees

--EX4
SELECT
ROUND(SUM(item_count::DECIMAL *order_occurrences)/SUM(order_occurrences),1)
AS mean
FROM items_per_order;

--EX5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT (skill)=3
ORDER BY candidate_id

--EX6
SELECT user_id,
DATE (MAX(post_date))-DATE(MIN(post_date)) as days_between
FROM posts
WHERE post_date >='2021-01-01' AND post_date <'2022-01-01'
GROUP BY user_id
HAVING COUNT(user_id)>=2;

--EX7
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY card_name DESC;

--EX8
SELECT manufacturer,
COUNT(drug) AS total_drug, 
ABS (SUM(total_sales-cogs)) AS loss
FROM pharmacy_sales
WHERE total_sales-cogs <=0
GROUP BY manufacturer
ORDER BY loss DESC
;

--EX9
SELECT *
FROM cinema
WHERE id%2 =1 AND description NOT LIKE 'boring'
ORDER BY rating DESC

--EX10
select teacher_id,
count(distinct subject_id) as cnt
from teacher
group by teacher_id

--EX11
select user_id,
count(follower_id) as followers_count
from followers
group by user_id
order by user_id

--EX12
select class
from courses
group by class
having count(class) >5;
