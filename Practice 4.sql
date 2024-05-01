--EX1
SELECT

SUM (CASE
  WHEN device_type ='laptop' THEN 1
  ELSE 0
END) latop_views,

SUM (CASE
  WHEN device_type IN('tablet','phone') THEN 1
  ELSE 0
END) mobile_views

FROM viewership;


--EX2
SELECT x, y, z,
CASE
  WHEN x+y>z AND y+z>x AND z+x>y THEN 'Yes'
  ELSE 'No'
END triangle
FROM triangle


--EX3
SELECT 
ROUND((SUM(CASE
 WHEN call_category = 'n/a' OR call_category is null THEN 1
 ElSE 0
END))/COUNT(case_id)::decimal*100
,1)
FROM callers


--EX4
SELECT name
FROM customer
WHERE referee_id != 2 OR referee_id is null


--EX5
select survived,
SUM(CASE
    WHEN pclass=1 THEN 1
    ELSE 0
END) AS first_class,
SUM(CASE
    WHEN pclass=2 THEN 1
    ELSE 0
END) AS second_class,
SUM(CASE
    WHEN pclass=3 THEN 1
    ELSE 0
END) AS third_class
from titanic
GROUP BY survived;
