-- Background:
-- You have been hired by BYU-I Air to help sort through the airportdb database. 
-- Each week you will receive a file from your manager with questions that 
-- need answered by writing queries against the database. 
-- This week your manager wants you to get familiar with the database. 

-- Week 7 questions
USE airportdb;

-- --------------------------------------------------------------------------
-- 1. What are the unique last names of our employees?
--    List them in alphabetical order.
--    Columns will look like the following:
--    | Last Name |
-- --------------------------------------------------------------------------

SELECT DISTINCT e.lastname
FROM employee e
ORDER BY e.lastname;

-- --------------------------------------------------------------------------
-- 2. What are the airlines and which airports are they based in?
--    List the airlines in alphabetical order.
--    Columns will look like the following:
--    | Airline | Airport |
-- --------------------------------------------------------------------------

SELECT al.airlinename, ap.name
FROM airline al JOIN airport ap ON al.base_airport = ap.airport_id
ORDER BY al.airlinename;

-- --------------------------------------------------------------------------
-- 3. What are the first 20 airports that are based in the United States?
--    Display the airport name and country.
--    Columns will look like the following:
--    | Airport | Country |
-- --------------------------------------------------------------------------

SELECT ap.name, apg.country
FROM airport ap JOIN airport_geo apg ON ap.airport_id = apg.airport_id
WHERE apg.country LIKE "UNITED STATES"
LIMIT 20;

-- --------------------------------------------------------------------------
-- 4. What are the top 10 airports without an IATA code?
--    Display the airport name, IATA code, and ICAO code.
--    Columns will look like the following:
--    | Airport | IATA | ICAO |
-- --------------------------------------------------------------------------

SELECT ap.name, ap.iata, ap.icao
FROM airport ap
WHERE ap.iata IS NULL
LIMIT 10;

-- --------------------------------------------------------------------------
-- 5. What are the flights that depart between 10:00 and 10:15 on Monday?
--    Sort the results by departure time.
--    List the following columns:
--    | Flight Number | Departure Time | Arrival Time | Airline | Monday |
-- --------------------------------------------------------------------------

SELECT fs.flightno, fs.departure, fs.arrival, al.airlinename, fs.monday
FROM flightschedule fs JOIN airline al ON fs.airline_id = al.airline_id
WHERE TIME(fs.departure) >= '10:00:00' AND TIME(fs.departure) <= '10:15:00' AND fs.monday = 1
ORDER BY fs.departure;

-- --------------------------------------------------------------------------
-- 6. What are the flights that arrive between 20:00 and 20:15 and are not
--    flown on Monday?
--    Sort the results by departure time.
--    List the following columns:
--    | Flight Number | Departure Time | Arrival Time | Airline | Monday |
-- --------------------------------------------------------------------------

SELECT fs.flightno, fs.departure, fs.arrival, al.airlinename, fs.monday
FROM flightschedule fs JOIN airline al ON fs.airline_id = al.airline_id
WHERE TIME(fs.arrival) >= '20:00:00' AND TIME(fs.arrival) <= '20:15:00' AND fs.monday = 0
ORDER BY fs.departure;

-- ------------------------------------------------------------------------------------------
-- 7. Marilyn is trying to schedule a flight that departs sometime between
--    3PM and 4PM and arrives between 6PM and 7PM on Wednesday or Thursday.
--    She also wants to avoid flights that are operated by Cyprus Airlines. 
--    Can you help her?
--    Sort the results by departure time.
--    List the following columns:
--    | Flight Number | Departure Time | Arrival Time | Airline | Wednesday | Thursday |
-- ------------------------------------------------------------------------------------------alter

SELECT fs.flightno, fs.departure, fs.arrival, al.airlinename, fs.wednesday, fs.thursday
FROM flightschedule fs JOIN airline al ON fs.airline_id = al.airline_id
WHERE (TIME(fs.departure) >= '15:00:00' AND TIME(fs.departure) <= '16:00:00') 
	AND (TIME(fs.arrival) >= '18:00:00' AND TIME(fs.arrival) <= '19:00:00' AND (fs.wednesday = 1 OR fs.thursday = 1))
    AND al.airlinename <> 'Cyprus Airlines'
ORDER BY fs.departure;