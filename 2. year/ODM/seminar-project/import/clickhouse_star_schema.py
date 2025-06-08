import requests

# Connection details for ClickHouse.
CLICKHOUSE_URL = "https://grv07xcd94.eu-central-1.aws.clickhouse.cloud:8443"
CLICKHOUSE_USER = "default"
CLICKHOUSE_PASSWORD = "zgCT1iMto~hqR"
AUTH = (CLICKHOUSE_USER, CLICKHOUSE_PASSWORD)
HEADERS = {"Content-Type": "text/plain"}

# Tables.
RAW_TABLES = ["Customers", "Products", "Transactions"]
RAW_TABLES_DICT = { "Customers": "Customers.csv", "Products": "Products.csv", "Transactions": "Transactions.csv"}
DIM_TABLES = ["DimCustomers", "DimProducts", "DimDate"]
FACT_TABLES = ["FactTransactions"]
ALL_TABLES = RAW_TABLES + DIM_TABLES + FACT_TABLES

def run_sql(sql: str) -> None:
    query_summary = sql.strip().split("\n")[0][:80].strip()
    response = requests.post(
        url=f"{CLICKHOUSE_URL}/",
        params={"query": sql},
        auth=AUTH,
        headers=HEADERS
    )

    if response.ok:
        print(f"✅ Query OK: {query_summary}")
    else:
        print(f"❌ Query failed: {query_summary}\n{response.text}")

def drop_tables_if_exist(tables: list[str]):
    for table in tables:
        try:
            run_sql(f"DROP TABLE IF EXISTS {table}")
        except Exception as e:
            print(f"⚠️ Warning: Could not drop table {table} → {e}")

def create_raw_tables():
    # Customers
    run_sql("""
    CREATE TABLE Customers (
        CustomerID String,
        CustomerName String,
        Region String,
        SignupDate Date
    ) ENGINE = MergeTree()
    ORDER BY CustomerID;
    """)

    # Products
    run_sql("""
    CREATE TABLE Products (
        ProductID String,
        ProductName String,
        Category String,
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY ProductID;
    """)

    # Transactions
    run_sql("""
    CREATE TABLE Transactions (
        TransactionID String,
        CustomerID String,
        ProductID String,
        TransactionDate DateTime,
        Quantity Int32,
        TotalValue Decimal(10, 2),
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY TransactionID;
    """)

def insert_csv_data_into_raw_tables():
    for table, path in RAW_TABLES_DICT.items():
        insert_url = f"{CLICKHOUSE_URL}/?query=INSERT INTO {table} FORMAT CSVWithNames"

        with open(path, "rb") as csv_file:
            csv_data = csv_file.read()

        response = requests.post(
            url=insert_url,
            data=csv_data,
            auth=AUTH,
            headers=HEADERS,
        )

        if response.ok:
            print(f"✅ Query OK: Inserted into {table}")
        else:
            print(f"❌ Query failed: Failed to insert into {table}: {response.status_code}\n{response.text}")

def create_dim_tables():
    # Customer dimension
    run_sql("""
    CREATE TABLE DimCustomers (
        CustomerID String,
        CustomerName String,
        Region String,
        SignupDate Date
    ) ENGINE = MergeTree()
    ORDER BY CustomerID;
    """)

    # Product dimension
    run_sql("""
    CREATE TABLE DimProducts (
        ProductID String,
        ProductName String,
        Category String,
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY ProductID;
    """)

    # Date dimension
    run_sql("""
    CREATE TABLE DimDate (
        DateKey Date,
        Year UInt16,
        Quarter UInt8,
        Month UInt8,
        Day UInt8,
        WeekDay UInt8,
        Hour UInt8,
        IsWeekend UInt8
    ) ENGINE = MergeTree()
    ORDER BY (DateKey, Hour);
    """)

def create_fact_table():
    run_sql("""
    CREATE TABLE FactTransactions (
        TransactionID String,
        CustomerID String,
        ProductID String,
        DateKey Date,
        Quantity Int32,
        TotalValue Decimal(10, 2),
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY TransactionID;
    """)

def insert_into_dim_tables():
    run_sql("INSERT INTO DimCustomers SELECT DISTINCT * FROM Customers;")
    run_sql("INSERT INTO DimProducts SELECT DISTINCT * FROM Products;")
    run_sql("""
    INSERT INTO DimDate
    SELECT
        toDate(TransactionDate) AS DateKey,
        toYear(TransactionDate) AS Year,
        toQuarter(TransactionDate) AS Quarter,
        toMonth(TransactionDate) AS Month,
        toDayOfMonth(TransactionDate) AS Day,
        toDayOfWeek(TransactionDate) AS WeekDay,
        toHour(TransactionDate) AS Hour,
        if(toDayOfWeek(TransactionDate) IN (6, 7), 1, 0) AS IsWeekend
    FROM Transactions
    GROUP BY DateKey, Year, Quarter, Month, Day, WeekDay, Hour, IsWeekend;
    """)

def insert_into_fact_table():
    run_sql("""
    INSERT INTO FactTransactions
    SELECT
        TransactionID,
        CustomerID,
        ProductID,
        toDate(TransactionDate) AS DateKey,
        Quantity,
        TotalValue,
        Price
    FROM Transactions;
    """)

def create_star_schema():
    drop_tables_if_exist(ALL_TABLES)

    create_raw_tables()
    insert_csv_data_into_raw_tables()

    create_dim_tables()
    insert_into_dim_tables()

    create_fact_table()
    insert_into_fact_table()

    drop_tables_if_exist(RAW_TABLES)


if __name__ == "__main__":
    create_star_schema()