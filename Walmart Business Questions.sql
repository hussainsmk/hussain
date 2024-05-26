use newdata;
SELECT * FROM walmart_sales;

-- // Data Cleaning //

-- 1 Finding Number of missing values
 
SELECT
    SUM(CASE WHEN store IS NULL THEN 1 ELSE 0 END) AS missing_store,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN weekly_sales IS NULL THEN 1 ELSE 0 END) AS missing_weekly_sales,
    SUM(CASE WHEN holiday_flag IS NULL THEN 1 ELSE 0 END) AS missing_holiday_flag,
    SUM(CASE WHEN temperature IS NULL THEN 1 ELSE 0 END) AS missing_temperature,
    SUM(CASE WHEN fuel_price IS NULL THEN 1 ELSE 0 END) AS missing_fuel_price,
    SUM(CASE WHEN cpi IS NULL THEN 1 ELSE 0 END) AS missing_cpi,
    SUM(CASE WHEN unemployment IS NULL THEN 1 ELSE 0 END) AS missing_unemployment
FROM walmart_sales;

-- Updating missing values in temperature column --

UPDATE walmart_sales
SET temperature = (
    SELECT AVG(temperature)
    FROM walmart_sales
    WHERE temperature IS NOT NULL
)
WHERE temperature IS NULL;

-- Question 1: How do holidays impact weekly sales at Walmart stores?

SELECT 
    holiday_flag, 
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales
FROM 
    walmart_sales
GROUP BY 
    holiday_flag
ORDER BY 
    holiday_flag;
    
-- Question 2: What is the relationship between temperature(F) and weekly sales?

SELECT 
    CASE
        WHEN temperature < 30 THEN '< 30'
        WHEN temperature BETWEEN 30 AND 50 THEN '30-50'
        WHEN temperature BETWEEN 51 AND 70 THEN '51-70'
        WHEN temperature BETWEEN 71 AND 90 THEN '71-90'
        ELSE '> 90'
    END AS temp_range,
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales
FROM 
    walmart_sales
GROUP BY 
    temp_range
ORDER BY 
    temp_range;

-- Question 3: How do changes in fuel prices impact weekly sales at Walmart stores?

SELECT 
    CASE
        WHEN fuel_price BETWEEN 2 AND 3 THEN '2-3'
        WHEN fuel_price BETWEEN 3 AND 4 THEN '3-4'
        ELSE '> 4'
    END AS fuel_price_range,
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales
FROM 
    walmart_sales
GROUP BY 
    fuel_price_range
ORDER BY 
    fuel_price_range;
    
-- Question 4: What is the effect of the Consumer Price Index (CPI) on weekly sales?

SELECT 
    CASE
        WHEN cpi < 100 THEN '< 100'
        WHEN cpi BETWEEN 200 AND 210 THEN '200-210'
        WHEN cpi BETWEEN 211 AND 220 THEN '211-220'
        ELSE '> 220'
    END AS cpi_range,
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales
FROM 
    walmart_sales
GROUP BY 
    cpi_range
ORDER BY 
    cpi_range;

-- Question 5: Which stores have the highest and lowest weekly sales, and what factors contribute to this variation?

SELECT 
    store, 
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales, ROUND(AVG(temperature), 2) AS avg_temperature,
    ROUND(AVG(cpi), 2) AS avg_cpi,
    ROUND(AVG(unemployment), 2) AS avg_unemployment
FROM 
    walmart_sales
GROUP BY 
    store
ORDER BY 
    avg_weekly_sales DESC
LIMIT 1;  -- Top performing store

SELECT 
    store, 
    ROUND(AVG(weekly_sales), 2) AS avg_weekly_sales, ROUND(AVG(temperature), 2) AS avg_temperature,
    ROUND(AVG(cpi), 2) AS avg_cpi,
    ROUND(AVG(unemployment), 2) AS avg_unemployment
FROM 
    walmart_sales
GROUP BY 
    store
ORDER BY 
    avg_weekly_sales ASC
LIMIT 1;  -- Bottom performing store

