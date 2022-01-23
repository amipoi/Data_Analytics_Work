-- add conncetion to database
USE IO_analytics;

-- check connection success
SELECT *
FROM users;

-- Trigger for Final Project

-- Application: Executes when data has been updated.

-- Trigger function will keep a log when user adjusts their review for a trip, this will help keep track of how users feel about a trip after 
-- some time has passed. Helps us to remember initial rating as well as current ratings for these trips

-- Alter to Innodb engines
SHOW TABLE STATUS WHERE Name = 'users';
SHOW TABLE STATUS WHERE Name = 'trails';
SHOW TABLE STATUS WHERE Name = 'trips';

-- Create Trigger

CREATE TABLE Trips_Log (
User INT(11),
TrailID INT(11),
OldRating INT(11),
NewRating INT(11),
LogDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

SELECT USER();

DELIMITER $$
CREATE TRIGGER Trips_After_Update
	AFTER UPDATE ON trips
	FOR EACH ROW
BEGIN
	INSERT INTO Trips_Log 
	(User, TrailID, OldRating, NewRating)
	VALUES 
	(OLD.user_id, OLD.trail_id, OLD.review, NEW.review);

END$$
DELIMITER ;

-- find testing value for trigger 
SELECT *
FROM trips 
WHERE trip_id = 643;

-- update trip to cause trigger to activate
UPDATE trips 
SET review = 5
WHERE user_id = 45
	AND trip_id = 643;

-- check that trigger works as anticipated
SELECT *
FROM Trips_Log;

