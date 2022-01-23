-- Date and String Functions

-- 01 - # of orders per day
SELECT 
	DAY(OrderDate) AS order_day,
	COUNT(*) AS count_order
FROM Orders
GROUP BY DAY(OrderDate);

-- 02 - # of orders per month
SELECT 
	MONTH(OrderDate) AS order_month,
	COUNT(*) AS count_order
FROM Orders
GROUP BY MONTH(OrderDate);

-- 03 - # of orders per quarter
SELECT 
	QUARTER(OrderDate) AS order_quarter,
	YEAR(OrderDate) AS order_year,
	COUNT(*) AS count_order
FROM Orders
GROUP BY 
	QUARTER(OrderDate),
	YEAR(OrderDate);

-- 04 - # of orders and revenue per day
SELECT 
	DATE(OrderDate) AS order_date,
	COUNT(DISTINCT (o.OrderNumber)) AS count_order,
	COUNT(o.OrderNumber) AS products_ordered_per_day,
	SUM(QuotedPrice * QuantityOrdered) AS revenue_per_day
FROM Orders o
JOIN Order_Details od 
	ON o.OrderNumber = od.OrderNumber 
GROUP BY 
	DATE(OrderDate);


-- Create an Orders2021 table to simulate recent data

-- Copy the Orders schema to Orders2021
CREATE TABLE Orders2021 LIKE Orders;

-- Select Jan - Mar 2018 data into Orders2021
INSERT INTO Orders2021
SELECT *
FROM Orders
WHERE OrderDate BETWEEN '2018-01-01' AND '2018-03-31';

-- What would the OrderDate look like if we added 3 years to make the OrderDate year 2021?
SELECT
	OrderDate,
	DATE_ADD(OrderDate, INTERVAL 3 YEAR)
FROM Orders2021
LIMIT 10;

-- Update OrderDate to reflect 2021. Always add a WHERE to UPDATE and DELETE.
UPDATE Orders2021
SET OrderDate = DATE_ADD(OrderDate, INTERVAL 3 YEAR)
WHERE OrderDate BETWEEN '2018-01-01' AND '2018-03-31';

-- Verify update
SELECT 
	DATE(OrderDate) AS OrderDateDay,
	COUNT(*)
FROM Orders2021
GROUP BY OrderDateDay;

SELECT 	
	OrderDate,
	DATE_ADD(OrderDAte, INTERVAL 1 MONTH)
FROM Orders2021
LIMIT 20;

UPDATE Orders2021
SET OrderDate = DATE_ADD(OrderDate, INTERVAL 1 MONTH)
WHERE OrderDate BETWEEN '2021-01-01' AND '2021-03-31';

-- 05 - How many orders per day for the past month? Do not include orders from today.
-- Only use DATE functions in the WHERE and do not hard code dates.
SELECT 
	DATE(OrderDate) AS OrderDateDay,
	COUNT(*)
FROM Orders2021
WHERE 
	ORDERDATE BETWEEN 
	DATE_SUB(CURDATE(), INTERVAL 1 MONTH) 
	AND 
	DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
GROUP BY OrderDateDay;

SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS yesterday;

SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AS one_month_ago;
-- VIEW

-- 06 - Create a VIEW to hold the results for the order count and revenue per day, category, and product name for all dates
CREATE OR REPLACE VIEW results_orders AS
	SELECT 
		DATE(OrderDate) AS order_date,
		COUNT(DISTINCT (o.OrderNumber)) AS count_order,
		SUM(QuotedPrice * QuantityOrdered) AS revenue_per_day,
		CategoryDescription,
		ProductName
	FROM Orders o
	JOIN Order_Details od 
		ON o.OrderNumber = od.OrderNumber 
	JOIN Products p 
		ON od.ProductNumber = p.ProductNumber 
	JOIN Categories c 
		ON p.CategoryID = c.CategoryID 
	GROUP BY 
		DATE(OrderDate),
		ProductName;


SELECT *
FROM results_orders;
-- 07 - Using the VIEW, return the days and order count where 
-- the order count for products in the bikes category was greater than 2
SELECT 
	order_date,
	count_order,
	CategoryDescription
FROM results_orders
WHERE count_order > 2
AND CategoryDescription = 'bikes';






