/*
================================================================================
Phase 0. Database Setup & Gold Table Creation
--------------------------------------------------------------------------------
Purpose:
  • Create project-specific SQL Server database.
  • Define raw staging and lookup tables for CTA ridership data.
  • Import CSVs into respective tables.
  • Create final cleaned analytical view with standardized fields.
================================================================================
*/

-- 0.1 Create project-specific database
CREATE DATABASE [PROJECT#7];
GO
USE [PROJECT#7];
GO

-- 0.2 Define raw CTA ridership structure
CREATE TABLE ridership_raw (
    date VARCHAR(20),
    route VARCHAR(10),
    daytype CHAR(1),
    rides INT
);

-- 0.3 Define route code to route name mapping table
CREATE TABLE route_lookup (
    route VARCHAR(10) PRIMARY KEY,
    route_name VARCHAR(100)
);

-- 0.4 [Manual Step] Import both CSVs via SSMS
--     ▸ chicago_bus_ridership.csv  →  ridership_raw
--     ▸ route_lookup.csv           →  route_lookup

/*
================================================================================
0.5 Create Analytical View: ridership_clean
--------------------------------------------------------------------------------
Purpose:
  • Standardize ride_date as DATE.
  • Decode daytype into Weekday / Saturday / Sunday.
  • Attach route_name via LEFT JOIN from route_lookup.
================================================================================
*/

CREATE VIEW ridership_clean AS
SELECT 
    CAST(TRY_CONVERT(DATE, date, 101) AS DATE) AS ride_date,
    r.route,
    rl.route_name,
    CASE 
        WHEN daytype = 'W' THEN 'Weekday'
        WHEN daytype = 'A' THEN 'Saturday'
        WHEN daytype = 'U' THEN 'Sunday/Holiday'
        ELSE 'Unknown'
    END AS day_type,
    rides
FROM ridership_raw r
LEFT JOIN route_lookup rl ON r.route = rl.route;
