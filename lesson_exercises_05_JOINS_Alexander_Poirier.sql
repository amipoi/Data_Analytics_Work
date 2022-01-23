-- SalesOrders Database
 
-- INNER JOINS

-- 01 - List customers and the dates they placed an order
/* 
*Customers
*	CustomerID
*Orders
*/
SELECT 
	Customers.CustomerID,
	CustFirstName,
	CustLastName,
	OrderDate,
	OrderNumber
FROM Customers
JOIN Orders
	ON Customers.CustomerID = Orders.CustomerID;

-- 02 - Show me customers and employees who share the same last name
SELECT 
	CustFirstName,
	CustLastName,
	EmpFirstName,
	EmpLastName
FROM Customers 
JOIN Employees
	ON Customers.CustLastName = Employees.EmpLastName
ORDER BY CustLastName;

-- 03 - Show me customers and employees who live in the same city
/* 
*Customers
*	Empcity, custcity
*Employees
*/
SELECT 
	CustFirstName,
	CustLastName,
	EmpFirstName,
	EmpLastName,
	CustCity
FROM Customers 
JOIN Employees 
	ON Customers.CustCity  = Employees.EmpCity;
-- 04 - Generate a list of employees and the customers for whom they booked an order
SELECT 
	CustFirstName,
	CustLastName,
	EmpFirstName,
	EmpLastName,
	Employees.EmployeeID,
	OrderNumber
FROM Customers 
JOIN Orders 
	ON Customers.CustomerID = Orders.CustomerID 
JOIN Employees 
	ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY Employees.EmployeeID;


-- 05 - Display all orders with the order date, the products in each order, and the amount owed for each product, in order number sequence
/* 
*Orders
*	OrderNumber
*Order Details
*	ProductNumber
*Products
*	
*/
SELECT 
	Orders.OrderNumber, 
	OrderDate,
	ProductName,
	Products.ProductNumber,
	QuotedPrice * QuantityOrdered AS AmountOwed,
	QuotedPrice,
	QuantityOrdered
FROM Orders 
JOIN Order_Details 
	ON Orders.OrderNumber = Order_Details.OrderNumber 
JOIN Products 
	ON Order_Details.ProductNumber = Products.ProductNumber 
ORDER BY Orders.OrderNumber;


-- 06 - Show me the vendors and the products they supply to us for products that have a wholesale price under $100. Sort by the vendor name then the wholesale price.
SELECT 
	Vendors.VendorID,
	Vendors.VendName AS VendorName,
	Product_Vendors.ProductNumber AS ProductID,
	ProductName,
	Product_Vendors.WholesalePrice
FROM Vendors 
JOIN Product_Vendors 
	ON Vendors.VendorID = Product_Vendors.VendorID 
JOIN Products 
	ON Products.ProductNumber = Product_Vendors.ProductNumber
WHERE Product_Vendors.WholeSalePrice < 100
ORDER BY Product_Vendors.WholeSalePrice;

-- 07 - Display customer names who have a sales rep (employees) in the same ZIP Code. Include the employee name.
SELECT 
	CustFirstName,
	CustLastName,
	EmpFirstName,
	EmpLastName,
	CustZipCode,
	EmpZipCode 
FROM Customers 
JOIN Employees 
	ON Customers.CustZipCode = Employees.EmpZipCode;

-- LEFT JOINS

-- 08 - Display customers who do NOT have a sales rep (employees) in the same ZIP Code
SELECT 
	CustFirstName,
	CustLastName,
	EmpFirstName,
	EmpLastName,
	CustZipCode,
	EmpZipCode 
FROM Customers 
LEFT JOIN Employees 
	ON Customers.CustZipCode = Employees.EmpZipCode
WHERE EmpZipCode IS NULL;

-- 09 - Are there any products that have never been ordered?
SELECT 
	Products.ProductNumber,
	Products.ProductName,
	QuantityOrdered
