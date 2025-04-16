				/* Modeling : Predicting High value Baskets*/


			-- 1.aggregate data at invoice level
/* modeling usually require one row per entity ,
 * so let's collapse all line items into one row per invoice with features  */
create table invoice_level_features as
WITH InvoiceAgg AS (
    SELECT
        InvoiceNo,
        CustomerID,
        Country,
        DATE_TRUNC('month', MAX(InvoiceDate)) AS InvoiceMonth,
        SUM(Quantity * UnitPrice) AS TotalInvoiceAmount,	-- The invoice value (target for regression or threshold for classification)
        SUM(Quantity) AS TotalItems,		-- How many items were bought
        COUNT(DISTINCT StockCode) AS DistinctProducts		--Product diversity
    FROM online_retail_features
    GROUP BY InvoiceNo, CustomerID, Country)

SELECT *,
    CASE 
        WHEN TotalInvoiceAmount > 100 THEN 1 
        ELSE 0 
    END AS HighValueBasket		-- Binary target (1 = big spend, 0 = not)
FROM InvoiceAgg;

select * from invoice_level_features limit10;


		-- 2. step1: data exploration(EDA in SQl) let's understand our new data first

-- let's chech how many customers and rows we have in our data
select 
count(*) as total_invoices, 		-- 19939
count(distinct CustomerID) as unique_customers 		-- 4332
from invoice_level_features ;

-- distribution of invoice totals (basic idea of revenue spread)
select min(TotalInvoiceAmount),	-- 0.38
max(TotalInvoiceAmount),		-- 168469.6
avg(TotalInvoiceAmount),		-- 533.0879409198054065
PERCENTILE_CONT(0.5) within group 
(order by TotalInvoiceAmount) as median_invoiceexcept -- 303.3
from invoice_level_features ;

-- let's find the top countries by number of invoice
select 
country , count(* ) as num_invoices
from invoice_level_features ilf 
group by country 
order by num_invoices desc 
limit 10;
/* UK is the target maket since it is the most contributer to the revenue
 * follwed by germany and france
 */

-- let's check the target balance(class balance: high vs low value baskets)
select HighValueBasket,
count(*) as counts,
round(count(*)*100.0/sum(count(*)) over(),2) as percents 
from invoice_level_features ilf 
group by HighValueBasket;
/* 13.74% of data represent low baskets with count= 2740 
 * 86.26% of data represent high baskets with count= 17199
 * ==> the data is highly unbalanced for classification
 */

 -- ==>since the data is unbalanced we will keep it simple and turn this into a regression instead
