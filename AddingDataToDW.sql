-- Switch to the data warehouse database
USE SummitStyleDW;
GO

---- Clear existing data in data warehouse tables
--DELETE FROM Fact.SalesFact;
--DELETE FROM Dim.StoreDimension;
--DELETE FROM Dim.ProductDimension;
--DELETE FROM Dim.CustomerDimension;
--DELETE FROM Dim.DateDimension;
--GO

-- Populate Dim.DateDimension with all dates in 2023
DECLARE @StartDate DATE = '2023-01-01';
DECLARE @EndDate DATE = '2023-12-31';
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO Dim.DateDimension (DateKey, FullDate, DayOfMonth, Month, MonthName, Quarter, Year, DayOfWeek)
    VALUES (
        CAST(YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate) AS INT), -- DateKey, e.g., 20230101
        @CurrentDate, -- FullDate
        DAY(@CurrentDate), -- DayOfMonth
        MONTH(@CurrentDate), -- Month
        DATENAME(MONTH, @CurrentDate), -- MonthName
        DATEPART(QUARTER, @CurrentDate), -- Quarter
        YEAR(@CurrentDate), -- Year
        DATENAME(WEEKDAY, @CurrentDate) -- DayOfWeek
    );
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;
GO

-- Populate Dim.CustomerDimension from Sales.Customer
INSERT INTO Dim.CustomerDimension (CustomerID, CustomerName, Email, Address, LoyaltyStatus, JoinDate)
SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.Email,
    NULL AS Address, -- Address not provided in transactional data; set to NULL
    c.LoyaltyStatus,
    c.JoinDate
FROM SummitStyleDB.Sales.Customer c;
GO

-- Populate Dim.ProductDimension from Production.Product
INSERT INTO Dim.ProductDimension (ProductID, ProductName, CategoryID, UnitPrice, ActiveFlag)
SELECT 
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    p.UnitPrice,
    p.ActiveFlag
FROM SummitStyleDB.Production.Product p;
GO

-- Populate Dim.StoreDimension from Sales.Store and HR.Employee
INSERT INTO Dim.StoreDimension (StoreID, StoreName, Region, OpenDate, ManagerName)
SELECT 
    s.StoreID,
    s.StoreName,
    s.Region,
    s.OpenDate,
    CASE 
        WHEN s.ManagerID IS NOT NULL THEN e.FirstName + ' ' + e.LastName 
        ELSE NULL 
    END AS ManagerName
FROM SummitStyleDB.Sales.Store s
LEFT JOIN SummitStyleDB.HR.Employee e ON s.ManagerID = e.EmployeeID;
GO

-- Populate Fact.SalesFact from Sales.SalesOrder, Sales.SalesOrderLine, and dimension tables
INSERT INTO Fact.SalesFact (OrderID, CustomerKey, ProductKey, StoreKey, DateKey, SalesAmount, Quantity)
SELECT 
    sol.SalesOrderID AS OrderID,
    cd.CustomerKey,
    pd.ProductKey,
    sd.StoreKey,
    dd.DateKey,
    sol.LineTotal AS SalesAmount,
    sol.Quantity
FROM SummitStyleDB.Sales.SalesOrderLine sol
JOIN SummitStyleDB.Sales.SalesOrder so ON sol.SalesOrderID = so.SalesOrderID
JOIN Dim.CustomerDimension cd ON so.CustomerID = cd.CustomerID
JOIN Dim.ProductDimension pd ON sol.ProductID = pd.ProductID
JOIN Dim.StoreDimension sd ON so.StoreID = sd.StoreID
JOIN Dim.DateDimension dd ON CAST(so.OrderDate AS DATE) = dd.FullDate;
GO