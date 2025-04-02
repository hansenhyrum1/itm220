-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to understand the possibilities of using aggregate functions. 

-- week 11 questions
USE airportdb;

-- ---------------------------------------------------------------------------
-- 1. What are the earliest and latest flights that depart from the U.K.?
--    How many months of data do we have for those flights?
--    The columns should look like the following:
--    | Earliest Departure | Latest Departure | Number of Months | From | To |
-- ---------------------------------------------------------------------------

	SELECT MIN(f.departure) AS "Earliest Departure",
		MAX(f.departure) AS "Latest Departure",
		ROUND(DATEDIFF(MAX(f.departure), MIN(f.departure)) / 30) AS "Number of Months",
		CONCAT(fa.city, " ", fa.country) AS "From",
		CONCAT(ta.city, " ", ta.country) AS "To"
	FROM flight f
		JOIN airport_geo fa ON f.from = fa.airport_id
		JOIN airport_geo ta ON f.to = ta.airport_id
	WHERE fa.country = "UNITED KINGDOM" AND ta.country = "United Kingdom"
	GROUP BY fa.city, ta.city
    ORDER BY MIN(f.departure);

-- ---------------------------------------------------------------------------------
-- 2. What is the total number of passengers that are on a flight
--    within the U.K.?
--    The columns should look like the following:
--    | Total Number of Passengers | From | To | Departure Date | Flight Number |
-- --------------------------------------------------------------------------------

SELECT COUNT(b.passenger_id) AS "Total Number of Passengers",
	CONCAT(fa.city, " ", fa.country) AS "From",
    CONCAT(ta.city, " ", ta.country) AS "To",
    f.departure AS "Departure Date",
    f.flightno AS "Flight Number"
FROM flight f
	JOIN booking b ON b.flight_id = f.flight_id
    JOIN airport_geo fa ON f.from = fa.airport_id
    JOIN airport_geo ta ON f.to = ta.airport_id
WHERE fa.country = "UNITED KINGDOM" AND ta.country = "UNITED KINGDOM"
GROUP BY f.flightno, fa.country, ta.country, fa.city, ta.city, f.departure
ORDER BY ta.city, f.departure;

-- ---------------------------------------------------------------------------------
-- 3. What is the total revenue generated from flights within the U.K.?
--    Format the revenue with a dollar sign, comma at the thousands place and
--    rounded to 2 decimal places.
--    The columns should look like the following:
--    | Total Revenue | From | To | Flight Number |
-- ---------------------------------------------------------------------------------

SELECT CONCAT("$", FORMAT(SUM(b.price), 2))AS "Total Revenue",
	CONCAT(fa.city, " ", fa.country) AS "From",
    CONCAT(ta.city, " ", ta.country) AS "To",
    f.flightno AS "Flight Number"
FROM flight f
	JOIN booking b ON b.flight_id = f.flight_id
    JOIN airport_geo fa ON f.from = fa.airport_id
    JOIN airport_geo ta ON f.to = ta.airport_id
WHERE fa.country = "UNITED KINGDOM" AND ta.country = "UNITED KINGDOM"
GROUP BY f.flightno, fa.city, ta.city
ORDER BY SUM(b.price) DESC;

-- ---------------------------------------------------------------------------------
-- 4. What is the average revenue above $250 generated from flights within the U.K.?
--    Format the revenue with a dollar sign, comma at the thousands place and
--    rounded to 2 decimal places.
--    The columns should look like the following:
--    | Average Revenue | From | To | Flight Number |
-- ---------------------------------------------------------------------------------

	SELECT CONCAT("$", FORMAT(AVG(b.price), 2))AS "Average Revenue",
		CONCAT(fa.city, " ", fa.country) AS "From",
		CONCAT(ta.city, " ", ta.country) AS "To",
		f.flightno AS "Flight Number"
	FROM flight f
		JOIN booking b ON b.flight_id = f.flight_id
		JOIN airport_geo fa ON f.from = fa.airport_id
		JOIN airport_geo ta ON f.to = ta.airport_id
	WHERE fa.country = "UNITED KINGDOM" AND ta.country = "UNITED KINGDOM"
	GROUP BY f.flightno, fa.city, ta.city
	HAVING AVG(b.price) > 250;

-- ---------------------------------------------------------------------------------------------------------
-- 5. List the number of passengers each flight serviced within the U.S.
--    Sort by total number of passengers from greatest to least
--    The activity column consists of a case statement with the
--    following conditions:
--    - If 10,000 or more, state "High Activity"
--    - If between 5,000 and 10,000, state "Moderate Activity"
--    - If between 1,000 and 5,000, state "Low Activity"
--    - If less than 1,000, state "Very Low Activity"
--    Add the total revenue generated from each flight and average cost per passenger
--    formatted with the following:
--    - Dollar sign
--    - Comma at the thousands place
--    - Rounded to 2 decimal places
--    The columns should look like the following:
--    | Flight Number | From | To | Activity | Number of Passengers | Total Revenue | Average Revenue |
-- ---------------------------------------------------------------------------------------------------------

SELECT f.flightno AS "Flight Number",
	CONCAT(fa.city, ", ", fa.country) AS "From",
	CONCAT(ta.city, ", ", ta.country) AS "To",
	CASE
		WHEN COUNT(b.passenger_id) >= 10000 THEN "High Activity"
		WHEN COUNT(b.passenger_id) < 10000 AND COUNT(b.passenger_id) >= 5000 THEN "Moderate Activity"
		WHEN COUNT(b.passenger_id) < 5000 AND COUNT(b.passenger_id) > 1000 THEN "Low Activity"
		WHEN COUNT(b.passenger_id) <= 1000 THEN "Very Low Activity"
	END AS "Activity",
	COUNT(b.passenger_id) AS "Number of Passengers",
	CONCAT("$", FORMAT(SUM(b.price), 2))AS "Total Revenue",
	CONCAT("$", FORMAT(AVG(b.price), 2))AS "Average Revenue"
FROM flight f
	JOIN booking b ON b.flight_id = f.flight_id
	JOIN airport_geo fa ON f.from = fa.airport_id
	JOIN airport_geo ta ON f.to = ta.airport_id
WHERE fa.country = "UNITED STATES" AND ta.country = "UNITED STATES"
GROUP BY f.flightno, fa.city, ta.city, fa.country, ta.country
ORDER BY COUNT(b.passenger_id) DESC;