USE WideWorldImporters

-- Task 1: Create a Test Table
CREATE TABLE TestCustomers ( -- table name
    CustomerID INT PRIMARY KEY IDENTITY(1,1), -- primary key as auto-incrementing
    CustomerName NVARCHAR(100) NOT NULL,
    BuyingGroupID INT NULL,
    PaymentDays INT NULL,
    CreditLimit DECIMAL(18,2) NULL
);

-- Task 2: Use SELECT INTO to Copy Data
INSERT INTO TestCustomers (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
	SELECT CustomerName, BuyingGroupID, PaymentDays, CreditLimit
	FROM Sales.Customers
	WHERE CreditLimit > 2000;

-- Task 3: Insert a Single Row
INSERT INTO TestCustomers (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
VALUES ('New Test Customer 1', 1, 30, 5000.00);

-- Task 4: Insert Multiple Rows
INSERT INTO TestCustomers (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
VALUES 
    ('New Test Customer 2', 2, 15, 3100.00),
    ('New Test Customer 3', 3, 20, 4000.00),
    ('New Test Customer 4', 1, 30, 2500.00);

-- Task 5: Insert Rows with Default and NULL Values
INSERT INTO TestCustomers (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
VALUES ('New Customer 5', NULL, 30, NULL); 
-- CustomerName and PaymentDays have explicit values
-- BuyingGroupID and CreditLimit are set to NULL

-- Task 6: Insert Rows Selected from Another Table
CREATE TABLE TestCustomers_Copy ( -- new table TestCustomers_Copy
    CustomerID INT PRIMARY KEY IDENTITY(1,1), 
    CustomerName NVARCHAR(100) NOT NULL,
    BuyingGroupID INT NULL,
    PaymentDays INT NULL,
    CreditLimit DECIMAL(18,2) NULL
);
-- copying data from already created TestCustomers table
INSERT INTO TestCustomers_Copy(CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
	SELECT CustomerName, BuyingGroupID, PaymentDays, CreditLimit
	FROM TestCustomers
-- inserting customers from TestCustomers_Copy into TestCustomers
INSERT INTO TestCustomers (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
SELECT CustomerName, BuyingGroupID, PaymentDays, CreditLimit
FROM TestCustomers_Copy;

-- Task 7: Perform an Update Operation
UPDATE TestCustomers
SET CreditLimit = 5000
WHERE CreditLimit IS NULL;

-- Task 8: Use a Subquery in an Update Operation
UPDATE TestCustomers
SET CreditLimit = CreditLimit * 1.10
WHERE BuyingGroupID IN (
    SELECT DISTINCT BuyingGroupID
    FROM Sales.Customers
    WHERE BuyingGroupID IS NOT NULL
);

-- Task 9: Delete Rows Using a Subquery and Joins
DELETE FROM TestCustomers
WHERE CustomerID NOT IN (
    SELECT tc.CustomerID
    FROM TestCustomers tc
		JOIN TestCustomers_Copy tcc ON tc.CustomerID = tcc.CustomerID
);

-- Task 10: Perform a MERGE Operation
MERGE INTO TestCustomers AS target
	USING TestCustomers_Copy AS source
		ON target.CustomerID = source.CustomerID
WHEN MATCHED THEN
    UPDATE SET target.CreditLimit = source.CreditLimit
WHEN NOT MATCHED THEN
    INSERT (CustomerName, BuyingGroupID, PaymentDays, CreditLimit)
    VALUES (source.CustomerName, source.BuyingGroupID, source.PaymentDays, source.CreditLimit);
