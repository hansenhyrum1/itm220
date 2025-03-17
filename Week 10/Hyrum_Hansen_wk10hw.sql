-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to understand left joins. 

-- week 10 questions
USE airportdb;

-- ---------------------------------------------------------------------------
-- 1. Who are our frequent fliers that reside in the U.K. and have flown
--    somewhere in the world from the U.K.?
--    We want to see all passengers regardless of whether they have flown.
--    Show their status as 'Platinum', 'Gold', 'Silver', or 'No Status' 
--    based on the number of flights they have taken.
--    The conditions are as follows
--    - Platinum: 30 or more flights
--    - Gold: 20 or more flights
--    - Silver: 10 or more flights
--    - No Status: Less than 10 flights
--    List the number of flights they have taken.
--    Group by departure month.
--    Hint: You will have three AND compound WHERE clause conditions separated
--    by two OR operators.
--    The columns should look like the following:
--    | Status | Number of Flights | First Name | Last Name |
-- ---------------------------------------------------------------------------

SELECT 
	CASE
		WHEN COUNT(b.passenger_id) >= 30 THEN "Platinum"
        WHEN COUNT(b.passenger_id) >= 20 THEN "Gold"
        WHEN COUNT(b.passenger_id) >= 10 THEN "Silver"
        ELSE "No Status" 
	END AS "Status",
	SUM(CASE WHEN b.passenger_id IS NULL THEN 0 ELSE 1 END) AS "Number of Flights",
    p.firstname AS "First Name",
    p.lastname AS "Last Name"
FROM passenger p
	LEFT JOIN booking b ON b.passenger_id = p.passenger_id
    LEFT JOIN flight f ON b.flight_id = f.flight_id
    LEFT JOIN passengerdetails pd ON p.passenger_id = pd.passenger_id
    LEFT JOIN airport a ON f.from = a.airport_id
    LEFT JOIN airport_geo ag ON a.airport_id = ag.airport_id
WHERE 
	(pd.country = "United Kingdom" AND ag.country = "UNITED KINGDOM")
	OR (pd.country = "United Kingdom" AND b.passenger_id IS NULL)
    OR (pd.country IS NULL AND b.passenger_id IS NULL)
GROUP BY p.firstname, p.lastname, MONTH(f.departure)
ORDER BY COUNT(b.passenger_id) DESC;

-- --------------------------------------------------------------
-- 2. Who in the 'no status' section from the previous query
--    have never flown?
--    Columns will look like the following:
--    | Status | Number of Flights | First Name | Last Name |
-- --------------------------------------------------------------

SELECT 
	CASE
		WHEN COUNT(b.passenger_id) >= 30 THEN "Platinum"
        WHEN COUNT(b.passenger_id) >= 20 THEN "Gold"
        WHEN COUNT(b.passenger_id) >= 10 THEN "Silver"
        ELSE "No Status" 
	END AS "Status",
	SUM(CASE WHEN b.passenger_id IS NULL THEN 0 ELSE 1 END) AS "Number of Flights",
    p.firstname AS "First Name",
    p.lastname AS "Last Name"
FROM passenger p
	LEFT JOIN booking b ON b.passenger_id = p.passenger_id
    LEFT JOIN flight f ON b.flight_id = f.flight_id
    LEFT JOIN passengerdetails pd ON p.passenger_id = pd.passenger_id
    LEFT JOIN airport a ON f.from = a.airport_id
    LEFT JOIN airport_geo ag ON a.airport_id = ag.airport_id
WHERE 
	(pd.country = "United Kingdom" AND ag.country = "UNITED KINGDOM")
	OR (pd.country = "United Kingdom" AND b.passenger_id IS NULL)
    OR (pd.country IS NULL AND b.passenger_id IS NULL)
GROUP BY p.firstname, p.lastname, MONTH(f.departure)
HAVING SUM(CASE WHEN b.passenger_id IS NULL THEN 0 END) = 0
ORDER BY COUNT(b.passenger_id) DESC;


-- --------------------------------------------------------------------------------
-- 3. Who has never flown and doesn't have any records in our
--    passenger details table?
--    | Status | Number of Flights | First Name | Last Name | Passenger Country |
-- --------------------------------------------------------------------------------

SELECT 
	CASE
		WHEN COUNT(b.passenger_id) >= 30 THEN "Platinum"
        WHEN COUNT(b.passenger_id) >= 20 THEN "Gold"
        WHEN COUNT(b.passenger_id) >= 10 THEN "Silver"
        ELSE "No Status" 
	END AS "Status",
	SUM(CASE WHEN b.passenger_id IS NULL THEN 0 ELSE 1 END) AS "Number of Flights",
    p.firstname AS "First Name",
    p.lastname AS "Last Name"
FROM passenger p
	LEFT JOIN booking b ON b.passenger_id = p.passenger_id
    LEFT JOIN flight f ON b.flight_id = f.flight_id
    LEFT JOIN passengerdetails pd ON p.passenger_id = pd.passenger_id
    LEFT JOIN airport a ON f.from = a.airport_id
    LEFT JOIN airport_geo ag ON a.airport_id = ag.airport_id
WHERE (pd.country IS NULL AND b.passenger_id IS NULL)
GROUP BY p.firstname, p.lastname, MONTH(f.departure)
HAVING SUM(CASE WHEN b.passenger_id IS NULL THEN 0 END) = 0
ORDER BY COUNT(b.passenger_id) DESC;