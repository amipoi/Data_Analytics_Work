/*
Example 1
- Create a stored procedure to check if a film title (IN parameter) is family friendly 
- Use a prepared statement for the SELECT
- If yes, set an OUT parameter named out_family_friendly_status to 1
*/

-- Set DELIMITER to $$
DELIMITER $$

-- Remove prodcedure if it already exists
DROP PROCEDURE IF EXISTS get_film_famil_friendly_status$$

-- Create procedure with 1 IN parameter and 1 OUT parameter
CREATE PROCEDURE get_film_famil_friendly_status(in_title VARCHAR(255), OUT out_family_friendly_status INT)

-- Start the block of multiple statements
BEGIN

	-- Assign the IN paramter to a variable in order to use the value in a prepared statement
	SET @film_title := in_title;
	
  	-- Reset rating variable, otherwise values from previous runs will carry over
	SET @rating := NULL;

	-- PREPARE SELECT statement
	PREPARE rating_select_stmt FROM 
		'
			SELECT rating INTO @rating
			FROM film
			WHERE title =?
		';
	
	
  	-- EXECUTE prepared statement
	EXECUTE rating_select_stmt USING @film_title;

  	-- DEALLOCATE prepared statement
	DEALLOCATE PREPARE rating_select_stmt;

  	-- Print out rating
	SELECT @rating;

	-- Example 1.0
  	-- IF - ELSEIF - ELSE
  	/*
	IF (@rating = 'G') THEN
		SET out_family_friendly_status :=1;
	ELSEIF (@rating = 'PG') THEN
		SET out_family_friendly_status :=1;
	ELSEIF (@rating IS NULL) THEN
		SET out_family_friendly_status := NULL;
	ELSE
		SET out_family_friendly_status :=0;
	END IF;
	*/
	-- Example 1.1
  	-- IF w/OR - ELSEIF - ELSE
	/*
	IF ((@rating = 'G') OR (@rating = 'PG'))THEN
		SET out_family_friendly_status :=1;
	ELSEIF (@rating IS NULL) THEN
		SET out_family_friendly_status := NULL;
	ELSE
		SET out_family_friendly_status :=0;
	END IF;
	*/
	-- Example 2
  	-- CASE
	CASE @rating
	WHEN 'G' THEN
		SET out_family_friendly_status := 1;
	WHEN 'PG' THEN
		SET out_family_friendly_status := 1;
	ELSE
		SET out_family_friendly_status := 0;
	END CASE;

-- End the block of multiple statements
END$$

-- Set DELIMITER back to ;
DELIMITER ;

-- Execute stored procedure and verify OUT parameter
-- G
-- CAT CONEHEADS
CALL get_film_famil_friendly_status('CAT CONEHEADS', @is_family_friendly);
SELECT @is_family_friendly;
-- PG
-- ACADEMY DINOSAUR
CALL get_film_famil_friendly_status('ACADEMY DINOSAUR', @is_family_friendly);
SELECT @is_family_friendly;

-- R
-- BEAR GRACELAND
CALL get_film_famil_friendly_status('BEAR GRACELAND', @is_family_friendly);
SELECT @is_family_friendly;

