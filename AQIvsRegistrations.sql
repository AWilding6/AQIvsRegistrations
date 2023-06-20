--Taking a look at the data to see if we can make a good comparison between the two tables. Year and County look great to join with
SELECT *
FROM AQIvsRegistrations.dbo.Registrations

SELECT *
FROM AQIvsRegistrations.dbo.AQI

--Registration data is complete for all counties in Utah over the course of 25 years
SELECT County,COUNT(County)
FROM AQIvsRegistrations.dbo.Registrations
GROUP BY County

--AQI data is not as complete and has mixed results for 17 counties
SELECT County,COUNT(County)
FROM AQIvsRegistrations.dbo.AQI
GROUP BY County

--Joining the two tables based on county and year where AQI was reported on at least 350 days
SELECT *
FROM AQIvsRegistrations.dbo.AQI aqi
JOIN AQIvsRegistrations.dbo.Registrations reg
	ON aqi.County = reg.County
	AND aqi.Year = reg.Year
WHERE "Days with AQI" >= 350

--Emissions from cars are the leading cause of CO and NO2 emissions. Make sure to pull those columns as well as other useful columns.
SELECT State, aqi.County, aqi.Year, "Max AQI", "Median AQI", "Days CO", "Days NO2", Registrations
FROM AQIvsRegistrations.dbo.AQI aqi
JOIN AQIvsRegistrations.dbo.Registrations reg
	ON aqi.County = reg.County
	AND aqi.Year = reg.Year
WHERE "Days with AQI" >= 350
ORDER BY aqi.County

--Adding "Days CO" and "Days NO2" into a single column to represent days that car emissions were the main pollutant. 
--Adding "Days Ozone", "Days PM2#5", "Days PM10" into a single column to represent days that other causes were the main pollutant.
SELECT State, aqi.County, aqi.Year, "Max AQI", "Median AQI", ("Days CO" + "Days NO2") as "Days CO, NO2",
("Days Ozone" + "Days PM2#5" + "Days PM10") as "Days Other", Registrations
FROM AQIvsRegistrations.dbo.AQI aqi
JOIN AQIvsRegistrations.dbo.Registrations reg
	ON aqi.County = reg.County
	AND aqi.Year = reg.Year
WHERE "Days with AQI" >= 350
ORDER BY aqi.County
