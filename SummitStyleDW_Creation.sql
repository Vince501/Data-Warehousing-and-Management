-- Create the data warehouse database
CREATE DATABASE SummitStyleDW;
GO

-- Switch to the new database
USE SummitStyleDW;
GO

-- Create schemas for organization
CREATE SCHEMA Fact;
GO
CREATE SCHEMA Dim;
GO

-- Create DateDimension table
CREATE TABLE Dim.DateDimension (
    DateKey INT PRIMARY KEY, -- e.g., 20230101 for Jan 1, 2023
    FullDate DATE NOT NULL,
    DayOfMonth INT NOT NULL,
    Month INT NOT NULL,
    MonthName VARCHAR(10) NOT NULL, -- e.g., January
    Quarter INT NOT NULL, -- e.g., 1 for Q1
    Year INT NOT NULL,
    DayOfWeek VARCHAR(10) NOT NULL -- e.g., Monday
);
GO

-- Create CustomerDimension table
CREATE TABLE Dim.CustomerDimension (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    CustomerID INT NOT NULL, -- From Sales.Customer
    CustomerName VARCHAR(100) NOT NULL, -- Concatenated FirstName and LastName
    Email VARCHAR(100),
    Address VARCHAR(200),
    LoyaltyStatus VARCHAR(50), -- e.g., Gold, Silver, Regular
    JoinDate DATE
);
GO

-- Create ProductDimension table
CREATE TABLE Dim.ProductDimension (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    ProductID INT NOT NULL, -- From Production.Product
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT, -- From Production.Product
    UnitPrice DECIMAL(10,2) NOT NULL,
    ActiveFlag BIT NOT NULL -- 1 = Active, 0 = Inactive
);
GO

-- Create StoreDimension table
CREATE TABLE Dim.StoreDimension (
    StoreKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    StoreID INT NOT NULL, -- From Sales.Store
    StoreName VARCHAR(100) NOT NULL,
    Region VARCHAR(50),
    OpenDate DATE,
    ManagerName VARCHAR(100) -- Concatenated FirstName and LastName from HR.Employee
);
GO

-- Create SalesFact table
CREATE TABLE Fact.SalesFact (
    SalesFactID BIGINT IDENTITY(1,1) PRIMARY KEY, -- Unique fact record ID
    OrderID INT NOT NULL, -- From Sales.SalesOrder
    CustomerKey INT NOT NULL, -- References Dim.CustomerDimension
    ProductKey INT NOT NULL, -- References Dim.ProductDimension
    StoreKey INT NOT NULL, -- References Dim.StoreDimension
    DateKey INT NOT NULL, -- References Dim.DateDimension
    SalesAmount DECIMAL(10,2) NOT NULL, -- Total revenue from the sale
    Quantity INT NOT NULL, -- Number of items sold
    CONSTRAINT FK_SalesFact_Customer FOREIGN KEY (CustomerKey) REFERENCES Dim.CustomerDimension(CustomerKey),
    CONSTRAINT FK_SalesFact_Product FOREIGN KEY (ProductKey) REFERENCES Dim.ProductDimension(ProductKey),
    CONSTRAINT FK_SalesFact_Store FOREIGN KEY (StoreKey) REFERENCES Dim.StoreDimension(StoreKey),
    CONSTRAINT FK_SalesFact_Date FOREIGN KEY (DateKey) REFERENCES Dim.DateDimension(DateKey)
);
GO

-- Create indexes for performance
CREATE NONCLUSTERED INDEX IX_SalesFact_CustomerKey ON Fact.SalesFact(CustomerKey);
CREATE NONCLUSTERED INDEX IX_SalesFact_ProductKey ON Fact.SalesFact(ProductKey);
CREATE NONCLUSTERED INDEX IX_SalesFact_StoreKey ON Fact.SalesFact(StoreKey);
CREATE NONCLUSTERED INDEX IX_SalesFact_DateKey ON Fact.SalesFact(DateKey);
GO

---- Insert sample data into DateDimension
--INSERT INTO Dim.DateDimension (DateKey, FullDate, DayOfMonth, Month, MonthName, Quarter, Year, DayOfWeek)
--VALUES 
--    (20230101, '2023-01-01', 1, 1, 'January', 1, 2023, 'Sunday'),
--    (20230102, '2023-01-02', 2, 1, 'January', 1, 2023, 'Monday'),
--    (20230615, '2023-06-15', 15, 6, 'June', 2, 2023, 'Thursday'),
--    (20231231, '2023-12-31', 31, 12, 'December', 4, 2023, 'Sunday');
--GO

---- Insert sample data into CustomerDimension
--INSERT INTO Dim.CustomerDimension (CustomerID, CustomerName, Email, Address, LoyaltyStatus, JoinDate)
--VALUES 
--    (1001, 'John Smith', 'john.smith@email.com', '123 Main St, New York', 'Gold', '2020-05-10'),
--    (1002, 'Jane Doe', 'jane.doe@email.com', '456 Oak Ave, Chicago', 'Silver', '2021-03-15'),
--    (1003, 'Michael Brown', 'michael.brown@email.com', '789 Pine Rd, Miami', 'Regular', '2022-01-20');
--GO

---- Insert sample data into ProductDimension
--INSERT INTO Dim.ProductDimension (ProductID, ProductName, CategoryID, UnitPrice, ActiveFlag)
--VALUES 
--    (3001, 'Blue T-Shirt', 101, 19.99, 1),
--    (3002, 'Wireless Headphones', 102, 99.99, 1),
--    (3003, 'Running Shoes', 103, 79.99, 1);
--GO

---- Insert sample data into StoreDimension
--INSERT INTO Dim.StoreDimension (StoreID, StoreName, Region, OpenDate, ManagerName)
--VALUES 
--    (1, 'Downtown NYC', 'Northeast', '2018-01-01', 'Alice Brown'),
--    (2, 'Chicago Central', 'Midwest', '2019-06-01', 'Bob Wilson'),
--    (3, 'Miami Beach', 'South', '2020-09-15', 'Carol Taylor');
--GO

---- Insert sample data into SalesFact
--INSERT INTO Fact.SalesFact (OrderID, CustomerKey, ProductKey, StoreKey, DateKey, SalesAmount, Quantity)
--VALUES 
--    (5001, 1, 1, 1, 20230101, 39.98, 2), -- John Smith buys 2 T-Shirts in NYC
--    (5002, 2, 2, 2, 20230102, 99.99, 1), -- Jane Doe buys Headphones in Chicago
--    (5003, 3, 3, 3, 20230615, 79.99, 1); -- Michael Brown buys Shoes in Miami
--GO