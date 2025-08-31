
SELECT 
  CAST(transaction_date AS DATE) AS Purchased_date,
  DATENAME(DAY, transaction_date) AS DayOfMonth,
  DATENAME(MONTH, transaction_date) AS MonthName,
  DATENAME(WEEKDAY, transaction_date) AS DayName,
  CASE 
    WHEN DATENAME(WEEKDAY, transaction_date) IN ('Sunday', 'Saturday') THEN 'Weekend'
    ELSE 'Weekday'
  END AS DayClassification,
  DATEPART(HOUR, transaction_time) AS HourOfDay,
  CASE 
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 6 AND 8 THEN 'Early Morning 6am-9am'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 9 AND 11 THEN 'Morning 9am-12pm'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 12 AND 15 THEN 'Afternoon 12pm-4pm'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 16 AND 19 THEN 'Evening 4pm-8pm'
    ELSE 'Night: +8pm'
  END AS Time_buckets,
  SUM(
  NULLIF(CAST(transaction_qty AS FLOAT), 0) * 
  NULLIF(CAST(unit_price AS FLOAT), 0)) AS total_revenue,
  COUNT(DISTINCT transaction_id) AS NumberOfSales,
  COUNT(DISTINCT store_id) AS stores,
  COUNT(DISTINCT product_id) AS NumDifProducts,
  product_category,
  product_detail,
  product_type,
  store_location
  into #check
FROM Brightlearn.dbo.Bright_Coffee_Shop
GROUP BY 
  CAST(transaction_date AS DATE),
  DATENAME(DAY, transaction_date),
  DATENAME(MONTH, transaction_date),
  DATENAME(WEEKDAY, transaction_date),
  DATEPART(HOUR, transaction_time),
  CASE 
    WHEN DATENAME(WEEKDAY, transaction_date) IN ('Sunday', 'Saturday') THEN 'Weekend'
    ELSE 'Weekday'
  END,
  CASE 
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 6 AND 8 THEN 'Early Morning 6am-9am'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 9 AND 11 THEN 'Morning 9am-12pm'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 12 AND 15 THEN 'Afternoon 12pm-4pm'
    WHEN DATEPART(HOUR, transaction_time) BETWEEN 16 AND 19 THEN 'Evening 4pm-8pm'
    ELSE 'Night: +8pm'
  END,
  product_category,
  product_detail,
  product_type,
  store_location;
