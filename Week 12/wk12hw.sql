-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to understand what views and CTE expressions are. 

-- week 12 questions
USE airportdb;

-- ---------------------------------------------------------------------------------
-- 1. Create a view from week 10 question 1 named passengerrewards_view. 
--    Make a table based on that view named `passengerrewards`. 
--    Provide a select statement that queries the table.
--    DO NOT use a select * statement.
--    The columns should look like the following:
--    | Status | Number of Flights | First Name | Last Name | Departure Month |
-- ---------------------------------------------------------------------------------

CREATE OR REPLACE VIEW passengerrewards_view AS
	SELECT 
		CASE
			WHEN COUNT(b.passenger_id) >= 30 THEN "Platinum"
			WHEN COUNT(b.passenger_id) >= 20 THEN "Gold"
			WHEN COUNT(b.passenger_id) >= 10 THEN "Silver"
			ELSE "No Status" 
		END AS "Status",
		SUM(CASE WHEN b.passenger_id IS NULL THEN 0 ELSE 1 END) AS "Number_of_Flights",
		p.firstname AS "First_Name",
		p.lastname AS "Last_Name",
        MONTH(f.departure) AS "Departure_Month"
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

WITH passengerrewards AS (
    SELECT 
        prv.Status,
        prv.Number_of_Flights,
        prv.First_Name,
        prv.Last_Name,
        prv.Departure_Month
    FROM passengerrewards_view prv
)

SELECT pr.Status,
    pr.Number_of_Flights,
    pr.First_Name,
    pr.Last_Name
FROM passengerrewards pr; 


-- --------------------------------------------------------------------------------------------------------
-- 2. What are the top 10 airports that handled the highest number of outbound flights in August? (Canvas has July)
--    Write a CTE statement called `flight_counts` to find the answer.
--    Columns will look like the following:
--    | Airport | Flight Count |
-- --------------------------------------------------------------------------------------------------------

WITH flight_counts AS (
	SELECT ag.name AS "Airport",
		COUNT(f.from) AS "Flight_Count"
    FROM flight f
		JOIN airport_geo ag ON f.from = ag.airport_id
	WHERE MONTH(f.departure) = 8
    GROUP BY ag.name
)

SELECT fc.Airport,
	fc.Flight_Count
FROM flight_counts fc
ORDER BY fc.Flight_Count DESC
LIMIT 10;

-- --------------------------------------------------------------------------------------------------------
-- 3. What are the top 5 longest flights by duration for each airline?
--    Don't include any duplicates.
--    Sort the results by airline name and rank.
--    Write a CTE statement called `ranked_flights` to find the answer.
--    Columns will look like the following:
--    | Airline | Flight Number | Origin Airport | Destination Airport | Flight Duration (Minutes) |
-- --------------------------------------------------------------------------------------------------------

WITH ranked_flights AS (
	SELECT DISTINCT a.airlinename AS "airline"
		, f.flightno AS "flight_number"
		, af.name AS "origin"
		, at.name AS "destination"
		, TIMESTAMPDIFF(MINUTE, f.departure, f.arrival) AS "duration"
        , DENSE_RANK() OVER (PARTITION BY a.airlinename ORDER BY (SELECT duration) DESC) AS "ranked"
    FROM airline a
		JOIN flight f ON f.airline_id = a.airline_id
        JOIN airport_geo af ON f.from = af.airport_id
        JOIN airport_geo at ON f.to = at.airport_id
)

SELECT rf.airline AS "Airline"
, rf.flight_number AS "Flight Number"
, rf.origin AS "Origin Airport"
, rf.destination AS "Destination Airport"
, rf.duration AS "Flight Duration (Minutes)"
FROM ranked_flights rf
WHERE ranked <= 5;
