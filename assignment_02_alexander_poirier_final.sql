/*
AWS RDS Database Connection Details
Host: {host}
Username: {username}
Password: {password}
*/

CREATE DATABASE assignment_02;

/*
3. SQL - Create a table named nyt_article with a column for each of these JSON keys in the API result:
nyt_article_id (set as an auto-incrementing primary key)
web_url (set as a unique key)
main_headline
document_type
pub_date
word_count
type_of_material
*/

CREATE TABLE nyt_article (
	nyt_article_id int NOT NULL AUTO_INCREMENT,
	web_url varchar(255),
	main_headline varchar(255),
	document_type varchar(255),
	pub_date varchar(255),
	word_count int,
	type_of_material varchar(255),
	PRIMARY KEY (nyt_article_id),
	CONSTRAINT UNIQUE (web_url));


-- Scratch Work
Truncate table nyt_article;

SELECT * FROM nyt_article;

SELECT * FROM simplyhired_job;

-- 5. SQL - How many articles were published between December 1, 2019 and December 25, 2019 in the nyt_article table?
SELECT 
	COUNT(*) AS number_of_articles_published_in_December
FROM nyt_article 
WHERE pub_date BETWEEN '2020-12-01' AND '2020-12-31';

-- 6. SQL - What is the average word count per article for articles published on and after November 2, 2019 in the nyt_article table?
SELECT
	AVG(word_count) AS average_wordcount_after_november01
FROM nyt_article 
WHERE pub_date > '2020-11-01';

-- 7. SQL - What is the minimum and maximum pub_date for articles published between October 1, 2019 and October 31, 2019 in the nyt_article table?
SELECT 
	MIN(pub_date),
	MAX(pub_date)
FROM nyt_article 
WHERE pub_date BETWEEN '2020-10-01' AND '2020-10-31';

-- 8. SQL - How many total words were published for articles published in November 2019 in the nyt_article table?
SELECT
	SUM(word_count)
FROM nyt_article 
WHERE pub_date BETWEEN '2020-11-01' AND '2020-11-30';

-- 9. SQL - Display the agents' full name as a single column and the engagement dates they booked where the negotiated price is over $1k. Sort the results by the booking start date from oldest to newest.
USE TalentAgency;
SELECT 
	CONCAT(AgtFirstName, ' ' , AgtLastName) AS AgentName,
	StartDate,
	EndDate,
	ContractPrice
FROM Agents a
JOIN Engagements e 
	ON a.AgentID = e.AgentID 
WHERE ContractPrice > 1000
ORDER BY StartDate;

-- 10. SQL - List the customers (full name) and the entertainers they booked from the 98052 zip code.
SELECT 
	CustFirstName,
	CustLastName,
	EntStageName,
	CustZipCode
FROM Customers c 
JOIN Engagements e 
	ON c.CustomerID = e.CustomerID 
JOIN Entertainers e2 
	ON e.EntertainerID = e2.EntertainerID 
WHERE CustZipCode = 98052;

-- 11. SQL - Find agent(s) who have yet to book an entertainer.
SELECT 
	AgtFirstName, 
	AgtLastName
FROM Agents 
WHERE AgentID NOT IN (SELECT AgentID FROM Engagements);
	

-- 12. SQL - Name the entertainer(s) who have never been booked.
SELECT 
	EntStageName
FROM Entertainers e 
WHERE EntertainerID NOT IN (SELECT EntertainerID FROM Engagements);

-- 13. SQL - Display a combined list of customers and entertainers. Be sure the number of columns lines up. Identify if the row is a Customer or Entertainer.
SELECT 	
	CONCAT(CustFirstName, " " ,CustLastName) AS Name,
	'Customer'
FROM Customers 
UNION
SELECT 
	CONCAT(MbrFirstName, " " ,MbrLastName) AS Name,
	'Entertainer'
FROM Members; 

-- 14. SQL - Without using a JOIN and only using subqueries, list the entertainers who played engagements for the customer, Sarah Thompson.
-- finished query
SELECT 
	EntStageName,
	EntertainerID 
FROM Entertainers 
WHERE EntertainerID IN (
	SELECT 
		EntertainerID
	FROM Engagements 
	WHERE CustomerID IN (
		SELECT 
			CustomerId
		FROM Customers 
		WHERE CustFirstName = 'Sarah'
			AND CustLastName = 'Thompson'));

-- getting entertainer id
SELECT 
	EntertainerID,
	CustomerID 
FROM Engagements 
WHERE CustomerID IN (
	SELECT 
		CustomerId
	FROM Customers 
	WHERE CustFirstName = 'Sarah'
		AND CustLastName = 'Thompson');


-- getting sarah's id
SELECT 
	CustomerId,
	CustFirstName,
	CustLastName
FROM Customers 
WHERE CustFirstName = 'Sarah'
	AND CustLastName = 'Thompson';

-- 15. SQL - Find the customer full name with the most engagements booked. The end result should only contain 1 row.
-- final query
SELECT 
	CONCAT(CustFirstName, ' ' ,CustLastName) AS name,
	COUNT(e.CustomerID) AS total_bookings
FROM Customers c 
JOIN Engagements e 
	ON c.CustomerID = e.CustomerID 
GROUP BY c.CustomerID
ORDER BY COUNT(e.CustomerID) DESC
LIMIT 1;

-- 16. SQL - Generate a list of entertainer names with their number of booked engagements, lowest contract price, highest contract price, contract price total, and contract price average.
SELECT 
	EntStageName,
	COUNT(e.EntertainerID) AS number_of_booked_engagements,
	MIN(ContractPrice) AS lowest_contract_price,
	MAX(ContractPrice) AS highest_contract_price,
	SUM(ContractPrice) AS sum_contract_price,
	AVG(ContractPrice) AS average_contract_price
