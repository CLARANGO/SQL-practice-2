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
