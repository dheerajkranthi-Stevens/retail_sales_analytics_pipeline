- FILE: 01_kpi_overview.sql
- PURPOSE: Executive level KPIs
- DATASET: cleaned_superstore

- KPI 1: Total Sales, Total Profit, Overall Profit Margin

SELECT 
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / SUM(Sales), 4) AS overall_profit_margin
FROM cleaned_superstore;