FROM Engagements e 
JOIN Entertainers e2 
	ON e.EntertainerID = e2.EntertainerID 
GROUP BY e2.EntertainerID
ORDER BY EntStageName;
-- 17. SQL - Name the agents who booked more than $1,000 worth of business in November 2017.
SELECT 
	e.AgentID,
	AgtFirstName,
	AgtLastName,
	SUM(ContractPrice) AS total_bookings
FROM Engagements e 
JOIN Agents a 
	ON e.AgentID = a.AgentID 
WHERE StartDate >= '2017/11/01'
	AND EndDate <= '2017/11/30'
GROUP BY AgentID
HAVING (SUM(ContractPrice) > 1000)
ORDER BY AgentID DESC;

-- 18. SQL - Query for each agent’s full name, the sum of the contract price for the engagements booked, and the agent’s total commission for agents whose total commission is more than $500. Consider the columns required to calculate the commission. The grouped results will be filtered by a calculated value.
SELECT 	
	CONCAT(AgtFirstName, ' ' , AgtLastName) AS agent_name,
	SUM(e.ContractPrice) AS total_booking_price,
	CommissionRate,
	(SUM(e.ContractPrice) * CommissionRate) AS commission 
FROM Agents a
JOIN Engagements e 
	ON a.AgentID = e.AgentID 
GROUP BY a.AgentID
HAVING (SUM(e.ContractPrice) * CommissionRate) > 500
ORDER BY commission;


/*
Data Request 1
{Question} How do our agents salaries compare when looking at individual city?

{Business Justification} Better understanding of employees and the cost associated with these hires. 
Can look at highest paid agents to see if they have the best performance or if you should promote 
other employees who have a lower salary. Also helps to see cost if you have expensive branches inn certain areas
or underpaid employees in other areas.

{Loom Video Link} https://www.loom.com/share/f0157a4475cf485885db305d1bd55daf
*/
WITH washington_agents AS (
	SELECT 
		AgtFirstName,
		AgtLastName,
		AgtCity,
		Salary,
		SUM(Salary) OVER (
			PARTITION BY AgtCity 
		) AS total_city_salary
	FROM Agents a 
	WHERE AgtState = 'WA'
)
SELECT *
FROM washington_agents;



-- scratch work
SELECT *
FROM Agents;
	


/*
Data Request 2
{Question} How large are the etertainer group sizes? Organize them by city

{Business Justification} This question helps to provide insight into capcaity issues for COVID timeline, 
potential costs with having more members, and a better understanding of the entertainers that you have 
to see whether you have success in landing bookings for larger groups or smaller groups.

{Loom Video Link} https://www.loom.com/share/222434d628f64a34a4fd275408a1ecca
*/

SELECT 
	e2.EntStageName,
	e.MemberID, 
	m.MbrFirstName,
	m.MbrLastName,
	e2.EntCity,
	e2.EntState,
	COUNT(e.MemberID) OVER (
		PARTITION BY EntCity, EntStageName 
	) AS number_of_members
FROM Entertainer_Members e
JOIN Members m
	ON e.MemberID = m.MemberID
JOIN Entertainers e2 
	ON e.EntertainerID = e2.EntertainerID;


SELECT *
FROM Entertainer_Members em;

/*
Data Request 3 
{Question} what are the different prices of bookings seperated by city?

{Business Justification} This helps our business to understand where are areas that we charge more versus areas that offer
cheaper prices. This can be great insight in order to give accurate quoted prices to future customers and help them to know
what to expect from our businenss, as well as to help agents know their historical data regarding contracts that they made.

{Loom Video Link} https://www.loom.com/share/381ff65dab0142adb0412efa61405c1f
*/
WITH avg_city_price AS (
	SELECT 
		CustCity,
		CustState,
		AVG(ContractPrice) OVER (PARTITION BY CustCity) AS average_city_price
	FROM Engagements e 
	JOIN Customers c 
		ON e.CustomerID = c.CustomerID 
)
SELECT 
	DISTINCT(CustCity),
	CustState,
	average_city_price
FROM avg_city_price
ORDER BY average_city_price;


/*
Data Request 4
{Question} What is the most recent engagement for the Agent William Thompson and the history of their bookings? 

{Business Justification} Have the ability to see the history of the time that William Thompson has worked here.
Helps the business to see his bookings as well as the most recent booking that he had. This base SQL query can
also be added to for other specifics like location, customers, or entertainers by adding joins or where statements.
Can be used in performance reviews or general queries to learn more about the agents.

{Loom Video Link} https://www.loom.com/share/2c96ed8c32ec480b951b1699627dd066
*/

WITH recent_engagements AS (
	SELECT 
		e.AgentID,
		AgtFirstName,
		AgtLastName,
		EngagementNumber,
		StartDate,
		FIRST_VALUE (StartDate) OVER (PARTITION BY AgentID ORDER BY StartDate DESC) AS most_recent_engagement
	FROM Engagements e
	JOIN Agents a
		ON e.AgentID = a.AgentID 
	
)
SELECT *
FROM recent_engagements
WHERE AgtLastName = 'Thompson';


-- scratch work
SELECT *
FROM Engagements;


/*
20. SQL - Create a table named simplyhired_job with a column for each of these job components:
simplyhired_job_id (set as an auto-incrementing primary key)
title
company
location
link (link to the job details - the link is a relative link without a domain)
*/
CREATE TABLE simplyhired_job (
	simplyhired_job_id int NOT NULL AUTO_INCREMENT,
	title varchar(255),
	company varchar(255),
	location varchar(255),
	link varchar(255),
	PRIMARY KEY (simplyhired_job_id));

