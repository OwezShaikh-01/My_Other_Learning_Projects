/*
================================================================================
Phase D. Temporal Trend Analysis
--------------------------------------------------------------------------------
Objective:
  • Uncover long-term and seasonal patterns in ridership.
  • Detect growth, decline, or recovery phases over time.
  • Identify temporal drivers of high and low transit demand.
================================================================================
*/

USE PROJECT#7;

-- D1. Monthly ridership trend (all routes combined)
SELECT
    FORMAT(ride_date, 'yyyy-MM') AS year_month,
    SUM(rides) AS total_rides
FROM ridership_featured
GROUP BY FORMAT(ride_date, 'yyyy-MM')
ORDER BY year_month;

-- D2. Year-over-year ridership summary
SELECT
    ride_year,
    COUNT(DISTINCT ride_date) AS active_days,
    SUM(rides)                AS total_rides,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_daily_rides
FROM ridership_featured
GROUP BY ride_year
ORDER BY ride_year;

-- D3. Total ridership by day category (Weekday vs Weekend)
SELECT
    CASE 
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_category,
    COUNT_BIG(*)                      AS total_days,
    SUM(CAST(rides AS BIGINT))        AS total_rides,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides_per_day
FROM ridership_featured
GROUP BY
    CASE 
        WHEN is_weekend = 1 THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY day_category;

-- D4. Top 5 routes – monthly ridership trend
WITH top_routes AS (
    SELECT TOP 5 route
    FROM ridership_featured
    GROUP BY route
    ORDER BY SUM(rides) DESC
)
SELECT
    FORMAT(ride_date, 'yyyy-MM') AS year_month,
    r.route,
    r.route_name,
    SUM(r.rides) AS total_rides
FROM ridership_featured r
JOIN top_routes t ON r.route = t.route
GROUP BY FORMAT(ride_date, 'yyyy-MM'), r.route, r.route_name
ORDER BY r.route, year_month;

-- D5. Year-month day count (to validate time coverage)
SELECT
    FORMAT(ride_date, 'yyyy-MM') AS year_month,
    COUNT(DISTINCT ride_date) AS available_days
FROM ridership_featured
GROUP BY FORMAT(ride_date, 'yyyy-MM')
ORDER BY year_month;


/*
================================================================================
🧠 Phase D: Temporal Trend Analysis Summary
--------------------------------------------------------------------------------
• Monthly ridership consistently exceeded 20M+ rides; early 2000s show gradual 
  recovery and growth from ~24M to 27M monthly rides.
• Average daily ridership peaked around 2012 (7,001/day) before declining in 
  2013–2015 (to ~6,400/day), indicating possible system-wide slowdown.
• Weekdays average 6,183 riders/day versus 4,798 on weekends—a 29% drop—confirming
  workday demand as a primary transit driver.
• Top routes like Cottage Grove sustained over 600K+ monthly rides since 2001,
  showcasing long-term route popularity and consistency.
• All months have full ride coverage (28–31 days), validating uniform time series 
  for monthly trend and forecast modeling.
================================================================================
*/
