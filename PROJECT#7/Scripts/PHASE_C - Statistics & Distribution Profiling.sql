/*
================================================================================
Phase C. Descriptive Statistics & Distribution Profiling
--------------------------------------------------------------------------------
Objective:
  • Quantify key statistical summaries across ridership metrics.
  • Understand distribution shape, variance, and relative magnitude.
  • Identify possible outliers, data skew, or transformation needs.
================================================================================
*/

USE PROJECT#7

-- C1. Global statistical summary for the entire dataset
SELECT
    COUNT(*)                             AS total_records,
    MIN(rides)                           AS min_rides,
    MAX(rides)                           AS max_rides,
    ROUND(AVG(CAST(rides AS FLOAT)),2)   AS avg_rides,
    ROUND(STDEV(CAST(rides AS FLOAT)),2) AS std_dev_rides,
    ROUND(VAR(CAST(rides AS FLOAT)),2)   AS variance_rides
FROM ridership_featured;

SELECT DISTINCT
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY CAST(rides AS FLOAT)) 
        OVER () AS median_rides
FROM ridership_featured;


-- C2. Distribution of ridership volumes (bucket frequency)
SELECT
    ride_bucket,
    COUNT(*) AS total_days,
    CAST(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS DECIMAL(5,2)) AS percentage_share
FROM ridership_featured
GROUP BY ride_bucket
ORDER BY total_days DESC;


-- C3. Average ridership per route across all time
SELECT
    route,
    route_name,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides,
    COUNT(*)                            AS active_days
FROM ridership_featured
GROUP BY route, route_name
ORDER BY avg_rides DESC;

-- C4. Average ridership by day of week
SELECT
    day_name,
    COUNT(*)                            AS total_days,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides
FROM ridership_featured
GROUP BY day_name
ORDER BY 
    CASE 
      WHEN day_name = 'Monday' THEN 1
      WHEN day_name = 'Tuesday' THEN 2
      WHEN day_name = 'Wednesday' THEN 3
      WHEN day_name = 'Thursday' THEN 4
      WHEN day_name = 'Friday' THEN 5
      WHEN day_name = 'Saturday' THEN 6
      WHEN day_name = 'Sunday' THEN 7
      ELSE 8
    END;

-- C5. Standard deviation of daily ridership by route (volatility)
SELECT
    route,
    route_name,
    ROUND(STDEV(CAST(rides AS FLOAT)), 2) AS ride_stddev,
    COUNT(*) AS data_points
FROM ridership_featured
GROUP BY route, route_name
HAVING COUNT(*) >= 100
ORDER BY ride_stddev DESC;

/*
================================================================================
Phase C: Descriptive Statistics & Distribution Summary
--------------------------------------------------------------------------------
• Dataset includes 1,067,754 records with rides ranging from 0 to 45,177.
• Average daily ridership is ~5,865 with high standard deviation (~6,070),
  indicating strong variability across days.
• Ride volume distribution is skewed: over 79% of days fall in "High" or 
  "Very High" buckets; only 2% in "Very Low".
• Top routes by average ridership include:
    - 79th (23,382), Ashland (20,778), Chicago (18,102), etc.
• Tuesday has the highest average ridership (6,250); Sunday the lowest (4,200),
  confirming expected weekday vs weekend patterns.
• Routes like 79th and Ashland show very high volatility (std dev > 7,000),
  suggesting inconsistent daily usage or periodic spikes.
================================================================================
*/

