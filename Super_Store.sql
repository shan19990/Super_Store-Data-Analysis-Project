CREATE DATABASE superstore;
USE superstore;
CREATE TABLE super_store (
dummy_column int
);

SELECT * FROM super_store;

# 1. What are total sales and total profits of each year?
SELECT YEAR(OrderDate) AS year, ROUND(SUM(Sales) ,2) AS Sales, ROUND(SUM(Profit) ,2) AS Profit FROM super_store GROUP BY year ORDER BY year;

# What are the total profits and total sales per quarter?
SELECT YEAR(OrderDate) AS year,
CASE WHEN MONTH(OrderDate) IN (1,2,3) THEN 'Q1'
	 WHEN MONTH(OrderDate) IN (4,5,6) THEN 'Q2'
     WHEN MONTH(OrderDate) IN (7,8,9) THEN 'Q3'
     WHEN MONTH(OrderDate) IN (10,11,12) THEN 'Q4' END AS Quater,
 ROUND(SUM(Sales) ,2) AS Sales, ROUND(SUM(Profit) ,2) AS Profit FROM super_store GROUP BY year,Quater ORDER BY year;

# What region generates the highest sales and profits ?
SELECT Region , ROUND(SUM(Sales) ,2) AS sum_of_sales , ROUND(SUM(Profit) ,2) AS sum_of_profit FROM super_store GROUP BY Region ORDER BY sum_of_profit DESC;

# Profit Margins for each region
SELECT Region , ROUND((ROUND(SUM(Profit) ,2) / ROUND(SUM(Sales) ,2)) * 100 ,2) AS profit_margin FROM super_store GROUP BY Region ORDER BY profit_margin DESC;

# What state and city brings in the highest sales and profits ?
SELECT State , ROUND(SUM(Sales) ,2) AS sum_of_sales , ROUND(SUM(Profit) ,2) AS sum_of_profit , ROUND((ROUND(SUM(Profit) ,2) / ROUND(SUM(Sales) ,2)) * 100 ,2) AS profit_margin FROM super_store GROUP BY State ORDER BY profit_margin DESC;

# What state and city brings in the highest sales and profits ?
SELECT City , ROUND(SUM(Sales) ,2) AS sum_of_sales , ROUND(SUM(Profit) ,2) AS sum_of_profit , ROUND((ROUND(SUM(Profit) ,2) / ROUND(SUM(Sales) ,2)) * 100 ,2) AS profit_margin FROM super_store GROUP BY City ORDER BY profit_margin DESC;

# The relationship between discount and sales and the total discount per category
SELECT YEAR(OrderDate) AS year , Discount , ROUND(AVG(Sales) ,3) AS avg_sales FROM super_store GROUP BY year,Discount;

# Discount per product
SELECT SubCategory , ROUND(AVG(Discount) ,2) FROM super_store GROUP BY SubCategory;

# What category generates the highest sales and profits in each region and state ?
SELECT Region, Category , ROUND(SUM(Sales),2) AS sum_sales ,ROUND(SUM(Profit),2) AS sum_profit FROM super_store GROUP BY Region,Category ORDER BY Region,sum_profit DESC,sum_sales DESC;
SELECT State, Category , ROUND(SUM(Sales),2) AS sum_sales ,ROUND(SUM(Profit),2) AS sum_profit FROM super_store GROUP BY State,Category ORDER BY State,sum_profit DESC,sum_sales DESC;

# What State has the most successfull category
SELECT State,Category , sum_sales, sum_profit FROM (
SELECT State ,Category, ROUND(SUM(Sales),2) AS sum_sales ,ROUND(SUM(Profit),2) AS sum_profit , RANK() OVER(PARTITION BY State ORDER BY ROUND(SUM(Profit),2) DESC) AS ranks FROM super_store GROUP BY State,Category
) AS sum_sales_category 
WHERE ranks = 1;

# What are the names of the products that are the most and least profitable to us?
WITH cte AS (
SELECT ProductName , ROUND(SUM(Profit) ,2) AS sum_profit, RANK() OVER(ORDER BY ROUND(SUM(Profit) ,2)) AS ranks FROM super_store GROUP BY ProductName ORDER BY sum_profit DESC
)
SELECT ProductName, sum_profit FROM cte WHERE ranks IN (1,(SELECT COUNT(*) FROM cte));

# What segment makes the most of our profits and sales ?
SELECT Segment,  ROUND(SUM(Profit) ,2) AS sum_profit , ROUND(SUM(Profit) ,2) AS sum_of_profit , ROUND((ROUND(SUM(Profit) ,2) / ROUND(SUM(Sales) ,2)) * 100 ,2) AS profit_margin FROM super_store GROUP BY Segment ORDER BY profit_margin DESC;

# How many customers do we have (unique customer IDs) in total and how much per region and state?
SELECT Region , COUNT(DISTINCT CustomerID) AS total_customers FROM super_store GROUP BY Region;
SELECT State , COUNT(DISTINCT CustomerID) AS total_customers FROM super_store GROUP BY State;

# Customer rewards program RANK the top customer who are the most profitable for use
SELECT CustomerID , CustomerName , ROUND(SUM(Profit) ,2) AS profit, RANK() OVER(ORDER BY ROUND(SUM(Profit) ,2) DESC) AS top_performers FROM super_store GROUP BY CustomerID,CustomerName LIMIT 10;
