-- Create a database named lesson_exercises to store our state_names table
CREATE DATABASE lesson_exercises;

-- Activate the lesson_exercises database
USE lesson_exercises;

-- Create the state_names table with only a primary key index
CREATE TABLE state_names (
    state_name_id INT NOT NULL,
    name VARCHAR(255),
    year INT(4),
    gender ENUM('F','M'),
    state VARCHAR(2),
    name_count INT,
    PRIMARY KEY (state_name_id)
);


-- Add the ability for the admin user to set session values to allow mysqlimport to run
GRANT SESSION_VARIABLES_ADMIN ON *.* TO 'admin'@'%';


-- Run mysqlimport from the command line to import the state_names.csv file into the state_names table

SELECT *
FROM state_names 
LIMIT 10;

SELECT COUNT(*)
FROM state_names;

-- Benchmark query performance before adding an index

-- One column in WHERE
-- Run 3x and record the query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Jane';
-- 1: 1.590s
-- 2: 1.531s
-- 3: 1.538s


-- Two columns in WHERE
-- Run 3x and record the query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;
-- 1: 1.716s
-- 2: 1.735s
-- 3: 1.540s


-- Add an index on name
CREATE INDEX index_name ON state_names (name);

-- Confirm index added
SHOW INDEX FROM state_names;


-- One column in WHERE
-- Run 3x and record the results and query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Jane';
-- Results: 
-- 1: 184 ms
-- 2: 177 ms
-- 3: 188 ms


-- Two columns in WHERE
-- Run 3x and record the results and query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;
-- Results: 
-- 1: 915 ms
-- 2: 203 ms
-- 3: 186 ms

/*
EXPLAIN
	- Shows the query execution plan
	- Confirms which indexes, if any, will be used

https://dev.mysql.com/doc/refman/8.0/en/using-explain.html
https://dba.stackexchange.com/questions/164251/what-is-the-meaning-of-filtered-in-mysql-explain
*/

-- Show the query execution plan with two columns in the WHERE
EXPLAIN 
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;


-- Add a second index using year
CREATE INDEX index_year ON state_names (year);

-- Confirm index added
SHOW INDEX FROM state_names;

-- Two columns in WHERE
-- Run 3x and record the results and query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;
-- 1: 228 ms
-- 2: 200 ms
-- 3: 190 ms


-- Show the query execution plan with two columns in the WHERE after adding the second index
EXPLAIN 
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;


/*
Cardinality

High cardinality: many distinct values
Low cardinality: few distinct values
*/

-- Display index stats
SHOW INDEX FROM state_names;

-- Count the # of unique name values
SELECT COUNT(DISTINCT(NAME))
FROM state_names;


-- Count the # of unique year values
SELECT COUNT(DISTINCT(year))
FROM state_names;


/*
Multiple Column (Composite) Indexes

If we wanted to query based on name and year, MySQL will return results faster 
if using 1 index with both columns versus 2 separate indexes for each column.

When creating the index, list the columns in the order based on frequency use.
The order determines if the index will be used. 

If name is listed first but not used in the WHERE, the composite index will not 
be used even if year is part of the index and year is in the WHERE
*/

-- Add a single, composite index referencing two columns
CREATE INDEX index_name_year ON state_names (name, year);

-- Show the updated query execution plan for two columns in the WHERE
EXPLAIN 
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;
	

-- Two columns in WHERE
-- Run 3x and record the results and query time
SELECT COUNT(*)
FROM state_names sn 
WHERE name = 'Angel'
	AND `year` = 1979;
-- Results: 
-- 1: 189 ms
-- 2: 181 ms
-- 3: 177 ms


-- Drop individual indexes on name and year
DROP INDEX index_name on state_names;

DROP INDEX index_year ON state_names;

SHOW INDEX FROM state_names;



