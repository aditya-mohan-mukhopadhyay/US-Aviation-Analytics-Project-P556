use aviation_analytics;
show tables;

CREATE TABLE flight2 (
    YEAR INT,
    MONTH INT,
    DAY INT,
    DAY_OF_WEEK int,
    AIRLINE VARCHAR(20),
    FLIGHT_NUMBER VARCHAR(20),
    TAIL_NUMBER VARCHAR(20),
    ORIGIN_AIRPORT VARCHAR(20),
    DESTINATION_AIRPORT VARCHAR(20),
    SCHEDULED_DEPARTURE VARCHAR(20),
    DEPARTURE_TIME VARCHAR(20),
    DEPARTURE_DELAY VARCHAR(20),
    TAXI_OUT VARCHAR(20),
    WHEELS_OFF VARCHAR(20),
    SCHEDULED_TIME VARCHAR(20),
    ELAPSED_TIME VARCHAR(20),
    AIR_TIME VARCHAR(20),
    DISTANCE VARCHAR(20),
    WHEELS_ON VARCHAR(20),
    TAXI_IN VARCHAR(20),
    SCHEDULED_ARRIVAL VARCHAR(20),
    ARRIVAL_TIME VARCHAR(20),
    ARRIVAL_DELAY VARCHAR(20),
    DIVERTED VARCHAR(20),
    CANCELLED VARCHAR(20),
    CANCELLATION_REASON VARCHAR(20),
    AIR_SYSTEM_DELAY VARCHAR(20),
    SECURITY_DELAY VARCHAR(20),
    AIRLINE_DELAY VARCHAR(20),
    LATE_AIRCRAFT_DELAY VARCHAR(20),
    WEATHER_DELAY VARCHAR(20)
); 

select * from flight2;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flightsa.csv' 
INTO TABLE flight2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@YEAR,	@MONTH,	@DAY,	@DAY_OF_WEEK,	@AIRLINE,	@FLIGHT_NUMBER,	@TAIL_NUMBER,	@ORIGIN_AIRPORT,	@DESTINATION_AIRPORT,	@SCHEDULED_DEPARTURE,	@DEPARTURE_TIME,	@DEPARTURE_DELAY,	@TAXI_OUT,	@WHEELS_OFF,	@SCHEDULED_TIME,	@ELAPSED_TIME,	@AIR_TIME,	@DISTANCE,	@WHEELS_ON,	@TAXI_IN,	@SCHEDULED_ARRIVAL,	@ARRIVAL_TIME,	@ARRIVAL_DELAY,	@DIVERTED,	@CANCELLED,	@CANCELLATION_REASON,	@AIR_SYSTEM_DELAY,	@SECURITY_DELAY,	@AIRLINE_DELAY,	@LATE_AIRCRAFT_DELAY,	@WEATHER_DELAY)
SET  YEAR = IF(@YEAR = '', NULL, @YEAR),	MONTH = IF(@MONTH = '', NULL, @MONTH),	DAY = IF(@DAY = '', NULL, @DAY),	DAY_OF_WEEK = IF(@DAY_OF_WEEK = '', NULL, @DAY_OF_WEEK),	AIRLINE = IF(@AIRLINE = '', NULL, @AIRLINE),	FLIGHT_NUMBER = IF(@FLIGHT_NUMBER = '', NULL, @FLIGHT_NUMBER),	TAIL_NUMBER = IF(@TAIL_NUMBER = '', NULL, @TAIL_NUMBER),	ORIGIN_AIRPORT = IF(@ORIGIN_AIRPORT = '', NULL, @ORIGIN_AIRPORT),	DESTINATION_AIRPORT = IF(@DESTINATION_AIRPORT = '', NULL, @DESTINATION_AIRPORT),	SCHEDULED_DEPARTURE = IF(@SCHEDULED_DEPARTURE = '', NULL, @SCHEDULED_DEPARTURE),	DEPARTURE_TIME = IF(@DEPARTURE_TIME = '', NULL, @DEPARTURE_TIME),	DEPARTURE_DELAY = IF(@DEPARTURE_DELAY = '', NULL, @DEPARTURE_DELAY),	TAXI_OUT = IF(@TAXI_OUT = '', NULL, @TAXI_OUT),	WHEELS_OFF = IF(@WHEELS_OFF = '', NULL, @WHEELS_OFF),	SCHEDULED_TIME = IF(@SCHEDULED_TIME = '', NULL, @SCHEDULED_TIME),	ELAPSED_TIME = IF(@ELAPSED_TIME = '', NULL, @ELAPSED_TIME),	AIR_TIME = IF(@AIR_TIME = '', NULL, @AIR_TIME),	DISTANCE = IF(@DISTANCE = '', NULL, @DISTANCE),	WHEELS_ON = IF(@WHEELS_ON = '', NULL, @WHEELS_ON),	TAXI_IN = IF(@TAXI_IN = '', NULL, @TAXI_IN),	SCHEDULED_ARRIVAL = IF(@SCHEDULED_ARRIVAL = '', NULL, @SCHEDULED_ARRIVAL),	ARRIVAL_TIME = IF(@ARRIVAL_TIME = '', NULL, @ARRIVAL_TIME),	ARRIVAL_DELAY = IF(@ARRIVAL_DELAY = '', NULL, @ARRIVAL_DELAY),	DIVERTED = IF(@DIVERTED = '', NULL, @DIVERTED),	CANCELLED = IF(@CANCELLED = '', NULL, @CANCELLED),	CANCELLATION_REASON = IF(@CANCELLATION_REASON = '', NULL, @CANCELLATION_REASON),	AIR_SYSTEM_DELAY = IF(@AIR_SYSTEM_DELAY = '', NULL, @AIR_SYSTEM_DELAY),	SECURITY_DELAY = IF(@SECURITY_DELAY = '', NULL, @SECURITY_DELAY),	AIRLINE_DELAY = IF(@AIRLINE_DELAY = '', NULL, @AIRLINE_DELAY),	LATE_AIRCRAFT_DELAY = IF(@LATE_AIRCRAFT_DELAY = '', NULL, @LATE_AIRCRAFT_DELAY),	WEATHER_DELAY = IF(@WEATHER_DELAY = '', NULL, @WEATHER_DELAY);

