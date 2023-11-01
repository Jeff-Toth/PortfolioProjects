SELECT * 
FROM pizza_sales

--KPI's
--Finding total revenue
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales

--Average Order Value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Average_Order_Value
FROM pizza_sales

--Total Pizzas Sold
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales

--Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

--Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Average_Pizzas_Per_Order
FROM pizza_sales

--Daily and Monthly Trend
--Daily Trend for Total Orders
SELECT DATENAME(DW, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

--Monthly Trend for Total Orders
SELECT DATENAME(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) AS Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Orders DESC

--Percentage of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL (10,2)) AS Percentage_Total_Sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Percentage_Total_Sales DESC

--Percentage of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS Percentage_Total_Sales
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Percentage_Total_Sales DESC

--Top 5 Sellers by Revenue, Total Quantity, and Total Orders
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS DECIMAL (10,2)) AS Total_Revenue from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

--Bottom 5 Sellers by Revenue, Total Quantity, and Total Orders
SELECT TOP 5 pizza_name, CAST(SUM(total_price) AS DECIMAL (10,2)) AS Total_Revenue from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue

--Top 5 Sellers by Total Quantity
SELECT TOP 5 pizza_name, CAST(SUM(quantity) AS DECIMAL (10,0)) AS Total_Quantity from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC

--Bottom 5 Sellers by Total Quantity
SELECT TOP 5 pizza_name, CAST(SUM(quantity) AS DECIMAL (10,0)) AS Total_Quantity from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity

--Top 5 Sellers by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC

--Bottom 5 Sellers by Total Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders from pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders