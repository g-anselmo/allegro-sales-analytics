-- =====================================================
-- Allegro Sales - Analysis queries
-- Database: allegro_sales (PostgreSQL 16)
-- =====================================================

-- 1. Revenue and orders by year (delivered orders only)
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(*)                      AS orders,
    SUM(revenue_pln)              AS revenue_pln
FROM orders
WHERE order_status = 'Delivered'
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;

-- 2. Revenue by category (delivered orders only)
SELECT
    category,
    COUNT(*)         AS orders,
    SUM(revenue_pln) AS revenue_pln
FROM orders
WHERE order_status = 'Delivered'
GROUP BY category
ORDER BY revenue_pln DESC;

-- 3. Orders by value band (CASE)
SELECT
    CASE
        WHEN revenue_pln < 100  THEN 'Small (<100)'
        WHEN revenue_pln < 1000 THEN 'Medium (100-999)'
        ELSE 'Large (1000+)'
    END AS value_band,
    COUNT(*) AS orders
FROM orders
WHERE order_status = 'Delivered'
  AND revenue_pln IS NOT NULL
GROUP BY value_band
ORDER BY orders DESC;

-- 4. Cities with more than 1,500 orders (HAVING)
SELECT
    customer_city,
    COUNT(*) AS orders
FROM orders
GROUP BY customer_city
HAVING COUNT(*) > 1500
ORDER BY orders DESC;

-- 5. Monthly revenue vs target (JOIN)
SELECT
    t.month,
    SUM(o.revenue_pln) AS revenue_pln,
    t.target_pln,
    ROUND(100.0 * SUM(o.revenue_pln) / t.target_pln, 2) AS achievement_pct
FROM targets t
JOIN orders o
    ON DATE_TRUNC('month', o.order_date) = t.month
WHERE o.order_status = 'Delivered'
GROUP BY t.month, t.target_pln
ORDER BY t.month;

-- 6. Return rate by category (conditional aggregation)
SELECT
    category,
    COUNT(*) AS orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returns,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS return_rate_pct
FROM orders
GROUP BY category
ORDER BY return_rate_pct DESC;
