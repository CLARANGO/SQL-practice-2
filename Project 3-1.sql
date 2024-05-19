select * from sales_dataset_rfm_prj_clean
--1) Doanh thu theo từng ProductLine, Year  và DealSize?
select productline, year_id, dealsize,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by productline, year_id, dealsize
order by productline,year_id, dealsize desc

--2) Đâu là tháng có bán tốt nhất mỗi năm? 11
select month_id, count(ordernumber) as order_number,
sum(sales) as revenue,
rank() over(order by sum(sales) desc)
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by month_id
order by revenue desc

--3) Product line nào được bán nhiều ở tháng 11? Classic Cars
select month_id, productline, 
count(ordernumber) as order_number,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
where month_id=11 and status = 'Shipped'
group by month_id, productline
order by revenue desc

--4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
--2003	"Classic Cars"	66705.63	1
--2004	"Vintage Cars"	72660.77	1
--2005	"Motorcycles"	20267.57	1

select year_id, productline,
sum(sales) as revenue,
rank() over(partition by year_id order by sum(sales)desc)
from public.sales_dataset_rfm_prj_clean
where country='UK' and status = 'Shipped'
group by year_id, productline

--5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
--find RFM 
with customer_rfm as (
select contactfullname,
current_date - max(orderdate) as R,
count(distinct ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by contactfullname)


--divide rfm by scale 1-5
, rfm as (select contactfullname,
ntile(5) over(order by r desc) as r_score,
ntile(5) over(order by f) as f_score,
ntile(5) over(order by m) as m_score
from customer_rfm),


--reflect on corresponding criteria
rfm_fin as(
select contactfullname, 
cast(r_score as varchar) ||cast(f_score as varchar) 
||cast(m_score as varchar) as rfm_score
from rfm)

select segment,
count(*) from (
select a.contactfullname, b.segment
from rfm_fin as a
join public.segment_score as b on a.rfm_score=b.scores) as c
group by segment
order by count(*)






