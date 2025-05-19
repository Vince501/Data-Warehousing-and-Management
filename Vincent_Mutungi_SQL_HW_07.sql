-- SQL Assignment 7
USE WideWorldImporters;

/*Query 1: Advanced String Manipulation with CTE
Description: Extract the domain name from the EmailAddress column in the Application.People table and count the number of occurrences of each domain.

Concepts: CHARINDEX, SUBSTRING, CTE, COUNT, GROUP BY
*/
WITH EmailDomains AS ( 
    SELECT 
        SUBSTRING(
            EmailAddress, 
            CHARINDEX('@', EmailAddress) + 1, --finds the position of the @ symbol
            LEN(EmailAddress) --extracts everything after the @ (the domain)
        ) AS DomainName
    FROM Application.People
    WHERE EmailAddress IS NOT NULL
) --CTE
SELECT 
    DomainName,
    COUNT(*) AS DomainCount --counts the occurrences of each domain
FROM EmailDomains
GROUP BY DomainName
ORDER BY DomainCount DESC;

/*Query 2: Complex String Problem Solving with Subquery
Description: Find the top 5 customers with the longest CustomerName in the Sales.Customers table.

Concepts: LEN, ORDER BY, TOP
*/
SELECT TOP 5 --Limits the result to the top 5 customers
    CustomerID, CustomerName,
    LEN(CustomerName) AS NameLength --Calculates the length of each customer s name
FROM Sales.Customers
WHERE CustomerName IS NOT NULL
ORDER BY NameLength DESC;

/*Query 3: Advanced Numeric Data Handling with Window Functions
Description: Calculate the average UnitPrice for each StockItemID 
in the Sales.OrderLines table, rounded to 2 decimal places, 
and include the overall average UnitPrice for all items.

Concepts: AVG, ROUND, GROUP BY, OVER
*/
SELECT 
    StockItemID,
    ROUND(AVG(UnitPrice), 2) AS AvgUnitPrice,
    ROUND(AVG(UnitPrice) OVER (), 2) AS OverallAvgUnitPrice
FROM Sales.OrderLines
GROUP BY StockItemID ,UnitPrice;

/* Query 4: Floating-Point Number Search with Conditions and Subquery
Description: Find all StockItems in the Warehouse.StockItems table 
where the RecommendedRetailPrice is a floating-point number and 
greater than the average RecommendedRetailPrice.

Concepts: ISNUMERIC, CAST, AVG, SUBQUERY
*/
SELECT 
    StockItemID, StockItemName, RecommendedRetailPrice
FROM Warehouse.StockItems
WHERE 
    ISNUMERIC(RecommendedRetailPrice) = 1 --Ensures RecommendedRetailPrice is a numeric value
    AND RecommendedRetailPrice > (
        SELECT AVG(CAST(RecommendedRetailPrice AS DECIMAL(10, 2))) -- Calculates the average ensuring it a 2 decimal
        FROM Warehouse.StockItems
        WHERE ISNUMERIC(RecommendedRetailPrice) = 1
    )
ORDER BY RecommendedRetailPrice DESC;

/*Query 5: Advanced Date/Time Data Handling with CTE
Description: Calculate the number of days between the InvoiceDate and 
the current date for each invoice in the Sales.Invoices table and 
categorize them into 'Recent' (within 30 days) and 'Old' (more than 30 days).

Concepts: DATEDIFF, GETDATE, CTE, CASE
*/
WITH InvoiceAge AS (
    SELECT 
        InvoiceID, InvoiceDate,
        DATEDIFF(DAY, InvoiceDate, GETDATE()) AS DaysSinceInvoice
		-- Calculates the number of days between InvoiceDate and the current date (GETDATE())
    FROM Sales.Invoices
) --CTE
SELECT 
    InvoiceID, InvoiceDate, DaysSinceInvoice,
    CASE --Categorizes invoices as 'Recent' (? 30 days) or 'Old' (> 30 days)
        WHEN DaysSinceInvoice <= 30 THEN 'Recent'
        ELSE 'Old'
    END AS InvoiceAgeCategory
FROM InvoiceAge
ORDER BY DaysSinceInvoice;

/* Query 6: Parsing and Formatting Dates with Subquery
Description: Using the InvoiceDate column in the Sales.Invoices table, 
find the month with the highest number of invoices.

Concepts: DATENAME, MONTH, GROUP BY, COUNT, ORDER BY, TOP
*/
SELECT TOP 1 --Returns only the month with the highest count
    DATENAME(MONTH, InvoiceDate) AS InvoiceMonth, --Extracts the month name from InvoiceDate
    -- YEAR(InvoiceDate) AS InvoiceYear, --Extracts the year
    COUNT(*) AS InvoiceCount --Counts the number of invoices for each month-year combination
