use WideWorldImporters;

-- Q1
select 
	CustomerName as 'Customer Name', 
	BuyingGroupID as 'Buying Group', 
	WebsiteURL as 'Website URL'
from Sales.Customers;


-- Q2
select 
	FullName + ' - Employee' as 'Employee Full Name'
from Application.People;
-- or
select
	CONCAT(FullName, ' - Employee') as 'Employee Full Name'
from Application.People;


-- Q3
select 
	StockItemID, UnitPrice,
	UnitPrice * 0.9 as 'Discounted Price'
from Warehouse.StockItems;


-- Q4
select 
	FullName,
	LEN(FullName) as 'Name Length'
from Application.People;


-- Q5
select 
	distinct CityName as 'Cities'
from Application.Cities;


-- Q6
select top 5
	StockItemID, UnitPrice
from Warehouse.StockItems
order by UnitPrice desc;


-- Q7
select *
from Sales.Customers
where 
	BuyingGroupID > 1 AND 
	IsOnCreditHold = 0;


-- Q8
select
	StockItemName, UnitPrice
from Warehouse.StockItems
where 
	StockItemID IN(10,20,30) AND 
	UnitPrice BETWEEN 5 AND 50 AND 
	StockItemName LIKE '%Chocolate%';

-- Q9
select SupplierName
from Purchasing.Suppliers
where FaxNumber = NULL;


-- Q10
select top 10
	InvoiceID, TransactionDate, TransactionAmount as TotalAmount
from Sales.CustomerTransactions
order by
	TransactionDate desc,
	TotalAmount asc,
	InvoiceID desc;