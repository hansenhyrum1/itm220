-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to get familiar with functions. 

-- week 8 questions
USE airportdb;

-- -------------------------------------------------------------------------
-- 1. Put the first and last names of the passengers together.
--    Only show passengers with a single letter as their last name.
--    Your columns will look like the following:
--    | Passenger Name |
-- -------------------------------------------------------------------------

SELECT CONCAT(p.firstname, " ", p.lastname) AS "Passenger Name"
FROM passenger p
WHERE p.lastname LIKE "_"
ORDER BY p.lastname;


-- -------------------------------------------------------------------------
-- 2. Locate all passenger names with the letter X in their last name that
--    end in XX. Can use LIKE or REGEXP.
--    Your columns will look like the following:
--    | Passenger Name |
-- -------------------------------------------------------------------------

SELECT CONCAT(p.firstname, " ", p.lastname) AS "Passenger Name"
FROM passenger p
WHERE p.lastname LIKE "%XX";

-- -------------------------------------------------------------------------
-- 3. Find the airplane type that contains '747' in the identifier.
--    Print the first 15 characters of the description.
--    Hint: (Use the substring and locate functions)
--    Your columns will look like the following:
--    | Airplane Identifier | Airplane Description |
-- -------------------------------------------------------------------------

SELECT t.identifier AS "Airplane Identifier"
	, SUBSTRING(t.description, 1, 15) AS "Airplane Description"
FROM airplane_type t
WHERE LOCATE("747", t.identifier);

-- -------------------------------------------------------------------------------------------------
-- 4. List what each passenger paid for their seat on flight number: AF1837
--    on June 1st, 2015. Show the original price, round the price to the nearest dollar, and floor it.
--    Add a $ sign to all prices.
--    Sort prices from lowest to highest.
--    Format the dates to look like: Feb 28, 2015 3:00:00 PM
--    Columns will look like the following:
--    | Flight Number | Departure Date | Passenger Name | Price | Rounded Price | Floored Price |
-- -------------------------------------------------------------------------------------------------

SELECT f.flightno AS "Flight Number"
	, DATE_FORMAT(f.departure, "%b %d, %Y %h:%i:%S %p") AS "Departure Date"
    , CONCAT(p.firstname, " ", p.lastname) AS "Passenger Name"
    , CONCAT("$", b.price) AS "Price"
    , CONCAT("$", ROUND(b.price)) AS "Rounded Price"
    , CONCAT("$", FLOOR(b.price)) AS "Floored Price"
FROM flight f 
	JOIN booking b ON f.flight_id = b.flight_id
	JOIN passenger p ON b.passenger_id = p.passenger_id
WHERE f.flightno = "AF1837"
	AND DATE(f.departure) = "2015-06-01"
ORDER BY b.price;

-- -------------------------------------------------------------------------------------------------
-- 5. Find all flights that have a duration of 20 hours or more. 
--    Show hours, how many days and how many years since the flight (Use FLOOR).
--    Sort them by longest flight first.
--    Format the dates to look like: Feb 28, 2015 3:00:00 PM
--    Limit to 10 results.
--    Columns will look like the following:
--    | Departure Date | Arrival Date | Duration in Hours | Duration in Days | Years Since Flight |
-- -------------------------------------------------------------------------------------------------

SELECT DATE_FORMAT(f.departure, "%b %d, %Y %h:%i:%S %p") AS "Departure Date"
	, DATE_FORMAT(f.arrival, "%b %d, %Y %h:%i:%S %p") AS "Arrival Date"
    , TIMESTAMPDIFF(HOUR, f.departure, f.arrival) AS "Duration in Hours"
    , FLOOR(DATEDIFF(f.arrival, f.departure)) AS "Duration in Days"
    , FLOOR(TIMESTAMPDIFF(YEAR, f.departure, NOW())) AS "Years Since Flight"
FROM flight f
WHERE TIMESTAMPDIFF(HOUR, f.departure, f.arrival) > 20
ORDER BY TIMESTAMPDIFF(HOUR, f.departure, f.arrival) DESC 
LIMIT 10;

-------------------------------------------------------------------------
-- 6. Assign a row number to each passenger for flight number: AL9073.
--    The flight_id is 93.
--    Your columns will look like the following:
--    | Flight Number | Passenger Name | Row Number |
-- -------------------------------------------------------------------------


-- SET @row_number := 0;

SELECT f.flightno AS "Flight Number"
	, CONCAT(p.firstname, " ", p.lastname) AS "Passenger Name"
    , ROW_NUMBER() OVER (ORDER BY lastname) AS "Row Number"
FROM flight f
	JOIN booking b ON f.flight_id = b.flight_id
    JOIN passenger p ON b.passenger_id = p.passenger_id
WHERE f.flight_id = 93 AND f.flightno = "AL9073";


