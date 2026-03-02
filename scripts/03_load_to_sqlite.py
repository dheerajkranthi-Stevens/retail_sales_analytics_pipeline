import sqlite3
from pathlib import Path
import pandas as pd

PROJECT_ROOT = Path(__file__).resolve().parents[1]
processed_csv = PROJECT_ROOT / "data" / "processed" / "cleaned_superstore.csv"
db_path = PROJECT_ROOT / "superstore.db"
table_name = "cleaned_superstore"

def main():
    if not processed_csv.exists():
        raise FileNotFoundError(f"Missing file: {processed_csv}")

    df = pd.read_csv(processed_csv)

    conn = sqlite3.connect(db_path)
    df.to_sql(table_name, conn, if_exists="replace", index=False)
    conn.close()

    print(f" Loaded {len(df)} rows into {db_path} (table: {table_name})")

if __name__ == "__main__":
    main()