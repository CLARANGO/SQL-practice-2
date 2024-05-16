

-----------------------------------
select order_id,
format_date('%Y-%m', created_at) as month,
extract(year from created_at) as year
from bigquery-public-data.thelook_ecommerce.orders
where status='Complete' 


select
format_date('%Y-%m', delivered_at) as month,
sum(sale_price)  as TPV,
count(order_id) as TPO
from bigquery-public-data.thelook_ecommerce.order_items
where status='Complete' 
group by month


select id as product_id,
category as product_category,
cost
from bigquery-public-data.thelook_ecommerce.products

---------------------------------------
select* from bigquery-public-data.thelook_ecommerce.order_items order by product_id
select * from bigquery-public-data.thelook_ecommerce.orders
select * from bigquery-public-data.thelook_ecommerce.products order by id

with a as (
select b.order_id, b.product_id,
format_date('%Y-%m', a.created_at) as month,
extract(year from a.created_at) as year,
b.sale_price,
c.category as product_category,
c.cost
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c on b.product_id=c.id
where b.status='Complete' 
order by month
)

select month,
sum(sale_price)  as TPV,
count(order_id) as TPO,
sum(cost) as total_cost
from a
group by month
order by month
