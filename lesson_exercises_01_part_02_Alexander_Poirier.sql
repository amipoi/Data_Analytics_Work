-- 01 - CREATE User Table
CREATE TABLE User (
	UserID INT(11) NOT NULL AUTO_INCREMENT,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	Email VARCHAR(255) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (UserID),
	UNIQUE KEY (Email)
) ENGINE =InnoDB;

-- 02 - List Tables
SHOW TABLES;

-- 03 - Confirm Table Structure
DESCRIBE User;

-- 04 - CREATE Tweet Table
CREATE TABLE Tweet (
	TweetID INT(11) NOT NULL AUTO_INCREMENT,
	Tweet VARCHAR(255) NOT NULL,
	UserID INT(11) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (TweetID)
)ENGINE=InnoDB;

-- 05 - Establish Relationship with a Foreign Key
ALTER TABLE Tweet 
ADD CONSTRAINT fk_Tweet_User_UserID FOREIGN KEY (UserID)
REFERENCES User(UserID);

DESCRIBE Tweet;
-- 06 - Delete Table to Recreate Table with Foreign Key
DROP TABLE Tweet;

-- 07 - Recreate Table with Foreign Key
CREATE TABLE Tweet (
	TweetID INT(11) NOT NULL AUTO_INCREMENT,
	Tweet VARCHAR(255) NOT NULL,
	UserID INT(11) NOT NULL,
	CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (TweetID),
	CONSTRAINT fk_Tweet_User_UserID FOREIGN KEY (UserID)
REFERENCES User(UserID)
)ENGINE=InnoDB;

-- 08 - Confirm Table Structure
DESCRIBE Tweet;

-- 09 - INSERT 1 User
INSERT INTO `User`
(FirstName, LastName, Email)
VALUES
('Alexander','Poirier','apoirie1@lion.lmu.edu');

-- 10 - Confirm INSERT
SELECT *
FROM User;

SELECT @@system_time_zone;
-- 11 - INSERT 2 Users at the Same Time
INSERT INTO User 
(FirstName, LastName, Email)
VALUES
('John','Doe','john@doe.com'),
('Jane','Doe','jane@doe.com');

-- 12 - Can List Columns in a Different Order from Table Structure
INSERT INTO `User`
(Email, LastName, FirstName)
VALUES
('bobsmith@gmail.com','Smith','Bob');

-- 13 - Use SET if Dealing with Many Columns
INSERT INTO `User` 
SET 
	LastName = 'Jonhson',
	FirstName = 'Mary',
	Email = 'mary@gmail.com';

-- 14 - Verify File Insert and Table Schema
SELECT *
FROM SupplierSales2010;

-- 15 - Spaces in the Column Name?!
SELECT `Order ID`, `Order Date`
FROM SupplierSales2010 
LIMIT 10;

-- 16 - Change Column Type - ALTER TABLE
DESCRIBE SupplierSales2010;

ALTER TABLE SupplierSales2010 MODIFY `Order Date` DATETIME;
ALTER TABLE SupplierSales2010 MODIFY `Ship Date` DATETIME;

-- 17 - Copy Existing Table Structure
CREATE Table SupplierSales2011 LIKE SupplierSales2010;

SHOW TABLES;

DESCRIBE SupplierSales2011;

-- 18 - Verify File Insert
SELECT *
From SupplierSales2011 
LIMIT 10;

-- 19 - Before a DELETE, confirm WHERE with a SELECT
SELECT *
FROM SupplierSales2011 
WHERE `Order ID` = 443193900;

-- 20 - DELETE and Double Check WHERE
DELETE FROM SupplierSales2011 
WHERE `Order ID` = 443193900;

-- 21 - As an extra precaution, LIMIT the # of rows deleted
DELETE FROM SupplierSales2011 
WHERE `Order ID` = 443193900
ORDER BY `Order ID`
LIMIT 1;

-- 22 - TRUNCATE to empty a table
TRUNCATE TABLE SupplierSales2011;

SELECT *
FROM SupplierSales2011;
-- 23 - UPDATE Jane's first name to Jill
SELECT *
FROM User
WHERE FirstName = 'Jane';

UPDATE User 
SET FirstName ='Jill'
WHERE Firstname = 'Jane';

-- 24 - Confirm UPDATE
SELECT *
FROM User
WHERE FirstName = 'Jill';

-- 25 - UPDATE Multiple Columns
UPDATE `User` 
SET FirstName = 'Bob',
	LastName = 'Miller'
WHERE FirstName = 'John'
	AND LastName = 'Doe';

SELECT *
FROM User;

-- 26 - Search and replace with UPDATE
UPDATE `User` 
SET Email = REPLACE(Email, '@doe.com', '@lmu.edu')
WHERE Email LIKE '%@doe.com';

-- 27 - CREATE TABLE ... SELECT. Make a copy of the entire User table into a new table
CREATE TABLE User20210118 Select * FROM User;

SELECT * 
FROM User20210118;

-- 28 - INSERT INTO ... SELECT. Copy data from one table and insert into an existing table
INSERT INTO User20210118 
SELECT *
FROM `User` 
WHERE CreatedOn  BETWEEN '2021-01-19 08:00:00' AND '2021-01-21 09:00:00';

