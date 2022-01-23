/*
# Upload https://bit.ly/state-names-unpartitioned (state-names-unpartitioned.zip) into S3 lesson-exercises-fname-lname bucket
# Upload https://bit.ly/state-names-partitioned (state-names-partitioned.zip) into S3 lesson-exercises-fname-lname bucket

# SSH into EC2 instance using EC2 Instance Connect

# Start a screen session in case your connection to the server drops
screen

# Configure AWS CLI
aws configure

# Get Access Key ID and Secret Access Key from My Security Credentials

# List S3 lesson-exercises-fname-lname bucket contents
aws s3 ls s3://lesson-exercises-fname-lname


# Reconnect to the EC2 server via SSH using EC2 Instance Connect

# Resume the previous screen session
screen -rd

# Confirm you're in the home directory
pwd

# Make a data directory
mkdir data

# Change into the data directory
cd data

# Copy state-names-unpartitioned.zip from S3 bucket to EC2 data directory
aws s3 cp s3://lesson-exercises-fname-lname/state-names-unpartitioned.zip state-names-unpartitioned.zip

# Unzip state-names-unpartitioned.zip
unzip state-names-unpartitioned.zip

# View first 10 rows of state-names-unpartitioned.csv
head state-names-unpartitioned.csv

# Confirm all rows present
wc -l state-names-unpartitioned.csv

# Copy state-names-unpartitioned.csv to state-names-unpartitioned folder in S3 bucket (S3 will create the folder if it doesn't exist)
aws s3 cp state-names-unpartitioned.csv s3://lesson-exercises-fname-lname/state-names-unpartitioned/

# Confirm state-names-unpartitioned.csv is in the S3 bucket via the aws cli
aws s3 ls s3://lesson-exercises-fname-lname/state-names-unpartitioned/

# Confirm state-names-unpartitioned.csv is in the S3 bucket via the AWS S3 console


# Go to Athena console

# Go to Settings. Set Query result location to s3://lesson-exercises-fname-lname/query-results/ (S3 will create the folder if it doesn't exist)

*/


-- Create lesson_exercises database
CREATE DATABASE lesson_exercises;

-- ------------------------------------------------------------
-- Unpartitioned table

-- Create state_names_unpartitioned table
-- https://docs.aws.amazon.com/athena/latest/ug/data-types.html
-- https://docs.aws.amazon.com/athena/latest/ug/supported-serdes.html
CREATE EXTERNAL TABLE lesson_exercises.state_names_unpartitioned (
  `state_name_id` INT,
  `name` STRING,
  `year` INT,
  `gender` STRING,
  `state` STRING,
  `name_count` INT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ','
)
LOCATION 's3://lesson-exercise-alexander-poirier/state-names-unpartitioned'
TBLPROPERTIES (
  'has_encrypted_date' = 'false'
);

-- Select the first 10 rows from the table
SELECT *
FROM lesson_exercises.state_names_unpartitioned
LIMIT 10;
--  (Run time: 1.25 seconds, Data scanned: 321.51 KB)


-- Count the # of rows in the state_names_unpartitioned table
SELECT COUNT(*)
FROM lesson_exercises.state_names_unpartitioned;
-- (Run time: 5.18 seconds, Data scanned: 147.53 MB)


-- Count the # of rows by year for females
SELECT 
	year,
	COUNT(*) AS year_count
FROM lesson_exercises.state_names_unpartitioned
WHERE gender = 'F'
GROUP BY year;
--  (Run time: 7.25 seconds, Data scanned: 147.53 MB)


-- Count the # of rows by year for females in California
SELECT 
	year,
	COUNT(*)
FROM lesson_exercises.state_names_unpartitioned
WHERE gender = 'F'
    AND state = 'CA'
GROUP BY year;
-- (Run time: 7.06 seconds, Data scanned: 147.53 MB)


-- ------------------------------------------------------------
-- Partitioned table

-- Determine partions based on cardinality
SELECT 
	COUNT(DISTINCT(gender)) AS distinct_gender_count,
    COUNT(DISTINCT(state)) AS distinct_state_count,
    COUNT(DISTINCT(year)) AS distinct_year_count,
    COUNT(DISTINCT(name)) AS distinct_name_count
FROM lesson_exercises.state_names_unpartitioned;
--  (Run time: 14.52 seconds, Data scanned: 147.53 MB)

/*
parse_state_names.sh:

#!/bin/bash

file="$1"
echo "file: $file"

while IFS="," read state_name_id name year gender state name_count
do
	mkdir -p /home/ec2-user/data/state-names-partitioned/gender=$gender/state=$state
	echo "$state_name_id,$name,$year,$name_count" >> /home/ec2-user/data/state-names-partitioned/gender=$gender/state=$state/data.csv
done < $file
-------------------------------------------------------------------------------------------
[ec2-user@ip-172-31-25-164 scripts]$ time sh parse_state_names.sh ../data/state-names-unpartitioned.csv
file: ../data/state_names.csv

real    97m42.079s
user    77m11.414s
sys     19m47.577s
*/

