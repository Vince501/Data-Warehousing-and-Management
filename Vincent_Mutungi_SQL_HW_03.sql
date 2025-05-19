USE WideWorldImporters;

/*Q1. Retrieve the total number of customers, average credit limit,
		maximum credit limit, and minimum credit limit from Sales.Customers. */
SELECT 
	COUNT(DISTINCT CustomerID) AS Total_No_of_Customers,
	AVG(CreditLimit) AS Average_Credit_Limit,
	MAX(CreditLimit) AS Maximum_Credit_Limit,
	MIN(CreditLimit) AS Minimum_Credit_Limit
FROM Sales.Customers;

/*Q2. List the total sales amount per customer from Sales.Invoices.
		Use ExtendedPrice from Sales.InvoiceLines to calculate sales amounts.
		Group the results by CustomerID. */
SELECT i.CustomerID,
		SUM(il.ExtendedPrice) AS Sales_Amount
FROM Sales.Invoices i
	 LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY i.CustomerID;

/*Q3. Retrieve customer IDs with total sales exceeding $50,000.
	   Using Sales.Invoices table with GROUP BY and HAVING. */
SELECT i.CustomerID,
		SUM(il.ExtendedPrice) AS Sales_Amount
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY i.CustomerID
HAVING SUM(il.ExtendedPrice) > 50000
ORDER BY Sales_Amount DESC;

/*Q4. a. List invoices where TotalDryItems > 20 using the WHERE clause.*/
-- SELECT * FROM Sales.Invoices
SELECT *
FROM Sales.Invoices
WHERE TotalDryItems > 20;
/*		b. Modify the previous query to group by CustomerID and use HAVING. */
SELECT CustomerID
FROM Sales.Invoices
GROUP BY CustomerID, TotalDryItems
HAVING TotalDryItems > 20;

/*Q5. Retrieve sales records from Sales.Invoices where:
		- TotalDryItems > 50 
			OR TotalExcludingTax is between $5,000 and $10,000,
		- AND the InvoiceDate is in 2016.*/
-- SELECT * FROM Sales.Invoices
-- SELECT * FROM Sales.InvoiceLines
SELECT i.*
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
WHERE (i.TotalDryItems > 50  OR (il.Quantity * il.UnitPrice) BETWEEN 5000 AND 10000)
  AND YEAR(InvoiceDate) = 2016;

/*Q6. Using the Sales.Invoices table, calculate the total sales by CustomerID and 
		InvoiceYear with a grand total. Use the ROLLUP operator.*/
SELECT CustomerID,
	YEAR(InvoiceDate) AS InvoiceYear,
	SUM(il.ExtendedPrice) AS TotalSales
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY ROLLUP (CustomerID, YEAR(InvoiceDate));

/*Q7. Generate a sales summary showing total sales by CustomerID and InvoiceYear, 
		including all possible subtotal combinations using the CUBE operator. */
SELECT CustomerID,
	YEAR(InvoiceDate) AS InvoiceYear,
	SUM(il.ExtendedPrice) AS TotalSales
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY CUBE (CustomerID, YEAR(InvoiceDate));

/*Q8. Produce a report with the total sales by CustomerID, by InvoiceYear, 
		and a grand total using GROUPING SETS.*/
SELECT CustomerID,
	YEAR(InvoiceDate) AS InvoiceYear,
	SUM(il.ExtendedPrice) AS TotalSales
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
GROUP BY GROUPING SETS (
    (CustomerID, YEAR(InvoiceDate)),
    (CustomerID),
    (YEAR(InvoiceDate)),
    ());

/*Q9. Show each invoice’s TotalExcludingTax and the average sales amount over all invoices 
		using the OVER() clause in the Sales.Invoices table.*/
SELECT 
    i.InvoiceID,
    (il.Quantity * il.UnitPrice) AS TotalExcludingTax,
    AVG((il.Quantity * il.UnitPrice)) OVER () AS AvgSalesAllInvoices
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID;

/*Q10. Retrieve each invoice with its total sales and the average sales per 
		CustomerID using OVER(PARTITION BY CustomerID).*/
SELECT 
    i.InvoiceID,
    i.CustomerID,
	il.ExtendedPrice,
	AVG(il.ExtendedPrice) OVER (PARTITION BY CustomerID) AS AvgSalesPerCustomer
FROM Sales.Invoices i
	LEFT JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID;