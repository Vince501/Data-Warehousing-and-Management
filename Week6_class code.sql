use AP


select count(*) as NoOfInvoices,
	sum(InvoiceTotal - PaymentTotal - CreditTotal) as TotalDue
from Invoices
where InvoiceTotal - PaymentTotal - CreditTotal > 0

select 'After 7/1/2022' as SelectionDt,
	count(*) as NoOfInvoices,
	avg(InvoiceTotal) as AverageInvoiceAmount,
	sum(InvoiceTotal) as TotalInvoiceAmount,
	max(InvoiceTotal) as HighestInvoiceTotal,
	min(InvoiceTotal) as LowestInvoiceTotal,
	STDEV(InvoiceTotal) as InvoiceSD
from Invoices
where InvoiceDate > '2022-07-01'


select count(distinct VendorID) as NoOfVendors,
	   count(VendorID) as NoOfInvoices,
	   avg(InvoiceTotal) as AvgInvAmt,
	   sum(InvoiceTotal) as TotalInvAmt
from Invoices
where InvoiceDate > '2022-07-01'

select v.VendorID, VendorName, avg(InvoiceTotal) as AvgInvAmt
from Invoices i
	inner join Vendors v
		on i.VendorID = v.VendorID
group by v.VendorID, VendorName
having avg(InvoiceTotal) > 2000
order by 3 desc;

select VendorState, VendorCity, count(*) as InvoiceQty
from Invoices as i
	inner join Vendors as v
		on i.VendorID = v.VendorID
group by VendorState, VendorCity
having count(*) >= 2
order by VendorState, VendorCity


select VendorName, count(*) as InvoiceQty
from Invoices as i
	inner join Vendors as v
		on i.VendorID = v.VendorID
--where InvoiceTotal > 500
group by VendorName
having avg(InvoiceTotal) > 500
order by VendorName



select VendorID, count(*) as InvoiceCount, sum(InvoiceTotal) as InvcoiceTotal
from Invoices
group by rollup(VendorID)

select VendorState, VendorCity, count(*) as QtyVendors
from Vendors
where VendorState in ('IA', 'NJ')
group by rollup(VendorState, VendorCity)
order by VendorState desc, VendorCity desc


select VendorCity, VendorState, count(*) as QtyVendors
from Vendors
where VendorState in ('IA', 'NJ')
group by rollup(VendorCity, VendorState)
order by VendorCity desc, VendorState desc


select VendorID, count(*) as InvoiceCount
from Invoices
group by cube(VendorID)


select VendorState, VendorCity, count(*) as QtyVendors
from Vendors
where VendorState in ('IA', 'NJ')
group by cube(VendorState, VendorCity)
order by VendorState desc, VendorCity desc


select VendorState, VendorCity, count(*) as QtyVendors
from Vendors
where VendorState in ('IA', 'NJ')
group by grouping sets(VendorState, VendorCity)
order by VendorState desc, VendorCity desc


select VendorState, VendorCity, VendorZipCode, count(*) as QtyVendors
from Vendors
where VendorState in ('IA', 'NJ')
group by grouping sets((VendorState, VendorCity), VendorZipCode, ())
order by VendorState desc, VendorCity desc


select InvoiceNumber, InvoiceDate, InvoiceTotal,
	   sum(InvoiceTotal) over (partition by InvoiceDate) as DateTotal,
	   count(InvoiceTotal) over (partition by InvoiceDate) as DateCount,
	   avg(InvoiceTotal) over (partition by InvoiceDate) as DateAvg
from Invoices

select InvoiceNumber, InvoiceDate, InvoiceTotal,
	   sum(InvoiceTotal) over (order by InvoiceDate) as DateTotal,
	   count(InvoiceTotal) over (order by InvoiceDate) as DateCount,
	   avg(InvoiceTotal) over (order by InvoiceDate) as DateAvg
from Invoices

select InvoiceNumber, TermsID, InvoiceDate, InvoiceTotal,
	   sum(InvoiceTotal) over (partition by TermsID order by InvoiceDate) as DateTotal,
	   count(InvoiceTotal) over (partition by TermsID order by InvoiceDate) as DateCount,
	   avg(InvoiceTotal) over (partition by TermsID order by InvoiceDate) as MovingAvg
from Invoices
