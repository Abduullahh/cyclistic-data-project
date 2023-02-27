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
FROM test; -- 5754248
SELECT COUNT(DISTINCT ride_id)
from test; -- 5754248
-- to make sure that there's no extra spaces or wrong data entered in this column.
SELECT rideable_type
FROM test
GROUP BY rideable_type
LIMIT 100; 
--
SELECT DATE_PART('year', started_at), DATE_PART('year', ended_at)
FROM test
GROUP BY started_at, ended_at
LIMIT 100;