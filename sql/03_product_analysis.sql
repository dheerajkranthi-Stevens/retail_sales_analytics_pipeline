- FILE: 03_product_analysis.sql
- PURPOSE: Product performance analysis


- KPI 4: Top 10 Products by Profit

SELECT 
    "Product Name",
    ROUND(SUM(Profit), 2) AS total_profit
FROM cleaned_superstore
GROUP BY "Product Name"
ORDER BY total_profit DESC
LIMIT 10;


- KPI 5: Profit by Category

SELECT 
    Category,
    ROUND(SUM(Profit), 2) AS total_profit
FROM cleaned_superstore
GROUP BY Category
ORDER BY total_profit DESC;
