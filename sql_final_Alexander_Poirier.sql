
/*
 * 1.
 * A steady increase in customers are finding PG films are out of stock. To help the inventory coordinator
 * balance the inventory to reduce stockouts, return a report with a list of genres and the number of films 
 * in inventory for each genre. Limit the results to PG films where the number of films in inventory is less 
 * than the average across all the genres. Sort the number of films per genre in ascending order. 
 * "In inventory" means the company carries the film. You do not have to check if the film is out for rental. 
 * 
 * For future data comparisons, include the date when the report was generated in this format:
 * Thursday, April 29, 2021
 * 
 * You can use any combination of subqueries, VIEWs, or CTEs.
 *
 * Expected results header:
 * report_date|genre|genre_count|
 * -----------|-----|-----------|
 * 
 * Loom video link: https://www.loom.com/share/0ea20a0c20e74c1589ce4bea2cf3f67a
 */
USE sakila;



WITH genreCountCTE AS (
	SELECT 
		c.name AS genre,
		COUNT(i.film_id) AS genre_count
	FROM inventory i 
	JOIN film f
		ON f.film_id = i.film_id 
	JOIN film_category fc 
		ON f.film_id = fc.film_id 
	JOIN category c
		ON c.category_id = fc.category_id
	WHERE f.rating = 'PG'
	GROUP BY c.name
	ORDER BY COUNT(i.film_id) ASC
)
SELECT 
	DATE_FORMAT(CURDATE(),"%W %M %d %Y")AS report_date,
	genre, 
	genre_count
FROM genreCountCTE
HAVING genre_count <
	(
		SELECT AVG(genre_count)
		FROM genreCountCTE
	);

-- date format %W - for weekday name, %M %d, %Y

-- count for each inventory for PG films
SELECT 
	c.name, 
	COUNT(i.film_id)
FROM inventory i 
	JOIN film f
		ON f.film_id = i.film_id 
	JOIN film_category fc 
		ON f.film_id = fc.film_id 
	JOIN category c
		ON c.category_id = fc.category_id 
WHERE f.rating = 'PG'
GROUP BY c.name;

-- subquery



/*
 * 2.
 * To increase profits, a business analyst wants to increase the rental rate for the most popular films
 * in each genre. Give the business analyst a list of films that rank first and second place for the most rentals. 
 * Include the film's title, current rental rate, genre, rental count, and the rank based on the rental count. 
 * If there is a tie for first or second place, include the tied titles. With that said, there can be more than 
 * 2 titles returned per genre. Convert the genre's letters to uppercase to match the title's capitalization.
 *
 * Expected results header:
 * title|rental_rate|genre|rental_count|rental_count_rank|
 * -----|-----------|-----|------------|-----------------|
 *
 * Loom video link: https://www.loom.com/share/88178603e71c4a73bbcdb9b064272354
 * 
 * Forgot to mention I used a CTE for this query, essentially it helps us to grab the data we want first and put it in a temporary table 
 * so that we  can select from it after. You could use other options but I chose to go with the CTE due to its simplicity in use and I 
 * find it easy to read though the code
*/
WITH rentalGenreCTE AS (
	SELECT 
		f.title,
		f.rental_rate,
		UPPER(c.name) AS genre,
		COUNT(r.inventory_id) AS rental_count,
		DENSE_RANK () OVER (
			PARTITION BY c.name 
			ORDER BY COUNT(r.inventory_id) DESC
		) AS rental_count_rank
	FROM film f
	JOIN inventory i
		ON f.film_id = i.film_id 
	JOIN film_category fc 
		ON f.film_id = fc.film_id 
	JOIN category c
		ON c.category_id = fc.category_id
	JOIN rental r 
		On r.inventory_id = i.inventory_id 
	GROUP BY f.film_id 
)
SELECT *
FROM rentalGenreCTE
WHERE rental_count_rank < 3;


-- extra work
SELECT 
	f.film_id,
	f.title,
	COUNT(r.inventory_id)
FROM film f 
JOIN inventory i
		ON f.film_id = i.film_id 
	JOIN film_category fc 
		ON f.film_id = fc.film_id 
	JOIN category c
		ON c.category_id = fc.category_id
	JOIN rental r 
		On r.inventory_id = i.inventory_id 
	GROUP BY f.film_id 
	
	
	SELECT * FROM film;
	
	SELECT 
		inventory_id,
		rental_id 
	FROM rental;
