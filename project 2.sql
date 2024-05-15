--select * from bigquery-public-data.thelook_ecommerce.orders
--select * from bigquery-public-data.thelook_ecommerce.products
--select * from bigquery-public-data.thelook_ecommerce.order_items
--select * from bigquery-public-data.thelook_ecommerce.users


select
FORMAT_DATE('%Y-%m',delivered_at) as month_year,
count(order_id) as total_user,
sum (case when status = 'Complete' then 1 else 0 end) as total_order,
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m',delivered_at) between'2019-01' and '2020-04'
group by month_year
order by month_year

-- There was a consistent growth of more than 850 in the number of buyers from Jan 2019 to April 2022. The number of buyers dropped from 824 to 714 then rose again to 914 in three months from January 2022 to March 2022
-- In addition, the total number of completed orders between Jan 2019 and April 2022 was increasing and stable at above 70% of the total order number.

select
FORMAT_DATE('%Y-%m',delivered_at) as month_year,
count(distinct user_id) as total_user,
round (sum(sale_price)/count(*),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m',delivered_at) between'2019-01' and '2020-04'
group by month_year
order by month_year


--There was a significant rise of more than 600 in the number of distinct customers while the average sales amount per order remained quite stable at the range from 55 to 70 over the period from Jan 2019 to April 2024.
--There was a slight drop in the quantity of customers of 63 between January 2022 and February 2022 before increasing significantly by 123 customers in March 2022.

with a as (
select 
first_name, last_name, gender, age
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01' and '2022-04-30'
and age in (select min(age)from bigquery-public-data.thelook_ecommerce.users group by gender)
union all
select 
first_name, last_name, gender,age
from bigquery-public-data.thelook_ecommerce.users
where created_at between '2019-01-01' and '2022-04-30'
and age in (select max(age)from bigquery-public-data.thelook_ecommerce.users group by gender)
)

select *,
case  when age =12 then 'youngest' else 'oldest' end as TAG
from a

--From January 2019 to April 2022, the youngest age of both male and female customers is 12 with 1028 customers, while the oldest age is 70 with 1070 customers.

  
with a as (
select FORMAT_DATE ('%Y-%m', delivered_at) as month_year,
product_id, 
round (sum (sale_price) over(partition by product_id,FORMAT_DATE('%Y-%m',delivered_at)),2) as sales
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete'
order by month_year ),

b as (select id as product_id, name as product_name, round (cost,2) as cost
from bigquery-public-data.thelook_ecommerce.products
order by id)

select * from(
select a.month_year, a.product_id, b.product_name, a.sales, b.cost ,
round(a.sales/b.cost *100,2) as profit,
dense_rank() over(partition by a.month_year order by cast(a.sales/b.cost *100 as string)) as rank_per_month
from a join b on a.product_id=b.product_id
order by a.month_year) as c
where rank_per_month<=3




