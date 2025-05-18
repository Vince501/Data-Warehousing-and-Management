-- Create the transactional database
CREATE DATABASE SummitStyleDB;
GO

-- Switch to the new database
USE SummitStyleDB;
GO

-- Create schemas
CREATE SCHEMA Sales;
GO
CREATE SCHEMA Production;
GO
CREATE SCHEMA HR;
GO

-- Create Sales.Customer table
CREATE TABLE Sales.Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    JoinDate DATE,
    LoyaltyStatus VARCHAR(20) -- e.g., Gold, Silver, Regular
);
GO

-- Create Sales.Store table
CREATE TABLE Sales.Store (
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    Region VARCHAR(50),
    OpenDate DATE,
    ManagerID INT -- Will reference HR.Employee
);
GO

-- Create HR.Employee table
CREATE TABLE HR.Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50), -- e.g., Manager, Sales Associate
    StoreID INT,
    CONSTRAINT FK_Employee_Store FOREIGN KEY (StoreID) REFERENCES Sales.Store(StoreID)
);
GO

-- Add foreign key constraint to Sales.Store for ManagerID
ALTER TABLE Sales.Store
ADD CONSTRAINT FK_Store_Employee FOREIGN KEY (ManagerID) REFERENCES HR.Employee(EmployeeID);
GO

-- Create Production.Product table
CREATE TABLE Production.Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT, -- Could reference a Category table if needed
    UnitPrice DECIMAL(10,2) NOT NULL,
    ActiveFlag BIT NOT NULL DEFAULT 1 -- 1 = Active, 0 = Inactive
);
GO

-- Create Sales.SalesOrder table
CREATE TABLE Sales.SalesOrder (
    SalesOrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    StoreID INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(20) DEFAULT 'Pending', -- e.g., Pending, Completed
    CONSTRAINT FK_SalesOrder_Customer FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID),
    CONSTRAINT FK_SalesOrder_Store FOREIGN KEY (StoreID) REFERENCES Sales.Store(StoreID)
);
GO

-- Create Sales.SalesOrderLine table
CREATE TABLE Sales.SalesOrderLine (
    SalesOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    SalesOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal DECIMAL(10,2) NOT NULL, -- Quantity * UnitPrice
    CONSTRAINT FK_SalesOrderLine_SalesOrder FOREIGN KEY (SalesOrderID) REFERENCES Sales.SalesOrder(SalesOrderID),
    CONSTRAINT FK_SalesOrderLine_Product FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID)
);
GO

-- Create indexes for performance
CREATE NONCLUSTERED INDEX IX_SalesOrder_CustomerID ON Sales.SalesOrder(CustomerID);
CREATE NONCLUSTERED INDEX IX_SalesOrder_StoreID ON Sales.SalesOrder(StoreID);
CREATE NONCLUSTERED INDEX IX_SalesOrderLine_SalesOrderID ON Sales.SalesOrderLine(SalesOrderID);
CREATE NONCLUSTERED INDEX IX_SalesOrderLine_ProductID ON Sales.SalesOrderLine(ProductID);
CREATE NONCLUSTERED INDEX IX_Employee_StoreID ON HR.Employee(StoreID);
GO

-- Insert sample data into Sales.Customer
INSERT INTO Sales.Customer (CustomerID, FirstName, LastName, Email, JoinDate, LoyaltyStatus)
VALUES 
    (1001, 'John', 'Smith', 'john.smith@email.com', '2020-05-10', 'Gold'),
    (1002, 'Jane', 'Doe', 'jane.doe@email.com', '2021-03-15', 'Silver');
GO

-- Insert sample data into Sales.Store (ManagerID will be updated later)
INSERT INTO Sales.Store (StoreID, StoreName, Region, OpenDate, ManagerID)
VALUES 
    (1, 'Downtown NYC', 'Northeast', '2018-01-01', NULL),
    (2, 'Chicago Central', 'Midwest', '2019-06-01', NULL);
GO

-- Insert sample data into HR.Employee
INSERT INTO HR.Employee (EmployeeID, FirstName, LastName, Position, StoreID)
VALUES 
    (2001, 'Alice', 'Brown', 'Manager', 1),
    (2002, 'Bob', 'Wilson', 'Sales Associate', 2);
GO

-- Update Sales.Store with ManagerID
UPDATE Sales.Store SET ManagerID = 2001 WHERE StoreID = 1;
UPDATE Sales.Store SET ManagerID = 2002 WHERE StoreID = 2;
GO

-- Insert sample data into Production.Product
INSERT INTO Production.Product (ProductID, ProductName, CategoryID, UnitPrice, ActiveFlag)
VALUES 
    (3001, 'Blue T-Shirt', 101, 19.99, 1),
    (3002, 'Wireless Headphones', 102, 99.99, 1);
GO

-- Insert sample data into Sales.SalesOrder
INSERT INTO Sales.SalesOrder (SalesOrderID, CustomerID, OrderDate, StoreID, TotalAmount, OrderStatus)
VALUES 
    (5001, 1001, '2023-01-01 10:00:00', 1, 139.97, 'Completed'),
    (5002, 1002, '2023-06-15 14:30:00', 2, 99.99, 'Completed');
GO

-- Insert sample data into Sales.SalesOrderLine
INSERT INTO Sales.SalesOrderLine (SalesOrderID, ProductID, Quantity, UnitPrice, LineTotal)
VALUES 
    (5001, 3001, 2, 19.99, 39.98),
    (5001, 3002, 1, 99.99, 99.99),
    (5002, 3002, 1, 99.99, 99.99);
GO
