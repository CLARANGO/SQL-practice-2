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
WHERE skill IN ('Python','Tableau' ,'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT (skill)=3
ORDER BY candidate_id

--EX6


--EX7
