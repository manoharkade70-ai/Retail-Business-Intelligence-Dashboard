USE retail_intelligence;

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / SUM(sales) * 100,2
    ) AS profit_margin
FROM retail_sales;

-- 2. CATEGORY PERFORMANCE

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 3. CATEGORY PROFITABILITY

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY category
ORDER BY profit_margin DESC;

-- 4. REGIONAL PERFORMANCE

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

-- 5. LOSS-MAKING REGIONS

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY region
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- 6. SUB-CATEGORY PROFITABILITY

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY sub_category
ORDER BY profit_margin ASC;

-- 7. DISCOUNT VS PROFITABILITY

SELECT
    ROUND(discount, 2) AS discount_level,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin
FROM retail_sales
WHERE sub_category = 'Tables'
GROUP BY ROUND(discount, 2)
ORDER BY discount_level;

-- 8. LOSS-MAKING TABLE PRODUCTS

SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 2) AS average_discount
FROM retail_sales
WHERE sub_category = 'Tables'
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;

-- 9. TOP CUSTOMERS BY SALES

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 10. TOP CUSTOMERS BY PROFIT

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_profit DESC
LIMIT 10;

-- 11. CUSTOMER PROFITABILITY

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING SUM(sales) > 0
ORDER BY profit_margin DESC
LIMIT 10;

-- 11. CUSTOMER PROFITABILITY
-- Minimum $1,000 in sales

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING SUM(sales) >= 1000
ORDER BY profit_margin DESC
LIMIT 10;

-- 12. HIGH-REVENUE LOSS-MAKING CUSTOMERS

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING SUM(sales) >= 5000
   AND SUM(profit) < 0
ORDER BY total_profit ASC;

-- 13. MONTHLY SALES AND PROFIT TREND

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;

-- 14. YEARLY SALES AND PROFIT PERFORMANCE

SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- 15. YEAR-OVER-YEAR SALES AND PROFIT GROWTH

WITH yearly_performance AS (
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM retail_sales
    GROUP BY YEAR(order_date)
)

SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_year))
        / NULLIF(LAG(total_sales) OVER (ORDER BY order_year), 0) * 100,
        2
    ) AS sales_growth_pct,

    ROUND(
        (total_profit - LAG(total_profit) OVER (ORDER BY order_year))
        / NULLIF(LAG(total_profit) OVER (ORDER BY order_year), 0) * 100,
        2
    ) AS profit_growth_pct

FROM yearly_performance
ORDER BY order_year;

-- 16. YEARLY PROFIT MARGIN TREND

SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- 17. TOP PRODUCTS BY SALES

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- 18. TOP PRODUCTS BY PROFIT

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
HAVING SUM(profit) > 0
ORDER BY total_profit DESC
LIMIT 10;

-- 19. LOSS-MAKING PRODUCTS

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM retail_sales
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;

-- 20. SHIPPING PERFORMANCE

SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM retail_sales
GROUP BY ship_mode
ORDER BY avg_shipping_days;

-- 21. CATEGORY × REGION PERFORMANCE

SELECT
    region,
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY
    region,
    category
ORDER BY
    region,
    total_sales DESC;

-- 22. MANAGEMENT SUMMARY

WITH overall AS (
    SELECT
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM retail_sales
),

loss_regions AS (
    SELECT
        COUNT(*) AS loss_making_regions
    FROM (
        SELECT region
        FROM retail_sales
        GROUP BY region
        HAVING SUM(profit) < 0
    ) AS r
),

loss_products AS (
    SELECT
        COUNT(*) AS loss_making_products
    FROM (
        SELECT product_id
        FROM retail_sales
        GROUP BY product_id
        HAVING SUM(profit) < 0
    ) AS p
)

SELECT
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS overall_profit_margin,

    loss_regions.loss_making_regions,
    loss_products.loss_making_products,

    CASE
        WHEN total_profit > 0
             AND total_profit / NULLIF(total_sales, 0) >= 0.10
        THEN 'Profitable Business'
        WHEN total_profit > 0
        THEN 'Profitable but Low Margin'
        ELSE 'Loss-Making Business'
    END AS business_status

FROM overall
CROSS JOIN loss_regions
CROSS JOIN loss_products;