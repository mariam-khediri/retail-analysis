-- create table then upload our csv file (data) into this table
create table online_retail (
InvoiceNo varchar, -- a 6 digit integral number uniquely assigned to each transaction, if the code stats with letter"c" then it indicates a cancellation
StockCode varchar,  -- a 5 digit integral number uniquely assigned to each distinct product
Description text, -- product name
Quantity integer,-- nbr of items per transaction
InVoiceDate timestamp,-- day and time of transactions
UnitPrice numeric,-- price per unit
CustomerID varchar,-- a 5 digit integral number uniquely assigned to each customer
Country varchar -- the name of the country where each customer resides
);
