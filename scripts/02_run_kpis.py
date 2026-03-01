import pandas as pd
import sqlite3
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
db_path = PROJECT_ROOT / "superstore.db"
out_dir = PROJECT_ROOT / "outputs"
out_dir.mkdir(exist_ok=True)

conn = sqlite3.connect(db_path)

queries = {
    "kpi_total_sales_profit": """
        SELECT 
            SUM(Sales) AS total_sales,
            SUM(Profit) AS total_profit,
            SUM(Profit) / SUM(Sales) AS overall_profit_margin
        FROM cleaned_superstore;
    """,
    "kpi_monthly_sales": """
        SELECT 
            strftime('%Y-%m', "Order Date") AS order_month,
            SUM(Sales) AS monthly_sales
        FROM cleaned_superstore
        GROUP BY order_month
        ORDER BY order_month;
    """,
    "kpi_top10_products_profit": """
        SELECT 
            "Product Name",
            SUM(Profit) AS total_profit
        FROM cleaned_superstore
        GROUP BY "Product Name"
        ORDER BY total_profit DESC
        LIMIT 10;
    """,
    "kpi_sales_by_region": """
        SELECT 
            Region,
            SUM(Sales) AS total_sales,
            SUM(Profit) AS total_profit
        FROM cleaned_superstore
        GROUP BY Region
        ORDER BY total_sales DESC;
    """,
    "kpi_discount_impact": """
        SELECT 
            "Is Discounted",
            AVG("Profit Margin") AS avg_profit_margin,
            COUNT(*) AS total_orders
        FROM cleaned_superstore
        GROUP BY "Is Discounted";
    """
}

for name, q in queries.items():
    df = pd.read_sql(q, conn)
    out_path = out_dir / f"{name}.csv"
    df.to_csv(out_path, index=False)
    print(f"Saved {name} -> {out_path}")

conn.close()
print("Done")
