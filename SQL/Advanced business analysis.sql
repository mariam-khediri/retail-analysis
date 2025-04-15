/* III. Advanced business analysis */

		-- 1. customr segmentation (let's group customers by revenue spent)
select CustomerID , 
sum(Quantity * UnitPrice) as total_spent
from online_retail or2 
group by CustomerID 
order by total_spent desc;
/* ==>  customer 14646 brings the most revenue to the business */


		-- 2. repeat customer analysis
select CustomerID , 
count (distinct InvoiceNo) as num_orders
from online_retail or2 
group by CustomerID 
having count(distinct InvoiceNo)>1 
order by num_orders desc
limit 10;
/* customer 12748 has purshesed 209 orders 
 which makes him the most valuable for long term business
 this help identify loyal customers vs one time buyers
 finance teams can use this to model customer lifetime value(CLV)*/



		-- 3. what is the average order value
select 
avg(total)as avg_order_value
from (
select InvoiceNo , sum(Quantity * UnitPrice) as total 
from online_retail or2 
group by InvoiceNo
)t; 
/*the avrage value is  533.0879409198054065
 this step helps pricing teams understand spending behavors 
 if avg is low , upselling or bundloing strategies might help  */


			/*   VI. Anomaly Detection */


		-- 1. let's find weird transactions
select*
from online_retail or2 
where  UnitPrice > 1000; 
/* i think finding manuals and dotcom and manuals for mor than 1000 sterling is quite weird ,
 *  but since this data is an occasion gift it might be whright 
but i have no idea about the products in real life so i will simplly keep them 

* in general outliers might be : fraudulent orders or data entry errors or special deals
* this step improves data quality and flags business risks*/


			
				/*  V. Window Functions(Advanced SQL)*/

		-- let's rank customers by monthly spending 
select CustomerID ,
date_trunc('month', InvoiceDate) as month,
sum(Quantity * UnitPrice) as monthly_spent,
rank() over(
partition by date_trunc('month',InvoiceDate)
order by sum(Quantity * UnitPrice) desc )as rank
from online_retail or2 
group by CustomerID , date_trunc('month', InvoiceDate);

/* this step helps raking customers by spending per month , so we can track monthly performance
 * this shows us top customers for each month 
 * pricing team use this for : personalized offers , seasonal trends , or vip segmentation
 * 
 */
		