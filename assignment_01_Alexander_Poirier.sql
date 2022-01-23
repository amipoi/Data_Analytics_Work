/*
Host: {host}
Username: {username}
Password: {password}
*/



-- sakila Database

/*
1. Select all columns from the film table for PG-rated films. (1 point)
*/
SELECT * 
FROM film 
WHERE rating = 'PG';

/*
2. Select the customer_id, first_name, and last_name for the active customers (0 means inactive). Sort the customers by their last name and restrict the results to 10 customers. (1 point)
*/
SELECT *
FROM customer
LIMIT 10;

SELECT 
	customer_id,
	first_name,
	last_name,
	active 
FROM customer
WHERE active = 1
ORDER BY last_name 
LIMIT 10;

/*
3. Select customer_id, first_name, and last_name for all customers where the last name is Clark. (1 point)
*/
SELECT 
	customer_id,
	first_name,
	last_name 
FROM customer 
WHERE last_name = 'Clark';

/*
4. Select film_id, title, rental_duration, and description for films with a rental duration of 3 days. (1 point)
*/
SELECT 
	film_id,
	title, 
	rental_duration, 
	description 
FROM film 
WHERE rental_duration = 3;

/*
5. Select film_id, title, rental_rate, and rental_duration for films that can be rented for more than 1 day and at a cost of $0.99 or more. Sort the results by rental_rate then rental_duration. (2 points)
*/
SELECT 
	film_id,
	title,
	rental_rate,
	rental_duration 
FROM film 
WHERE rental_duration > 1 AND rental_rate >= .99
ORDER BY rental_rate, rental_duration;

/*
6. Select film_id, title, replacement_cost, and length for films that cost 9.99 or 10.99 to replace and have a running time of 60 minutes or more. (2 points)
*/
SELECT 
	film_id,
	title,
	replacement_cost,
	film.length AS movie_runtime 
FROM film
WHERE (film.length >= 60) AND (replacement_cost = 9.99 OR replacement_cost = 10.99)
ORDER BY replacement_cost, film.length;

/*
7. Select film_id, title, replacement_cost, and rental_rate for films that cost $20 or more to replace and the cost to rent is less than a dollar. (2 points)
*/
SELECT 
	film_id,
	title,
	replacement_cost,
	rental_rate
FROM film 
WHERE replacement_cost >=20 AND rental_rate < 1
ORDER BY replacement_cost, rental_rate;

/*
8. Select film_id, title, and rating for films that do not have a G, PG, and PG-13 rating.  Do not use the OR logical operator. (2 points)
*/
SELECT 
	film_id,
	title,
	rating
FROM film 
WHERE NOT (rating = 'G') AND NOT (rating = 'PG') AND NOT (rating = 'PG-13')
ORDER BY rating, title;

/*
9. How many films can be rented for 5 to 7 days? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(film_id) AS number_of_films_available_for_5_to_7_days
FROM film
where rental_duration >= 5 AND rental_duration <= 7;


SELECT COUNT(title) , rental_duration 
FROM film 
GROUP BY rental_duration;
/*
10. INSERT your favorite movie into the film table. You can arbitrarily set the column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
INSERT INTO film (title, release_year,language_id) 
VALUES ('The Prestige',2006,1);

/*
11. INSERT your two favorite actors/actresses into the actor table with a single SQL statement. (2 points)
*/
INSERT INTO actor (first_name, last_name) VALUES ('Christian','Bale'),('Natalie','Portman');

/*
12. The address2 column in the address table inconsistently defines what it means to not have an address2 associated with an address. UPDATE the address2 column to an empty string where the address2 value is currently null. (2 points)
*/
UPDATE address 
SET address2 = ''
WHERE address2 IS NULL; 

/*
13. For rated G films less than an hour long, update the special_features column to replace Commentaries with Audio Commentary. Be sure the other special features are not removed. (2 points)
*/

SELECT *
FROM film 
WHERE rating = 'G' AND length <60;

UPDATE film
SET special_features = replace(special_features, 'Commentaries','Audio Commentary')
WHERE length < 60 AND rating = 'G';
/*
14. Create a new database named LinkedIn. You will still need to use  LMU.build to create the database. Even though you're creating the database on LMU.build, write the SQL to create a database.(1 point)
*/
CREATE DATABASE LinkedIn;

/*
15. Create a user table to store LinkedIn users. The table must include 5 columns minimum with the appropriate data type and a primary key. One of the columns should be Email and must be a unique value. (3 points)
*/
CREATE TABLE user (
	UserID int UNSIGNED NOT NULL AUTO_INCREMENT,
	FirstName varchar(255),
	LastName varchar(255),
	Email varchar(255) NOT NULL,
	BirthDate date,
	PRIMARY KEY (UserID),
	UNIQUE INDEX unique_email (Email)
);

