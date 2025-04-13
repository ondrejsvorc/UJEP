import requests

CLICKHOUSE_URL = "https://grv07xcd94.eu-central-1.aws.clickhouse.cloud:8443"
CLICKHOUSE_USER = "default"
CLICKHOUSE_PASSWORD = "zgCT1iMto~hqR"
AUTH = (CLICKHOUSE_USER, CLICKHOUSE_PASSWORD)
HEADERS = {"Content-Type": "text/plain"}

def run_sql(query: str):
    response = requests.post(
        url=f"{CLICKHOUSE_URL}/",
        params={"query": query},
        auth=AUTH,
        headers=HEADERS
    )
    query_first_line = query.strip().split("\n")[0][:80].strip()
    if response.ok:
        print(f"✅ Query OK: {query_first_line}")
    else:
        print(f"❌ Query failed: {query_first_line}\n{response.text}")
        raise Exception("Query failed")

def drop_tables():
    tables = [
        "Customers",
        "Products",
        "Transactions",
        "DimCustomers",
        "DimProducts",
        "DimDate",
        "FactTransactions"
    ]
    for table in tables:
        try:
            run_sql(f"DROP TABLE IF EXISTS {table}")
        except Exception as e:
            print(f"⚠️ Warning: Could not drop table {table} → {e}")

def create_raw_tables():
    run_sql("""
    CREATE TABLE Customers (
        CustomerID String,
        CustomerName String,
        Region String,
        SignupDate Date
    ) ENGINE = MergeTree()
    ORDER BY CustomerID;
    """)

    run_sql("""
    CREATE TABLE Products (
        ProductID String,
        ProductName String,
        Category String,
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY ProductID;
    """)

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

def insert_csv_data():
    TABLES = {
        "Customers": "Customers.csv",
        "Products": "Products.csv",
        "Transactions": "Transactions.csv"
    }
    for table_name, file_path in TABLES.items():
        insert_url = f"{CLICKHOUSE_URL}/?query=INSERT INTO {table_name} FORMAT CSVWithNames"
        with open(file_path, "rb") as f:
            csv_data = f.read()
        response = requests.post(
            url=insert_url,
            data=csv_data,
            auth=AUTH,
            headers=HEADERS,
        )
        if response.ok:
            print(f"✅ Inserted into {table_name}")
        else:
            print(f"❌ Failed to insert into {table_name}: {response.status_code}")
            print(response.text)
            raise Exception("Insert failed")

def create_dim_tables():
    run_sql("""
    CREATE TABLE DimCustomers (
        CustomerID String,
        CustomerName String,
        Region String,
        SignupDate Date
    ) ENGINE = MergeTree()
    ORDER BY CustomerID;
    """)

    run_sql("""
    INSERT INTO DimCustomers
    SELECT DISTINCT CustomerID, CustomerName, Region, SignupDate
    FROM Customers;
    """)

    run_sql("""
    CREATE TABLE DimProducts (
        ProductID String,
        ProductName String,
        Category String,
        Price Decimal(10, 2)
    ) ENGINE = MergeTree()
    ORDER BY ProductID;
    """)

    run_sql("""
    INSERT INTO DimProducts
    SELECT DISTINCT ProductID, ProductName, Category, Price
    FROM Products;
    """)

def create_dim_date():
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
    GROUP BY
        DateKey, Year, Quarter, Month, Day, WeekDay, Hour, IsWeekend;
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

if __name__ == "__main__":
    drop_tables()
    create_raw_tables()
    insert_csv_data()
    create_dim_tables()
    create_dim_date()
    create_fact_table()
    print("✅ Star schema successfully built and populated.")