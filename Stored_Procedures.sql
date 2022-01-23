-- Stored Procedures

-- connect to database
USE IO_analytics;

-- Application: This stored procedure allows us as analysts to add trails of a certain rating into a list in order 
-- to be able to view trails that have received either a positive or negative response. The analyst can limit how many trails are returned as well 
-- as what specific rating they would like to look at between 0 and 5.

DELIMITER $$

DROP PROCEDURE IF EXISTS get_trips_by_rating$$

CREATE PROCEDURE get_trips_by_rating(in_rating INT, in_trip_limit INT, OUT out_trail_list TEXT)

BEGIN

	DECLARE selected_trail_id INT;
	DECLARE selected_trail_name VARCHAR(255);
	DECLARE selected_rating INT;
	

	DECLARE trail_list TEXT DEFAULT '';
 	
	DECLARE done INT DEFAULT 0;

	DECLARE trail_cursor CURSOR FOR
		SELECT trail_id, trail_name, star_review
		FROM trails 
		WHERE star_review = in_rating
		LIMIT in_trip_limit;

	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET done =1;

	OPEN trail_cursor;

	trail_cursor_loop : LOOP
  	
		FETCH trail_cursor INTO selected_trail_id, selected_trail_name, selected_rating;
		
		IF done = 1 THEN
			LEAVE trail_cursor_loop;
		END IF;
		
		SELECT selected_trail_id, selected_trail_name, selected_rating;

		SET trail_list := CONCAT(trail_list, ',', selected_trail_name); 
		
		SET out_trail_list := TRIM( LEADING ',' FROM trail_list);

	END LOOP trail_cursor_loop;

	CLOSE trail_cursor;

END$$

DELIMITER ;

-- Execute stored procedure 
CALL get_trips_by_rating(5,5, @out_trail_list);

-- verify OUT parameter
SELECT @out_trail_list;