-- NULL
-- LMU AIMS (film doesn't exist)
CALL get_film_famil_friendly_status('LMU AIMS', @is_family_friendly);
SELECT @is_family_friendly;


-- ------------------------------------------
-- LOOPS


-- Example 3
-- LOOP - LEAVE - END LOOP
-- Count to 3

-- Set DELIMITER to $$
DELIMITER $$

-- Remove prodcedure if it already exists
DROP PROCEDURE IF EXISTS loop_leave_end_loop_example$$

-- Create procedure with 0 parameters
CREATE PROCEDURE loop_leave_end_loop_example()

-- Start the block of multiple statements
BEGIN
	-- DECLARE a variable to keep track of the running count. Make sure to set a default value to avoid an infinite loop
	DECLARE running_count INT DEFAULT 0;
	
  	-- Label and start LOOP
	count_to_3_loop : LOOP
	
    	-- Increment the running_count
		SET running_count := running_count + 1;

	    -- Print out the current running_count
		SELECT running_count;

    	-- Check if the running_count equals 3
		IF running_count = 3 THEN
      		-- If yes, exit the loop
      		-- Need the LEAVE, otherwise LOOP will count forever -> infinite loop
			LEAVE count_to_3_loop;
		END IF;

  	-- End LOOP
	END LOOP count_to_3_loop;

-- End the block of multiple statements
END $$

-- Set DELIMITER back to ;
DELIMITER ;

-- Execute stored procedure
CALL loop_leave_end_loop_example();


-- Example 4
-- WHILE LOOP
-- Count to 3
DELIMITER $$

DROP PROCEDURE IF EXISTS while_loop_example$$

CREATE PROCEDURE while_loop_example()

BEGIN
	
	DECLARE running_count INT DEFAULT 0;
	
	count_to_3_loop: WHILE running_count < 3 DO
		SET running_count := running_count + 1;
	
		SELECT running_count;
	END WHILE count_to_3_loop;
	
END$$



DELIMITER ;

CALL while_loop_example();

-- Example 5
-- REPEAT ... UNTIL LOOP
-- Count to 3
DELIMITER $$

DROP PROCEDURE IF EXISTS repeat_until_loop_example$$

CREATE PROCEDURE repeat_until_loop_example()
BEGIN
	
	DECLARE running_count INT DEFAULT 0;
	
	count_to_3_loop: REPEAT
		SET running_count := running_count + 1;
	
		SELECT running_count;
	UNTIL running_count = 3
	END REPEAT count_to_3_loop;
	
END$$

DELIMITER ;

CALL repeat_until_loop_example();


-- ------------------------------------------------------------------------------------
-- CURSORS and LOOPS

/*
Example 6
- Query for film_id, title, and rating based on a rating
- Create a stored procedure named get_film_by_rating
- IN parameters
  - rating
  - LIMIT for the # of films returned
- OUT parameter
  - list of films
- LOOP - LEAVE - END LOOP
*/

-- Set DELIMITER to $$
DELIMITER $$

-- Remove prodcedure if it already exists
DROP PROCEDURE IF EXISTS get_film_by_rating$$

-- Create procedure with 2 IN parameters and 1 OUT parameter
CREATE PROCEDURE get_film_by_rating(in_rating VARCHAR(5), in_film_limit INT, OUT out_film_list TEXT)

-- Start the block of multiple statements
BEGIN

  	-- DECLARE variables
  	-- Queried columns
	DECLARE selected_film_id INT;
	DECLARE selected_title VARCHAR(255);
	DECLARE selected_rating VARCHAR(5);
	

  	-- To store the list of films. Need a blank string as default value for CONCAT
	DECLARE film_list TEXT DEFAULT '';
 	
 	-- For LOOP termination flag
	DECLARE done INT DEFAULT 0;

  	-- DECLARE CURSOR and write SELECT SQL
	DECLARE film_cursor CURSOR FOR
		SELECT film_id, title, rating
		FROM film 
		WHERE rating = in_rating
		LIMIT in_film_limit;

  	-- Error Handling
  	-- Execute when no row is found in the cursor (all rows read)
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET done =1;

  	-- OPEN CURSOR to execute query
	OPEN film_cursor;

    -- Label and start LOOP
	film_cursor_loop : LOOP
  	
	    -- FETCH SELECT results into desired variables. Columns SELECTed must match the # of variables.
		FETCH film_cursor INTO selected_film_id, selected_title, selected_rating;
		
	    -- Exit loop if no more rows to process
		IF done = 1 THEN
			LEAVE film_cursor_loop;
		END IF;
		
	    -- Print out film_id, title, and rating
		SELECT selected_film_id, selected_title, selected_rating;

    	-- Append title to the declared variable for the list of films OUT parameter
		SET film_list := CONCAT(film_list, ',', selected_title); 
		
    	-- Assign running list of films to the OUT parameter
		SET out_film_list := TRIM( LEADING ',' FROM film_list);

    -- End LOOP
	END LOOP film_cursor_loop;

  	-- CLOSE CURSOR to free up resources
	CLOSE film_cursor;

-- End the block of multiple statements
END$$

-- Set DELIMITER back to ;
DELIMITER ;

-- Execute stored procedure and verify OUT parameter
CALL get_film_by_rating('PG-13',3, @out_film_list);
SELECT @out_film_list;




