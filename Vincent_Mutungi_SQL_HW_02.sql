USE WideWorldImporters

-- 1. Retrieve a list of customers and their sales orders
SELECT c.CustomerName AS 'Customer Name', 
	o.OrderDate AS 'Order Date'
FROM Sales.Customers AS c
	INNER JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID;

-- 2. Retrieve stock items, purchase prices, order dates, and supplier names for non-refrigerated items
SELECT si.StockItemName AS 'Stock Items', 
       pol.OrderedOuters * pol.ExpectedUnitPricePerOuter AS 'Purchase Prices', 
       po.OrderDate AS 'Order Date', 
       s.SupplierName AS 'Supplier Names; non-refrigerated items'
FROM Warehouse.StockItems AS si
	INNER JOIN Purchasing.PurchaseOrderLines AS pol ON si.StockItemID = pol.StockItemID
	INNER JOIN Purchasing.PurchaseOrders AS po ON pol.PurchaseOrderID = po.PurchaseOrderID
	INNER JOIN Purchasing.Suppliers AS s ON po.SupplierID = s.SupplierID
WHERE si.IsChillerStock = 0;

-- 3. Retrieve employee names and order numbers they serviced
SELECT p.FullName, o.[Order Key]
FROM WideWorldImporters.Application.People AS p
	INNER JOIN WideWorldImportersDW.Fact.[Order] AS o ON p.PersonID = o.[Salesperson Key]
WHERE p.IsSalesperson = 1;

-- 4. Retrieve customers from the same city
SELECT c1.CustomerName AS 'First Customer', 
	c2.CustomerName AS 'Second Customer', 
	ct.CityName AS 'City'
FROM Sales.Customers AS c1
	JOIN Sales.Customers AS c2 ON c1.DeliveryCityID = c2.DeliveryCityID AND c1.CustomerID <> c2.CustomerID
	INNER JOIN Application.Cities AS ct ON c1.DeliveryCityID = ct.CityID;

-- 5. Retrieve orders with customer names and stock items purchased
SELECT o.OrderID, 
       c.CustomerName AS 'Customer Name', 
       si.StockItemName AS 'Stock Item'
FROM Sales.Orders AS o
	INNER JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	INNER JOIN Warehouse.StockItems AS si ON ol.StockItemID = si.StockItemID
	INNER JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID;

-- 6. Retrieve invoices and customer details using implicit join
SELECT i.InvoiceID, i.InvoiceDate, c.CustomerName, 
	c.PostalAddressLine1 + ' ' + c.PostalAddressLine2 AS 'Customer Address'
FROM Sales.Invoices i, Sales.Customers c
WHERE i.CustomerID = c.CustomerID;

-- 7. Retrieve all customers and their orders (including those with no orders)
SELECT c.CustomerName AS Customer, o.OrderID, o.OrderDate
FROM Sales.Customers AS c
	LEFT JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC;

-- 8. Retrieve orders with customer and salesperson details (ensure all orders appear)
SELECT o.OrderID, si.StockItemName AS 'Item', 
       c.CustomerName, 
       p.FullName AS Salesperson
FROM Sales.Orders AS o
	LEFT JOIN Sales.Customers AS c ON o.CustomerID = c.CustomerID
	LEFT JOIN Application.People AS p ON o.SalespersonPersonID = p.PersonID
	LEFT JOIN Sales.OrderLines AS ol ON o.OrderID = ol.OrderID
	LEFT JOIN Warehouse.StockItems AS si ON ol.StockItemID = si.StockItemID
WHERE p.IsSalesperson = 1;

-- 9. Generate all possible combinations of stock items and suppliers
SELECT si.StockItemName AS 'Stock Item', 
       s.SupplierName AS 'Supplier Name'
FROM Warehouse.StockItems AS si
	CROSS JOIN Purchasing.Suppliers AS s;

-- 10a. Customers who placed an order but have not received an invoice
SELECT DISTINCT c.CustomerName AS 'Customer Name'
FROM Sales.Customers AS c
	LEFT JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Invoices AS i ON o.OrderID = i.OrderID
WHERE i.InvoiceID IS NULL;

-- 10b. Customers who placed an order and received an invoice
SELECT DISTINCT c.CustomerName AS 'Customer Name'
FROM Sales.Customers AS c
	INNER JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID
	INNER JOIN Sales.Invoices AS i ON o.OrderID = i.OrderID;