/*
# SSH into EC2 instance using EC2 Instance Connect
# Refresh browser tab if command line is not responding
# Reconnect to screen session if you were disconnected
screen -rd

# Copy state-names-partitioned.zip from S3 bucket to EC2 data directory
aws s3 cp s3://lesson-exercises-fname-lname/state-names-partitioned.zip state-names-partitioned.zip

# Unzip state-names-partitioned.zip
unzip state-names-partitioned.zip

# View first 10 rows of a sample data.csv file
head state-names-partitioned/gender=M/state=TX/data.csv

# Verify a row was added to the correct partition folder
grep "4937855,John" state-names-unpartitioned.csv

# Recursively list the directories under state-names-partitioned
ls -R state-names-partitioned

# Copy state-names-partitioned.csv to state-names-partitioned folder in S3 bucket (S3 will create the folder if it doesn't exist)
aws s3 cp --recursive state-names-partitioned/ s3://lesson-exercises-fname-lname/state-names-partitioned/

# Confirm the state-names-partitioned folder is in the S3 bucket via the aws cli
aws s3 ls s3://lesson-exercises-fname-lname/state-names-partitioned/

# Confirm the state-names-partitioned folder is in the S3 bucket via the AWS S3 console

*/

-- Create state_names_partitioned table
CREATE EXTERNAL TABLE lesson_exercises.state_names_partitioned (
  `state_name_id` INT,
  `name` STRING,
  `year` INT,
  `name_count` INT
)
PARTITIONED BY (
	`gender` STRING,
	`state` STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ','
)
LOCATION 's3://lesson-exercise-alexander-poirier/state-names-partitioned'
TBLPROPERTIES (
  'has_encrypted_date' = 'false'
);

-- Select the first 10 rows from the table
SELECT *
FROM lesson_exercises.state_names_partitioned
LIMIT 10;
--  (Run time: 0.82 seconds, Data scanned: 0 KB)


-- Load partitions to view the data
MSCK REPAIR TABLE lesson_exercises.state_names_partitioned;
--  (Run time: 31.76 seconds, Data scanned: 0 KB)


-- Select the first 10 rows from the table
SELECT *
FROM lesson_exercises.state_names_partitioned
LIMIT 10;
--  (Run time: 1.36 seconds, Data scanned: 3.23 MB)


-- Count the # of rows in the state_names_partitioned table
SELECT COUNT(*)
FROM lesson_exercises.state_names_partitioned;
-- (Run time: 6.28 seconds, Data scanned: 120.6 MB)


-- Count the # of rows by year for females
SELECT 
	year,
	COUNT(*) AS year_count
FROM lesson_exercises.state_names_partitioned
WHERE gender = 'F'
GROUP BY year;
--  (Run time: 4.06 seconds, Data scanned: 67.6 MB)


-- Count the # of rows by year for females in California
SELECT 
	year,
	COUNT(*)
FROM lesson_exercises.state_names_partitioned
WHERE gender = 'F'
    AND state = 'CA'
GROUP BY year;
--  (Run time: 4.1 seconds, Data scanned: 4.36 MB)


-- ------------------------------------------------------------
-- Partitioned table in Parquet columnar storage format with Snappy compression
-- https://docs.aws.amazon.com/athena/latest/ug/compression-formats.html

-- Create state_names_partitioned_parquet_snappy table using CTAS (Create Table As Select)
CREATE TABLE lesson_exercises.state_names_partitioned_parquet_snappy
WITH (
  format = 'Parquet',
  parquet_compression = 'SNAPPY',
  partitioned_by = ARRAY['gender','state'],
  external_location = 's3://lesson-exercise-alexander-poirier/state-names-partitioned-parquet-snappy/'
 ) AS SELECT *
 FROM lesson_exercises.state_names_partitioned;
--  (Run time: 33.79 seconds, Data scanned: 120.61 MB)


-- Confirm the state-names-partitioned-parquet-snappy folder is in the S3 bucket via the AWS S3 console


-- Select the first 10 rows from the table
SELECT *
FROM lesson_exercises.state_names_partitioned_parquet_snappy
LIMIT 10;
--  (Run time: 1.18 seconds, Data scanned: 1.17 MB)


-- Count the # of rows in the state_names_partitioned_parquet_snappy table
SELECT COUNT(*)
FROM lesson_exercises.state_names_partitioned_parquet_snappy;
--  (Run time: 3.9 seconds, Data scanned: 0 KB)


-- Count the # of rows by year for females
SELECT 
	year,
	COUNT(*) AS year_count
FROM lesson_exercises.state_names_partitioned_parquet_snappy
WHERE gender = 'F'
GROUP BY year;
--  (Run time: 2.24 seconds, Data scanned: 48.09 KB)


-- Count the # of rows by year for females in California
SELECT 
	year,
	COUNT(*)
FROM lesson_exercises.state_names_partitioned_parquet_snappy
WHERE gender = 'F'
    AND state = 'CA'
GROUP BY year;
--  (Run time: 1.18 seconds, Data scanned: 1.15 KB)


-- Compare to indexes queries
-- One column in WHERE
SELECT COUNT(*)
FROM lesson_exercises.state_names_partitioned_parquet_snappy
WHERE name = 'Jane';

-- (Run time: 3.63 seconds, Data scanned: 17.71 MB)
-- 1: 263ms
-- 2: 289ms
-- 3: 255ms


-- Two columns in WHERE
SELECT COUNT(*)
FROM lesson_exercises.state_names_partitioned_parquet_snappy
WHERE name = 'Angel'
	AND YEAR =1979;
-- (Run time: 3.39 seconds, Data scanned: 11.14 MB)
-- 1: 276ms
-- 2: 248ms
-- 3: 266ms


-- Three columns in WHERE
SELECT COUNT(*)
FROM lesson_exercises.state_names_partitioned_parquet_snappy
WHERE name = 'Angel'
	AND YEAR =1979
	AND gender = 'F';
-- (Run time: 2.06 seconds, Data scanned: 6.94 MB)

