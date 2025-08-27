/*
================================================================================
Phase F. Magnitude, Ranking & Contribution Analysis
--------------------------------------------------------------------------------
Objective:
  • Rank routes, days, and segments based on overall traffic volume.
  • Identify top contributors to ridership by proportion.
  • Quantify concentration of traffic across route network.
================================================================================
*/

-- F1. Top 15 routes by total ridership
SELECT
	TOP 15
    route,
    route_name,
    SUM(rides) AS total_rides,
    CAST(ROUND(100.0 * SUM(CAST(rides AS BIGINT)) / (SELECT SUM(CAST(rides AS BIGINT)) FROM ridership_featured), 2) AS DECIMAL (3,2)) AS pct_of_total
FROM ridership_featured
GROUP BY route, route_name
ORDER BY total_rides DESC;

-- F2. Day of week ranking by average ridership
SELECT
    day_name,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides,
    COUNT(*) AS total_days
FROM ridership_featured
GROUP BY day_name
ORDER BY avg_rides DESC;

-- F3. Route rank within each year based on total ridership
WITH yearly_ranks AS (
  SELECT
    ride_year,
    route,
    route_name,
    SUM(rides) AS total_rides,
    RANK() OVER (PARTITION BY ride_year ORDER BY SUM(rides) DESC) AS yearly_rank
  FROM ridership_featured
  GROUP BY ride_year, route, route_name
)
SELECT *
FROM yearly_ranks
WHERE yearly_rank <= 5
ORDER BY ride_year, yearly_rank;

-- F4. Contribution share by route bucket
SELECT
    ride_bucket,
    COUNT_BIG(*) AS num_days,
    SUM(CAST(rides AS BIGINT)) AS total_rides,
    CAST (
		ROUND(
        100.0 * SUM(CAST(rides AS BIGINT)) 
        / (SELECT SUM(CAST(rides AS BIGINT)) FROM ridership_featured), 
        2
    ) AS DECIMAL(4,2)) AS contribution_pct
FROM ridership_featured
GROUP BY ride_bucket
ORDER BY total_rides DESC;


-- F5. Top 10 route-daytype combinations by average rides
SELECT TOP 10
    route,
    route_name,
    day_type,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides,
    COUNT(*) AS records
FROM ridership_featured
GROUP BY route, route_name, day_type
ORDER BY avg_rides DESC;


  /*
================================================================================
Phase F: Magnitude, Ranking & Contribution Analysis Summary
--------------------------------------------------------------------------------
• Top 5 highest ridership routes include: 79th (3.32%), Ashland (2.95%), 
  Chicago (2.57%), Cottage Grove (2.45%), and Western (2.45%), together 
  contributing ~13.74% of total system traffic.

• Tuesday and Wednesday rank as the highest ridership days (~6,250/day), 
  followed closely by Thursday and Friday, validating midweek commuter demand. 
  Sunday averages the lowest (~4,200/day), reinforcing the weekday/weekend gap.

• Route 79th has consistently ranked #1 in yearly ridership (e.g., 2001, 2002, 
  2007), with Ashland and Western also appearing frequently in the top 5, 
  highlighting their long-standing popularity and service relevance.

• Over 81% of total ridership comes from "Very High" bucket days, while "High" 
  days contribute 17% more — together making up 98.3% of all rides — suggesting 
  a highly concentrated network usage pattern.

• Weekday route/day combinations led by 79th, Ashland, and Chicago average 
  20K+ rides/day, with 79th reaching 26K/day — these are critical segments for 
  peak-hour transit planning and infrastructure load handling.
================================================================================
*/