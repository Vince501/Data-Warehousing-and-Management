USE WideWorldImporters;
/*
1.	Write a query to retrieve a list of customers and their sales orders, displaying the customer name and order date. Use table aliases for readability.
a.	Tables: Sales.Customers, Sales.Orders
*/
select c.CustomerName, 
	o.OrderDate
from Sales.Customers as c
	join Sales.Orders as o on c.CustomerID = o.CustomerID;

	/*
2.	Retrieve a list of stock items, purchase prices, order dates, and supplier names for items that do not require refrigeration.
a.	Tables: Warehouse.StockItems, Purchasing.PurchaseOrderLines, Purchasing.PurchaseOrders, Purchasing.Suppliers
b.	The PurchaseOrderLines table links stock items to purchase orders, which in turn links to suppliers.
*/
select s.StockItemName,
	l.OrderedOuters*l.ExpectedUnitPricePerOuter as 'Purchase prices', 
	p.OrderDate, sp.SupplierName
from Warehouse.StockItems as s
	join Purchasing.PurchaseOrderLines as l on s.StockItemID = l.StockItemID
	join Purchasing.PurchaseOrders as p on l.PurchaseOrderID = p.PurchaseOrderID
	join Purchasing.Suppliers as sp on p.SupplierID = sp.SupplierID
WHERE s.IsChillerStock = 0;

/*
3.	Retrieve the names of employees from the WideWorldImporters database along with the order numbers they serviced in the WideWorldImportersDW database.
a.	Tables: WideWorldImporters.Application.People, WideWorldImportersDW.Fact.[Order]
*/
select p.FullName, wm.[Order Key]
from WideWorldImporters.Application.People as p
	join WideWorldImportersDW.Fact.[Order] as wm on p.PersonID = wm.SalespersonPersonID;

/*
4.	Retrieve a list of customers located in the same city as another customer. The output should include:
a.	The first customer's name.
b.	The second customer's name (who is from the same city).
c.	The city they both share.
d.	Tables: Sales, Customers, Application, Cities. To join the tables, use DeliveryCityID from the Customers table.
*/
select a.CustomerName as First_Customer, b.CustomerName as Second_Customer, ct.CityName
from Sales.Customers as a
	join Sales.Customers as b on a.DeliveryCityID = b.DeliveryCityID AND a.CustomerID <> b.CustomerID
	join Application.Cities as ct on a.DeliveryCityID = ct.CityID;

/*
5.	Retrieve a list of orders along with customer names and the stock items they purchased.
a.	Tables: Sales.Orders, Sales.OrderLines, Warehouse.StockItems, Sales.Customers
*/
select o.OrderID, c.CustomerName, s.StockItemName
from Sales.Orders as o
	join Sales.OrderLines as l on o.OrderID = l.OrderID
	join Warehouse.StockItems as s on l.StockItemID = s.StockItemID
	join Sales.Customers as c on o.CustomerID = c.CustomerID;

/*
6.	Retrieve a list of invoices along with customer details using implicit join syntax instead of INNER JOIN.
a.	Tables: Sales.Invoices, Sales.Customers
*/

select i.InvoiceID, i.InvoiceDate , c.CustomerName,c.PostalAddressLine1 +' ' + c.PostalAddressLine2 as 'Customer Address'
from Sales.Invoices i, Sales.Customers c
where i.CustomerID = c.CustomerID;

/*
7.	Retrieve a list of customers and their orders, ensuring that all customers appear in the output, even if they have no orders.
a.	Tables: Sales.Customers, Sales.Orders
*/
select c.CustomerName, o.OrderID
from Sales.Customers as c
	left join Sales.Orders as o on c.CustomerID = o.CustomerID;

	/*
8.	Retrieve a list of orders, including details of the customer and salesperson,
ensuring that all orders appear even if the customer or salesperson information is missing.
a.	Tables: Sales.Orders, Sales.Customers, HumanResources.Employees
*/
select o.OrderID, st.StockItemName, c.CustomerName, p.FullName as Salesperson
from Sales.Orders as o
	left join Sales.Customers as c on o.CustomerID = c.CustomerID
	left join Application.People as p on o.SalespersonPersonID = p.PersonID
	left join Sales.OrderLines as ol on o.OrderID=ol.OrderID
	left join Warehouse.StockItems as st on ol.StockItemID=st.StockItemID
where p.IsSalesperson=1

/*
9.	Generate a combination of all possible stock items and suppliers.
a.	Tables: Warehouse.StockItems, Purchasing.Suppliers
*/
select t.StockItemName, s.SupplierName
from Warehouse.StockItems as t
	cross join Purchasing.Suppliers as s;

/*
10.	Retrieve:
a.	A list of customers who have placed an order but have not received an invoice.
b.	A list of customers who have placed an order and also received an invoice.
c.	Tables: Sales.Customers, Sales.Orders, Sales.Invoices
*/
--Part a 

select distinct c.CustomerName
from Sales.Customers as c
	inner join Sales.Orders as o on c.CustomerID = o.CustomerID
	left join Sales.Invoices as i on o.OrderID = i.OrderID
where i.InvoiceID IS NULL;

--Part b
select distinct c.CustomerName
from Sales.Customers as c
	inner join Sales.Orders as o on  c.CustomerID = o.CustomerID
	inner join Sales.Invoices as i on o.OrderID = i.OrderID



