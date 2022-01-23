/*
Host: {host}
Username: {username}
Password: {password}
*/

-- Create a database named lesson_exercises_08
CREATE DATABASE lesson_exercises_08;


-- List the databases
SHOW DATABASES;

-- Make the lesson_exercises_08 database the active database
USE lesson_exercises_08;

-- Create a customer table with a primary key and the following columns:
-- first_name, last_name, email
CREATE TABLE customer (
	customer_id INT(11) NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email VARCHAR(255),
	PRIMARY KEY (customer_id)
);

-- List the tables in the active database
SHOW TABLES;

-- Display the customer table schema
DESCRIBE customer;

-- Insert one record into the customer table
INSERT INTO customer
SET 
	first_name = 'Alexander',
	last_name = 'Poirier',
	email = 'apoirie1@lion.lmu.edu';
-- Confirm the insert by selecting all rows and columns from the customer table
SELECT *
FROM customer;


