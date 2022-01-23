################
# TRANSACTIONS
################

SHOW TABLE STATUS WHERE Name = 'Categories';

SELECT *
FROM information_schema.TABLES;

SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE ENGINE = 'MyISAM'
	AND TABLE_SCHEMA = 'apoiriel_SalesOrders';

SELECT CONCAT('ALTER TABLE ', TABLE_NAME, ' ENGINE = InnoDB;')
FROM information_schema.TABLES
WHERE ENGINE = 'InnoDB'
	AND TABLE_SCHEMA ='apoiriel_SalesOrders';

ALTER TABLE Categories ENGINE = InnoDB;
ALTER TABLE Customers ENGINE = InnoDB;
ALTER TABLE Employees ENGINE = InnoDB;
ALTER TABLE Order_Details ENGINE = InnoDB;
ALTER TABLE Orders ENGINE = InnoDB;
ALTER TABLE Orders2021 ENGINE = InnoDB;
ALTER TABLE Product_Vendors ENGINE = InnoDB;
ALTER TABLE Products ENGINE = InnoDB;
ALTER TABLE Vendors ENGINE = InnoDB;
ALTER TABLE ztblMonths ENGINE = InnoDB;
ALTER TABLE ztblPriceRanges ENGINE = InnoDB;
ALTER TABLE ztblPurchaseCoupons ENGINE = InnoDB;
ALTER TABLE ztblSeqNumbers ENGINE = InnoDB;



# Example 1
# Insert a new category named Food with a transaction
START TRANSACTION;

INSERT INTO Categories 
SET CategoryDescription = 'Food';

SELECT *
FROM Categories 
WHERE CategoryDescription = 'Food';

COMMIT;


# Example 2
# Create a transaction to attempt an UPDATE on the Food category. 
# Set the CategoryDescription to "Drinks"
START TRANSACTION;

UPDATE Categories
SET CategoryDescription = 'Drinks'
WHERE CategoryDescription = 'Food';

SELECT *
FROM Categories 
WHERE CategoryDescription = 'Food';

ROLLBACK;

# Example 3
# Update the example where you inserted a new bike product with 
# variables and prepared statements to use a basic transaction

START TRANSACTION;

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

COMMIT;

SELECT *
FROM Products 
WHERE ProductName = 'Linus Road Bike';

SELECT *
FROM Product_Vendors 
WHERE ProductNumber = 0;

################
# TRIGGERS
################

# Example 4
# Create a trigger to keep track of QuantityOrdered updates in the Order_Details table

CREATE TABLE Order_Details_Log (
User VARCHAR(255),
OrderNumber INT(11),
ProductNumber INT(11),
QuotedPrice DECIMAL(15,2),
OldQuantityOrdered INT(11),
NewQuantityOrdered INT(11),
LogDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT USER();

DELIMITER $$
CREATE TRIGGER Order_Details_After_Update
	AFTER UPDATE ON Order_Details
	FOR EACH ROW
BEGIN
	INSERT INTO Order_Details_Log 
	(User, OrderNumber, ProductNumber, QuotedPrice, OldQuantityOrdered, NewQuantityOrdered)
	VALUES 
	(USER(), OLD.OrderNumber, OLD.ProductNumber, OLD.QuotedPrice, OLD.QuantityOrdered, NEW.QuantityOrdered);

END$$
DELIMITER ;

SELECT *
FROM Order_Details 
ORDER BY RAND()
LIMIT 1;


UPDATE Order_Details 
SET QuantityOrdered = 10
WHERE OrderNumber = 135;
	AND ProductNumber = 25;

SELECT *
FROM Order_Details_Log;

SELECT *
FROM Order_Details 
WHERE OrderNumber = 135;
	AND ProductNumber = 25;

UPDATE Order_Details 
SET QuantityOrdered = 21
WHERE OrderNumber = 135;
	AND ProductNumber = 25;


# Managing Triggers

SHOW TRIGGERS;

SHOW TRIGGERS WHERE `Table` = 'Order_Details';

SHOW CREATE TRIGGER Order_Details_After_Update;




