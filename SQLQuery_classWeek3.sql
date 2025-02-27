-- THIS IS AN EXAMPLE OF A LINE COMMENT
use AP;

/*
Comment Block
*/

select * from Invoices; 

-- retrive 3 columns from invoices
select InvoiceNumber, InvoiceDate, InvoiceTotal from Invoices;

select InvoiceID, InvoiceTotal, CreditTotal + PaymentTotal as 'Total Credits'
from Invoices
where InvoiceID = 17;
