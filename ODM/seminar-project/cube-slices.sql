-- Řez 1: Celkové tržby podle roku
SELECT Year, SUM(TotalValue) AS Revenue
FROM FactTransactions
JOIN DimDate ON FactTransactions.DateKey = DimDate.DateKey
GROUP BY Year
ORDER BY Year;

-- Řez 2: Počet transakcí podle regionu
SELECT Region, COUNT(*) AS TransactionCount
FROM FactTransactions
JOIN DimCustomers ON FactTransactions.CustomerID = DimCustomers.CustomerID
GROUP BY Region
ORDER BY TransactionCount DESC;

-- Řez 3: Průměrná cena produktů podle kategorie
SELECT Category, round(AVG(Price), 2) AS AveragePrice
FROM FactTransactions
JOIN DimProducts ON FactTransactions.ProductID = DimProducts.ProductID
GROUP BY Category
ORDER BY AveragePrice DESC;

-- Řez 4: Tržby podle části týdne (víkend vs. pracovní dny)
SELECT CASE WHEN IsWeekend = 1 THEN 'Weekend' ELSE 'Workdays' END AS DayType, SUM(TotalValue) AS Revenue
FROM FactTransactions
JOIN DimDate ON FactTransactions.DateKey = DimDate.DateKey
GROUP BY DayType
ORDER BY Revenue DESC;

-- Řez 5: Tržby podle měsíce a kategorie produktu
SELECT Month, Category, SUM(TotalValue) AS Revenue
FROM FactTransactions
JOIN DimDate ON FactTransactions.DateKey = DimDate.DateKey
JOIN DimProducts ON FactTransactions.ProductID = DimProducts.ProductID
GROUP BY Month, Category
ORDER BY Month, Revenue DESC;

-- Řez 6: Počet transakcí podle kontinentu a víkendu
SELECT Region, CASE WHEN IsWeekend = 1 THEN 'Weekend' ELSE 'Workdays' END AS DayType, COUNT(*) AS TransactionCount
FROM FactTransactions
JOIN DimCustomers ON FactTransactions.CustomerID = DimCustomers.CustomerID
JOIN DimDate ON FactTransactions.DateKey = DimDate.DateKey
GROUP BY Region, DayType
ORDER BY Region, TransactionCount DESC;