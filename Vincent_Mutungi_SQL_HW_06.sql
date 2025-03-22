USE WideWorldImporters

-- Section 1: Data Conversion with CAST
-- 1. Converting Data Types with CAST:
SELECT InvoiceID, TotalInvoiceAmount,
    CAST(TotalInvoiceAmount AS VARCHAR(20)) AS Converted_TotalAmount -- Casting
FROM (
    SELECT InvoiceID, SUM(ExtendedPrice) AS TotalInvoiceAmount
    FROM Sales.InvoiceLines
    GROUP BY InvoiceID
) AS InvoiceTotals;

-- 2. Integer Division with CAST:
SELECT OrderID, Quantity, 
    Quantity / 3 AS IntegerDivision,
    CAST(Quantity AS DECIMAL(10,2)) / 3 AS DecimalDivision  -- Casting
FROM Sales.OrderLines;

-- Section 2: Data Conversion with CONVERT
-- 3. Formatting Date Using CONVERT:
SELECT InvoiceID, InvoiceDate,
    CONVERT(VARCHAR(10), InvoiceDate, 101) AS 'DateFormat_101_(MM/DD/YYYY)',
    CONVERT(VARCHAR(10), InvoiceDate, 103) AS 'DateFormat_103_(DD/MM/YYYY)',
    CONVERT(VARCHAR(19), InvoiceDate, 120) AS 'DateFormat_120_(YYYY-MM-DD HH:MI:SS)'
FROM Sales.Invoices;

-- 4. Converting Real to Character Using CONVERT:
SELECT TypicalWeightPerUnit,
    CONVERT(VARCHAR(20), TypicalWeightPerUnit) AS Converted_Weight --Converts the numeric TypicalWeightPerUnit to a string
FROM Warehouse.StockItems
WHERE TypicalWeightPerUnit > 5;

-- 5. Converting Money to Character Using CONVERT:
SELECT InvoiceID, TotalInvoiceAmount,
    CONVERT(VARCHAR(20), TotalInvoiceAmount, 0) AS Converted_Default,
    CONVERT(VARCHAR(20), TotalInvoiceAmount, 1) AS Converted_with_Commas
FROM ( 
    SELECT InvoiceID, 
        SUM(ExtendedPrice) AS TotalInvoiceAmount
    FROM Sales.InvoiceLines
    GROUP BY InvoiceID
    HAVING SUM(ExtendedPrice) > 500
) AS InvoiceTotals;

-- Section 3: Error Handling with TRY_CONVERT
-- 6. Using TRY_CONVERT to Handle Conversion Errors: 
SELECT StockItemName,
    TRY_CONVERT(INT, StockItemName) AS Converted_to_Int -- returns NULL for non-convertible values
FROM Warehouse.StockItems;

-- Section 4: Other Data Conversion Functions
-- 7. Using STR to Convert Numeric Data:
SELECT TypicalWeightPerUnit,
    STR(TypicalWeightPerUnit, 10) AS Converted_Weight -- Converts the weight to a fixed-length string
FROM Warehouse.StockItems
WHERE TypicalWeightPerUnit > 5;

-- 8. Using CHAR and ASCII to Examine Character Codes:
SELECT CustomerName,
    LEFT(CustomerName, 1) AS First_Letter, -- Getting the First Letter
    ASCII(LEFT(CustomerName, 1)) AS ASCII_Code, --Getting the ASCII code
	CHAR (ASCII(LEFT(CustomerName, 1))) AS 'Character of the ASCII' --Getting the Character
FROM Sales.Customers
WHERE CustomerID < 10;

-- 9. Using NCHAR and UNICODE to Work with Unicode Data:
SELECT CustomerName,
    LEFT(CustomerName, 1) AS First_Letter,
    UNICODE(LEFT(CustomerName, 1)) AS Unicode_Value,
    NCHAR(UNICODE(LEFT(CustomerName, 1))) AS Unicode_Character
FROM Sales.Customers
WHERE CustomerID < 10;

-- 10. Challenge: Using Multiple Conversions Together:
SELECT InvoiceID, InvoiceDate,
    CONVERT(VARCHAR(10), InvoiceDate, 120) AS Converted_Date,
    TotalInvoiceAmount,
    CAST(TotalInvoiceAmount AS VARCHAR(20)) AS Converted_TotalAmount
FROM (
    SELECT i.InvoiceID, i.InvoiceDate, 
        SUM(il.ExtendedPrice) AS TotalInvoiceAmount
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il ON i.InvoiceID = il.InvoiceID
    GROUP BY i.InvoiceID, i.InvoiceDate
    HAVING SUM(il.ExtendedPrice) > 5000
) AS InvoiceTotals;
