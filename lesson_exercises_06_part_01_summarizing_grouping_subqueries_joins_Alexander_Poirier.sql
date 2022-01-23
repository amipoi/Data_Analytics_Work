
-- 01 - How many orders were booked by employees from the 425 area code?
SELECT COUNT(*)
FROM Orders 
WHERE EmployeeID IN
	(
		SELECT EmployeeID 
		FROM Employees 
		WHERE EmpAreaCode = 425
	);

-- 02 - How many orders were booked by employees from the 425 area code? 
-- Use a JOIN instead of a subquery.
SELECT COUNT(*)
FROM Orders o
JOIN Employees e 
	ON o.EmployeeID = e.EmployeeID 
WHERE EmpAreaCode = 425;

-- 03 - Show me the average number of days to deliver products per vendor name.
-- Filter the results to only show vendors where the 
-- average number of days to deliver is greater than 5.
SELECT VendName ,AVG(DaysToDeliver)
FROM Product_Vendors pv
JOIN Vendors v 
	ON pv.VendorID = v.VendorID 
GROUP BY VendName
HAVING AVG(pv.DaysToDeliver) > 5;
-- Avoid GROUP BY column_#


-- 04 - Show me the average number of days to deliver products per vendor name 
-- where the average is greater than the average delivery days for all vendors.
SELECT VendName ,AVG(DaysToDeliver)
FROM Product_Vendors pv
JOIN Vendors v 
	ON pv.VendorID = v.VendorID 
GROUP BY VendName
HAVING AVG(pv.DaysToDeliver) > 
	(
		SELECT AVG(DaysToDeliver)
		FROM Product_Vendors 	
	);

-- 05 - Return just the number of vendors where their number of days to deliver 
-- products is greater than the average days to deliver across all vendors.
SELECT COUNT(*)
FROM 	
	(
		SELECT VendName ,AVG(DaysToDeliver)
		FROM Product_Vendors pv
		JOIN Vendors v 
			ON pv.VendorID = v.VendorID 
		GROUP BY VendName
		HAVING AVG(pv.DaysToDeliver) > 
			(
				SELECT AVG(DaysToDeliver)
				FROM Product_Vendors 	
			)
	
	) AS Days_to_Deliver_Greater_Than_AVG ;

-- 06 - How many products are associated to each category name?
-- Alias the aggregate expression
-- Sort the product counts from high to low
/*
 * Products
 * 			CategoryID
 * Categories
 */
SELECT 
	CategoryDescription, 
		COUNT(*) AS ProductCount
FROM Products p 
JOIN Categories c 
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription 
ORDER BY ProductCount DESC;

-- 07 - List the categories with more than 3 products.
SELECT 
	CategoryDescription, 
		COUNT(*) AS ProductCount
FROM Products p 
JOIN Categories c 
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription 
HAVING ProductCount > 3
ORDER BY ProductCount DESC;

-- 08 - List the categories with a product count greater than the average.
-- Average based on grouped results and not just a column's value.

-- 08.01 - Select the product counts per category
SELECT 
	CategoryDescription, 
		COUNT(*) AS ProductCount
FROM Products p 
JOIN Categories c 
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription 
ORDER BY ProductCount DESC;

-- 08.02 - Get average # of products per category
SELECT AVG(ProductCount)
FROM 
(
	SELECT 
		CategoryDescription, 
		COUNT(*) AS ProductCount
	FROM Products p 
	JOIN Categories c 
		ON p.CategoryID = c.CategoryID 
	GROUP BY CategoryDescription 
	ORDER BY ProductCount DESC	
) AS ProductsCountByCategory;

-- 08.03 - Add the average # of products per category as a subquery 
-- to the right-hand side of the HAVING comparison operator 
SELECT 
	CategoryDescription, 
		COUNT(*) AS ProductCount
FROM Products p 
JOIN Categories c 
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription 
HAVING ProductCount > 
	(
		SELECT AVG(ProductCount)
		FROM 
		(
			SELECT 
				CategoryDescription, 
				COUNT(*) AS ProductCount
			FROM Products p 
			JOIN Categories c 
				ON p.CategoryID = c.CategoryID 
			GROUP BY CategoryDescription 
			ORDER BY ProductCount DESC	
		) AS ProductsCountByCategory
	)
	
ORDER BY ProductCount DESC;

-- 08.04 - Display the average product count alongside the category product count
SELECT 
	CategoryDescription,
	COUNT(*) AS ProductCount,
	(SELECT AVG(ProductCount)
	FROM 
	(
		SELECT 
			CategoryDescription,
			COUNT(*) AS ProductCount
		FROM Products p 
		JOIN Categories c
			ON p.CategoryID = c.CategoryID 
		GROUP BY CategoryDescription
		ORDER BY ProductCount DESC
	) AS AvgProdCount) AS AvgProductCount
FROM Products p 
JOIN Categories c
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription
HAVING ProductCount >
(
	SELECT AVG(ProductCount)
	FROM 
	(
		SELECT 
			CategoryDescription,
			COUNT(*) AS ProductCount
		FROM Products p 
		JOIN Categories c
			ON p.CategoryID = c.CategoryID 
		GROUP BY CategoryDescription
		ORDER BY ProductCount DESC
	) AS AvgProdCount
)
ORDER BY ProductCount DESC;

-- 09 - How many categories have more products than the average product count per category?
SELECT COUNT(*)
FROM
(
	SELECT 
	CategoryDescription,
	COUNT(*) AS ProductCount,
	(SELECT AVG(ProductCount)
	FROM 
	(
		SELECT 
			CategoryDescription,
			COUNT(*) AS ProductCount
		FROM Products p 
		JOIN Categories c
			ON p.CategoryID = c.CategoryID 
		GROUP BY CategoryDescription
		ORDER BY ProductCount DESC
	) AS AvgProdCount) AS AvgProductCount
FROM Products p 
JOIN Categories c
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryDescription
HAVING ProductCount >
(
	SELECT AVG(ProductCount)
	FROM 
	(
		SELECT 
			CategoryDescription,
			COUNT(*) AS ProductCount
		FROM Products p 
		JOIN Categories c
			ON p.CategoryID = c.CategoryID 
		GROUP BY CategoryDescription
		ORDER BY ProductCount DESC
	) AS AvgProdCount
)
ORDER BY ProductCount DESC
) AS ProductCountGreaterThanAVG;
