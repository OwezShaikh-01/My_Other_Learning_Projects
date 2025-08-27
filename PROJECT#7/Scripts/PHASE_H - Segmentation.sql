/*
================================================================================
Phase H. Segmentation & Behavioral Patterns
--------------------------------------------------------------------------------
Objective:
  • Group ridership trends by meaningful segments (time, geography, traffic).
  • Reveal behavioral patterns tied to weekday/weekend, seasonal shifts, or route types.
  • Support targeted visual storytelling in the dashboard phase.
================================================================================
*/

-- H1. Weekday vs Weekend ridership comparison
SELECT
    CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_category,
    COUNT(*)                            AS total_days,
    SUM(CAST(rides AS BIGINT))         AS total_rides,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides
FROM ridership_featured
GROUP BY is_weekend;


-- H2. Seasonal (quarter-wise) ridership pattern
SELECT
    DATEPART(YEAR, ride_date)           AS ride_year,
    DATEPART(QUARTER, ride_date)        AS quarter,
    SUM(rides)                          AS total_rides,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_daily_rides
FROM ridership_featured
GROUP BY DATEPART(YEAR, ride_date), DATEPART(QUARTER, ride_date)
ORDER BY ride_year, quarter;

-- H3. Route categories based on average volume
WITH route_volume AS (
    SELECT
        route,
        route_name,
        AVG(CAST(rides AS FLOAT)) AS avg_rides
    FROM ridership_featured
    GROUP BY route, route_name
)
SELECT
    route,
    route_name,
    ROUND(avg_rides, 1) AS avg_rides,
    CASE 
        WHEN avg_rides > 8000 THEN 'Heavy Traffic'
        WHEN avg_rides > 3000 THEN 'Moderate Traffic'
        ELSE                     'Low Traffic'
    END AS route_classification
FROM route_volume
ORDER BY avg_rides DESC;

-- H4. Monthly ride behavior by day type
SELECT
    FORMAT(ride_date, 'yyyy-MM')        AS year_month,
    day_type,
    SUM(rides)                          AS total_rides,
    COUNT(*)                            AS total_days,
    ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides
FROM ridership_featured
GROUP BY FORMAT(ride_date, 'yyyy-MM'), day_type
ORDER BY year_month, day_type;

-- H5. Weekend-heavy vs Weekday-heavy routes
WITH route_split AS (
    SELECT
        route,
        route_name,
        SUM(CASE WHEN is_weekend = 1 THEN rides ELSE 0 END) AS weekend_rides,
        SUM(CASE WHEN is_weekend = 0 THEN rides ELSE 0 END) AS weekday_rides
    FROM ridership_featured
    GROUP BY route, route_name
)
SELECT 
    route,
    route_name,
    weekend_rides,
    weekday_rides,
    CASE 
        WHEN weekend_rides > weekday_rides THEN 'Weekend-Heavy'
        WHEN weekday_rides > weekend_rides THEN 'Weekday-Heavy'
        ELSE 'Balanced'
    END AS dominant_segment
FROM route_split
ORDER BY 
  CASE 
    WHEN weekend_rides > weekday_rides THEN weekend_rides
    ELSE weekday_rides
  END DESC;


/*
================================================================================
Phase H: Segmentation & Behavioral Patterns Summary
--------------------------------------------------------------------------------
• Weekday vs Weekend: Weekdays dominate with ~6.1K avg rides/day vs ~4.8K on weekends—confirms work commute bias.
• Seasonal Variation: Ridership peaks in Q2 and Q3, especially in 2008–2012—indicating warmer-month demand surges.
• Route Load Types: Categorized routes as 'Heavy', 'Moderate', or 'Low' traffic—Cottage Grove, 79th, and Western lead in average daily load (>8K).
• Monthly Behavior: Weekdays show consistently higher ride volumes than weekends across months—seasonality + day-type patterns overlap.
• Route Affinity: 79th, Ashland, and Western identified as ‘Weekday-Heavy’ routes; while select express/internal routes lean toward weekend spikes.
================================================================================
*/
