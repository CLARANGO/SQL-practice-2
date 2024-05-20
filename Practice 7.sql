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
WITH aa AS
(SELECT user_id,	tweet_date, tweet_count as curr_count,
LAG(tweet_count) OVER(PARTITION BY user_id) as fol_count,
LAG(tweet_count,2) OVER(PARTITION BY user_id) as fol_count1
FROM tweets) 

SELECT aa.user_id,	aa.tweet_date,
(CASE
 WHEN aa.fol_count is null THEN ROUND(aa.curr_count::decimal/1,2)
 WHEN aa.fol_count1 is null THEN ROUND((aa.curr_count+aa.fol_count)::decimal/2,2)
 WHEN aa.fol_count1 is not null THEN ROUND((aa.curr_count+aa.fol_count+aa.fol_count1)::decimal/3,2)
 END) as rolling_avg_3d
FROM aa

--EX6

with dup as (
 select  merchant_id, credit_card_id, amount, transaction_timestamp
 from (
 select merchant_id, credit_card_id, amount, transaction_timestamp,
 count(row_number) over (PARTITION BY  merchant_id, credit_card_id, amount)
 from (
select merchant_id, credit_card_id, amount, transaction_timestamp,
row_number() over( PARTITION BY  merchant_id, credit_card_id, amount)
from transactions) b )c 
where count >1 ),

gap as (
select merchant_id, credit_card_id, amount,
transaction_timestamp, transaction_timestamp,
(DATE_PART('Day', following_payment_date - transaction_timestamp)) * 24 + 
(DATE_PART('Hour', following_payment_date - transaction_timestamp)) * 60 +
(DATE_PART('Minute', following_payment_date - transaction_timestamp)) as diff

from(
select merchant_id, credit_card_id, amount, transaction_timestamp,
lead(transaction_timestamp) over(order by transaction_timestamp) as following_payment_date
 from dup) as d )
 
SELECT sum (count) as payment_count
from (
select merchant_id, credit_card_id,
count(merchant_id) 
from gap 
where diff <=10
GROUP BY merchant_id, credit_card_id) as count_repeated_trans



--EX7
with a as (select category, product,
sum(spend) as total_spend
from product_spend
where transaction_date between '2022-01-01' and '2022-12-31'
group by category, product)

select category, product, total_spend
from (select category, product, total_spend,
rank() over(PARTITION BY category order by total_spend desc) as rank_
from a) as b  
where rank_ <=2


--EX8
with aa as (SELECT c.day, a.artist_id, a.artist_name, b.song_id, c.rank 
FROM artists as a  
join songs as b  on a.artist_id=b.artist_id
join global_song_rank  as c on b.song_id=c.song_id
where c.rank <=10)

select artist_name, artist_rank from (
select artist_name ,
dense_rank() over(order by count DESC) as artist_rank
from 
(SELECT artist_name,
count(rank)
from aa
group by artist_name) as bb) as cc  
where artist_rank <=5
 ;




-------------------------------------------------------------
PRACTICE 8




--1
with aa as( Select customer_id, min(order_date) as first_date
  from Delivery
group by customer_id)

Select 
    round(avg(order_date = customer_pref_delivery_date)*100, 2) as immediate_percentage
from Delivery as bb
join aa on aa.customer_id=bb.customer_id
where order_date=aa.first_date


--2
with a as
(select player_id, min(event_date )as firstdate
from Activity 
group by player_id)

select 
round((sum(case
when a.firstdate +1=b.event_date then 1
else 0
end))
/count(distinct a.player_id)::decimal,2) 
as fraction
from Activity  as b
join a on a.player_id=b.player_id


--3



--4
with b as(
select visited_on, amount_ind,
sum(amount_ind) over(order by visited_on rows between 6 preceding and current row) as amount,
round(avg(amount_ind) over(order by visited_on rows between 6 preceding and current row),2)as average_amount 
from(
SELECT visited_on,
SUM(amount) as amount_ind
FROM Customer
GROUP BY visited_on) as a)

select visited_on, amount, average_amount 
from (
select visited_on, amount, average_amount,
lag(visited_on,6) over(order by visited_on) as visited_7days_pre
from b) as c
where visited_7days_pre is not null


--5

select 
cast(sum(tiv_2016 ) as decimal) as tiv_2016 
from(
select pid , tiv_2015 , tiv_2016 , loc,
count(rank_loc) over(partition by rank_loc) as count_loc,
count(rank) over(partition by rank) as count_tiv
from(
select pid , tiv_2015 , tiv_2016 , concat(lat,',',lon) as loc,
rank() over(order by concat(lat,',',lon)) as rank_loc,
rank() over(order by tiv_2015)
from Insurance ) as a 
) as b
where count_tiv !=1 and count_loc =1


--6
with ab as (
select * from (
select * ,
dense_rank() over(partition by departmentId order by salary desc)
from employee
) as a
where dense_rank <=3)

select b.name as department, ab.name as employee, ab.salary
from Department as b 
join ab 
on b.id =ab.departmentid 


--7
select person_name 
from (
select *,
sum(weight) over (order by turn)
from Queue ) as a
where sum<=1000 order by turn desc
limit 1



--8
