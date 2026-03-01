- FILE: 02_sales_analysis.sql
- PURPOSE: Sales performance breakdown

- KPI 2: Monthly Sales Trend

SELECT 
    strftime('%Y-%m', "Order Date") AS order_month,
    ROUND(SUM(Sales), 2) AS monthly_sales
FROM cleaned_superstore
GROUP BY order_month
ORDER BY order_month;


- KPI 3: Sales & Profit by Region

SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM cleaned_superstore
GROUP BY Region
ORDER BY total_sales DESC;
