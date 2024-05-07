--EX1
SELECT EXTRACT(year FROM transaction_date), product_id,
spend as curr_year_spend,
lag(spend) over(PARTITION BY product_id ORDER BY product_id) AS prev_year_spend,
ROUND(100*(spend-lag(spend) over(PARTITION BY product_id ORDER BY product_id))/lag(spend) over(PARTITION BY product_id ORDER BY product_id),2) AS yoy_rate
FROM user_transactions;

--EX2
(SELECT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month ) as issued_amount
FROM monthly_cards_issued
WHERE card_name ='Chase Freedom Flex'
LIMIT 1)
UNION ALL
(SELECT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) as issued_amount
FROM monthly_cards_issued
WHERE card_name ='Chase Sapphire Reserve'
LIMIT 1)
ORDER BY issued_amount DESC;

--EX3
SELECT user_id, spend, transaction_date
FROM
(SELECT *, RANK() OVER(PARTITION BY user_id ORDER BY transaction_date) as rank 
FROM transactions) 
as a
WHERE a.rank=3;

--EX4
SELECT transaction_date, user_id,
COUNT(*) as purchase_count
FROM (SELECT transaction_date,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as rank_,
user_id
FROM user_transactions) as a  
WHERE rank_=1
GROUP BY user_id,transaction_date
ORDER BY transaction_date;

--EX5
