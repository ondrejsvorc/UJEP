-- Shlukování zákazníků
SELECT CustomerID, COUNT(*) AS PurchaseCount, SUM(TotalValue) AS TotalSpent
FROM FactTransactions
GROUP BY CustomerID
ORDER BY CustomerID;