/*
16. Create a table to store a user's work experience. The table must include a primary key, a foreign key column to the user table, and have at least 5 columns with the appropriate data type. (3 points)
*/
CREATE TABLE work_experience (
	WorkExperienceID int NOT NULL AUTO_INCREMENT,
	UserID int NOT NULL ,
	JobTitle varchar(255),
	Description varchar(255),
	HoursWorked int,
	Primary Key (WorkExperienceID),
	Foreign Key (UserID) REFERENCES user(UserID)
);

/*
17. INSERT 1 user into the user table. (2 points)
*/
INSERT INTO user (UserID, FirstName, LastName, Email, BirthDate) VALUES (1,'Alexander','Poirier','apoirie1@lion.lmu.edu', '1998-09-25' );

/*
18. INSERT 1 work experience entry for the user just inserted. (2 points)
*/
INSERT INTO work_experience (UserID, JobTitle, Description, HoursWorked) VALUES (1, 'Data Analyst', 'Analyzing and understanding data to make informed business decisions', 1000);


-- SpecialtyFood Database

/*
19. The warehouse manager wants to know all of the products the company carries. Generate a list of all the products with all of the columns. (1 point)
*/
SELECT *
FROM Products;

/*
20. The marketing department wants to run a direct mail marketing campaign to its American, Canadian, and Mexican customers. Write a query to gather the data needed for a mailing label. (2 points)
*/
SELECT 
	ContactName,
	Address,
	City,
	Country,
	PostalCode
FROM Customers
WHERE Country IN ('Canada', 'Mexico','USA')
ORDER BY Country;

/*
21. HR wants to celebrate hire date anniversaries for the sales representatives in the USA office. Develop a query that would give HR the information they need to coordinate hire date anniversary gifts. Sort the data as you see best fit. (2 points)
*/
SELECT 
	FirstName,
	LastName,
	HireDate 
FROM Employees
WHERE Country = 'USA'
ORDER BY LastName;
/*
22. What is the SQL command to show the structure for the Shippers table? (1 point)
*/
Describe Shippers;

/*
23. Customer service noticed an increase in shipping errors for orders handled by the employee, Janet Leverling. Return the OrderIDs handled by Janet so that the orders can be inspected for other errors. (2 points)
*/
SELECT 
	o.OrderID,
	e.EmployeeID,
	e.FirstName,
	e.LastName
FROM Orders o
JOIN Employees e
	ON o.EmployeeID = e.EmployeeID 
WHERE FirstName= 'Janet' AND LastName = 'Leverling';
/*
24. The sales team wants to develop stronger supply chain relationships with its suppliers by reaching out to the managers who have the decision making power to create a just-in-time inventory arrangement. Display the supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title. (2 points)
*/
SELECT 
	CompanyName,
	ContactName,
	ContactTitle,
	Phone
FROM Suppliers 
WHERE ContactTitle LIKE '%manager%' 
OR ContactTitle LIKE '%mgr%';

/*
25. The warehouse packers want to label breakable products with a fragile sticker. Identify the products with glasses, jars, or bottles and are not discontinued (0 = not discontinued). (2 points)
*/
SELECT ProductName, QuantityPerUnit, discontinued 
FROM Products p
WHERE (QuantityPerUnit LIKE '%glasses%' OR QuantityPerUnit LIKE '%jars%' OR QuantityPerUnit LIKE '%bottles%') AND Discontinued=0;

/*
26. How many customers are from Brazil and have a role in sales? Your query should only return 1 row. (2 points)
*/
SELECT COUNT(*)
FROM Customers 
WHERE Country = 'Brazil'
AND ContactTitle LIKE '%Sales%';

/*
27. Who is the oldest employee in terms of age? Your query should only return 1 row. (2 points)
*/
SELECT 
	MIN(Birthdate),
	FirstName,
	LastName
FROM Employees;

/*
28. Calculate the total order price per order and product before and after the discount. The products listed should only be for those where a discount was applied. Alias the before discount and after discount expressions. (3 points)
*/
SELECT 
	OrderID,
	Quantity,
	UnitPrice,
	(UnitPrice * Quantity) AS Before_Discount,
	Discount,
	(Discount * Quantity) AS Amount_Saved,
	( (UnitPrice * Quantity)- (Discount * Quantity)) AS Amount_Owed
FROM OrderDetails
ORDER BY Amount_Owed;

/*
29. To assist in determining the company's assets, find the total dollar value for all products in stock. Your query should only return 1 row.  (2 points)
*/
SELECT SUM(UnitsInStock * UnitPrice ) AS Total_Assets_Inventory
FROM Products;


/*
30. Supplier deliveries are confirmed via email and fax. Create a list of suppliers with a missing fax number to help the warehouse receiving team identify who to contact to fill in the missing information. (2 points)
*/
SELECT CompanyName, ContactName, Phone, Fax 
FROM Suppliers 
WHERE Fax IS NULL;

