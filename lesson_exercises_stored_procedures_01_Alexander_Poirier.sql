-- 01 - Create a stored procedure to return the number of rows in the orders table
DELIMITER $$

CREATE PROCEDURE getOrdersCount()
BEGIN
	SELECT COUNT(*)
	FROM Orders;
END

DELIMITER ;

-- Execute the stored procedure
CALL getOrdersCount();

-- 02 - Update the getOrdersCount stored procedure to accept IN parameters for an orderDate date range
DELIMITER $$

DROP PROCEDURE IF EXISTS getOrdersCount$$
CREATE PROCEDURE getOrdersCount(IN inOrderDateStart DATE, IN inOrderDateEnd DATE)
BEGIN
	
	SET @orderDateStart := inOrderDateStart;
	SET @orderDateEnd := inOrderDateEnd;

	SELECT COUNT(*)
	FROM Orders
	WHERE OrderDate BETWEEN @orderDateStart AND @orderDateEnd;

END

DELIMITER ;


-- Execute the stored procedure
CALL getOrdersCount('2018-02-12', '2018-02-14');

-- Verify results with a SELECT
SELECT COUNT(*)
FROM Orders 
WHERE OrderDate BETWEEN '2018-02-12' AND '2018-02-14';


-- 03 - Update the getOrdersCount stored procedure to return an OUT parameter for the number of rows in the orders table.
DELIMITER $$

DROP PROCEDURE IF EXISTS getOrdersCount$$
CREATE PROCEDURE getOrdersCount(inOrderDateStart DATE, inOrderDateEnd DATE, OUT outOrdersCount INT)
BEGIN
	
	SET @orderDateStart := inOrderDateStart;
	SET @orderDateEnd := inOrderDateEnd;

	SELECT COUNT(*) INTO outOrdersCount
	FROM Orders
	WHERE OrderDate BETWEEN @orderDateStart AND @orderDateEnd;

END

DELIMITER ;


-- Execute the stored procedure
CALL getOrdersCount('2018-02-12', '2018-02-14', @ordersRowCount);

-- Confirm the order count was assigned to the OUT parameter
SELECT @ordersRowCount;


-- List stored procedures
SHOW PROCEDURE STATUS;

-- Display code to create the stored procedure
SHOW CREATE PROCEDURE getOrdersCount;

