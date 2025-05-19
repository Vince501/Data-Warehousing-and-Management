USE WideWorldImporters;
GO

/* Problem 1: Create a Simple View
Objective: Understand how to define a basic view.
Task: Create a view named vw_CustomerContacts that includes
the CustomerID, CustomerName, and PhoneNumber from the Sales.Customers table. */
CREATE VIEW vw_CustomerContacts
AS SELECT CustomerID, CustomerName, PhoneNumber
FROM Sales.Customers;
GO

/* Problem 2: Restrict Access via View
Objective: Learn how to use views to restrict sensitive columns.
Task: Create a view named vw_PublicSuppliers that returns only the
SupplierID, SupplierName, and PhoneNumber from the Purchasing.Suppliers table,
excluding credit and bank-related information.*/
CREATE VIEW vw_PublicSuppliers
AS SELECT SupplierID, SupplierName, PhoneNumber
FROM Purchasing.Suppliers;
GO

/* Problem 3: Create View with a Join
Objective: Demonstrate joining tables inside a view.
Task: Create a view named vw_InvoiceDetails that joins Sales.InvoiceLines
and Sales.Invoices, returning InvoiceID, InvoiceDate, StockItemID, and Quantity. */
CREATE VIEW vw_InvoiceDetails
AS
SELECT i.InvoiceID, i.InvoiceDate, il.StockItemID, il.Quantity
FROM Sales.Invoices i
JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID;
GO

/* Problem 4: Create a View with TOP and ORDER BY
Objective: Create views that use ordering and row limits.
Task: Create a view vw_Top10ExpensiveItems that shows the
top 10 most expensive stock items by UnitPrice from Sales.InvoiceLines. */
CREATE VIEW vw_Top10ExpensiveItems
AS SELECT TOP 10 StockItemID, UnitPrice
FROM Sales.InvoiceLines
ORDER BY UnitPrice DESC;
GO

/* Problem 5: View with UNION ALL and Column Aliases
Objective: Combine multiple data sources into one view.
Context: You want to create a unified view of people who are either suppliers or customers.
Task: Create a view vw_Contacts that combines customer and
supplier contact info (name and phone), with a column indicating their role. */
CREATE VIEW vw_Contacts
AS SELECT CustomerName AS ContactName, PhoneNumber, 'Customer' AS Role
FROM Sales.Customers
UNION ALL SELECT SupplierName AS ContactName, PhoneNumber, 'Supplier' AS Role
FROM Purchasing.Suppliers;
GO

/* Problem 6: Create Summary View with SCHEMABINDING
Objective: Build a summary view that can�t be broken by schema changes.
Task: Create a view vw_SalesSummary that summarizes total invoice amounts
per customer using Sales.Invoices, with the WITH SCHEMABINDING option. */
CREATE VIEW vw_SalesSummary
WITH SCHEMABINDING
AS SELECT c.CustomerID, c.CustomerName, SUM(il.ExtendedPrice) AS TotalInvoiceAmount
FROM Sales.Customers c
JOIN Sales.Invoices i ON c.CustomerID = i.CustomerID
JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY c.CustomerID, c.CustomerName;
GO

/* Problem 7: Create an Updatable View
Objective: Understand conditions for view updateability.
Task: Create a view vw_MyTestCustomers that shows CustomerID,
CustomerName, and PhoneNumber from Sales.Customers. Then insert a new row into the view.*/
CREATE VIEW vw_MyTestCustomers
AS SELECT CustomerID, CustomerName, PhoneNumber
FROM Sales.Customers;
GO
-- Inserting new row
INSERT INTO vw_MyTestCustomers (CustomerID, CustomerName, PhoneNumber)
VALUES (1001, 'Test Customer', '(605) 123-4567');
GO --ERROR

/* Problem 8: Create a Read-Only View
Objective: Prevent data modifications via a view.
Task: Create a view vw_ReadOnlyCustomers based on
Sales.Customers that includes a computed column CustomerInfo = CustomerName + PhoneNumber. */
CREATE VIEW vw_ReadOnlyCustomers
AS SELECT CustomerName + ' ' + PhoneNumber AS CustomerInfo
FROM Sales.Customers;
GO

/* Problem 9: Modify and Delete Views
Objective: Manage view lifecycle.
Task A: Create a view vw_StaffEmails listing PersonID, FullName, and EmailAddress from Application.People.
Task B: Modify the view to include only staff with non-null email.
Task C: Drop the view. */
-- Task A: Create view
CREATE VIEW vw_StaffEmails
AS SELECT PersonID, FullName, EmailAddress
FROM Application.People;
GO
-- Task B: Modify view
ALTER VIEW vw_StaffEmails
AS SELECT PersonID, FullName, EmailAddress
FROM Application.People
WHERE EmailAddress IS NOT NULL;
GO
-- Task C: Drop view
DROP VIEW IF EXISTS vw_StaffEmails;
GO

/* Problem 10: Use Views and Catalog View
Objective: Use metadata views to explore schemas and update through a view.
Task A: Select name and schema of all views using sys.views and sys.schemas.
Task B: Update a row using a view and enforce integrity with WITH CHECK OPTION. */
-- TASK A
SELECT v.name AS ViewName, s.name AS SchemaName
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id;
-- TASK B
CREATE VIEW vw_UpdateTestCustomers
AS
SELECT CustomerID, CustomerName, PhoneNumber
FROM Sales.Customers
WHERE CustomerName LIKE 'Test%'
WITH CHECK OPTION;
GO
-- Update test data (assuming CustomerID 1001 exists from Problem 7)
UPDATE vw_UpdateTestCustomers
SET PhoneNumber = '(605) 987-6543'
WHERE CustomerID = 1001;
GO