/*
31. The PR team wants to promote the company's global presence on the website. Identify a unique and sorted list of countries where the company has customers. (2 points)
*/
SELECT DISTINCT Country
FROM Customers
ORDER BY Country;

/*
32. List the products that need to be reordered from the supplier. Know that you can use column names on the right-hand side of a comparison operator. Disregard the UnitsOnOrder column. (2 points)
*/
SELECT ProductName, SupplierID, UnitsInStock, ReorderLevel 
FROM Products
WHERE UnitsInStock < ReorderLevel AND Discontinued = 0;

/*
33. You're the newest hire. INSERT yourself as an employee with the INSERT … SET method. You can arbitrarily set the column values as long as they are related to the column. Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/
INSERT INTO Employees (LastName, FirstName) VALUES ('Poirier','Alexander');

/*
34. The supplier, Bigfoot Breweries, recently launched their website. UPDATE their website to bigfootbreweries.com. (2 points)
*/
UPDATE Suppliers 
SET HomePage = 'bigfootbreweries.com'
WHERE CompanyName = 'Bigfoot Breweries';

/*
35. The images on the employee profiles are broken. The link to the employee headshot is missing the .com domain extension. Fix the PhotoPath link so that the domain properly resolves. Broken link example: http://accweb/emmployees/buchanan.bmp (2 points)
*/
UPDATE Employees 
SET PhotoPath = REPLACE(PhotoPath, '.bmp', '.com');


-- Custom Data Requests

/*
Data Request 1
Question How long does it take from ordering a product to the supplier actually shipping it 

Business Justification This will help the company to better understand the time it takes from ordering a product to actually having it shipped and then can better plan for how long itll take for the product to be shipped, even after a customer has ordered the product.
*/
SELECT 
	MAX(DATEDIFF(ShippedDate, OrderDate)) AS Maximum_Order_to_Shipped_time_Days,
	MIN(DATEDIFF(ShippedDate, OrderDate)) AS Minimum_Order_to_Shipped_time_Days,
	AVG(DATEDIFF(ShippedDate, OrderDate)) AS Average_Order_to_Shipped_time_Days
FROM Orders ;

/*
 * NOTE ANSWER IS RETURNED IN DAYS DIFFERENCE AND WILL NOT LOOK AT HOURS
 */

SELECT OrderID, DATEDIFF(ShippedDate, OrderDate) AS TimeDifference
FROM Orders
ORDER BY TimeDifference;
/*
Data Request 2
Question Which Employees Are the best at selling products to customers

Business Justification This is a metric the company can use to betteer understand who is  an effective seller and who is an employee who is not as successful in sales. This kind of metric can be used in performance reviews and determine promotions and firings.
*/
SELECT 
	e.EmployeeID,
	FirstName,
	LastName,
	(COUNT(e.EmployeeID)) AS Number_of_Sales
FROM Orders o
JOIN Employees e
	ON o.EmployeeID = e.EmployeeID 
GROUP BY EmployeeID
ORDER BY Number_of_Sales DESC;

/*
Data Request 3
Question Which countries do majority of our suppliers come from?

Business Justification: By understanding where the suppliers are shipping products from, we can focus on the specific trade routes and poolicies that affect the majoirty of our products
*/
SELECT COUNTRY, COUNT(*) AS Number_Of_Suppliers
FROM Suppliers
GROUP BY Country
ORDER BY Number_Of_Suppliers DESC;

/*
Data Request 4
Question Counting how many orders go to each country

Business Justification: This helps maangers to understand where their customers are located and where they should be marketing and using funds and resources in order to make the most customers happy
*/
SELECT ShipCountry, COUNT(OrderID)
FROM Orders o 
GROUP BY ShipCountry
ORDER BY COUNT(OrderID) DESC;

/*
Data Request 5
Question Who are the customers that consistently buy from us, who are the "usuals"

Business Justification This helps us to better understand who are the usuals and how effective we are with customer aquistion
*/
SELECT c.CustomerID, CompanyName, COUNT(o.CustomerID) AS Number_Of_Orders
FROM Customers c
JOIN Orders o 
	ON c.CustomerID = o.CustomerID 
GROUP BY CustomerID
ORDER BY Number_Of_Orders DESC;


/*
Data Request 6
Question HOw many products do we have in each category?

Business Justification This will help managers to better understand the business and what we hold alot of invenotry of versus which categories our business doesn't prioirtize
*/
SELECT 
	CategoryName, COUNT(ProductName) AS Number_Of_Products
FROM Products p
JOIN Categories c 
	ON p.CategoryID = c.CategoryID 
GROUP BY CategoryName
ORDER BY Number_Of_Products;

