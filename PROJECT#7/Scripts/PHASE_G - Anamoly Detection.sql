/*
================================================================================
Phase G. Outlier & Anomaly Detection
--------------------------------------------------------------------------------
Objective:
  • Detect extreme values and ride spikes that deviate significantly from norm.
  • Flag days with statistically abnormal ridership patterns.
  • Support further investigation or alert-based visualizations.
================================================================================
*/

USE PROJECT#7;

-- G1. Compute Z-score per record (relative to route's mean and stddev)
WITH route_stats AS (
    SELECT
        route,
        ROUND(AVG(CAST(rides AS FLOAT)), 2)   AS mean_rides,
        ROUND(STDEV(CAST(rides AS FLOAT)), 2) AS stddev_rides
    FROM ridership_featured
    GROUP BY route
),
scored_data AS (
    SELECT
        r.ride_date,
        r.route,
        r.route_name,
        r.rides,
        rs.mean_rides,
        rs.stddev_rides,
        CASE 
            WHEN rs.stddev_rides = 0 THEN 0
            ELSE ROUND((r.rides - rs.mean_rides) / rs.stddev_rides, 2)
        END AS z_score
    FROM ridership_featured r
    JOIN route_stats rs ON r.route = rs.route
)
SELECT *
FROM scored_data
WHERE ABS(z_score) >= 3
ORDER BY ABS(z_score) DESC;

-- G2. Identify spike days per route (highest ridership per route)
SELECT *
FROM (
    SELECT
        route,
        route_name,
        ride_date,
        rides,
        RANK() OVER (PARTITION BY route ORDER BY rides DESC) AS spike_rank
    FROM ridership_featured
    WHERE rides IS NOT NULL
) AS ranked_spikes
WHERE spike_rank = 1;

-- G3. Identify routes with highly volatile ridership (stddev > 1.5× global avg)
WITH global_std AS (
    SELECT STDEV(CAST(rides AS FLOAT)) AS global_std FROM ridership_featured
),
volatile_routes AS (
    SELECT
        route,
        route_name,
        STDEV(CAST(rides AS FLOAT)) AS route_stddev
    FROM ridership_featured
    GROUP BY route, route_name
)
SELECT v.route, v.route_name, v.route_stddev
FROM volatile_routes v
JOIN global_std g ON v.route_stddev > 1.5 * g.global_std
ORDER BY v.route_stddev DESC;

-- G4. Detect flatlined routes (stddev ≈ 0)
SELECT
    route,
    route_name,
    ROUND(STDEV(CAST(rides AS FLOAT)), 2) AS ride_stddev,
    COUNT(*) AS days_tracked
FROM ridership_featured
GROUP BY route, route_name
HAVING STDEV(CAST(rides AS FLOAT)) < 1
ORDER BY ride_stddev ASC;

-- G5. List routes with abnormal ride counts on weekends only

-- List records with abnormal high weekend ridership
SELECT
    route,
    route_name,
    ride_date,
    rides
FROM ridership_featured
WHERE is_weekend = 1
  AND rides > 10000
ORDER BY rides DESC;

-- Weekend spike frequency by route (how often a route exceeds 10k on weekend)
SELECT
    route,
    route_name,
    COUNT(*) AS spike_days
FROM ridership_featured
WHERE is_weekend = 1
  AND rides > 10000
GROUP BY route, route_name
ORDER BY spike_days DESC;


/*
================================================================================
🧠 Phase G: Outlier & Anomaly Detection Summary
--------------------------------------------------------------------------------
• Detected high-z-score spikes: e.g., United Center Express (z = 22.42),
  Armitage (21.76), and others above z = 13—these suggest extreme outlier days.
• Identified spike dates per route—top spikes include Bronzeville/Union (10,765),
  Jeffery Manor (3,592), and several [Internal/Stop ID] routes above 30,000 rides.
• Found highly volatile routes (e.g., [Internal/Stop ID] 1002) with extreme 
  standard deviation (9285.6), suggesting erratic or bulk-entry issues.
• Exposed flatlined routes with near-zero stddev and very short tracking 
  duration (2–11 days)—likely data logging test cases or discontinued IDs.
• Analyzed weekend anomalies: routes like Ashland (2,341 days), 79th (2,234), 
  and Western exhibit frequent high (>10k) ridership spikes—warranting monitoring.
================================================================================
*/
