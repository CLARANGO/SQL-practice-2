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

