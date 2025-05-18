USE AP;

SELECT * FROM Invoices;
GO

declare @MaxInvoice money,
		@MinInvoice money,
		@InvoiceCount int,
		@PercentDifference decimal(8,2),
		@VendorIDVar int = 95;

select @MaxInvoice = max(InvoiceTotal),
		@MinInvoice = min(InvoiceTotal),
		@InvoiceCount = COUNT(*)
from Invoices
where VendorID = @VendorIDVar;

set @PercentDifference = (@MaxInvoice -@MinInvoice) / @MinInvoice * 100;

print 'Max invoice is $' + convert(varchar, @MaxInvoice, 1) + ',';
print 'Min invoice is $' + convert(varchar, @MinInvoice, 1) + ',';
print 'Max is $' + convert(varchar, @PercentDifference) + '% more than minimum.';