USE WideWorldImporters;
GO

/* 1. Declare and Use Scalar Variables
	Objective: Demonstrate the use of scalar variables in a script.
	Description: Declare a scalar variable named @AvgUnitPrice and 
	assign it the average UnitPrice from the Sales.InvoiceLines table. 
	Display the value of the variable using a SELECT statement. 
	This exercise helps you understand scalar variable declaration, assignment, and output.*/
DECLARE @AvgUnitPrice DECIMAL(18,2); -- Declares a scalar variable @AvgUnitPrice with DECIMAL type (18 digits, 2 decimal places).
SET @AvgUnitPrice = (SELECT AVG(UnitPrice) FROM Sales.InvoiceLines); -- Assigns the average UnitPrice from the Sales.InvoiceLines using a subquery.
SELECT @AvgUnitPrice AS AverageUnitPrice; -- Displays the value of @AvgUnitPrice, aliased as AverageUnitPrice.
GO -- Batch separator


/* 2. Use Table Variables
	Objective: Use table variables to store and manipulate data.
	Description: Define a table variable to capture the top 5 customers 
	based on the sum of ExtendedPrice. Join the Sales.InvoiceLines table with Sales.
	Invoices to get the CustomerID. Group by CustomerID and use an ORDER BY clause 
	with OFFSET FETCH to select only the top 5. Then display the results. 
	This will help you learn how to work with table variables and aggregate joins.*/
DECLARE @Top5Customers TABLE (CustomerID INT, TotalExtendedPrice DECIMAL(18,2)); -- Declares a table variable @Top5Customers with two columnS.
INSERT INTO @Top5Customers
	SELECT i.CustomerID, SUM(il.ExtendedPrice) AS TotalExtendedPrice
	FROM Sales.Invoices i
	JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
	GROUP BY i.CustomerID
	ORDER BY TotalExtendedPrice DESC
	OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY; -- Limits the result to the top 5 rows, starting from the first row (offset 0).
SELECT * FROM @Top5Customers; -- Displays from the @Top5Customers table variable.
GO

/* 3. Use Temporary Tables
	Objective: Work with temporary tables and populate data from an existing table.
	Description: Create a temporary table named #HeavyStockItems that includes StockItemID, 
	StockItemName, and TypicalWeightPerUnit for all stock items where the typical weight per unit 
	is greater than 500 from the Warehouse.StockItems table. Display the contents and drop the table afterward. 
	This reinforces how to use SELECT INTO for temp table creation and cleanup.*/
SELECT StockItemID, StockItemName, TypicalWeightPerUnit
	INTO #HeavyStockItems -- Creates a temporary table #HeavyStockItems.
	FROM Warehouse.StockItems
	WHERE TypicalWeightPerUnit > 500;
SELECT * FROM #HeavyStockItems; -- Displays from the #HeavyStockItems temporary table.

DROP TABLE #HeavyStockItems; -- Drops the #HeavyStockItems temporary table to clean up.
GO

/* 4. Conditional Script Execution
	Objective: Demonstrate conditional logic using IF...ELSE statements.
	Description: Count how many invoices exist in the Sales.Invoices table. 
	If the count is greater than 1000, print a message stating that. Otherwise, 
	print a message indicating fewer invoices. 
	This teaches you to use IF...ELSE logic with scalar variables and PRINT statements.*/
DECLARE @InvoiceCount INT; -- Declares a scalar variable @InvoiceCount.
SET @InvoiceCount = (SELECT COUNT(*) FROM Sales.Invoices); -- Assigns the total count of rows in Sales.Invoices to @InvoiceCount using a subquery.
IF @InvoiceCount > 1000
    PRINT 'There are more than 1000 invoices in the Sales.Invoices table.';
ELSE
    PRINT 'There are 1000 or fewer invoices in the Sales.Invoices table.';
GO

/* 5. Existence Check for Object
	Objective: Use IF EXISTS to test for an object before creating or dropping it.
	Description: Check for the existence of a temporary table named #TestTable using OBJECT_ID. 
	If it exists, drop it. Then create a new temporary table with columns ID (int) and Name (nvarchar). 
	This is useful for ensuring repeatable scripts. */
IF OBJECT_ID('tempdb..#TestTable') IS NOT NULL -- Checks if the temporary table #TestTable exists in the tempdb database.
    DROP TABLE #TestTable; -- Drops the #TestTable if it exists to avoid errors on creation.
CREATE TABLE #TestTable (ID INT, Name NVARCHAR(100)); -- Creates a new temporary table #TestTable.
SELECT * FROM #TestTable; -- Displays the contents of #TestTable (will be empty since no data is inserted).
GO

/* 6. Repetitive Processing with WHILE
	Objective: Demonstrate the use of WHILE loop for repetition.
	Description: Use a WHILE loop to print the numbers 1 to 5. Store a counter variable and 
	increment it in each loop iteration. Use PRINT statements to output each number. 
	This demonstrates repetitive logic and basic loop constructs.*/
