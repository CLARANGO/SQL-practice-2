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