FROM Products
LEFT JOIN Order_Details 
	ON Products.ProductNumber = Order_Details.ProductNumber 
WHERE Order_Details.QuantityOrdered IS NULL;
	



-- sakila Database

-- INNER JOINS

-- 10 - What country is the city based in?
SHOW Tables;

SELECT * 
FROM city 
LIMIT 10;

SELECT * 
FROM country 
LIMIT 10;

SELECT 
	city,
	country
FROM city 
JOIN country 
	ON city.country_id = country.country_id;
	

-- 11 - What language is spoken in each film?
SELECT * 
FROM film 
LIMIT 10;

SELECT * 
FROM `language` 
LIMIT 10;

SELECT  
	title,
	language.name,
	film.language_id 
FROM film 
JOIN `language` 
ON film.language_id = language.language_id ;

SELECT COUNT(*)
FROM film 
WHERE language_id =1;
-- 12 - List all film titles and their category (genre)
SELECT *
FROM film_category 
LIMIT 10;

SELECT * 
FROM category 
LIMIT 10;

/*
 * film
 * 		film_id
 * film_category
 * 		category_id
 * category
 */



SELECT film.film_id, film.title, category.name, category.category_id
FROM film 
JOIN film_category  
	ON film.film_id = film_category.film_id 
JOIN category 
	ON film_category.category_id = category.category_id;

SELECT title
FROM film 
WHERE film_id =18;

SELECT *
FROM category 
WHERE category_id =2;

-- 13 - Create an email list of Canadian customers
/*
 * customer
 * 		address_id
 * address
 * 		city_id
 * city
 * 		country_id
 * country
 */

SELECT customer_id, first_name, last_name, email, city, country
FROM customer
JOIN address 
	ON customer.address_id = address.address_id 
JOIN city 
	ON address.city_id = city.city_id 
JOIN country 
	ON city.country_id = country.country_id
WHERE country.country = 'Canada';

	
SELECT *
FROM address
LIMIT 10;

SELECT *
FROM customer 
LIMIT 10;
-- 14 - How much rental revenue has each customer generated? In other words, what is the SUM rental payment amount for each customer ordered by the SUM amount from high to low?
SELECT *
FROM payment 
LIMIT 10;

SELECT c.customer_id, first_name, last_name, SUM(amount)
FROM customer c
JOIN payment p
	ON c.customer_id = p.customer_id 
GROUP BY c.customer_id 
ORDER BY SUM(amount) DESC;
-- 15 - How many cities are associated to each country? Filter the results to countries with at least 10 cities.
SELECT country, COUNT(city)
FROM country 
JOIN city 
	ON country.country_id = city.country_id
GROUP BY country 
HAVING COUNT(city) > 10
ORDER BY COUNT(city) DESC;


-- LEFT JOINS

-- 16 - Which films do not have an actor?
SELECT film.title, film_actor.film_id 
FROM film
LEFT JOIN film_actor 
	ON film.film_id = film_actor.film_id 
WHERE film_actor.film_id IS NULL;

-- 17 - Which comedies are not in inventory?
SELECT *
FROM inventory 
LIMIT 10;

SELECT title, inventory.film_id 
FROM film 
LEFT JOIN inventory 
	On film.film_id = inventory.film_id 
JOIN film_category 
	ON film.film_id = film_category.film_id 
JOIN category 
	ON film_category.category_id = category.category_id 
WHERE inventory.film_id IS NULL
	AND category.name = 'Comedy';

-- 18 - Generate a list of never been rented films
SELECT *
FROM rental 
LIMIT 10;

SELECT *
FROM inventory 
LIMIT 10;

/*
 * film
 * 	film_id
 * inventory
 * 	inventory_id
 * rental
*/

SELECT title, r.inventory_id, i.inventory_id
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id 
LEFT JOIN rental r
	On i.inventory_id = r.inventory_id 
WHERE r.inventory_id IS NULL;