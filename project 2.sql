select * from bigquery-public-data.thelook_ecommerce.orders
select * from bigquery-public-data.thelook_ecommerce.products
select * from bigquery-public-data.thelook_ecommerce.order_items


select
FORMAT_DATE('%Y-%m',delivered_at) as month_year,
count(order_id) as total_user,
count(status) as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where extract(YEAR from delivered_at) || '-' || extract(MONTH from delivered_at) between'2019-1' and '2020-4'
and status = 'Complete'
group by month_year
order by month_year


