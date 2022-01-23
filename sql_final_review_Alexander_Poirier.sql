
-- AWS RDS MySQL SalesOrders Database

-- List the products with at least 100 units sold.

/*
 * Products
 * 			----- product number 
 * Order_Details
 */

-- products table
SELECT * FROM Products;

SELECT * FROM Orders;

SELECT * FROM Order_Details;

-- need products and order_details
SELECT 
	p.ProductNumber,
	ProductName,
	SUM(QuantityOrdered) AS UnitsSold
FROM Products p 
JOIN Order_Details od 
	ON p.ProductNumber = od.ProductNumber
GROUP BY ProductNumber
HAVING SUM(QuantityOrdered) > 100;


-- List the products where the units sold is greater than the average units sold across all products.


WITH unitsSoldCTE AS (
	SELECT 
		p.ProductNumber,
		ProductName,
		SUM(QuantityOrdered) AS UnitsSold
	FROM Products p 
	JOIN Order_Details od 
		ON p.ProductNumber = od.ProductNumber
	GROUP BY ProductNumber
)
SELECT 
	*,
	(
	 SELECT AVG(UnitsSold)
	 FROM unitsSoldCTE
	) AS AvgUnitsSold
FROM unitsSoldCTE
WHERE UnitsSold > (
	SELECT AVG(UnitsSold)
	FROM unitsSoldCTE
);


-- What is the top selling product in each product category?
use SalesOrders;

WITH unitsSoldCTE AS (
	SELECT 
		p.ProductNumber,
		ProductName,
		SUM(QuantityOrdered) AS UnitsSold,
		c.CategoryDescription,
		RANK () OVER (
			PARTITION BY c.CategoryDescription
			ORDER BY SUM(QuantityOrdered) DESC
		) AS UnitsSoldRank
	FROM Products p 
	JOIN Order_Details od 
		ON p.ProductNumber = od.ProductNumber
	JOIN Categories c 
		ON c.CategoryID = p.CategoryID 
	GROUP BY ProductNumber
)
SELECT *
FROM unitsSoldCTE
WHERE UnitsSoldRank = 1;
