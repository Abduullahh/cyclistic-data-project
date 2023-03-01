SELECT COUNT( DISTINCT ride_id) FROM test;
SELECT COUNT (ride_id) AS total, ((CAST(COUNT(ride_id) AS NUMERIC)/5754248) * 100) AS percent_total,member_casual
FROM test
GROUP BY member_casual
ORDER BY total DESC; -- to know how many each of the riders and their percentege and sort the result by the highest total

SELECT ride_id, started_at, ended_at, member_casual,start_station_name,
COALESCE(end_station_name, end_station_id), (ended_at - started_at) AS ride_length
FROM test
WHERE member_casual = 'casual'
ORDER BY ride_length DESC
LIMIT 1000;
---------------------------------------------------------------------------------------------------------------------------
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

