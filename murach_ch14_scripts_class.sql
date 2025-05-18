/* SLIDE 4 */
-- Creates three tables in a database named ClubRoster.
-- batch 1
CREATE DATABASE ClubRoster;	
GO
-- batch 2
USE ClubRoster;
 
CREATE TABLE Members
(MemberID int NOT NULL IDENTITY PRIMARY KEY,
 LastName varchar(75) NOT NULL,
 FirstName varchar(50) NOT NULL,
 MiddleName varchar(50) NULL);
 
CREATE TABLE Committees
(CommitteeID int NOT NULL IDENTITY PRIMARY KEY,
 CommitteeName varchar(50) NOT NULL);
 
CREATE TABLE CommitteeAssignments
(MemberID int NOT NULL REFERENCES Members(MemberID),
 CommitteeID int NOT NULL 
 REFERENCES  Committees(CommitteeID));


 /* SLIDE 8 */
USE AP;
 
DECLARE @TotalDue money;
SET @TotalDue = 
  (SELECT SUM(InvoiceTotal - PaymentTotal - CreditTotal)
   FROM Invoices);
IF @TotalDue > 0
    PRINT 'Total invoices due = $' + 
           CONVERT(varchar,@TotalDue,1);
ELSE
    PRINT 'Invoices paid in full';


/* SLIDE 10 & 11 */
USE AP;

DECLARE @MaxInvoice money, 
        @MinInvoice money,
        @InvoiceCount int,
        @PercentDifference decimal(8,2),
        @VendorIDVar int = 95;
 
SELECT @MaxInvoice = MAX(InvoiceTotal),
       @MinInvoice = MIN(InvoiceTotal), 
       @InvoiceCount = COUNT(*)
FROM Invoices
WHERE VendorID = @VendorIDVar;
 
SET @PercentDifference = 
    (@MaxInvoice - @MinInvoice) / @MinInvoice * 100;

PRINT 'Maximum invoice is $' +  
   CONVERT(varchar,@MaxInvoice,1) + '.';
PRINT 'Minimum invoice is $' + 
   CONVERT(varchar,@MinInvoice,1) + '.';
PRINT 'Maximum is ' + 
       CONVERT(varchar,@PercentDifference) +
      '% more than minimum.';
PRINT 'Number of invoices: ' + 
       CONVERT(varchar,@InvoiceCount) + '.';

/* SLIDE 13 */
USE AP;
 
DECLARE @BigVendors table
(VendorID int, VendorName varchar(50));
 
INSERT @BigVendors
SELECT VendorID, VendorName
FROM Vendors
WHERE VendorID IN 
    (SELECT VendorID FROM Invoices 
     WHERE InvoiceTotal > 5000);
 
SELECT * FROM @BigVendors;

/* SLIDE 14 */
SELECT TOP 1 VendorID, AVG(InvoiceTotal) AS AvgInvoice
INTO #TopVendors
FROM Invoices
GROUP BY VendorID
ORDER BY AvgInvoice DESC;
 
SELECT i.VendorID, MAX(InvoiceDate) AS LatestInv
FROM Invoices AS i JOIN #TopVendors AS tv
    ON i.VendorID = tv.VendorID
GROUP BY i.VendorID;

/* SLIDE 15 */
CREATE TABLE ##RandomSSNs
(
  SSN_ID int     IDENTITY,
  SSN    char(9) DEFAULT
    LEFT(CAST(CAST(CEILING(RAND()*10000000000) AS bigint) 
         AS varchar),9)
);
 
INSERT ##RandomSSNs VALUES (DEFAULT);
INSERT ##RandomSSNs VALUES (DEFAULT);
 
SELECT * FROM ##RandomSSNs;

/* SLIDE 18 */
DECLARE @EarliestInvoiceDue date;
 
SELECT @EarliestInvoiceDue = MIN(InvoiceDueDate)
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;
 
IF @EarliestInvoiceDue < GETDATE()
    PRINT 'Outstanding invoices overdue!';

/* SLIDE 19 & 20 */
DECLARE @MinInvoiceDue money, 
        @MaxInvoiceDue money,
        @EarliestInvoiceDue date, 
        @LatestInvoiceDue date;
 
SELECT @MinInvoiceDue = 
          MIN(InvoiceTotal - PaymentTotal - CreditTotal),
       @MaxInvoiceDue = 
          MAX(InvoiceTotal - PaymentTotal - CreditTotal),
       @EarliestInvoiceDue = MIN(InvoiceDueDate),
       @LatestInvoiceDue = MAX(InvoiceDueDate)
FROM Invoices
WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

IF @EarliestInvoiceDue < GETDATE()
    BEGIN
       PRINT 'Outstanding invoices overdue!';
       PRINT 'Dated ' +  
              CONVERT(varchar,@EarliestInvoiceDue,1) + 
             ' through ' +                
              CONVERT(varchar,@LatestInvoiceDue,1) + '.';
       PRINT 'Amounting from $' + 
              CONVERT(varchar,@MinInvoiceDue,1) +
             ' to $' + 
              CONVERT(varchar,@MaxInvoiceDue,1) + '.';
    END;
