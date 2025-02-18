IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'EverMart') CREATE DATABASE EverMart;
GO
USE EverMart;
GO

CREATE TABLE Customers (
    CustomerID NVARCHAR(50) NOT NULL,
    CustomerName NVARCHAR(255),
    Region NVARCHAR(100),
    SignupDate DATE
);
CREATE TABLE Products (
    ProductID NVARCHAR(50) NOT NULL,
    ProductName NVARCHAR(255),
    Category NVARCHAR(100),
    Price DECIMAL(10,2)
);
CREATE TABLE Transactions (
    TransactionID NVARCHAR(50) NOT NULL,
    CustomerID NVARCHAR(50),
    ProductID NVARCHAR(50),
    TransactionDate DATE,
    Quantity INT,
    TotalValue DECIMAL(10,2),
    Price DECIMAL(10,2)
);
GO

BULK INSERT Customers FROM 'C:\Users\ondre\source\repos\git\UJEP\ODM\seminar-project\eCommerceTransactions\Dataset\Customers.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
BULK INSERT Products FROM 'C:\Users\ondre\source\repos\git\UJEP\ODM\seminar-project\eCommerceTransactions\Dataset\Products.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
BULK INSERT Transactions FROM 'C:\Users\ondre\source\repos\git\UJEP\ODM\seminar-project\eCommerceTransactions\Dataset\Transactions.csv' WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', CODEPAGE = '65001');
GO

ALTER TABLE Customers ADD CONSTRAINT PK_Customers PRIMARY KEY (CustomerID);
ALTER TABLE Products ADD CONSTRAINT PK_Products PRIMARY KEY (ProductID);
ALTER TABLE Transactions ADD CONSTRAINT PK_Transactions PRIMARY KEY (TransactionID);
ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);
ALTER TABLE Transactions ADD CONSTRAINT FK_Transactions_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID);