/*     II.Revenue and pricing analysis */


	-- 1. add a total price column (no need to alter the table we just need the values)
select * , Quantity * UnitPrice as TotalPrice
from online_retail or2 
limit 10;

	-- 2. Revenue overview basic KPIs (total revenue , total transaction , number of customers)
select all
count(distinct InvoiceNo) as total_invoices,	-- 	19939
count(distinct CustomerID) as totla_customers,	-- 	4332
sum(Quantity * UnitPrice) as total_revenue		--	10629240.454
from online_retail ;


	-- 3. revenue by country
select country,
sum(quantity * UnitPrice) as revenue
from online_retail or2 
group by country 
order by revenue desc;
/* UK is the market that generates the most revenue followed by netherlands and ireland*/


	--4. top selling product (by quantity and revenue)
select description , 
sum(Quantity) as total_sold,
sum(Quantity * UnitPrice ) as revenue
from online_retail or2 
group by description 
-- order by revenue desc
order by total_sold  desc 
limit 10;
/* DOTCOM POSTAGE has the biggest revenue followed by REGENCY CAKESTAND 3 TIER   */
/* PAPER CRAFT , LITTLE BIRDIE is the most sold followed  by MEDIUM CERAMIC TOP STORAGE JAR*/


	-- let's check the revenue over time (monthly)
select 
date_trunc('month' , InvoiceDate) as month,
sum(Quantity * UnitPrice) as revenue
from online_retail or2 
group by month
--order by month
order by revenue desc;
/* november 2011 has the biggest revenue =1502901.03 */
