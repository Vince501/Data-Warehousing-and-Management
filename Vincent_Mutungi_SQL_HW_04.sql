USE WideWorldImporters

-- 1. Basic Subquery with the IN Operator
SELECT c.CustomerName, c.CustomerID
FROM Sales.Customers c
WHERE c.CustomerID IN (
    SELECT o.CustomerID
    FROM Sales.Orders o
    WHERE o.OrderDate >= DATEADD(DAY, -30, (SELECT MAX(OrderDate) FROM Sales.Orders)) --DATEADD(DAY, -30, ...) calculates the date 30 days prior.
);

-- 2. Comparing Subqueries to Joins
-- Subquery Version
SELECT DISTINCT p.FullName
FROM Application.People p
WHERE p.PersonID IN (
    SELECT o.SalespersonPersonID
    FROM Sales.Orders o
    WHERE o.OrderID IN (
        SELECT ol.OrderID
        FROM Sales.OrderLines ol
        GROUP BY ol.OrderID
        HAVING SUM(ol.UnitPrice * ol.Quantity) > 10000
    )
);
-- Join Version
SELECT DISTINCT p.FullName
FROM Application.People p
	RIGHT JOIN Sales.Orders o ON p.PersonID = o.SalespersonPersonID
	RIGHT JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
GROUP BY p.FullName, o.OrderID
HAVING SUM(ol.UnitPrice * ol.Quantity) > 10000;

--3. Subquery with Expression Comparison
SELECT StockItemID, StockItemName, UnitPrice
FROM Warehouse.StockItems
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Warehouse.StockItems);

--4. Using the ALL Keyword
SELECT c.CustomerName
FROM Sales.Customers c
JOIN Application.Cities ci ON c.DeliveryCityID = ci.CityID
WHERE EXISTS ( -- The EXISTS clause eliminates customers who are alone in their city, preventing the subquery from returning an empty set and incorrectly including them.
    SELECT 1
    FROM Sales.Customers c2
    WHERE c2.DeliveryCityID = c.DeliveryCityID AND c2.CustomerID != c.CustomerID
) AND (
    SELECT SUM(ol.UnitPrice * ol.Quantity)
    FROM Sales.Orders o
		JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
    WHERE o.CustomerID = c.CustomerID
) > ALL (
    SELECT SUM(ol2.UnitPrice * ol2.Quantity)
    FROM Sales.Orders o2
		JOIN Sales.OrderLines ol2 ON o2.OrderID = ol2.OrderID
		JOIN Sales.Customers c2 ON o2.CustomerID = c2.CustomerID
    WHERE c2.DeliveryCityID = c.DeliveryCityID AND c2.CustomerID != c.CustomerID
    GROUP BY c2.CustomerID
);

-- 5. Using ANY and SOME Keywords
-- SELECT COUNT(*) FROM Warehouse.StockItems;
SELECT si.StockItemID, si.StockItemName, si.UnitPrice
FROM Warehouse.StockItems si
WHERE si.UnitPrice > ANY (
    SELECT si2.UnitPrice
    FROM Warehouse.StockItems si2
		JOIN Warehouse.StockItemStockGroups sisg ON si2.StockItemID = sisg.StockItemID
		JOIN Warehouse.StockGroups sg ON sisg.StockGroupID = sg.StockGroupID
    WHERE sg.StockGroupName = 'Clothing'
);

-- 6. Correlated Subquery
SELECT c.CustomerID, c.CustomerName, 
       (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) AS OrderCount
FROM Sales.Customers c
WHERE (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) > 140;

-- 7. Using EXISTS Operator
SELECT c.CustomerID, c.CustomerName
FROM Sales.Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- 8. Subquery in the FROM Clause
SELECT SalespersonName, TotalSales, OrderCount
FROM (
    SELECT p.FullName AS SalespersonName,
           SUM(ol.UnitPrice * ol.Quantity) AS TotalSales,
           COUNT(DISTINCT o.OrderID) AS OrderCount
    FROM Application.People p
		JOIN Sales.Orders o ON p.PersonID = o.SalespersonPersonID
		JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
    GROUP BY p.FullName
) AS SalespersonSummary;

-- 9. Subquery in the SELECT Clause
SELECT si.StockItemID, si.StockItemName,
       (SELECT COUNT(*) FROM Sales.OrderLines ol WHERE ol.StockItemID = si.StockItemID) AS OrderCount
FROM Warehouse.StockItems si;

-- 10. Complex Query with a CTE
WITH CustomerOrderValues AS (
    SELECT c.CustomerID, c.CustomerName,
           SUM(ol.UnitPrice * ol.Quantity) AS TotalOrderValue
    FROM Sales.Customers c
		JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
		JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerID, CustomerName, TotalOrderValue
FROM CustomerOrderValues
WHERE TotalOrderValue > 350000;