DECLARE @Counter INT = 1; -- Declares a scalar variable @Counter and initializes it to 1.
WHILE @Counter <= 5
BEGIN -- Marks the start of the loop body.
    PRINT CAST(@Counter AS NVARCHAR(10)); -- Prints the current value of @Counter, casting it to NVARCHAR.
    SET @Counter = @Counter + 1; -- Increments @Counter by 1 for the next iteration.
END; -- Marks the end of the loop body.
GO

/* 7. Cursor Usage
	Objective: Use a cursor to iterate through a result set.
	Description: Declare and use a cursor to fetch and print customer names one-by-one from the Sales.Customers table. 
	This exercise demonstrates cursor declaration, fetching, iteration, and cleanup using CLOSE and DEALLOCATE.*/
DECLARE @CustomerName NVARCHAR(100); -- Declares a variable @CustomerName to store each customer name fetched by the cursor.
DECLARE CustomerCursor CURSOR FOR -- Declares a cursor named CustomerCursor to iterate through a result set.
SELECT CustomerName FROM Sales.Customers;
OPEN CustomerCursor; -- Opens the cursor to make it ready for fetching rows.
FETCH NEXT FROM CustomerCursor INTO @CustomerName; -- Fetches the first row from the cursor and stores the CustomerName in @CustomerName.
WHILE @@FETCH_STATUS = 0 -- Begins a loop that continues as long as the last fetch was successful (@@FETCH_STATUS = 0).
BEGIN
    PRINT @CustomerName; -- Prints the current CustomerName fetched by the cursor.
    FETCH NEXT FROM CustomerCursor INTO @CustomerName; -- Fetches the next row from the cursor into @CustomerName.
END;
CLOSE CustomerCursor; -- Closes the cursor to release the result set.
DEALLOCATE CustomerCursor; -- Deallocates the cursor to free resources.
GO

/* 8. Error Handling
	Objective: Use TRY...CATCH to handle errors in scripts.
	Description: Use a TRY...CATCH block to attempt a division by zero operation. If an error occurs, catch it and 
	print an informative error message. 
	This reinforces error detection and graceful handling of unexpected issues.*/
BEGIN TRY -- Starts a TRY block to attempt a potentially error-prone operation.
    DECLARE @Result INT = 1 / 0; -- Attempts a division by zero, which will raise an error.
END TRY -- Marks the end of the TRY block.
BEGIN CATCH -- Starts a CATCH block to handle any errors that occur in the TRY block.
    PRINT 'Error occurred: ' + ERROR_MESSAGE(); -- Prints an error message, including the specific error details from ERROR_MESSAGE().
END CATCH; -- Marks the end of the CATCH block.
GO

/* 9. Session Settings
	Objective: Use SET statements to configure session options.
	Description: Use SET NOCOUNT ON to prevent the row count message from being returned during insert operations. 
	Create a temporary table, insert a value, then display the contents. Drop the table and turn SET NOCOUNT OFF afterward.*/
SET NOCOUNT ON; -- Disables the row count messages.
CREATE TABLE #TempTable (Value NVARCHAR(50)); -- Creates a temporary table #TempTable with a single column Value (nvarchar).
INSERT INTO #TempTable (Value) VALUES ('Test Value'); -- Inserts a single row into #TempTable.
SELECT * FROM #TempTable;

DROP TABLE #TempTable;
SET NOCOUNT OFF; -- Re-enables row count messages for subsequent operations.
GO

/*10. Dynamic SQL
	Objective: Demonstrate use of dynamic SQL for flexibility.
	Description: Declare a variable @TableName with a value of 'Sales.Invoices'. Build a SQL string to select the top 5 rows 
	from that table and execute it using sp_executesql. 
	This shows how to use dynamic SQL for flexible scripting.*/
DECLARE @TableName NVARCHAR(100) = '[WideWorldImporters].[Sales].[Invoices]';
DECLARE @SQLString NVARCHAR(200) = N'SELECT TOP 5 * FROM ' + @TableName;
EXEC sp_executesql @SQLString; -- Executes the dynamic SQL string using sp_executesql to retrieve the results.
GO

--BEGIN TRY -- Starts a TRY block to catch potential errors during dynamic SQL execution.
--    EXEC sp_executesql @SQLString; -- Executes the dynamic SQL string using sp_executesql to retrieve the top 5 rows.
--END TRY -- Marks the end of the TRY block.
--BEGIN CATCH -- Starts a CATCH block to handle errors, such as an invalid table name.
--    PRINT 'Error executing dynamic SQL: ' + ERROR_MESSAGE(); -- Prints an error message with details from ERROR_MESSAGE() if the table is invalid or another error occurs.
--END CATCH; -- Marks the end of the CATCH block.
--GO