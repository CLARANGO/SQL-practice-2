select * from bigquery-public-data.thelook_ecommerce.orders
select * from bigquery-public-data.thelook_ecommerce.products
select * from bigquery-public-data.thelook_ecommerce.order_items


select
FORMAT_DATE('%Y-%m',delivered_at) as month_year,
count(order_id) as total_user,
sum (case when status = 'Complete' then 1 else 0 end) as total_order,
from bigquery-public-data.thelook_ecommerce.order_items
where FORMAT_DATE('%Y-%m',delivered_at) between'2019-01' and '2020-04'
group by month_year
order by month_year

--There was a consistent growth of more than 200 in the number of buyers from Jan 2019 to April 2020. In addition, the total number of completed orders between Jan 2019 and April 2020 was stable at above 50% of the total number of orders.








