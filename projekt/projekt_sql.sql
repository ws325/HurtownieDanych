-- 1) sredmia kroczca dla dni
with cte_date as (
	select sum(cast(amount as decimal)) as sales_amount,  cast(date as date) as date
	from FactSales
	group by date
	),

cte_d_sales as (
select sum(sales_amount) as sales_amount,  date 
from cte_date
group by date
)

select sales_amount, date,
avg(sales_amount) over (order by date rows between 3 preceding and current row) as rolling_avg
from cte_d_sales
order by date;

-- 2) roczny ranking sprzedazowy firm 
select DIMCarrier.carrier_name, year(date) as year,
sum(cast(amount as decimal)) as sales_amount,
PERCENT_RANK() over (partition by year(date) order by sum(cast(amount as decimal)) desc) as rank
from FactSales
join DIMCarrier on FactSales.carrier_id_key = DIMCarrier.carrier_id
group by rollup(carrier_name, year(date));

-- 3)
with cte_1 as (
select country, sum(cast(amount as decimal)) as amount, year(date) as year_
from FactSales
left join DIMCustomers on FactSales.customer_id_key = DIMCustomers.id_key
group by date, country),

cte_2 as (
select country, year_, sum(amount) as amount from cte_1
group by country, year_)

select rank() over( order by amount desc) as rank,  country, year_, amount
from cte_2;