ELSE --@EarliestInvoiceDue >= GETDATE()
    PRINT 'No overdue invoices.';

/* SLIDE 23 */
USE master;
DROP DATABASE IF EXISTS TestDB;

--Test whether a database exists before deleting it
USE master;
IF DB_ID('TestDB') IS NOT NULL
    DROP DATABASE TestDB;
--Test for the existence of a table
IF OBJECT_ID('InvoiceCopy') IS NOT NULL
    DROP TABLE InvoiceCopy;
--Another way to test for the existence of a table
IF EXISTS (SELECT * FROM sys.tables
           WHERE name = 'InvoiceCopy')
    DROP TABLE InvoiceCopy;
--Test for the existence of a temporary table
IF OBJECT_ID('tempdb..#AllUserTables') IS NOT NULL
    DROP TABLE #AllUserTables;

/* SLIDE 25 */
USE AP;
 
IF OBJECT_ID('tempdb..#InvoiceCopy') IS NOT NULL
    DROP TABLE #InvoiceCopy;
 
SELECT * INTO #InvoiceCopy FROM Invoices 
WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;
 
WHILE (SELECT SUM(InvoiceTotal - CreditTotal - PaymentTotal) 
       FROM #InvoiceCopy) >= 20000
   BEGIN
     UPDATE #InvoiceCopy
     SET CreditTotal = CreditTotal + .05
     WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;
 
     IF (SELECT MAX(CreditTotal) FROM #InvoiceCopy) > 3000
         BREAK;
     ELSE 
         CONTINUE;
   END;
 
SELECT InvoiceDate, InvoiceTotal, CreditTotal
FROM #InvoiceCopy;

/* SLIDE 28-30 */
USE AP;
DECLARE @InvoiceIDVar int, 
        @InvoiceTotalVar money, 
        @UpdateCount int = 0;
 
DECLARE Invoices_Cursor CURSOR
FOR
    SELECT InvoiceID, InvoiceTotal 
    FROM Invoices
    WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;
OPEN Invoices_Cursor;

FETCH NEXT FROM Invoices_Cursor
    INTO @InvoiceIDVar, @InvoiceTotalVar;
WHILE @@FETCH_STATUS <> -1
  BEGIN
    IF @InvoiceTotalVar > 1000
    BEGIN
      UPDATE Invoices
      SET CreditTotal = CreditTotal + (InvoiceTotal * .1)
      WHERE InvoiceID = @InvoiceIDVar;
 
      SET @UpdateCount = @UpdateCount + 1;
    END;
    FETCH NEXT FROM Invoices_Cursor 
    INTO @InvoiceIDVar, @InvoiceTotalVar;
  END;

CLOSE Invoices_Cursor;
DEALLOCATE Invoices_Cursor;
    
PRINT '';
PRINT CONVERT(varchar, @UpdateCount) + ' row(s) updated.';

/* SLIDE 32 */
BEGIN TRY
    INSERT Invoices
    VALUES (799, 'ZXK-799', '2023-03-07', 299.95, 0, 0,
            1, '2023-04-06', NULL);
    PRINT 'SUCCESS: Record was inserted.';
END TRY
BEGIN CATCH
    PRINT 'FAILURE: Record was not inserted.';
    PRINT 'Error ' + CONVERT(varchar, ERROR_NUMBER(), 1) 
        + ': ' + ERROR_MESSAGE();
END CATCH;

/* SLIDE 36 */
USE AP;
 
DECLARE @MyIdentity int, @MyRowCount int;
 
INSERT Vendors (VendorName, VendorAddress1, VendorCity, 
                VendorState, VendorZipCode, VendorPhone, 
                DefaultTermsID, DefaultAccountNo)
VALUES ('Peerless Binding', '1112 S Windsor St', 
        'Hallowell', 'ME', '04347', '(207) 555-1555', 
         4, 400);
 
SET @MyIdentity = @@IDENTITY;
SET @MyRowCount = @@ROWCOUNT;
 
IF @MyRowCount = 1
    INSERT Invoices
    VALUES (@MyIdentity, 'BA-0199', '2023-03-01',  
            4598.23, 0, 0, 4, '2023-04-30', NULL);

/* SLIDE 38 */
USE AP;
 
DECLARE @TableNameVar varchar(128) = 'Invoices';
 
EXEC ('SELECT * FROM ' + @TableNameVar + ';');

SELECT * FROM Invoices;

/* SLIDE 39 */
USE AP;
 
DECLARE @DynamicSQL varchar(8000);
 
DROP TABLE IF EXISTS XtabVendors;
 
SET @DynamicSQL = 'CREATE TABLE XtabVendors ('
    SELECT @DynamicSQL = @DynamicSQL + '[' + 
                         VendorName + '] bit,'
    FROM Vendors 
    WHERE VendorID IN
      (SELECT VendorID 
       FROM Invoices 
       WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0)
    ORDER BY VendorName;
SET @DynamicSQL = @DynamicSQL + ');';

PRINT(@DynamicSQL); 
EXEC (@DynamicSQL);
 
SELECT * FROM XtabVendors;

