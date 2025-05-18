-- Part 1: Set up roles and permissions for SummitStyleDB (Transactional Database)
USE SummitStyleDB;
GO

-- Create database roles
CREATE ROLE BI_Analyst;
CREATE ROLE Data_Manager;
CREATE ROLE DBA;
CREATE ROLE SQL_Developer;
CREATE ROLE Department_Head;
CREATE ROLE Data_Entry;
GO

-- Grant permissions for BI_Analyst (read-only access to sales and product data)
GRANT SELECT ON SCHEMA::Sales TO BI_Analyst;
GRANT SELECT ON SCHEMA::Production TO BI_Analyst;
GO

-- Grant permissions for Data_Manager (update and delete specific tables)
GRANT SELECT, UPDATE, DELETE ON Sales.Customer TO Data_Manager;
GRANT SELECT, UPDATE, DELETE ON Sales.SalesOrder TO Data_Manager;
GRANT SELECT, UPDATE, DELETE ON Sales.SalesOrderLine TO Data_Manager;
GRANT SELECT ON Production.Product TO Data_Manager; -- Read-only for products
GO

-- Grant permissions for DBA (full control)
GRANT CONTROL ON DATABASE::SummitStyleDB TO DBA;
GO

-- Grant permissions for SQL_Developer (create and alter stored procedures and views)
GRANT CREATE PROCEDURE, CREATE VIEW TO SQL_Developer;
GRANT ALTER ON SCHEMA::Sales TO SQL_Developer;
GRANT ALTER ON SCHEMA::Production TO SQL_Developer;
GRANT ALTER ON SCHEMA::HR TO SQL_Developer;
GO

-- Grant permissions for Department_Head (read-only access to specific views)
-- Create a sample view for department heads
CREATE VIEW Sales.SummarySalesByStore AS
SELECT 
    s.StoreName,
    SUM(so.TotalAmount) AS TotalSales
FROM Sales.SalesOrder so
JOIN Sales.Store s ON so.StoreID = s.StoreID
GROUP BY s.StoreName;
GO

GRANT SELECT ON Sales.SummarySalesByStore TO Department_Head;
GO

-- Grant permissions for Data_Entry (insert and update specific tables)
GRANT SELECT, INSERT, UPDATE ON Sales.Customer TO Data_Entry;
GRANT SELECT, INSERT, UPDATE ON Sales.SalesOrder TO Data_Entry;
GRANT SELECT, INSERT, UPDATE ON Sales.SalesOrderLine TO Data_Entry;
DENY DELETE ON Sales.Customer TO Data_Entry;
DENY DELETE ON Sales.SalesOrder TO Data_Entry;
DENY DELETE ON Sales.SalesOrderLine TO Data_Entry;
GO

-- Part 2: Set up roles and permissions for SummitStyleDW (Data Warehouse)
USE SummitStyleDW;
GO

-- Create database roles
CREATE ROLE BI_Analyst_DW;
CREATE ROLE Data_Manager_DW;
CREATE ROLE DBA_DW;
CREATE ROLE SQL_Developer_DW;
CREATE ROLE Department_Head_DW;
CREATE ROLE Data_Entry_DW;
GO

-- Grant permissions for BI_Analyst_DW (read-only access to all data)
GRANT SELECT ON SCHEMA::Fact TO BI_Analyst_DW;
GRANT SELECT ON SCHEMA::Dim TO BI_Analyst_DW;
GO

-- Grant permissions for Data_Manager_DW (update dimension tables)
GRANT SELECT, UPDATE ON Dim.CustomerDimension TO Data_Manager_DW;
GRANT SELECT, UPDATE ON Dim.ProductDimension TO Data_Manager_DW;
GRANT SELECT, UPDATE ON Dim.StoreDimension TO Data_Manager_DW;
GRANT SELECT ON Fact.SalesFact TO Data_Manager_DW; -- Read-only for facts
GO

-- Grant permissions for DBA_DW (full control)
GRANT CONTROL ON DATABASE::SummitStyleDW TO DBA_DW;
GO

