/*
Subqueries

How many categories have more products than the average product count per CategoryID?

What is your approach? How did you deconstruct the problem? State any assumptions.	
*/

/*
 * start by breaking down some of the key pieces
 * 
 * seeing that there is a comparison and a piece specific for the average product count per category
 * 
 * 
 * Step 1 begins with solving the average product count per Category
 * 
 * 	look for number of products in categories
 * 
 * find avg from the categories
 * 
 * Step 2 
 * filter by using having in order to remove categories that are below average
 * 
 * top query needs to utilize count in order to find answer
 * 
 */


/*
UNION

List the customers who ordered a King Cobra Helmet 
together with the vendors who provide the King Cobra Helmet

What is your approach? How did you deconstruct the problem? State any assumptions.	
*/

/*
 * need to find vendors who provide king cobra helmet
 * 
 * need to find customers who ordered king cobra  helmet
 * 
 * together requires a union
 * 
 * With union, make sure that the columns are the same number, or else you will reach an error
 * 
 */


-- Switch to the sakila database
USE lontoklm_sakila;


/*
CASE

Label if a film at the $4.99 rental rate was rented in June 2005.

Explain the SQL and why you used certain SQL features.
*/
SELECT 
	film_id,
	title,
	rental_rate,
	CASE 
		WHEN film_id IN -- begining of CASE using IN for a list
			(
				SELECT DISTINCT(film_id) -- Dont want any movies that have been counted more than once 
				FROM inventory
				JOIN rental
					ON inventory.inventory_id = rental.inventory_id
				WHERE rental_date BETWEEN '2005-06-01' AND '2005-06-30 23:59:59' -- time stamps as our range of searching for films in June 2005
			) THEN 'Rented' -- label as rented if they were rented
		ELSE 'Not Rented' -- if not found, clasified as not rented
	END AS rental_status -- naming the Case 
FROM film -- getting information from film
WHERE rental_rate = 4.99 -- requirement we are filtering for
ORDER BY title; -- Helps organize for title 



/*
CASE

What is another approach to fulfill this request?
Label if a film at the $4.99 rental rate was rented in June 2005.

Give a brief interpretation of the results. What insights can be drawn from the results? 
What actions can those insights inform?
*/

/*
 * 
 * Another way is by using left joins
 */

/*
 * The results actually show majority of the films were rented at least once throughout June of 2005
 * 
 * 
 * These results help show which films are seen as relevant and a good prioirty during the certain time period that you set as the analyst
 * 
 * We can figure out which movies may be seen as unpopular or out of style and we can hold less of these in inventory since it is not in high demand during this time 
 */