select * from flight2;
select count(*) from flight2;

-- 1) Weekday Vs Weekend total flights statistics

SELECT CASE WHEN DAY_OF_WEEK < 6 THEN "Weekday"  ELSE "Weekend" END AS DayType,
    COUNT(*) AS Total_Flights
FROM
    flight2
GROUP BY
    DayType;
    
    -- 2)  Total number of cancelled flights for JetBlue Airways on first date of every month
    
    SELECT
    YEAR,
    MONTH,
    COUNT(*) AS Cancelled_Flights
FROM
    flight2
WHERE
    AIRLINE = 'B6'
    AND DAY = 1
    AND CANCELLED = '1'
GROUP BY
YEAR,MONTH;

-- 4) Number of airlines with No departure/arrival delay with distance covered between 2500 and 3000

SELECT DISTINCT airline AS Airlines_Name, COUNT(DEPARTURE_DELAY) as Departure_Delay,COUNT(ARRIVAL_DELAY) as Arrival_Delay
FROM flight2
WHERE DEPARTURE_DELAY > 15
  AND ARRIVAL_DELAY > 15
  AND distance BETWEEN 2500 AND 3000
  GROUP BY airline;
  
  -- 3) Week wise, State wise and City wise statistics of delay of flights with airline details
  
select  a.airline,ar.city,round(count(f.ARRIVAL_DELAY),3) as  'Count_of_Arrival_Delay',round(count(f.DEPARTURE_DELAY),3) as 'Count_of_Departure_Delay'
from flight2 f
left join airlines a on a.IATA_CODE=f.AIRLINE
left join airports ar on ar.IATA_CODE=f.ORIGIN_AIRPORT
where ARRIVAL_DELAY > 15 and DEPARTURE_DELAY> 15
group by a.AIRLINE,ar.CITY;

select  a.airline,ar.state,round(count(f.ARRIVAL_DELAY),3) as  'Count_of_Arrival_Delay',round(count(f.DEPARTURE_DELAY),3) as 'Count_of_Departure_Delay'
from flight2 f
left join airlines a on a.IATA_CODE=f.AIRLINE
left join airports ar on ar.IATA_CODE=f.ORIGIN_AIRPORT
where ARRIVAL_DELAY > 15 and DEPARTURE_DELAY> 15
group by a.AIRLINE,ar.STATE;


select a.airline,ar.CITY,ar.STATE, week(concat(year ,  '-' ,month ,  '-' ,day)) as 'weeknum',round(count(f.ARRIVAL_DELAY),3) as  'Count_of_Arrival_Delay', round(count(f.DEPARTURE_DELAY),3) as 'Count_of_Departure_Delay'
from flight2 f
left join airlines a on a.IATA_CODE=f.AIRLINE
left join airports ar on ar.IATA_CODE=f.ORIGIN_AIRPORT
where 'weeknum' between 1 and 54
and ARRIVAL_DELAY>15 and DEPARTURE_DELAY>15
group by a.airline,ar.CITY, ar.STATE, weeknum;

select * from flight2;
select flight2.AIRLINE,weekofyear(convert(convert(CONCAT_WS('-', flight2.year, flight2.month,flight2.day),DATE),char(20))) 
as weeknum , 
round(count(flight2.ARRIVAL_DELAY),3) as  'Count_of_Arrival_Delay'
from flight2
left join airlines on airlines.IATA_CODE=flight2.AIRLINE
where 'weeknum' between  1 and 54
and flight2.ARRIVAL_DELAY>15
group by flight2.AIRLINE,weeknum;