-- Grant permissions for SQL_Developer_DW (create and alter stored procedures and views)
GRANT CREATE PROCEDURE, CREATE VIEW TO SQL_Developer_DW;
GRANT ALTER ON SCHEMA::Fact TO SQL_Developer_DW;
GRANT ALTER ON SCHEMA::Dim TO SQL_Developer_DW;
GO

-- Grant permissions for Department_Head_DW (read-only access to summary view)
-- Create a sample view for department heads
CREATE VIEW Fact.SummarySalesByRegion AS
SELECT s.Region, SUM(f.SalesAmount) AS TotalSales
FROM Fact.SalesFact f
JOIN Dim.StoreDimension s ON f.StoreKey = s.StoreKey
GROUP BY s.Region;
GO

GRANT SELECT ON Fact.SummarySalesByRegion TO Department_Head_DW;
GO

-- Grant permissions for Data_Entry_DW (limited access, e.g., insert into staging tables)
-- Create a sample staging table for data entry (optional, as data entry is less common in DW)
CREATE TABLE Dim.CustomerStaging (
    CustomerID INT,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    LoyaltyStatus VARCHAR(50),
    JoinDate DATE
);
GO

GRANT SELECT, INSERT, UPDATE ON Dim.CustomerStaging TO Data_Entry_DW;
DENY DELETE ON Dim.CustomerStaging TO Data_Entry_DW;
GO

-- Part 3: Create example users and assign to roles
-- Create logins (SQL Server authentication)
CREATE LOGIN Alex WITH PASSWORD = 'SecurePass123!', DEFAULT_DATABASE = SummitStyleDW;
CREATE LOGIN Sam WITH PASSWORD = 'SecurePass456!', DEFAULT_DATABASE = SummitStyleDB;
CREATE LOGIN Maria WITH PASSWORD = 'SecurePass789!', DEFAULT_DATABASE = SummitStyleDB;
CREATE LOGIN Tom WITH PASSWORD = 'SecurePass012!', DEFAULT_DATABASE = SummitStyleDW;
CREATE LOGIN Lisa WITH PASSWORD = 'SecurePass345!', DEFAULT_DATABASE = SummitStyleDB;
CREATE LOGIN Admin WITH PASSWORD = 'SecurePass678!', DEFAULT_DATABASE = SummitStyleDB;
GO

-- Create users and assign to roles in SummitStyleDB
USE SummitStyleDB;
CREATE USER Alex FOR LOGIN Alex;
CREATE USER Sam FOR LOGIN Sam;
CREATE USER Maria FOR LOGIN Maria;
CREATE USER Tom FOR LOGIN Tom;
CREATE USER Lisa FOR LOGIN Lisa;
CREATE USER Admin FOR LOGIN Admin;
GO

ALTER ROLE BI_Analyst ADD MEMBER Alex;
ALTER ROLE Data_Entry ADD MEMBER Sam;
ALTER ROLE Data_Manager ADD MEMBER Maria;
ALTER ROLE SQL_Developer ADD MEMBER Tom;
ALTER ROLE Department_Head ADD MEMBER Lisa;
ALTER ROLE DBA ADD MEMBER Admin;
GO

-- Create users and assign to roles in SummitStyleDW
USE SummitStyleDW;
CREATE USER Alex FOR LOGIN Alex;
CREATE USER Sam FOR LOGIN Sam;
CREATE USER Maria FOR LOGIN Maria;
CREATE USER Tom FOR LOGIN Tom;
CREATE USER Lisa FOR LOGIN Lisa;
CREATE USER Admin FOR LOGIN Admin;
GO

ALTER ROLE BI_Analyst_DW ADD MEMBER Alex;
ALTER ROLE Data_Entry_DW ADD MEMBER Sam;
ALTER ROLE Data_Manager_DW ADD MEMBER Maria;
ALTER ROLE SQL_Developer_DW ADD MEMBER Tom;
ALTER ROLE Department_Head_DW ADD MEMBER Lisa;
ALTER ROLE DBA_DW ADD MEMBER Admin;
GO