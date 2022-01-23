/*
86/100

-14 SQL

*/

/*
 * 1.
 * Customers are complaining about the available parking at all store locations. 
 * Corporate headquarters wants to get in contact with the store manager to assess the parking situation. 
 * 
 * Return the store manager's name, their contact information, and the full address for the store they manage.
 * 
 * Expected results header:
 * first_name|last_name|email|address|address2|city|postal_code|country|
 * ----------|---------|-----|-------|--------|----|-----------|-------|
 *
 * Loom video link: https://www.loom.com/share/572dfa92af514dec8a5d4c3c27b86cbd
 */
SELECT 
	first_name,
	last_name,
	email,
	address,
	address2,
	city,
	postal_code,
	country
FROM staff 
JOIN address  
	ON staff.address_id = address.address_id 
JOIN city c
	ON address.city_id = c.city_id 
JOIN country c2 
	ON c.country_id = c2.country_id
JOIN store s 
	ON staff.staff_id = s.manager_staff_id;

	
-- WHERE manager_staff_id = staff_id;

-- checking form of tables	
SELECT *
FROM store;
	
SELECT * 
FROM staff ;

use apoiriel_sakila;
show tables;
/*
 * 2.
 * A marketing analyst from store_id 1 wants to perform a recency, frequency, and monetary analysis 
 * to segment customers for future marketing campaigns. 
 * 
 * Create a report for store_id 1 showing a customer's most recent rental date, number of rentals, 
 * and total rental revenue. Sort the report on the total rental revenue from high to low. 
 * 
 * Assign the customer segment labels below based on the following total rental revenue ranges:
 * big spender: > $140
 * promising spender: $70 - $140
 * cheap customer: < $70
 * 
 * Expected results header:
 * customer_id|first_name|last_name|email|most_recent_rental_date|number_of_rentals|total_rental_revenue|customer_segment|
 * -----------|----------|---------|-----|-----------------------|-----------------|--------------------|----------------| 
 * 
 * Loom video link: https://www.loom.com/share/c97b02d232a4468b9e033368ce0f2129
 * 
 * NEW LOOM VIDEO: https://www.loom.com/share/1af795802b294e75ba934d85319240c7
*/

/*
-4 points
Code does not fulfill the data request.
*/

SELECT 
	customer.customer_id,
	first_name,
	last_name,
	email,
	MAX(rental_date) AS most_recent_rental_date,
	COUNT(rental.customer_id) AS number_of_rentals,
	SUM(amount) AS total_rental_revenue,
	CASE 
		WHEN total_rental_revenue < 70 THEN 'cheap customer'
		WHEN total_rental_revenue > 70 AND total_rental_revenue < 140 THEN 'Promising Spender'
		WHEN total_rental_revenue > 140 THEN 'Big Spender'
	END 
JOIN rental 
	ON customer.customer_id = rental.customer_id 
JOIN payment 
	ON customer.customer_id = payment.customer_id;
WHERE store_id = 1
GROUP BY customer_id;
-- ORDER BY total_rental_revenue DESC;



/*
 * CORRECTED CODE BELOW
 */

SELECT 
	customer.customer_id,
	first_name,
	last_name,
	email,
	MAX(rental_date) AS most_recent_rental_date,
	COUNT(rental.customer_id) AS number_of_rentals,
	SUM(amount) AS total_rental_revenue,
	CASE 
		WHEN SUM(amount) < 70 THEN 'cheap customer'
		WHEN SUM(amount) > 70 AND SUM(amount) < 140 THEN 'Promising Spender'
		WHEN SUM(amount) > 140 THEN 'Big Spender'
	END AS customer_segment
FROM customer
JOIN rental 
	ON customer.customer_id = rental.customer_id 
JOIN payment 
	ON customer.customer_id = payment.customer_id
WHERE store_id = 1
GROUP BY customer_id
ORDER BY total_rental_revenue DESC;





SELECT 
	first_name,
	last_name,
	amount
FROM customer 
JOIN rental 
	ON customer.customer_id = rental.customer_id 
JOIN payment 
	ON customer.customer_id = payment.customer_id
WHERE store_id =1;

/*
 * 3.
 * The sales department noticed G-rated films had the lowest number of rentals. 
 * The sales director wants to identify if it is an inventory issue causing the lower number of rentals.
 * 
 * Identify the total number of G-rated films not carried in inventory. A film is considered in inventory 
 * if it exists in the inventory table. You do not have to check if a film is out on rental.
 * The result should return only 1 row and 1 column containing the total.
 * 
 * Expected results header:
 * films_not_in_inventory_count|
 * ----------------------------|
 * 
 * Loom video link: https://www.loom.com/share/16cf7a6706ac465faabf8817d03edcf2
 */
-- Final Answer Below
SELECT COUNT(*) AS films_not_in_inventory_count
FROM film
WHERE film_id NOT IN(
		SELECT DISTINCT film.film_id 
		FROM inventory
		JOIN film 
			ON inventory.film_id = film.film_id
		WHERE rating = "G"
	)
AND rating = "G";


-- Work done for problem

