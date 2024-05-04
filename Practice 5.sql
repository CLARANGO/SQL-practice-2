--EX1
SELECT b.continent,
FLOOR(AVG(a.population))
FROM country AS b
INNER JOIN city AS a
ON b.code=a.countrycode
GROUP BY b.continent

 
--EX2
SELECT
ROUND(SUM(CASE
 WHEN b.signup_action = 'Confirmed' THEN 1
 ELSE 0
END)::decimal /COUNT(*), 2)
FROM emails AS a  
LEFT JOIN texts AS b 
ON a.email_id=b.email_id
WHERE signup_action IS NOT NULL;


--EX3
SELECT  b.age_bucket,

ROUND(SUM(CASE 
  WHEN a.activity_type ='send' THEN a.time_spent 
  ELSE 0 
END)/SUM(a.time_spent)*100.0,2)
AS send_perc,

ROUND(SUM(CASE 
  WHEN a.activity_type ='open' THEN a.time_spent 
  ELSE 0 
END)/SUM(a.time_spent)*100.0,2)
AS open_perc

FROM activities AS a
INNER JOIN age_breakdown AS b 
ON a.user_id=b.user_id
WHERE a.activity_type <> 'chat'
GROUP BY age_bucket

 
 --EX4
SELECT 
a.customer_id
FROM customer_contracts AS a
INNER JOIN products AS b 
ON a.product_id=b.product_id
WHERE b.product_category IN ('Analytics','Containers','Compute')
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category)=3
;


--EX5
SELECT b.employee_id, b.name,
COUNT(a.reports_to) as reports_count,
ROUND(AVG(CASE WHEN a.reports_to IS NOT NULL THEN a.age ELSE 0 END)) 
average_age
FROM employees AS a
LEFT JOIN employees AS b
ON b.employee_id=a.reports_to
WHERE a.reports_to is not null
GROUP BY b.name, b.employee_id
ORDER BY b.employee_id


--EX6
SELECT a.product_name,
SUM(b.unit) AS unit
FROM products AS a
INNER JOIN orders AS b
ON a.product_id=b.product_id
WHERE b.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY a.product_name
HAVING SUM(b.unit)>=100  ;


--EX7
SELECT a.page_id
FROM pages AS a  
LEFT JOIN page_likes AS b
ON a.page_id=b.page_id
WHERE b.liked_date IS NULL
GROUP BY a.page_id
;



