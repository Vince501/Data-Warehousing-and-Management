use AP

-- option 1
select InvoiceNumber, VendorName
from Vendors as v	-- as is optional
	inner join Invoices as i
		on v.VendorID = i.VendorID

-- option 2
select InvoiceNumber, VendorName
from Vendors as v, Invoices as i
where v.VendorID = i.VendorID

-- compounded join conditions
select InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceLineItemAmount
from Invoices as i
	inner join InvoiceLineItems as li
		on i.InvoiceID = li.InvoiceID
			and i.InvoiceTotal > li.InvoiceLineItemAmount
order by InvoiceNumber

-- self join
select v1.VendorName, v1.VendorCity, v1.VendorState
from Vendors v1
	inner join vendors v2
	on v1.VendorCity = v2.VendorCity
		and v1.VendorState = v2.VendorState
		and v1.VendorID <> v2.VendorID
order by v1.VendorState, v1.VendorCity


-- with 4 tables
select VendorName, InvoiceNumber, InvoiceDate,
	InvoiceLineItemAmount as LineItemAmount, AccountDescription
from Vendors as v
	inner join Invoices as i on v.VendorID = i.VendorID
	inner join InvoiceLineItems as li on i.InvoiceID = li.InvoiceID
	inner join GLAccounts as gla on li.AccountNo = gla.AccountNo
where InvoiceTotal - PaymentTotal - CreditTotal > 0
order by VendorName, LineItemAmount desc


-- outer joins
select VendorName, InvoiceNumber, InvoiceTotal
from Vendors as v
	left join Invoices as i
		on v.VendorID = i.VendorID
where i.VendorID is null
order by VendorName
