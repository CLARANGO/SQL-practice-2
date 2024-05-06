--EX1
SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM (SELECT company_id,	title,	description,
COUNT(job_id) as job_count
FROM job_listings
GROUP BY company_id,	title,	description
ORDER BY company_id) AS job_count
WHERE job_count >1
;


--EX2
(SELECT category, product,
SUM(spend) as total_spend
FROM product_spend
WHERE category='appliance' AND 
EXTRACT(year FROM transaction_date) = '2022'
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2)

UNION ALL

(SELECT category, product,
SUM(spend) as total_spend
FROM product_spend
WHERE category='electronics' AND 
EXTRACT(year FROM transaction_date) = '2022'
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2)


--EX3
SELECT
COUNT(policy_holder_id)
FROM (SELECT policy_holder_id
FROM callers
GROUP BY policy_holder_id 
HAVING COUNT(case_id) >=3) AS holder_count;
       --OR--
WITH holder_count AS
(SELECT policy_holder_id
FROM callers
GROUP BY policy_holder_id 
HAVING COUNT(case_id) >=3) 

SELECT
COUNT(policy_holder_id)
FROM holder_count;



--EX4
SELECT a.page_id
FROM pages AS a  
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.liked_date IS NULL
GROUP BY a.page_id
;
-----------------------------------
WITH liked_date AS 
(SELECT a.page_id, b.liked_date
FROM pages AS a  
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
GROUP BY a.page_id, b.liked_date)

SELECT page_id 
FROM liked_date
WHERE liked_date IS NULL
;


--EX5
SELECT EXTRACT(MONTH FROM A.event_date) AS mth, 
COUNT(DISTINCT A.user_id) AS monthly_active_users
FROM user_actions AS A  

WHERE 
EXISTS(SELECT DISTINCT B.user_id
FROM user_actions AS B 
WHERE A.user_id=B.user_id
AND EXTRACT(month FROM event_date)=6)

AND EXTRACT(month FROM A.event_date)=7
GROUP BY mth
       
-------------------------------------------------------
WITH a AS (SELECT DISTINCT user_id, event_date
FROM user_actions 
WHERE EXTRACT(month FROM event_date)=6),

b AS (SELECT DISTINCT user_id, event_date
FROM user_actions 
WHERE EXTRACT(month FROM event_date)=7)

SELECT EXTRACT(MONTH FROM b.event_date) AS mth, 
COUNT(DISTINCT a.user_id) AS monthly_active_users
FROM a JOIN b ON a.user_id=b.user_id
WHERE a.user_id=b.user_id
GROUP BY mth


--EX6
WITH tt_count AS 
(SELECT TO_CHAR(trans_date,'yyyy-mm') as month,
country, 
COUNT(state) as trans_count,
SUM(amount) as trans_total_amount
FROM transactions
GROUP BY month, country),

ap_count AS 
(SELECT TO_CHAR(trans_date,'yyyy-mm') as month,
country, 
COUNT(state) as approved_count,
SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) as approved_total_amount 
FROM transactions
WHERE state='approved'
GROUP BY month, country)

SELECT a.month, a.country,
a.trans_count, b.approved_count, 
a.trans_total_amount, b.approved_total_amount
FROM tt_count as a
JOIN ap_count as b
ON a.month=b.month
GROUP BY  a.month, a.country, a.trans_count, b.approved_count, 
a.trans_total_amount, b.approved_total_amount
ORDER BY a.month

--EX7
SELECT a.product_id, b.first_year, a.quantity, a.price 
FROM sales as a
INNER JOIN (SELECT product_id,
MIN(year) AS first_year
FROM sales
GROUP BY product_id) as b
ON a.year=b.first_year AND a.product_id=b.product_id

--EX8
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING (COUNT(DISTINCT product_key)) = (SELECT COUNT(DISTINCT product_key) FROM product)
-----------------
WITH a AS (SELECT COUNT(DISTINCT product_key) AS total_product  FROM product),
b AS (SELECT customer_id, COUNT(DISTINCT product_key) AS product_bought  FROM customer
GROUP by customer_id)
SELECT b.customer_id
from a join b on a.total_product=b.product_bought
where a.total_product=b.product_bought

--EX9
WITH emp_sal AS
(SELECT employee_id, salary
FROM employees
WHERE salary<30000),

mng_left AS (SELECT a.employee_id, a.manager_id, b.employee_id as mgr
FROM employees as a
LEFT JOIN employees as b
ON a.manager_id=b.employee_id 
WHERE a.manager_id IS NOT NULL)

SELECT a.employee_id
FROM emp_sal as a
JOIN mng_left as b
ON a.employee_id=b.employee_id
WHERE b.mgr IS NULL
ORDER BY a.employee_id

--EX10
SELECT 
COUNT(DISTINCT company_id) AS duplicate_companies
FROM (SELECT company_id,	title,	description,
COUNT(job_id) as job_count
FROM job_listings
GROUP BY company_id,	title,	description
ORDER BY company_id) AS job_count
WHERE job_count >1
;


--EX11
WITH ID AS
(SELECT a.name as results,
COUNT(b.rating)
FROM users as a
JOIN movierating as b
ON a.user_id=b.user_id
GROUP BY a.name
ORDER BY COUNT(b.rating) DESC, a.name
LIMIT 1),

MV AS 
(SELECT a.title as results,
AVG(b.rating):: decimal
FROM movies as a
JOIN movierating as b
ON a.movie_id=b.movie_id
WHERE b.created_at BETWEEN '2020-02-01' AND'2020-02-29'
GROUP BY a.title
ORDER BY AVG(b.rating):: decimal DESC, results
LIMIT 1)

SELECT results FROM ID
UNION ALL
SELECT results FROM MV
ORDER BY results

--EX12
WITH accept_rate AS 
(SELECT requester_id,
COUNT(accepter_id)
FROM requestaccepted
GROUP BY requester_id),

accepted AS 
(SELECT accepter_id,
COUNT(requester_id)
FROM requestaccepted
GROUP BY accepter_id)

SELECT a.requester_id AS id,
SUM(a.count+b.count) AS num
FROM accept_rate AS a
JOIN accepted AS b
ON a.requester_id = b.accepter_id
GROUP BY a.requester_id
ORDER BY num DESC
LIMIT 1
------------------------------------------------------------
SELECT id, COUNT(*) AS num 
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id FROM RequestAccepted
) AS friends_count
GROUP BY id
ORDER BY num DESC 
LIMIT 1;
------------------------------------------------------------
SELECT  requester_id as id,
SUM(count) AS num
  
FROM(
(SELECT requester_id,
COUNT(accepter_id)
FROM requestaccepted
GROUP BY requester_id)
UNION ALL 
(SELECT accepter_id,
COUNT(requester_id)
FROM requestaccepted
GROUP BY accepter_id) ) 

GROUP BY id
ORDER BY num DESC
LIMIT 1







