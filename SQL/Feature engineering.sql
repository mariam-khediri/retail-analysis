/* Iv. Feature engineering*/


		-- 1. let's add a total price  column 
		--==> this features shows how much money each row brought in 
select * ,
 Quantity * UnitPrice as TotalPrice
 from online_retail or2 ;
		
		--2. extract InvoiceMonth 
		--==> this used for time based trends , monthly KPIs or customer retention analysis
select *,
date_trunc('month',InvoiceDate) as InvoiceMonth
from online_retail or2 ;



		-- 3. create a flag for high value basket 
		-- ==>detect large orders or customers who frequently buy in bulk
select * ,
case
	when Quantity * UnitPrice > 1000 then 1
	else 0
end as HighValueBasket
from online_retail or2 
order by highvaluebasket desc;


		-- 4. compute BasketSizeInvoice
		--==> this gives the number of items in a single invoice for understanding shopping behavior
-- first let's create the table that has all the engineered features next to the original table
create table online_retail_features as

-- first calculate total quantity per invoice
WITH Basket AS (
    SELECT 
        InvoiceNo,
        SUM(Quantity) AS BasketSize
    FROM online_retail
    GROUP BY InvoiceNo
)


-- now lets join it back to the original data 
SELECT 
    r.*,
    r.Quantity * r.UnitPrice AS TotalPrice,
    DATE_TRUNC('month', r.InvoiceDate) AS InvoiceMonth,
    CASE 
        WHEN r.Quantity * r.UnitPrice > 1000 THEN 1 
        ELSE 0 
    END AS HighValueBasket,
    b.BasketSize
FROM online_retail r
JOIN Basket b 
  ON r.InvoiceNo = b.InvoiceNo;



SELECT * FROM online_retail_features LIMIT 10;



				





 



