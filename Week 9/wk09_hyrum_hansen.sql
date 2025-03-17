-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to understand case statements. 

-- week 9 questions
USE airportdb;

-- ---------------------------------------------------------------------------
-- 1. What are the flight details for flight AL9073 (flight id #93)?
--    Format the dates to look like: Jun 01, 2015 07:56 AM
--    The From and To columns should display the city and country together.
--    The columns should look like the following:
--    | Flight Number | From | To | Departure Date | Arrival Date |
-- ---------------------------------------------------------------------------

SELECT 
	f.flightno AS "Flight Number"
	, CONCAT(agf.city, ", ", agf.country) AS "From"
    , CONCAT(agt.city, ", ", agt.country) AS "To"
    , DATE_FORMAT(f.departure, "%b %d, %Y %h:%i %p") AS "Departure Date"
    , DATE_FORMAT(f.arrival, "%b %d, %Y %h:%i %p") AS "Arrival Date"
FROM flight f 
	JOIN airport_geo agf ON f.from = agf.airport_id
    JOIN airport_geo agt ON f.to = agt.airport_id 
WHERE f.flight_id = 93;

-- ---------------------------------------------------------------------------
-- 2. How many passengers are on flight AL9073 (flight id #93)?
--    Tell me whether or not the flight is full.
--    Code an example with seats available and when it is full
--    This should be done in one query.
--    A `group by` clause shouldn't be used.
--    The columns should look like the following:
--    | Flight Number | From | To | Plane Capacity | Original # of Passengers | Seats Remaining | Full Flight # of Passengers | Seats Remaining |
-- ---------------------------------------------------------------------------

SET @passenger := 0;

SELECT 
	f.flightno AS "Flight Number"
	, CONCAT(agf.city, ", ", agf.country) AS "From"
    , CONCAT(agt.city, ", ", agt.country) AS "To"
    , ap.capacity AS "Plane Capacity"
    , @passenger := SUM(CASE WHEN b.flight_id = 93 THEN 1 ELSE 0 END) AS "Original # of Passengers"
    , CASE 
		WHEN @passenger < ap.capacity THEN CONCAT(ap.capacity - @passenger, " seats left") 
        WHEN @passenger = ap.capacity THEN "Flight Full"
        ELSE "Error" END
        AS "Seats Remaining"
    , @passenger := ap.capacity AS "Full Flight # of Passengers"
    , CASE 
		WHEN @passenger < ap.capacity THEN CONCAT(ap.capacity - @passenger, " seats left") 
        WHEN @passenger = ap.capacity THEN "Flight Full"
        ELSE "Error" END
        AS "Seats Remaining"
FROM flight f
	JOIN airport_geo agf ON f.from = agf.airport_id
    JOIN airport_geo agt ON f.to = agt.airport_id
    JOIN airplane ap ON f.airplane_id = ap.airplane_id
    JOIN booking b ON b.flight_id = f.flight_id
WHERE f.flight_id = 93;

-- -------------------------------------------------------------------------------------
-- 3. How many flights are on each day that are contained within the U.S.?
--    These flights depart from a city in the U.S. and arrives at a U.S. city
--    Also display the total amount of flights at the end
--    The columns should look like the following:
--    | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday | Total |
-- -------------------------------------------------------------------------------------

SELECT
	@monday := SUM(CASE WHEN fs.monday = 1 THEN 1 ELSE 0 END) AS "Monday"
    , @tuesday := SUM(CASE WHEN fs.tuesday = 1 THEN 1 ELSE 0 END) AS "Tuesday"
    , @wednesday := SUM(CASE WHEN fs.wednesday = 1 THEN 1 ELSE 0 END) AS "Wednesday"
    , @thursday := SUM(CASE WHEN fs.thursday = 1 THEN 1 ELSE 0 END) AS "Thursday"
    , @friday := SUM(CASE WHEN fs.friday = 1 THEN 1 ELSE 0 END) AS "Friday"
    , @saturday := SUM(CASE WHEN fs.saturday = 1 THEN 1 ELSE 0 END) AS "Saturday"
    , @sunday := SUM(CASE WHEN fs.sunday = 1 THEN 1 ELSE 0 END) AS "Sunday"
    , @monday + @tuesday + @wednesday + @thursday + @friday + @saturday + @sunday AS "Total"
FROM flightschedule fs
    JOIN airport_geo agf ON fs.from = agf.airport_id
    JOIN airport_geo agt ON fs.to = agt.airport_id
WHERE agf.country = "UNITED STATES" AND agt.country = "UNITED STATES";

-- ---------------------------------------------------------------------------
--    YOU MAY NEED TO RUN THIS QUERY FROM THE TERMINAL TO VERIFY THAT IT WORKS
-- 4. List the number of passengers each flight serviced within the U.S.
--    Sort by total number of passengers from greatest to least
--    The activity column consists of a case statement with the
--    following conditions:
--    - If 10,000 or more, state "High Activity"
--    - If between 5,000 and 10,000, state "Moderate Activity"
--    - If between 1,000 and 5,000, state "Low Activity"
--    - If less than 1,000, state "Very Low Activity"
--    The columns should look like the following:
--    | Flight Number | From | To | Activity | Number of Passengers |
-- ---------------------------------------------------------------------------

SELECT
	f.flightno AS "Flight Number"
	, CONCAT(agf.city, ", ", agf.country) AS "From"
    , CONCAT(agt.city, ", ", agt.country) AS "To"
    , CASE
		WHEN COUNT(b.passenger_id) >= 10000 THEN "High Activity"
        WHEN COUNT(b.passenger_id) BETWEEN 5000 AND 10000 THEN "Moderate Activity"
        WHEN COUNT(b.passenger_id) BETWEEN 1000 AND 5000 THEN "Low Activity"
        WHEN COUNT(b.passenger_id) < 1000 THEN "Very Low Activity"
        ELSE "Error"
        END AS "Activity"
    , COUNT(b.passenger_id) AS "Number of Passengers"
FROM flight f
    JOIN airport_geo agf ON f.from = agf.airport_id
    JOIN airport_geo agt ON f.to = agt.airport_id
    JOIN booking b ON f.flight_id = b.flight_id
WHERE agf.country = "UNITED STATES" AND agt.country = "UNITED STATES"
GROUP BY f.flightno, agf.city, agf.country, agt.city, agt.country
ORDER BY COUNT(b.passenger_id) DESC;