FROM Sales.Invoices
GROUP BY DATENAME(MONTH, InvoiceDate) --, YEAR(InvoiceDate)
ORDER BY InvoiceCount DESC; --get the highest count first

/* Query 7: Advanced Date Operations with Window Functions
Description: Calculate the end of the month for each InvoiceDate 
in the Sales.Invoices table and find the running total of invoices for each month.

Concepts: EOMONTH, COUNT, OVER, PARTITION BY
*/
SELECT 
    EOMONTH(InvoiceDate) AS EndOfMonth,
    COUNT(*) AS MonthlyInvoices,
    SUM(COUNT(*)) OVER (ORDER BY EOMONTH(InvoiceDate)) AS RunningTotal
FROM Sales.Invoices
GROUP BY EOMONTH(InvoiceDate)
ORDER BY RunningTotal DESC;

/* Query 8: Complex CASE Expression with Joins
Description: Categorize StockItems based on their QuantityPerOuter and 
RecommendedRetailPrice in the Warehouse.StockItems table and include 
the supplier name from the Purchasing.Suppliers table.

Concepts: CASE, JOIN
*/
SELECT 
    s.StockItemID, s.StockItemName, s.QuantityPerOuter, s.RecommendedRetailPrice, sup.SupplierName,
    CASE 
        WHEN s.QuantityPerOuter > 50 AND s.RecommendedRetailPrice > 100 THEN 'High Value Bulk'
        WHEN s.QuantityPerOuter > 50 THEN 'Bulk'
        WHEN s.RecommendedRetailPrice > 100 THEN 'High Value'
        ELSE 'Standard'
    END AS StockCategory
FROM Warehouse.StockItems s
JOIN Purchasing.Suppliers sup
ON s.SupplierID = sup.SupplierID
ORDER BY StockCategory;

/* Query 9: Advanced COALESCE Usage with Window Functions
Description: Replace NULL values in the CustomerCategoryID 
column of the Sales.Customers table with the average CustomerCategoryID 
and include the overall average for reference.

Concepts: COALESCE, AVG, OVER
*/
SELECT 
    CustomerID, CustomerName, CustomerCategoryID AS OriginalCategoryID,
    COALESCE( --Replaces NULL values in CustomerCategoryID with the average CustomerCategoryID
        CustomerCategoryID, ROUND(AVG(CAST(CustomerCategoryID AS DECIMAL(10, 2))) OVER (), 0)
		-- Calculates the average across all rows
    ) AS AdjustedCategoryID,
    ROUND(AVG(CAST(CustomerCategoryID AS DECIMAL(10, 2))) OVER (), 0) AS OverallAvgCategoryID
FROM Sales.Customers
ORDER BY CustomerID;

/* Query 10: Advanced Ranking Functions with CTE and Subquery
Description: Rank Customers based on their total InvoiceAmount in descending order, 
and include only those customers whose total invoice amount is above the average. 
Use the Sales.Customers, Sales.Invoices, and Sales.InvoiceLines tables.

Concepts: RANK, SUM, OVER, JOIN, CTE, SUBQUERY
*/
WITH CustomerTotals AS ( 
    SELECT 
        c.CustomerID, c.CustomerName,
        SUM(il.Quantity * il.UnitPrice) AS TotalInvoiceAmount
    FROM Sales.Customers c
    JOIN Sales.Invoices i ON c.CustomerID = i.CustomerID
    JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
    GROUP BY c.CustomerID, c.CustomerName
) --CTE
SELECT 
    CustomerID, CustomerName, TotalInvoiceAmount,
	--Ranks customers by their total invoice amount in descending order.
    RANK() OVER (ORDER BY TotalInvoiceAmount DESC) AS InvoiceRank 
FROM CustomerTotals
WHERE TotalInvoiceAmount > ( --Subquery
    SELECT AVG(TotalInvoiceAmount)
    FROM CustomerTotals
)
ORDER BY TotalInvoiceAmount DESC;

--WITH CustomerTotals AS (
--    SELECT 
--        c.CustomerID,c.CustomerName,
--        SUM(il.ExtendedPrice) AS TotalInvoiceAmount
--    FROM Sales.Customers c
--    JOIN Sales.Invoices i ON c.CustomerID = i.CustomerID
--    JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
--    GROUP BY c.CustomerID, c.CustomerName
--),
--AboveAverage AS (
--    SELECT *, 
--        RANK() OVER (ORDER BY TotalInvoiceAmount DESC) AS Rank
--    FROM CustomerTotals
--    WHERE TotalInvoiceAmount > (SELECT AVG(TotalInvoiceAmount) FROM CustomerTotals)
--)
--SELECT * FROM AboveAverage;