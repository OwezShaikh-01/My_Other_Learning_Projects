/*
================================================================================
Phase B. Feature Engineering
--------------------------------------------------------------------------------
Objective:
  • Enrich the cleaned ridership data with derived attributes.
  • Facilitate segmented analysis by date components and value buckets.
  • Prepare the dataset for aggregation, ranking, and visualization.
================================================================================
*/

USE PROJECT#7;

-- B1. Create a staging table with extracted date components and proper data types
SELECT
    CAST(ride_date AS DATE)         AS ride_date,
    route,
    route_name,
    day_type,
    CAST(rides AS INT)              AS rides,
    YEAR(ride_date)                 AS ride_year,
    MONTH(ride_date)                AS ride_month,
    DATENAME(WEEKDAY, ride_date)    AS day_name
INTO ridership_featured
FROM ridership_clean;


-- B2. Define categorical buckets for ridership volume
-- (first add the column ride bucket)
ALTER TABLE ridership_featured
ADD
    ride_bucket VARCHAR(20);
-- (now update the categorical bucket volume)
UPDATE ridership_featured
SET ride_bucket =
    CASE
      WHEN rides BETWEEN    1 AND   100 THEN 'Very Low'
      WHEN rides BETWEEN  101 AND   500 THEN 'Low'
      WHEN rides BETWEEN  501 AND  1000 THEN 'Medium'
      WHEN rides BETWEEN 1001 AND  5000 THEN 'High'
      ELSE                                   'Very High'
    END;

-- B3. Compute route ranking by average daily ridership
-- (first add the column route_rank)
ALTER TABLE ridership_featured
ADD route_rank INT;
-- (now update the route rankings)
WITH avg_rides AS (
  SELECT
    route,
    ROW_NUMBER() OVER (
      ORDER BY AVG(rides) DESC
    ) AS rank_order
  FROM ridership_featured
  GROUP BY route
)
UPDATE e
SET route_rank = a.rank_order
FROM ridership_featured AS e
JOIN avg_rides          AS a
  ON e.route = a.route;

-- B4. Flag weekend vs weekday for simple segmentation

-- (first add the column is_weekend)
ALTER TABLE ridership_featured
ADD is_weekend BIT;
-- (now upadate the column)
UPDATE ridership_featured
SET is_weekend =
    CASE
      WHEN day_type IN ('Saturday','Sunday/Holiday') THEN 1
      ELSE                                            0
    END;

-- B5. Verify featured schema and sample records
SELECT TOP 10 *
FROM ridership_featured
ORDER BY ride_date DESC, route_rank;

/*
================================================================================
-- Phase B: Feature Engineering Summary
--------------------------------------------------------------------------------
-- • Added derived fields for year, month, day name, weekend flag, and categorized ride volumes.
-- • Created "ride_bucket" to segment ridership into 5 categories (Very Low → Very High).
-- • Assigned dynamic "route_rank" based on average daily ridership across the dataset.
-- • Enriched dataset with "is_weekend" flag to simplify weekday/weekend segmentation.
-- • All features verified with recent records; top-ranked routes include 79th, Ashland, Chicago, and Cottage Grove.
================================================================================
*/