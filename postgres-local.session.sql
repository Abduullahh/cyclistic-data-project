-------------------------------------------------------------------------------------------------------
--------------------------------------/* PROCESS STEP */-----------------------------------------------

-- to make sure that there's no duplicates in the ride_id column.
SELECT COUNT(ride_id)
FROM test; -- 5754248 ROWS
SELECT COUNT(DISTINCT ride_id)
from test; -- 5754248 ROWS

-- to make sure that there's no extra spaces or wrong data entered in this column.
SELECT rideable_type
FROM test
GROUP BY rideable_type
LIMIT 100; 

-- to make sure the start_at, ended_at columns are clean and correct.
SELECT DISTINCT DATE_PART('year', started_at) AS started_at_year, DATE_PART('month', started_at) AS started_at_months
FROM test
ORDER BY started_at_year, started_at_months;
SELECT DISTINCT DATE_PART('year', ended_at) AS ended_at_year, DATE_PART('month', ended_at) AS ended_at_months
FROM test
ORDER BY ended_at_year, ended_at_months;
SELECT * 
FROM test 
WHERE DATE_PART('year', ended_at) = 2023 AND DATE_PART('month', ended_at) = 2
ORDER BY ended_at;
SELECT *
FROM test
WHERE started_at IS NULL OR ended_at IS NULL; -- no nulls found

-- to make sure that member_casual column is consistent
SELECT DISTINCT member_casual
FROM test;

-- Remove duplicates ( HINT : we cant delete records from CTE in postgresql )
WITH cte AS(
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY rideable_type,
                 started_at,
                 ended_at,
                 start_station_name,
                 start_station_id,
                 end_station_name,
                 end_station_id,
                 start_lat,
                 start_lng,
                 end_lat,
                 end_lng
) row_num
FROM test)
SELECT *
FROM cte
WHERE row_num > 1;
-- I used this query to delete the duplicates because the normal way of deleting from a cte doesn't work in postgresql
DELETE FROM test
WHERE ride_id IN (
    SELECT ride_id
    FROM (
        SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY rideable_type,
                 started_at,
                 ended_at,
                 start_station_name,
                 start_station_id,
                 end_station_name,
                 end_station_id,
                 start_lat,
                 start_lng,
                 end_lat,
                 end_lng
) row_num
FROM test
    ) s
    WHERE row_num > 1
) -- DELETE successfully executed. 25 rows were affected.
SELECT COUNT(*)
FROM test; -- total number of rows now is 5754223

-- i found some errors with the started_at and ended_at columns like they were swapped or something
SELECT * 
FROM test 
WHERE ended_at < started_at
LIMIT 10000;
-- so i swapped them using the update statement
UPDATE test
SET started_at = ended_at, ended_at = started_at
WHERE ended_at < started_at;

-- to count the ride_length for each record
SELECT ride_id, started_at, ended_at, (ended_at - started_at) AS ride_length, member_casual
FROM test
ORDER BY ride_length DESC
LIMIT 10000;

/* this adds a new column has numbers from 0 to 6 (0 means sunday, 6 means saturday) 
but i want it to be textual not numbers so i used the below query instead */
SELECT *, EXTRACT(dow from started_at)
FROM test
LIMIT 100;
-- to know the day of each ride per record
SELECT *, to_char(started_at, 'Day')
FROM test
LIMIT 100000;
-- to count ride length in hours
SELECT started_at, ended_at, (EXTRACT(EPOCH FROM(ended_at - started_at))/3600) AS ride_length
FROM test
LIMIT 10;

-- here i'm adding the new column (weekday) to the table
ALTER TABLE test
ADD COLUMN weekday text;
UPDATE test
SET weekday = to_char(started_at, 'Day');
-- added the ride_length column and noting that the calculated field is in Hours
ALTER TABLE test
ADD COLUMN ride_length NUMERIC;
UPDATE test
SET ride_length = EXTRACT(EPOCH FROM(ended_at - started_at))/3600;

-- Remove extra spaces if exists
UPDATE test
SET ride_id = TRIM(ride_id),
start_station_name = TRIM(start_station_name),
start_station_id = TRIM(start_station_id),
end_station_name = TRIM(end_station_name),
end_station_id = TRIM(end_station_id),
member_casual = TRIM(member_casual);

-- I noticed here that this field is not numeric so i'm gonna convert it to float
SELECT *, (ended_at - started_at) FROM test ORDER BY ride_length DESC LIMIT 10000;
SELECT *, CAST(ride_length AS FLOAT) ride_length_2 FROM test LIMIT 100000;

UPDATE test
SET ride_length = CAST(ride_length AS FLOAT);

-- i just wanted to make sure that the datatype of each field is correct
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'public' AND
TABLE_NAME = 'test';
-------------------------------------------------------------------------------------------------------
--------------------------------------/* ANALYZE STEP */-----------------------------------------------

