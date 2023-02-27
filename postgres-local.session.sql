SELECT COUNT( DISTINCT ride_id) FROM test;
SELECT COUNT (ride_id) AS total, ((CAST(COUNT(ride_id) AS NUMERIC)/5754248) * 100) AS percent_total,member_casual
FROM test
GROUP BY member_casual
ORDER BY total DESC; -- to know how many each of the riders and their percentege and sort the result by the highest total
SELECT  *
FROM test
LIMIT 1000;
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
-- to know how many nulls in each column
SELECT COUNT(*)
FROM test
WHERE start_station_name IS NULL; -- 843525 ROWS
SELECT COUNT(*)
FROM test
WHERE start_station_id IS NULL; -- 843525 ROWS
SELECT COUNT(*)
FROM test
WHERE end_station_name IS NULL; -- 902655 ROWS
SELECT COUNT(*)
FROM test
WHERE end_station_id IS NULL; -- 902655 ROWS
SELECT COUNT(*)
FROM test
WHERE start_station_name IS NULL OR start_station_id IS NULL OR end_station_name IS NULL OR end_station_id IS NULL; -- 1316732 ROWS
SELECT COUNT(*)
FROM test
WHERE end_lat IS NULL; -- 5899 ROWS
SELECT COUNT(*)
FROM test
WHERE end_lng IS NULL; -- 5899 ROWS -- there are no nulls within the start_lat or start_lng columns --
SELECT COUNT(*)
FROM test
WHERE member_casual IS NULL; -- 0 ROWS