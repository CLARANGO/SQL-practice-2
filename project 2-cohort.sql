--select* from bigquery-public-data.thelook_ecommerce.order_items order by product_id
--select * from bigquery-public-data.thelook_ecommerce.orders
--select * from bigquery-public-data.thelook_ecommerce.products order by id


--1) create dataset

with aa as (
select b.order_id, b.product_id,
format_date('%Y-%m', a.created_at) as month,
extract(year from a.created_at) as year,
b.sale_price,
c.category as product_category,
c.cost
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where b.status='Complete' and b.sale_price >0 and c.cost>0 and c.category <>''
order by product_category, month
),

bb as (
select month, year, product_category,
round(sum(sale_price),2)  as TPV,
count(order_id) as TPO,
round(sum(cost),2) as total_cost,
round(sum(sale_price)-sum(cost) ,2) as total_profit,
round((sum(sale_price)-sum(cost))/sum(cost),2) as profit_to_cost_ratio
from aa
group by  month, year, product_category
order by product_category, month
),
vw_ecommerce_analyst as (
select
month, year, product_category, TPV,TPO, 
round((lead(TPV) over(partition by product_category order by month)-TPV)/TPV*100,2) ||'%' as revenue_growth,
round((lead(TPO) over(partition by product_category order by month)-TPO)/TPO*100,2)|| '%' as order_growth,
total_cost, total_profit, profit_to_cost_ratio
from bb 
order by product_category,month)




  
--2) retention cohort analysis.
--Exploration & Cleaning

with a as (select 
id,
order_id,
user_id,
product_id,
inventory_item_id,
status,
created_at,
shipped_at,
delivered_at,
returned_at,
cast(sale_price as numeric) as price
from bigquery-public-data.thelook_ecommerce.order_items
where user_id is not null and cast(sale_price as numeric)>0 ),

for_corhort as (
select * from (select *,
row_number() over(partition by id, order_id,user_id,product_id,inventory_item_id,status order by created_at) as rnk
from a ) as b
where rnk=1 ),

--cohort
d as(
select user_id, price,
format_date('%Y-%m', first_purchase_date) as cohort_date,
created_at,
(extract(year from created_at) - extract(year from first_purchase_date))*12
+ (extract(month from created_at)-extract(month from first_purchase_date)) +1 as index
from (
select user_id,
round(price,2) as price,
min (created_at) over(partition by user_id) as first_purchase_date,
created_at
from for_corhort
where status NOT IN ( ' Cancelled', 'Returned'))
--where first_purchase_date between'2024-02-01' and '2024-05-31'
--and created_at between'2024-02-01' and '2024-05-31'
),
YY as(
select cohort_date, index,
count(distinct user_id) as no_customers,
sum(price) as revenue
from d
group by cohort_date, index
order by cohort_date, index),


--cohort chart
c_chart as(
select cohort_date,
sum(case when index =1 then no_customers else 0 end) as M1,
sum(case when index =2 then no_customers else 0 end) as M2,
sum(case when index =3 then no_customers else 0 end) as M3,
sum(case when index =4 then no_customers else 0 end) as M4,
from yy
group by cohort_date
order by cohort_date )


--retention cohort


select cohort_date,
concat (round (m1/m1*100) , '%') as m1,
concat (round (m2/m1*100) , '%') as m2,
concat (round (m3/m1*100) , '%') as m3,
concat (round (m4/m1*100) , '%') as m4
from c_chart 











