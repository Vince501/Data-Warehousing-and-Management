USE AdventureWorks2022

/* Step 1: Identify Relevant Tables */
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person
SELECT * FROM Person.Address
SELECT * FROM Person.StateProvince
SELECT * FROM Person.CountryRegion
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesTerritory
SELECT * FROM Person.BusinessEntityAddress
/*
Based on the AdventureWorks2019 database schema, the relevant tables for RFM analysis include:
- Sales.Customer: Contains customer ID and related information.
- Person.Person: Stores first and last names of customers.
- Person.Address: Stores address details.
- Person.StateProvince: Provides province information.
- Person.CountryRegion: Provides country details.
- Sales.SalesOrderHeader: Contains order details including OrderDate and TotalDue.
- Sales.SalesTerritory: Contains Territory ID for mapping addresses
- Person.BusinessEntityAddress: Maps persons to addresses
*/

-- Step 2: Retrieve Customers Living in France
SELECT c.CustomerID, p.FirstName, p.LastName, a.AddressLine1, a.City, a.PostalCode AS Zip,
       sp.Name AS ProvinceName, cr.Name AS Country
FROM Sales.Customer c
	JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
	JOIN Person.Address a ON c.CustomerID = a.AddressID
	JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
	JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';

-- Step 3: Retrieve Customers' Order Count and Total Spending
SELECT soh.CustomerID, (p.FirstName + ' ' + p.LastName) AS CustomerName, COUNT(soh.SalesOrderID) AS NumberOfOrders, SUM(soh.TotalDue) AS TotalMoneySpent
FROM Sales.SalesOrderHeader soh
	JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
	JOIN Sales.SalesTerritory st ON c.TerritoryID = st.TerritoryID 
WHERE st.Name = 'France' -- Filters by country France
GROUP BY soh.CustomerID, p.FirstName, p.LastName;

-- Step 4: Retrieve Data for RFM Analysis
SELECT c.CustomerID, (p.FirstName + ' ' + p.LastName) AS 'Customer Name', a.City, cr.Name AS Country, 
       COUNT(soh.SalesOrderID) AS 'Number Of Orders', 
       SUM(soh.TotalDue) AS 'Total Dollars Spent', 
       MAX(soh.OrderDate) AS 'Last Order Date'
FROM Sales.Customer c
	JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
	JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
	JOIN Person.Address a ON bea.AddressID = a.AddressID
	JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
	JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
	JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE cr.Name = 'France' -- Filters by country France
GROUP BY c.CustomerID, p.FirstName, p.LastName, a.City, cr.Name, soh.OrderDate
ORDER BY soh.OrderDate DESC;