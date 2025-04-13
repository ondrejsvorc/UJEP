import requests

CLICKHOUSE_URL = "https://grv07xcd94.eu-central-1.aws.clickhouse.cloud:8443"
CLICKHOUSE_USER = "default"
CLICKHOUSE_PASSWORD = "zgCT1iMto~hqR"

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
        auth=(CLICKHOUSE_USER, CLICKHOUSE_PASSWORD),
        headers={"Content-Type": "text/plain"},
    )

    if response.ok:
        print(f"✅ Inserted into {table_name}")
    else:
        print(f"❌ Failed to insert into {table_name}: {response.status_code}")
        print(response.text)

# for table_name in TABLES:
#     check_url = f"{CLICKHOUSE_URL}/?query=SELECT COUNT(*) FROM {table_name}"
#     r = requests.get(check_url, auth=(CLICKHOUSE_USER, CLICKHOUSE_PASSWORD))
#     print(f"🔍 {table_name} row count:", r.text.strip())