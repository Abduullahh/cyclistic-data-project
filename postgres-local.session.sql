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