/* to know the number and percentage of each rider type and sort the result by the highest total,
refer to GDAC-Capstone-book1.csv and it's dashboard (GDAC-Capstone-book1 on tableau) */
SELECT COUNT( DISTINCT ride_id) FROM test; -- 5754248 rows
SELECT COUNT (ride_id) AS total,
((CAST(COUNT(ride_id) AS NUMERIC)/5754248) * 100) AS percent_total,member_casual
FROM test
GROUP BY member_casual
ORDER BY total DESC;

/* this returns a table displaying the type of bike and the number of them for each type of riders,
refer to GDAC-Capstone-book2.csv and its dashboard (GDAC-Capstone-book2 on tableau) */
SELECT member_casual, rideable_type, COUNT(rideable_type) AS rideable_type_count
FROM test
GROUP BY member_casual, rideable_type
ORDER BY 3 DESC;

/* this returns a result displaying the number of rides per weekday for each type of riders,
refer to GDAC-Capstone-book3-sheet1.csv and its dashboard (GDAC-Capstone-book3 sheet1 on tableau) */
SELECT weekday, member_casual, COUNT(weekday) AS weekday_count
FROM test
GROUP BY weekday, member_casual
ORDER BY member_casual DESC,weekday_count DESC;

-- found some extra spaces in the weekday column so i'm gonna update it.
UPDATE test
SET weekday = TRIM(weekday);

-- this shows the most times at which rides happen on Saturday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Saturday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Sunday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Sunday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Monday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Monday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Tuesday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Tuesday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Wednesday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Wednesday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Thursday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Thursday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
-- this shows the most times at which rides happen on Friday.
SELECT weekday, ride_hour,COUNT(ride_hour) AS ride_hour_count
FROM(
    SELECT started_at, weekday, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
WHERE weekday = 'Friday'
) s
GROUP BY s.weekday, ride_hour
ORDER BY ride_hour_count DESC;
/* this shows the most times at which rides happen on weekdays for each type of riders,
refer to GDAC-Capstone-book3-sheet2.csv and its dashboard (GDAC-Capstone-book3 sheet2 on tableau) */
SELECT ride_hour,COUNT(ride_hour) AS ride_hour_count, member_casual
FROM(
    SELECT started_at, weekday, member_casual,EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
) s
GROUP BY ride_hour, member_casual
ORDER BY member_casual, ride_hour_count DESC;
/* this shows the most times at which rides happen per weekday for each type of the riders,
refer to GDAC-Capstone-book3-sheet3.csv and its dashboard (GDAC-Capstone-book3 sheet3 on tableau) */
SELECT weekday, ride_hour, COUNT(ride_hour) AS ride_hour_count, member_casual
FROM(
    SELECT started_at, weekday, member_casual, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
) s
GROUP BY s.weekday, member_casual, ride_hour
ORDER BY s.weekday, ride_hour_count DESC;
/* Hourly rides during weekends for each type of riders,
refer to GDAC-Capstone-book4-sheet1.csv and its dashboard (GDAC-Capstone-book4 sheet1 on tableau) */
SELECT weekday, ride_hour, COUNT(ride_hour) AS ride_hour_count, member_casual
FROM(
    SELECT started_at, weekday, member_casual, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
) s
WHERE s.weekday IN ('Saturday', 'Sunday')
GROUP BY s.weekday, member_casual, ride_hour
ORDER BY s.weekday, ride_hour_count DESC;
/* Hourly rides during weekdays for each type of riders,
refer to GDAC-Capstone-book4-sheet2.csv and its dashboard (GDAC-Capstone-book4 sheet2 on tableau) */
SELECT weekday, ride_hour, COUNT(ride_hour) AS ride_hour_count, member_casual
FROM(
    SELECT started_at, weekday, member_casual, EXTRACT(HOUR FROM started_at) AS ride_hour
FROM test
) s
WHERE s.weekday NOT IN ('Saturday', 'Sunday')
GROUP BY s.weekday, member_casual, ride_hour
ORDER BY s.weekday, ride_hour_count DESC;

/* here i'm calculating the average, median, maximum and minimum ride length for each rider type,
refer to GDAC-Capstone-book5.csv and its dashboard (GDAC-Capstone-book5 on tableau) */
SELECT member_casual,
COUNT(*) AS total,
(AVG(ride_length)) AS mean,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ride_length) AS median,
MAX(ride_length) AS maximum,
MIN(ride_length) AS minimum
FROM test
GROUP BY member_casual;
/* while i'm calculating the max and min ride length for each rider type 
i found that there were records with 0 ride length, and i removed them (434 record exactly). */
SELECT *
FROM test
WHERE ride_length = 0
LIMIT 1000;
DELETE FROM test
WHERE ride_length = 0; 
-- to convert ride length from hours to minutes.
UPDATE test
SET ride_length = ride_length * 60;

/* monthly rides, refer to GDAC-Capstone-book6.csv and its dashboard (GDAC-Capstone-book6 on tableau) */
SELECT member_casual, date, COUNT(date) AS rides_per_month
FROM(
    SELECT started_at, weekday, member_casual, TO_CHAR(started_at, 'YYYY-MM') AS date
FROM test
) d
GROUP BY d.date ,member_casual
ORDER BY member_casual, date,rides_per_month DESC;