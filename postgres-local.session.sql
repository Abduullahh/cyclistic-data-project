SELECT COUNT(*) FROM test;
SELECT COUNT (DISTINCT ride_id) AS total, member_casual FROM test
GROUP BY member_casual
ORDER BY total DESC; -- to know how many each of the riders and sort the result by the highest total
SELECT * FROM test LIMIT 10;