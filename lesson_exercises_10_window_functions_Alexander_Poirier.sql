/*
 * 01 - Compare a film's replacement cost against the average replacement cost for the films within a rating.
 * Indicate with a boolean if the replacement cost is greater than the average.
 * 
 * Expected headers:
 * title |rating|replacement_cost|avg_cost |is_overpriced|
 * ------|------|----------------|---------|-------------|
 */
SELECT 	
	title,
	rating,
	replacement_cost,
	AVG(replacement_cost) OVER (
		PARTITION BY rating
	) AS avg_cost,
	replacement_cost > AVG(replacement_cost) OVER (
		PARTITION BY rating
	) AS is_overpriced
FROM film;


/*
 * 02 - Who is the actor with the most films in each genre?
 * Ties are allowed.
 * 
 * Expected headers:
 * genre|actor_id|first_name|last_name|film_count|film_count_rank|
 * -----|--------|----------|---------|----------|---------------|
*/


-- Verify the film_count for the actor with the most films in the Comedy genre
WITH film_actor_count AS (
	SELECT 
		c.name AS genre,
		a.actor_id,
		a.first_name,
		a.last_name,
		COUNT(fa.actor_id) AS film_count,
		RANK() OVER (
			PARTITION BY c.name
			ORDER BY COUNT(fa.actor_id) DESC
		) AS film_count_rank
	FROM film f
	JOIN film_actor fa
		ON f.film_id = fa.film_id 
	JOIN actor a
		ON fa.actor_id = a.actor_id
	JOIN film_category fc 
		ON f.film_id = fc.film_id 
	JOIN category c
		ON fc.category_id = c.category_id 
	GROUP BY 
		genre,
		a.actor_id 
)
SELECT *
FROM film_actor_count
WHERE film_count_rank =1;




