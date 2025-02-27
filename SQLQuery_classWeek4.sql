use AP;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
from Invoices
where InvoiceDate between '2023-01-01' and '2023-03-31'
and TermsID = 3
order by InvoiceDate, InvoiceTotal -- desc-- asc


SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
from Invoices
where InvoiceDate between '2023-01-01' and '2023-03-31'
and TermsID = 3
order by InvoiceDate desc, InvoiceTotal desc -- nested sorting


SELECT InvoiceNumber, InvoiceDate, InvoiceTotal 
from Invoices
where InvoiceDate between '2023-01-01' and '2023-03-31'
and TermsID = 3
order by InvoiceDate desc, 3 desc -- nested sorting


select VendorContactFName + ' ' + VendorContactLName as FullName
from Vendors

select VendorName + '''s Address:',
	VendorCity + ', ' + VendorState + ' ' + VendorZipCode as VendorAddress
from Vendors


select InvoiceTotal, PaymentTotal, CreditTotal,
	InvoiceTotal - PaymentTotal - CreditTotal as BalanceDue
from Invoices

select InvoiceID,
	InvoiceID + 7 * 3 as OrderOfPrecedence,
	(InvoiceID + 7) * 3 as AdditionFirst
from Invoices


select getdate()

select VendorContactFName, VendorContactLName, 
	left(VendorContactFName, 1) + left(VendorContactLName, 1) as Initials
from Vendors

select 'Invoice: #' + InvoiceNumber
	+ ', dated ' + CONVERT(char(8), PaymentDate, 1)
	+ ' for $' + CONVERT(varchar(9), PaymentTotal, 1),
	LEN(convert(varchar, PaymentTotal, 1)) as Length
from Invoices
order by 2 desc 


select InvoiceDate,
	getdate() as 'Today''s Date',
	DATEDIFF(day, InvoiceDate, GETDATE()) as InvoiceAge
from Invoices


select distinct VendorCity, VendorState
from Vendors
order by VendorState


select top 5 VendorID, InvoiceTotal
from Invoices
order by InvoiceTotal desc

select top 5 with ties VendorID, InvoiceDate
from Invoices
order by InvoiceDate