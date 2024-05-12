select * from public.sales_dataset_rfm_prj;


alter table sales_dataset_rfm_prj
alter column priceeach type numeric using priceeach::numeric,
alter column sales type numeric using sales::numeric,

update sales_dataset_rfm_prj
set orderdate= to_timestamp(orderdate, 'mm/dd/yyyy HH24:MI');
alter table sales_dataset_rfm_prj
alter column orderdate type timestamp USING orderdate::timestamp without time zone;

alter table sales_dataset_rfm_prj
alter customername type text,
alter productline type text ,
alter addressline1 type text,
alter addressline2 type text,
alter city type text,
alter state type text,
alter country type text,
alter territory type text,
alter contactfullname type text;

alter table sales_dataset_rfm_prj
alter orderlinenumber type int USING orderlinenumber::integer,
alter quantityordered type int USING quantityordered::integer,
alter column ordernumber type int using sales::integer,
alter msrp type int USING msrp::integer;


select * from public.sales_dataset_rfm_prj
where ordernumber is null
or quantityordered is null 
or priceeach is null 
or orderlinenumber is null
or sales is null
or orderdate is null or orderdate= ''


select * from public.sales_dataset_rfm_prj;

alter table sales_dataset_rfm_prj
add column contactlastname text,
add column contactfirstname text;

update sales_dataset_rfm_prj
set contactlastname = substring(contactfullname from 1 for position('-' in contactfullname)-1);
update sales_dataset_rfm_prj
set contactlastname = upper(left(contactlastname,1))||lower (substring(contactlastname,2));

update sales_dataset_rfm_prj
set contactfirstname = substring(contactfullname, position('-' in contactfullname)+1);
update sales_dataset_rfm_prj
set contactfirstname = upper(left(contactfirstname,1))||lower (substring(contactfirstname,2));

alter table sales_dataset_rfm_prj
add column qtr_id int,
add column month_id int,
add column year_id int;


--alter table sales_dataset_rfm_prj
--drop column qtr_id,
--drop column month_id, 
--drop column year_id;

update sales_dataset_rfm_prj
set qtr_id= extract(quarter from orderdate);

update sales_dataset_rfm_prj
set month_id= extract(month from orderdate);

update sales_dataset_rfm_prj
set year_id= extract(year from orderdate);

with avg_sd as (
select quantityordered,
(select avg(quantityordered) as avg from sales_dataset_rfm_prj),
(select stddev(quantityordered) as sd from sales_dataset_rfm_prj)
from sales_dataset_rfm_prj)

select quantityordered, (quantityordered-avg)/sd as z_score
from avg_sd
where abs((quantityordered-avg)/sd)>3

