-- 01 - How many employees are from Washington?
SELECT COUNT(*)
FROM Employees 
WHERE EmpState = 'WA';

-- 02 - How many vendors provided a web page?
DESC Vendors;

SELECT COUNT(VendWebPage), COUNT(*)
FROM Vendors;

-- 03 - What is the total quantity ordered for the product, Eagle FS-3 Mountain Bike?
SELECT SUM(QuantityOrdered)
FROM Order_Details 
WHERE ProductNumber = 2;

SELECT * 
FROM Products 
WHERE ProductName = 'Eagle FS-3 Mountain Bike';

DESC Order_Details ;

-- 04 - How much is the current inventory worth?
SELECT SUM(RetailPrice * QuantityOnHand)
FROM Products;

-- 05 - What is the average quoted price for the Dog Ear Aero-Flow Floor Pump (ProductNumber 21)?
SELECT AVG(QuotedPrice)
FROM Order_Details 
WHERE ProductNumber = 21;

-- 06 - Count the unique number of quoted prices for the Dog Ear Aero-Flow Floor Pump (ProductNumber 21).
SELECT COUNT(DISTINCT(QuotedPrice)) AS UniqueQuotedPriceCount
FROM Order_Details 
WHERE ProductNumber = 21;
-- 07 - What is lowest, highest, and average retail price charged for a product?
SELECT 
	MIN(RetailPrice), 
	MAX(RetailPrice), 
	AVG(RetailPrice)
FROM Products;

-- 08 - Show me each vendor ID and the average by vendor  ID of the number of days to deliver products
DESC Product_Vendors;

SELECT VendorID, AVG(DaystoDeliver)
FROM Product_Vendors 
GROUP BY VendorID
ORDER BY AVG(DaysToDeliver);

-- 09 - Display for each product the product number and the total sales sorted by the product number
SELECT ProductNumber, SUM(QuotedPrice * QuantityOrdered) AS Sales
FROM Order_Details 
GROUP BY ProductNumber
ORDER BY Sales DESC;

-- 10 - List all vendors IDs and the count of products sold by each. Sort the results by the count of products sold in descending order.
SELECT VendorID, COUNT(ProductNumber)
FROM Product_Vendors 
GROUP BY VendorID 
ORDER BY COUNT(ProductNumber) DESC;

-- 11 - Display the customer ID and their most recent order date.
SELECT CustomerID , MAX(OrderDate)
FROM Orders 
GROUP BY CustomerID 
ORDER BY MAX(OrderDate);

-- 12 - Show me each vendor ID and the average by vendor  ID of the number of days to deliver products. 
-- Filter the results to only show vendors where the average number of days to deliver is greater than 5.
SELECT VendorID, AVG(DaysToDeliver)
FROM Product_Vendors 
GROUP BY VendorID 
HAVING AVG(DaysToDeliver)>5;

-- 13 - Show me each vendor and the average by vendor of the number of days to deliver products that are greater than the average delivery days for all vendors
SELECT VendorID, AVG(DaysToDeliver)
FROM Product_Vendors 
GROUP BY VendorID 
HAVING AVG(DaysToDeliver)>
	(
		SELECT AVG(DaysToDeliver)
		FROM Product_Vendors
	);

SELECT AVG(DaysToDeliver)
FROM Product_Vendors;

-- 14 - Return just the number of vendors where their number of days to deliver products 
-- is greater than the average days to deliver across all vendors
SELECT COUNT(VendorID)
FROM 
(
	SELECT VendorID, AVG(DaysToDeliver)
	FROM Product_Vendors 
	GROUP BY VendorID 
	HAVING AVG(DaysToDeliver)>
		(
			SELECT AVG(DaysToDeliver)
			FROM Product_Vendors
		)
) AS DaysToDeliverGreaterThanAVG;

-- 15 - How many orders are for only one product?
SELECT OrderNumber, COUNT(ProductNumber)
FROM Order_Details
GROUP BY OrderNumber
HAVING COUNT(ProductNumber)=1;

SELECT * 
FROM Order_Details 
WHERE OrderNumber =1;

-- 16 - Show all product names in a comma delimited list
SELECT GROUP_CONCAT(ProductName)
FROM Products;

-- 17 - Show all product names in a comma delimited list per category ID
SELECT 
	CategoryID,
	GROUP_CONCAT(ProductName)
FROM Products
GROUP BY CategoryID;

-- 18 - Show all product names in a comma delimited list per category ID sorted by product name
SELECT 
	CategoryID,
	GROUP_CONCAT(ProductName ORDER BY ProductName)
FROM Products
GROUP BY CategoryID;