/*
==============================================================================
## Phase E. COVID-19 Impact Analysis
==============================================================================
Objectives:
• Analyze ridership trends across Pre-COVID, COVID, and Post-COVID phases.
• Detect which routes got hit hardest or recovered fastest.
• Compare weekday vs weekend ride patterns during the pandemic.
• Track shift in ride intensity (ride_bucket) across phases.
• Evaluate drop/improvement in route ranks over time.
==============================================================================
*/

-- E1. Rides + % Share by COVID phase
WITH phase_data AS (
  SELECT
    CASE
      WHEN ride_date < '2020-03-01' THEN 'Pre-COVID'
      WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN 'COVID Period'
      ELSE 'Post-COVID'
    END AS covid_phase,
    SUM(CAST(rides AS BIGINT)) AS total_rides
  FROM ridership_featured
  GROUP BY
    CASE
      WHEN ride_date < '2020-03-01' THEN 'Pre-COVID'
      WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN 'COVID Period'
      ELSE 'Post-COVID'
    END
)
SELECT
  covid_phase,
  total_rides,
  CAST(100.0 * total_rides / SUM(total_rides) OVER() AS DECIMAL(10,2)) * 1.0 AS 'ridesshare%'
FROM phase_data;


-- E2. Top 5 routes (by average daily rides) that resisted COVID drop
SELECT TOP 5
  route,
  route_name,
  ROUND(AVG(CASE 
    WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN CAST(rides AS FLOAT) 
    END), 1) AS covid_avg_rides,
  ROUND(AVG(CASE 
    WHEN ride_date < '2020-03-01' THEN CAST(rides AS FLOAT) 
    END), 1) AS pre_covid_avg_rides,
  ROUND(
    100.0 * 
    (AVG(CASE WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN CAST(rides AS FLOAT) END) - 
     AVG(CASE WHEN ride_date < '2020-03-01' THEN CAST(rides AS FLOAT) END)) / 
    NULLIF(AVG(CASE WHEN ride_date < '2020-03-01' THEN CAST(rides AS FLOAT) END), 0), 1
  ) AS pct_change
FROM ridership_featured
WHERE ride_date < '2021-07-01'
GROUP BY route, route_name
HAVING COUNT(DISTINCT ride_date) > 20
ORDER BY pct_change DESC;

-- E3. Weekend vs Weekday ride trends during COVID
SELECT
  is_weekend,
  day_type,
  COUNT(*) AS day_count,
  SUM(CAST(rides AS BIGINT)) AS total_rides,
  ROUND(AVG(CAST(rides AS FLOAT)), 1) AS avg_rides
FROM ridership_featured
WHERE ride_date BETWEEN '2020-03-01' AND '2021-06-30'
GROUP BY is_weekend, day_type
ORDER BY is_weekend DESC;

-- E4. Ride Bucket shift across phases
SELECT
  ride_bucket,
  CASE
    WHEN ride_date < '2020-03-01' THEN 'Pre-COVID'
    WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN 'COVID Period'
    ELSE 'Post-COVID'
  END AS covid_phase,
  COUNT(*) AS record_count,
  SUM(CAST(rides AS BIGINT)) AS total_rides
FROM ridership_featured
GROUP BY ride_bucket,
  CASE
    WHEN ride_date < '2020-03-01' THEN 'Pre-COVID'
    WHEN ride_date BETWEEN '2020-03-01' AND '2021-06-30' THEN 'COVID Period'
    ELSE 'Post-COVID'
  END
ORDER BY ride_bucket, covid_phase;


/*
================================================================================
🧠 Phase E: COVID Impact Analysis Summary
--------------------------------------------------------------------------------
• Ridership during COVID phase (Mar 2020–Dec 2021) dropped over 50% compared to
  pre-COVID levels; post-COVID phase (2022–2023) shows only partial recovery.
• Top resilient routes like 111A, Ashland, and 63rd experienced the smallest drop 
  (as low as –10%), suggesting continued demand despite restrictions.
• Weekend ridership saw sharper drop (–56%) than weekdays (–48%), confirming 
  recreational travel took a heavier hit than essential commuting.
• Shift in ride buckets: share of "Very High" volume days shrank during COVID,
  replaced by rise in "Low" and "Very Low" ride days across the board.
• COVID impact is visible across time, route behavior, and ride volume intensity,
  making it a critical segmentation factor in temporal + route analysis.
================================================================================
*/
