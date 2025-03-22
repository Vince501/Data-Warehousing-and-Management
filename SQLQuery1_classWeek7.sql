use AP

select AVG(InvoiceTotal)
from Invoices

select InvoiceNumber, InvoiceDate, InvoiceTotal
from Invoices
where InvoiceTotal >
	(select AVG(InvoiceTotal)
	from Invoices)
order by InvoiceTotal;


select InvoiceNumber, InvoiceDate, InvoiceTotal
from Invoices i
	inner join Vendors v
		on i.VendorID=V.VendorID
where VendorState = 'CA'
order by InvoiceDate;
--

select v.VendorID, VendorName, VendorState
from Vendors v
	left join Invoices i
		on v.VendorID = i.VendorID
where i.VendorID is null;
--
select VendorID, VendorName, VendorState
from Vendors
where VendorID not in (select distinct VendorID from Invoices);
--

select VendorName, InvoiceNumber, InvoiceTotal
from Invoices i inner join Vendors v on v.VendorID = i.VendorID
where InvoiceTotal < any (select InvoiceTotal from Invoices where VendorID = 115)
order by VendorName;
-- select min(InvoiceTotal) from Invoices
select VendorName, InvoiceNumber, InvoiceTotal
from Invoices i inner join Vendors v on v.VendorID = i.VendorID
where InvoiceTotal > (select max(InvoiceTotal) from Invoices where VendorID = 115)
order by VendorName;
-- 

select VendorID, InvoiceNumber, InvoiceTotal
from Invoices i1
where InvoiceTotal > (select avg(InvoiceTotal) from Invoices as i2 where i2.VendorID = i1.VendorID)
order by VendorID, InvoiceTotal;

select VendorID, VendorName, VendorState
from Vendors v
where not exists (select * from Invoices as i where i.VendorID = v.VendorID);
--
select i.VendorID, max(InvoiceDate) as LatestInvoince
from Invoices i inner join (select top 5 VendorID, AVG(InvoiceTotal) as AvgInvoice 
							from Invoices
							group by VendorID
							order by AvgInvoice desc) as v on i.VendorID = v.VendorID
group by i.VendorID
order by LatestInvoince desc;

select VendorName, max(InvoiceDate) as LatestInvoice
from Vendors v left join Invoices as i on v.VendorID = i.VendorID
group by VendorName
order by LatestInvoice desc