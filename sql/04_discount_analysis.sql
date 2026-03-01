- FILE: 04_discount_analysis.sql
- PURPOSE: Discount impact on profitability

- KPI 6: Discount vs Non-Discount Performance

SELECT 
    "Is Discounted",
    ROUND(AVG("Profit Margin"), 4) AS avg_profit_margin,
    COUNT(*) AS total_orders
FROM cleaned_superstore
GROUP BY "Is Discounted";


- KPI 7: Average Profit Margin by Discount Level

SELECT 
    Discount,
    ROUND(AVG("Profit Margin"), 4) AS avg_profit_margin
FROM cleaned_superstore
GROUP BY Discount
ORDER BY Discount;
