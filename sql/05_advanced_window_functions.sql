- FILE: 05_advanced_window_functions.sql
- PURPOSE: Advanced SQL (Window Functions) for Analytics
- DATASET: cleaned_superstore
- DB: SQLite (superstore.db)


- 1) Top Customers by Sales (RANK)

SELECT
    "Customer Name",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
FROM cleaned_superstore
GROUP BY "Customer Name"
ORDER BY total_sales DESC
LIMIT 20;



- 2) Top Customers per Region (ROW_NUMBER partition)

WITH customer_region_sales AS (
    SELECT
        Region,
        "Customer Name",
        ROUND(SUM(Sales), 2) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Region
            ORDER BY SUM(Sales) DESC
        ) AS rn
    FROM cleaned_superstore
    GROUP BY Region, "Customer Name"
)
SELECT
    Region,
    "Customer Name",
    total_sales
FROM customer_region_sales
WHERE rn <= 5
ORDER BY Region, total_sales DESC;



- 3) Best Products within each Category (DENSE_RANK)

WITH product_profit AS (
    SELECT
        Category,
        "Product Name",
        ROUND(SUM(Profit), 2) AS total_profit
    FROM cleaned_superstore
    GROUP BY Category, "Product Name"
)
SELECT
    Category,
    "Product Name",
    total_profit,
    DENSE_RANK() OVER (
        PARTITION BY Category
        ORDER BY total_profit DESC
    ) AS profit_rank_in_category
FROM product_profit
WHERE total_profit IS NOT NULL
ORDER BY Category, profit_rank_in_category, total_profit DESC;



- 4) Month-over-Month Sales Growth (LAG)

WITH monthly_sales AS (
    SELECT
        strftime('%Y-%m', "Order Date") AS order_month,
        ROUND(SUM(Sales), 2) AS monthly_sales
    FROM cleaned_superstore
    GROUP BY order_month
)
SELECT
    order_month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (ORDER BY order_month) AS prev_month_sales,
    ROUND(
        (monthly_sales - LAG(monthly_sales, 1) OVER (ORDER BY order_month)) 
        / NULLIF(LAG(monthly_sales, 1) OVER (ORDER BY order_month), 0),
        4
    ) AS mom_growth_rate
FROM monthly_sales
ORDER BY order_month;



- 5) Running Total Sales over Time (SUM OVER)

WITH daily_sales AS (
    SELECT
        DATE("Order Date") AS order_date,
        ROUND(SUM(Sales), 2) AS sales
    FROM cleaned_superstore
    GROUP BY order_date
)
SELECT
    order_date,
    sales,
    ROUND(
        SUM(sales) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
        2
    ) AS running_total_sales
FROM daily_sales
ORDER BY order_date;


- 6) Identify Loss-Making Orders (Profit < 0) + Rank worst

SELECT
    "Order ID",
    "Order Date",
    "Customer Name",
    "Product Name",
    ROUND(Sales, 2) AS sales,
    ROUND(Profit, 2) AS profit,
    RANK() OVER (ORDER BY Profit ASC) AS worst_profit_rank
FROM cleaned_superstore
WHERE Profit < 0
ORDER BY Profit ASC
LIMIT 25;
