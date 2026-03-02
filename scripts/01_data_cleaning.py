RAW_FILE_NAME = "Sample - Superstore.csv"

import pandas as pd
from pathlib import Path

# Paths
import pandas as pd
from pathlib import Path

# project root (2 levels up from scripts/01_data_cleaning.py)
PROJECT_ROOT = Path(__file__).resolve().parents[1]

RAW_DIR = PROJECT_ROOT / "data" / "raw"
PROCESSED_DIR = PROJECT_ROOT / "data" / "processed"
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

RAW_FILE_NAME = "Sample - Superstore.csv"

raw_path = RAW_DIR / RAW_FILE_NAME
output_path = PROCESSED_DIR / "cleaned_superstore.csv"

print("Project root:", PROJECT_ROOT)
print("Looking for file at:", raw_path)

# Load data
df = pd.read_csv(raw_path, encoding="latin1")


# Ensure numeric columns are clean

df["Sales"] = pd.to_numeric(df["Sales"], errors="coerce")
df["Profit"] = pd.to_numeric(df["Profit"], errors="coerce")
df["Discount"] = pd.to_numeric(df["Discount"], errors="coerce").fillna(0)


# Derived analytics fields

# Profit Margin = Profit / Sales (safe divide)
df["Profit Margin"] = (df["Profit"] / df["Sales"]).replace([float("inf"), -float("inf")], 0).fillna(0)

# Is Discounted = 1 if Discount > 0 else 0
df["Is Discounted"] = (df["Discount"] > 0).astype(int)

print("Loaded dataset")
print("Shape:", df.shape)

# Remove duplicates
df = df.drop_duplicates()

# Strip spaces from text columns
for col in df.select_dtypes(include="object").columns:
    df[col] = df[col].str.strip()

# Convert date columns
df["Order Date"] = pd.to_datetime(df["Order Date"])
df["Ship Date"] = pd.to_datetime(df["Ship Date"])

# Convert numeric columns
df["Sales"] = pd.to_numeric(df["Sales"])
df["Profit"] = pd.to_numeric(df["Profit"])
df["Quantity"] = pd.to_numeric(df["Quantity"])
df["Discount"] = pd.to_numeric(df["Discount"])

# Add new features
df["Profit Margin"] = df["Profit"] / df["Sales"]
df["Order Month"] = df["Order Date"].dt.to_period("M").astype(str)
df["Order Year"] = df["Order Date"].dt.year

# Save cleaned dataset
df.to_csv(output_path, index=False)

print("Cleaned dataset saved to:", output_path)
print("Final Shape:", df.shape)


import sqlite3

# Create SQLite database in project root
db_path = PROJECT_ROOT / "superstore.db"

conn = sqlite3.connect(db_path)
df.to_sql("cleaned_superstore", conn, if_exists="replace", index=False)

print("✅ Data loaded into SQLite database:", db_path)

# Example test query
query = """
SELECT SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit
FROM cleaned_superstore;
"""

result = pd.read_sql(query, conn)
print("\nSQL Test Result:")
print(result)

conn.close()
