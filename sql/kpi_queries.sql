- FILE: kpi_queries.sql
- PURPOSE: KPI queries for cleaned_superstore (SQLite)
- TABLE: cleaned_superstore

- KPI 1: Total Sales, Total Profit, Overall Profit Margin
SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0), 4) AS overall_profit_margin
FROM cleaned_superstore;


- KPI 2: Monthly Sales Trend
SELECT
    strftime('%Y-%m', "Order Date") AS order_month,
    ROUND(SUM(Sales), 2) AS monthly_sales
FROM cleaned_superstore
GROUP BY order_month
ORDER BY order_month;


- KPI 3: Top 10 Products by Profit
SELECT
    "Product Name",
    ROUND(SUM(Profit), 2) AS total_profit
FROM cleaned_superstore
GROUP BY "Product Name"
ORDER BY total_profit DESC
LIMIT 10;


- KPI 4: Sales & Profit by Region
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM cleaned_superstore
GROUP BY Region
ORDER BY total_sales DESC;


- KPI 5: Discount Impact Analysis
- Requires a column "Is Discounted" (0/1) and "Profit Margin"
SELECT
    "Is Discounted",
    ROUND(AVG("Profit Margin"), 4) AS avg_profit_margin,
    COUNT(*) AS total_orders
FROM cleaned_superstore
GROUP BY "Is Discounted"
ORDER BY "Is Discounted";
