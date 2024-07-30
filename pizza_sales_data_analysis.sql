SELECT * FROM pizza_db.order_details;
-- to retrive  total counter of records
SELECT 
    COUNT(order_id) AS total
FROM
    pizza_db.orders;
    
--  max pizza price --
SELECT 
    MAX(price) AS highest_price_pizza
FROM
    pizzas;
    
-- total revinue of pizza sales
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;


--  highest pizzas price  --
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

use pizza_db;

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identify the most common pizza size ordered. ---
select count(size) as sizes, size as size from pizzas join order_details on order_details.pizza_id = pizzas.pizza_id group by size order by sizes DESC limit 1;

SELECT 
    COUNT(order_details.order_details_id) AS order_count,
    pizzas.size AS size
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

SELECT 
    COUNT(od.order_details_id) AS order_count,
    p.size AS size
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.-- 
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.--
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;


-- Determine the distribution of orders by hour of the day.--
SELECT 
    HOUR(order_time) AS hours, COUNT(order_id) AS orders
FROM
    orders
GROUP BY hours
ORDER BY hours ASC;


-- Join relevant tables to find the category-wise distribution of pizzas.--
SELECT 
    pizza_types.category, COUNT(pizza_types.name) AS name_count
FROM
    pizza_types
GROUP BY pizza_types.category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.--
SELECT 
    ROUND(AVG(avg_orders), 0) AS average_number_of_pizzas
FROM
    (SELECT 
        orders.order_date AS date,
            SUM(order_details.quantity) AS avg_orders
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY date) AS order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue. 
SELECT 
    pizza_types.category AS category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY revenue DESC;


-- Analyze the cumulative revenue generated over time.

select date , sum(revenue) over(order by date) as cum_revenue from
(SELECT 
    orders.order_date AS date,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
    
    join orders on orders.order_id = order_details.order_id group by date) as sales ;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name ,category ,revenue from
(select category, name , revenue
, rank() over(partition by category order by revenue desc) as rn from
(SELECT 
    pizza_types.category AS category,
    pizza_types.name AS name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category , name) as a)  as b where rn <= 3;







