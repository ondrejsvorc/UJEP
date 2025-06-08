import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

data = pd.read_csv('customer_aggregates.csv')
X = data[['PurchaseCount', 'TotalSpent']]

kmeans = KMeans(n_clusters=3, random_state=42)
data['Cluster'] = kmeans.fit_predict(X)

groups = {
    0: 'Věrní a silně nakupující zákazníci',
    1: 'Pravidelní zákazníci',
    2: 'Jednorázoví zákazníci'
}
data['GroupName'] = data['Cluster'].map(groups)

def print_customers_in_group(group_name: str):
    selected_customers = data[data['GroupName'] == group_name]['CustomerID']
    if selected_customers.empty:
        print(f"Žádní zákazníci ve skupině: {group_name}")
    else:
        print(f"Zákazníci ve skupině '{group_name}':")
        for cid in selected_customers:
            print(f"{cid}")

plt.figure(figsize=(10, 6))
scatter = plt.scatter(
    data['PurchaseCount'],
    data['TotalSpent'],
    c=data['Cluster'],
    cmap='viridis'
)
plt.xlabel('Počet nákupů')
plt.ylabel('Celková útrata')
plt.title('Shlukování zákazníků')

handles, labels = scatter.legend_elements(prop='colors')
named_labels = [groups[i] for i in range(len(labels))]

plt.legend(handles, named_labels, title='Skupiny zákazníků')
plt.savefig('clustering.png')
plt.show()

print_customers_in_group('Věrní a silně nakupující zákazníci')