-- count of G films is 179
SELECT COUNT(*)
FROM film 
WHERE rating = "G";

-- looking at inventory of G rated films this is my list
SELECT DISTINCT film.film_id 
FROM inventory
JOIN film 
	ON inventory.film_id = film.film_id
WHERE rating = "G";
/*
 * 4.
 * The marketing team wants to build a campaign highlighting actors who appear in multiple films.
 * To reach the widest audience and to maximize rental revenue, the marketing team stipulates 
 * the following requirements:
 * 	- actor must appear in 8 or more films
 * 	- rental_duration ranges from 3 to 5 days
 * 	- rental_rate equal to 2.99 or 4.99
 *  - all ratings except for NC-17
 * 	- special_features do not include Deleted Scenes
 *	- display actors with the most films at the top of the results
 * 
 * Expected results header:
 * actor_id|first_name|last_name|film_count|
 * --------|----------|---------|----------|
 *
 * Loom video link: https://www.loom.com/share/71a267d553964d12bd20af41629febac
 * 
 * 
 * NEW LOOM VIDEO: https://www.loom.com/share/4f31bf54241f418ea7e2dcb043a5f3f7
 */
 /*
-10 points
Code does not fulfill the data request.
*/

SELECT 
	actor_id,
	first_name,
	last_name,
	film_count
FROM actor a
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id 
JOIN film f 
	ON fa.film_id = f.film_id 
WHERE 

-- rental_duration > 3 AND rental_duration < 5

-- rental_rate = 2.99 OR rental_rate = 4.99

-- rating Not = 'NC-17'

-- Special features NOT LIKE "%Deleted Scenes%"

-- Order by Count(films) DESC


/*
 * CORRECTED CODE BELOW (12 actors returned)
 */

SELECT 
	actor.actor_id,
	actor.first_name,
	actor.last_name,
	COUNT(film.film_id) AS film_count,
	film.special_features 
FROM film 
JOIN film_actor 
	ON film.film_id = film_actor.film_id 
JOIN actor 
	ON film_actor.actor_id = actor.actor_id 
WHERE (rental_duration = 3 OR rental_duration = 5)
AND rental_rate IN (2.99,4.99)
AND rating != "NC-17"
-- AND film.special_features NOT LIKE '%Deleted Scenes%'
Group BY actor.actor_id
HAVING COUNT(film.film_id) > 7
ORDER BY film_count DESC;




-- first checking rental_duration (167)
SELECT 
	a.actor_id,
	COUNT(f.film_id) AS number_of_films
FROM film f 
JOIN film_actor fa 
	ON f.film_id = fa.film_id 
JOIN actor a 
	ON fa.actor_id = a.actor_id 
WHERE rental_duration IN (3,5)
GROUP BY actor_id
HAVING COUNT(f.film_id)>7;

-- Adding rating (129)
SELECT 
	a.actor_id,
	COUNT(f.film_id) AS number_of_films
FROM film f 
JOIN film_actor fa 
	ON f.film_id = fa.film_id 
JOIN actor a 
	ON fa.actor_id = a.actor_id 
WHERE rental_duration IN (3,5)
AND NOT rating= "NC-17"
GROUP BY actor_id
HAVING COUNT(f.film_id)>7;

-- Adding rental_rate (32)
SELECT 
	a.actor_id,
	COUNT(f.film_id) AS number_of_films
FROM film f 
JOIN film_actor fa 
	ON f.film_id = fa.film_id 
JOIN actor a 
	ON fa.actor_id = a.actor_id 
WHERE rental_duration IN (3,5)
AND NOT rating= "NC-17"
AND rental_rate IN (2.99,4.99)
GROUP BY actor_id
HAVING COUNT(f.film_id)>7;

-- Adding Special Features (1)
SELECT 
	a.actor_id,
	COUNT(f.film_id) AS number_of_films
FROM film f 
JOIN film_actor fa 
	ON f.film_id = fa.film_id 
JOIN actor a 
	ON fa.actor_id = a.actor_id 
WHERE rental_duration IN (3,5)
AND NOT rating= "NC-17"
AND rental_rate IN (2.99,4.99)
AND special_features NOT LIKE "%Deleted Scenes%"
GROUP BY actor_id
HAVING COUNT(f.film_id)>7;



-- Subquery for the special features

SELECT film_id,
	special_features
FROM film 
WHERE special_features LIKE "%Deleted Scenes%"


-- trying contains and INSTR
SELECT 
	actor.actor_id,
	actor.first_name,
	actor.last_name,
	COUNT(film.film_id) AS film_count,
	film.special_features 
FROM film 
JOIN film_actor 
	ON film.film_id = film_actor.film_id 
JOIN actor 
	ON film_actor.actor_id = actor.actor_id 
WHERE (rental_duration = 3 OR rental_duration = 5)
AND rental_rate IN (2.99,4.99)
AND rating != "NC-17"
AND NOT INSTR(film.special_features , "Deleted Scenes")
Group BY actor.actor_id
HAVING COUNT(film.film_id) > 7
ORDER BY film_count DESC;


 