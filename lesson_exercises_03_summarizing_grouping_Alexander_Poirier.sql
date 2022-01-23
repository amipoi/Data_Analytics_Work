-- How many products do we carry?
SELECT COUNT(ProductNumber)
FROM Products;

-- What does the data look like in the Products table?
SELECT * 
FROM Products 
LIMIT 10;

DESCRIBE Products 

-- What are the unique product categories?
SELECT DISTINCT (CategoryID)
FROM Products;

-- How many unique product categories exist?
SELECT COUNT(DISTINCT(CategoryID))
FROM Products;

-- How many products are associated to each category?
SELECT CategoryID, COUNT(ProductNumber)
FROM Products 
GROUP BY CategoryID;

-- Sort the product counts from high to low.
SELECT CategoryID, COUNT(ProductNumber)
FROM Products 
GROUP BY CategoryID
ORDER BY COUNT(ProductNumber) DESC;

-- List the categories with more than 3 products.
SELECT CategoryID, COUNT(ProductNumber)
FROM Products
GROUP BY CategoryID
HAVING COUNT(ProductNumber)>3
ORDER BY COUNT(ProductNumber) DESC;

-- List the categories with a product count greater than the average.
-- Get average # of products per CategoryID
	
SELECT AVG(ProductCount)
FROM 
	(
	SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
	FROM Products
	GROUP BY CategoryID 
	) AS ProductCountsByCategoryID;

-- Add the average # of products per CategoryID as a subquery to the right-hand side of the comparison operator 
SELECT CategoryID, COUNT(ProductNumber)
FROM Products
GROUP BY CategoryID
HAVING COUNT(ProductNumber)> 
	(
		SELECT AVG(ProductCount)
		FROM 
		(
			SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
			FROM Products
			GROUP BY CategoryID 
		) AS ProductCountsByCategoryID
	);
-- Display the average product count alongside the CategoryID product count
SELECT 
	CategoryID, 
	COUNT(ProductNumber) AS ProductCount, 
	(
		SELECT AVG(ProductCount)
		FROM 
			(
				SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
				FROM Products
				GROUP BY CategoryID 
			) AS ProductCountsByCategoryID
	) AS AverageProductCount
FROM Products
GROUP BY CategoryID
HAVING COUNT(ProductNumber)> 
	(
		SELECT AVG(ProductCount)
		FROM 
			(
				SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
				FROM Products
				GROUP BY CategoryID 
			) AS ProductCountsByCategoryID
	);

-- How many categories have more products than the average product count per CategoryID?
SELECT COUNT(*) AS CategoryIDCount
FROM
	(
	SELECT 
	CategoryID, 
	COUNT(ProductNumber) AS ProductCount, 
	(
		SELECT AVG(ProductCount)
		FROM 
			(
				SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
				FROM Products
				GROUP BY CategoryID 
			) AS ProductCountsByCategoryID
	) AS AverageProductCount
FROM Products
GROUP BY CategoryID
HAVING COUNT(ProductNumber)> 
	(
		SELECT AVG(ProductCount)
		FROM 
			(
				SELECT CategoryID, COUNT(ProductNumber) AS ProductCount
				FROM Products
				GROUP BY CategoryID 
			) AS ProductCountsByCategoryID
	) 

	) AS ProductCountGreaterThanAverage;

/*
The inventory coordinator wants to reduce their overall cost by 
first comparing the pricing for products supplied by multiple vendors. 
Return products with more than 2 vendors and list the vendors 
as a comma-delimited list next to the product.
*/

-- Which table do we need?
-- What does the data look like in that table?
SELECT *
FROM Product_Vendors;

-- How many vendors supply each product?
SELECT ProductNumber, COUNT(VendorID)
FROM Product_Vendors 
GROUP BY ProductNumber;

-- Filter the results to show products that have more than 2 vendors.
SELECT ProductNumber, COUNT(VendorID)
FROM Product_Vendors 
GROUP BY ProductNumber
HAVING COUNT(VendorID) > 2;

-- Update the query to return a comma-delimited list of vendors per product.
SELECT ProductNumber, GROUP_CONCAT(VendorID) AS VendorIDs
FROM Product_Vendors 
GROUP BY ProductNumber
HAVING COUNT(VendorID) > 2;

-- Show the vendor pricing for products with more than 2 vendors.
-- Which products have more than 2 vendors?
SELECT ProductNumber, VendorID, WholesalePrice 
FROM Product_Vendors 
WHERE ProductNumber IN 
	(
		SELECT ProductNumber
		FROM Product_Vendors 
		GROUP BY ProductNumber
		HAVING COUNT(VendorID) > 2
	);




SELECT ProductNumber
FROM Product_Vendors 
GROUP BY ProductNumber
HAVING COUNT(VendorID) > 2;
