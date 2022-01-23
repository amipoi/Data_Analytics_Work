#################
### VARIABLES ###
#################

# Example 1
# Find the most expensive product using the SET variable method
# to store the maximum retail price then using the variable in
# another SQL statement's WHERE condition
SELECT MAX(RetailPrice)
FROM Products;

SET @maxRetailPrice = 1800.00;

SELECT @maxRetailPrice;

SELECT *
FROM Products 
WHERE RetailPrice = @maxRetailPrice;

# Example 2
# Find the most expensive product using the SELECT variable method
# with a SELECT against a table
SELECT @maxRetailPrice := MAX(RetailPrice)
FROM Products;

SELECT @maxRetailPrice;

SELECT *
FROM Products 
WHERE RetailPrice = @maxRetailPrice;


# Example 3
# Find the most expensive product(s) with a subquery and no variables
SELECT *
FROM Products 
WHERE RetailPrice =
(
	SELECT MAX(RetailPrice)
	FROM Products
);

# Example 4
# See what happens when you select multiple Products RetailPrice values into a single variable
SELECT @retailPrice :=REtailPrice
FROM Products;

SELECT @retailPrice;


# Example 5
# INSERT a Child Seats category
DESCRIBE Categories;

ALTER TABLE Categories 
MODIFY CategoryID INT(11) NOT NULL AUTO_INCREMENT;

INSERT INTO Categories 
SET CategoryDescription = 'Child Seats';

SELECT LAST_INSERT_ID();

SELECT *
FROM Categories;


# Example 6
# New Product Process
# The vendor, Big Sky Mountain Bikes, is introducing a new bike. 
# We have to INSERT into multiple tables to add the new product into the system.
DESCRIBE Products;

ALTER TABLE Products 
MODIFY ProductNumber INT(11) NOT NULL AUTO_INCREMENT;

SELECT  *
FROM Products 
LIMIT 10;

SET @productName := 'Canyon Mountain Bike';
SET @retailPrice := 823.16;
SET @quantityOnHand := 96;

SELECT @categoryID := CategoryID
FROM Categories 
WHERE CategoryDescription = 'Bikes';

SELECT @categoryID;

INSERT INTO Products 
SET ProductName = @productName, RetailPrice = @retailPrice, QuantityOnHand = @quantityOnHand, CategoryID = @categoryID;

SELECT *
FROM Products
WHERE ProductName = @productName;

SELECT LAST_INSERT_ID();

SELECT @lastInsertedProductNumber := LAST_INSERT_ID(); 

SELECT @lastInsertedProductNumber;

SELECT @vendorID := vendorID
FROM Vendors 
WHERE VendName = 'Big Sky Mountain Bikes';

SELECT @vendorID;

SET @wholesalePrice = 605.80;
SET @daysToDeliver = 11;

SELECT @wholesalePrice, @daysToDeliver;

SELECT *
FROM Product_Vendors 
LIMIT 3;

INSERT INTO Product_Vendors 
SET ProductNumber = @lastInsertedProductNumber, VendorID = @vendorID, WholesalePrice = @wholesalePrice, DaysToDeliver = @daysToDeliver;


SELECT *
FROM Product_Vendors 
WHERE ProductNumber = @lastInsertedProductNumber;
###########################
### PREPARED STATEMENTS ###
###########################
SELECT COUNT(*) FROM Products; SELECT 'hello'; SELECT DaysToDeliver FROM Product_Vendors LIMIT 1;


# Example 7
# INSERT a new product with prepared statements

# insertProduct

# Define Variables
SET @productName := 'Linus Road Bike';
SET @retailPrice := 250.00;
SET @quantityOnHand := 40;

SELECT @categoryID := CategoryID
FROM Categories 
WHERE CategoryDescription = 'Bikes';

SELECT @productName, @retailPrice, @quantityOnHand, @categoryID;

# 1
PREPARE insertProduct FROM '
	INSERT INTO Products 
	SET ProductName = ?, RetailPrice = ?, QuantityOnHand = ?, CategoryID = ?;
';

# 2
EXECUTE insertProduct USING @productName, @retailPrice, @quantityOnHand, @categoryID;

SELECT *
FROM Products 
WHERE ProductName = @productName;

# 3
DEALLOCATE PREPARE insertProduct;

# insertProductVendor

# Define Vairables

SELECT @lastInsertedProductNumber := LAST_INSERT_ID();

SELECT @lastInsertedProductNumber;

SET @wholesalePrice = 125.00;
SET @daysToDeliver = 5;

SELECT @vendorID := vendorID
FROM Vendors
WHERE VendName = 'Big Sky Mountain Bikes';

# 1
PREPARE insertProductVendor FROM '
	INSERT INTO Product_Vendors
	SET ProductNumber = ?, VendorID = ?, WholesalePrice = ?, DaysToDeliver = ?;
';

# 2
EXECUTE insertProductVendor USING @lastInsertedProductNumber, @vendorID, @wholesalePrice, @daysToDeliver;

SELECT *
FROM Product_Vendors 
WHERE ProductNumber = @lastInsertedProductNumber;

# 3
DEALLOCATE PREPARE insertProductVendor;





