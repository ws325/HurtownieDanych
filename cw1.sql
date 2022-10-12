
select * from order_details;

select * from orders;

select * from pizza_types;

select * from pizzas;

-- zad 1
with cte as (																					-- cte ( common table as expression ) - lokalny sposób na upoirz¹dkowanie kodu
select order_details.*, pizzas.price, pizzas.price*order_details.quantity as summary_amount, orders.date as order_date
from order_details
inner join pizzas on pizzas.pizza_id = order_details.pizza_id
inner join orders on orders.order_id = order_details.order_id
where orders.date = '2015-02-18'
)

select avg(summary_amount) as avg_orders_amount, order_date  from cte
group by order_date;


-- zad 2
select orders.order_id
from orders
inner join order_details on order_details.order_id = orders.order_id
inner join pizzas on pizzas.pizza_id = order_details.pizza_id
inner join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
where month(date) = 3 and year(date) = 2015
group by orders.order_id
having string_agg(ingredients, ',') NOT LIKE '%Pineapple%'


-- zad 3
with cte as (	
select sub.order_id, sum( sub.summary_amount ) as summary_amount_of_order from (
select order_details.*, pizzas.price, pizzas.price*order_details.quantity as summary_amount,  orders.date as order_date
from order_details
inner join pizzas on pizzas.pizza_id = order_details.pizza_id
inner join orders on orders.order_id = order_details.order_id
where month(orders.date) = 2 
) sub
group by sub.order_id
)

select sub2.* from ( select order_id, summary_amount_of_order,
rank () over ( order by summary_amount_of_order desc ) as rank_over
from cte) sub2
where rank_over <= 10;


-- zad 4
with order_amount_cte as ( 
select order_details.order_id, sum(price * quantity) as order_amount, month(date) as month, date
from order_details
inner join pizzas on pizzas.pizza_id = order_details.pizza_id
inner join orders on orders.order_id = order_details.order_id
group by order_details.order_id, date
),

monthly_amount_avg as (
select month, avg(order_amount) as average_month_amount from order_amount_cte
group by month
)

select order_id, order_amount, average_month_amount, date
from order_amount_cte
inner join monthly_amount_avg on monthly_amount_avg.month = order_amount_cte.month;


-- zad 5
select count(sub.hour) as order_count, sub.date, sub.hour
from (
select order_id, datepart(HOUR, time) as hour, date from orders
where date = '2015-01-01'
) sub
group by sub.hour, sub.date;


-- zad 6
with cte_pizza_type_id as(
select orders.order_id, orders.date, quantity, pizzas.pizza_type_id, pizza_types.category
from orders
inner join order_details on orders.order_id = order_details.order_id
inner join pizzas on pizzas.pizza_id = order_details.pizza_id
inner join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
where month(orders.date) = 1
),

ctee as (
select pizza_type_id, category, sum(quantity) as summary_val from cte_pizza_type_id
group by pizza_type_id, category
)

select * from ctee
order by summary_val desc;


-- zad. 7
select  lower(size) as size, count(orders.order_id) as count from orders
inner join order_details on orders.order_id = order_details.order_id
inner join pizzas on order_details.pizza_id = pizzas.pizza_id 
where month(orders.date) = 2 or month(orders.date) = 3
group by size;