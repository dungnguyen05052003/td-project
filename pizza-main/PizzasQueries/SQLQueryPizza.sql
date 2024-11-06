USE Pizza_sales




-- KPIs

-- 1) Total Revenue (Tính tổng doanh thu)

SELECT *
FROM pizzas
WHERE pizza_id = 'big_meat_s'

SELECT 
 round(SUM(quantity * price), 2) AS [Total Revenue]
FROM order_details AS o
 JOIN pizzas AS p
 ON o.pizza_id = p.pizza_id


 -- 2) Average Order Value (Tính tông giá trị trung binh của đơn đặt hàng)
 -- total order value/order count

 SELECT 
  round(SUM(quantity * price)/COUNT(DISTINCT order_id), 2) AS [Average Order Value]
 FROM order_details AS o
 JOIN pizzas AS p
 ON o.pizza_id = p.pizza_id



 -- 3) Total Pizzas Sold (Tổng giá bán Pizza)

 SELECT 
  SUM(quantity) AS [Total Pizzas Sold]
 FROM order_details;





-- 4) Total Orders (Tổng đơn đặt hàng)
SELECT 
COUNT(DISTINCT order_id) AS [Total Orders]
 FROM order_details;







-- 5) Average Pizza per Order (Tính trung bình số Pizza trên 1 đơn đặt hàng)
-- pizzas sold/number of pizzas

SELECT 
 SUM(quantity)/COUNT(DISTINCT order_id) AS [Average Pizzas Per Order]
FROM order_details;






-- QUESTIONS TO ANSWER 

-- 1) Daily Trends for Total Orders (Xu hướng hằng ngày cho tổng số đơn đặt hàng)
SELECT 
 FORMAT( date, 'dddd') AS DayOfWeek
 ,COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT( date, 'dddd')
ORDER BY total_orders DESC;


-- abbreviated day of week (viết tắt ngày)
SELECT 
    LEFT(FORMAT(date, 'dddd'), 3) AS AbbreviatedDayOfWeek,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    orders
GROUP BY 
    FORMAT(date, 'dddd'),
    LEFT(FORMAT(date, 'dddd'), 3)
ORDER BY 
    total_orders DESC;




-- 2) Hourly Trend for Total Orders ( Xu hướng hằng giờ cho tổng số đơn đặt hàng)

SELECT 
 DATEPART(HOUR, time) AS [Hour]
 ,COUNT(DISTINCT order_id) AS count
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [Hour];





-- 3) Percentage of Sales by Pizza Category	( phần trăm doanh thu theo phân loại Category Pizza)
-- a: calculate total revenue per category
-- % sales calculated as (a:/total revenue) * 100


SELECT 
category
,SUM(quantity * price) AS revenue
,round(SUM(quantity * price) * 100/(
  SELECT SUM(quantity * price)
  FROM pizzas AS p2
  JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
  ), 2) AS percentage_sales
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY percentage_sales DESC;


-- 4) Percentage of Sales by Pizza Size (phần trăm doanh thu theo phân loại kích thước của Pizza)
SELECT 
size
,SUM(quantity * price) AS revenue
,round(SUM(quantity * price) * 100/(
  SELECT SUM(quantity * price)
  FROM pizzas AS p2
  JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
  ), 2) AS percentage_sales
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY percentage_sales DESC;



-- 5) Total Pizzas Sold by Pizza Category ( tổng số lượng Pizza đã bán theo Pizza Category)

SELECT 
category
,SUM(quantity) AS quantity_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY SUM(quantity) DESC;



-- 6) Top 5 Best Sellers by Total Pizzas Sold ( Top 5 sản phẩm Best Seller theo tổng số Pizzas đã bán)


SELECT TOP 5
name
,SUM(quantity) AS total_pizzas_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold DESC;






-- 7) Bottom 5 Worst Sellers by Total Pizzas Sold (Top 5 sản phẩm Worst Seller theo tổng số Pizzas đã bán)
SELECT TOP 5
name
,SUM(quantity) AS total_pizzas_sold
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold ASC;



-- orders by categories and dates (Đơn đặt hàng phân loại theo categories and dates)

select
 category
 ,p.size
 ,pt.name
 ,o.date
 ,o.time
 ,COUNT(DISTINCT o.order_id) as total_orders
 ,SUM(price * quantity) AS total_sales
FROM 
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
JOIN orders AS o ON o.order_id = od.order_id
GROUP BY category, o.date, p.size, pt.name,o.time;


