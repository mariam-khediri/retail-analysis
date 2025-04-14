-- let's start by looking at the first 10 rows of our data 
select * from online_retail limit 10 ;



-- check total row count
select count(*) from online_retail or2 ; -- ==> the result is : 541909 rows 



	--1. let's check for nulls in each column
select count(*) filter(where InvoiceNo is null) as null_invoiceno,
count(*) filter (where StockCode is null) as null_stockcode,
count(*) filter (where Description is null) as null_description,
count(*) filter (where Quantity is null) as null_quantity,
count(*) filter(where InVoiceDate is null) as null_invoicedate,
count(*) filter(where UnitPrice is null) as null_unitprice,
count(*)filter(where CustomerID is null) as null_customerid,
count(*)filter(where Country is null) as null_country
from online_retail; 
			-- ==> no null values all over the dataset



	--2. let's check duplicate rows
select InvoiceNo ,StockCode ,Description ,Quantity , InvoiceDate , UnitPrice , CustomerID , Country, count(*) as nombre 
from online_retail or2 
group by  InvoiceNo ,StockCode ,Description ,Quantity , InvoiceDate , UnitPrice , CustomerID , Country
having count(*)>1
limit 10; 
				-- ==> there exist multiple duplicates 



/* let's delete all duplicates we will be using 
   delete with CTE + ROW_NUMBER()
   ctid is a unique row identifier in postgresql , and useful for safely deleting duplicates */
delete from online_retail 
where ctid in (
select ctid from(
select ctid , 
row_number() over(
partition by InvoiceNo ,StockCode ,Description ,Quantity , InvoiceDate , UnitPrice , CustomerID , Country 
order by ctid 
) as row_num 
from online_retail or2 
)t
where t.row_num > 1
) ;


-- now let's check if the nbr of rows decreased
select count(*) from online_retail or2 ; 
			-- ==> 536641



	--3. let's get a summary stats for numeric columns
select 
min(Quantity) as min_qte, -- -80995
max(Quantity) as max_qte,-- 80995
avg(Quantity)as avg_qte,-- 9.55
min(UnitPrice) as min_price,--  -11062.06
max(UnitPrice)as max_price,--   38970
avg(UnitPrice)as avg_price--   4.611
from online_retail or2 ; 
/*==> finding negative prices and quantities is weird
  ==> we need to clean our data first */


	--4. let's investigate and remove negative values 
select count(*) as negative_qte
from online_retail or2 
where Quantity <0;
/* ==> reust = 10587 
this might mean product returns but since we are working on a pricing analysis project 
it is better to remove them initially   */

select count(*) as negative_price
from online_retail or2 
where UnitPrice <0;
		-- ==> result =2

delete from online_retail 
where Quantity<0 or UnitPrice<0;



-- now let's check if the nbr of rows decreased
select count(*) from online_retail or2 ; 
		-- ==> 526052



-- let's confirm the cleanup
select  
min(Quantity),	--    1
max(Quantity),	--	80995
avg(Quantity),	-- 	10.73
min(UnitPrice), --	0
max(UnitPrice),	--	13541.33
avg(UnitPrice)	--	3.91
from online_retail or2 ;

	-- 5. let's check for zero quantity or price (they could skew kpis like revenue)
select count(*) as zero_qty
from online_retail or2 
where Quantity =0;  
	-- no 0 quantities
select count(*)as zero_price
from online_retail or2 
where UnitPrice =0;
	--  1174
-- let's delete rows where the price = 0
delete from online_retail 
where UnitPrice =0;


	-- 6. let's check for odd date ranges ,normal range  between 01/12/2010 and 09/12/2011
select
min(InvoiceDate)as earliest_date, -- 2010-12-01 08:26:00.000
max(InvoiceDate)as latest_date -- 2011-12-09 12:50:00.000
from online_retail or2 ;
  -- ==> nothing weird


	--7. let's check for country value issues (misspelled or blank country names)
select distinct Country
from online_retail or2 
order by Country; 
-- we found a non existing country so we will delete its data 

delete from online_retail 
where Country= 'Israel' or Country='Unspecified';


	-- 8. let's check the invoiceNo formatting
select InvoiceNo
from online_retail or2 
where length(TRIM(InvoiceNo))=0
limit 10;
-- all good


	--9. let's check consistency between related fields(if Product descriptions are blank or duplicated for different stock codes)
SELECT *
FROM online_retail
WHERE Description IS NULL OR TRIM(Description) = '';
-- all good
