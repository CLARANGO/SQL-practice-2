--select* from bigquery-public-data.thelook_ecommerce.order_items order by product_id
--select * from bigquery-public-data.thelook_ecommerce.orders
--select * from bigquery-public-data.thelook_ecommerce.products order by id




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


--- chi hi huc ca toi tuong 1) vs 2) lien quan den nhau nen chua lam xong haha. 
--em xem tam phan nay di chi lam roi nop tiep huhuhu 





