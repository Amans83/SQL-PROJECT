USE aman; 

set SQL_SAFE_UPDATES=0;

select * from coffeesales;

UPDATE coffeesales
SET Date = STR_TO_DATE(Date,'%Y/%M/%D');

UPDATE coffeesales 
SET Date = STR_TO_DATE(Date, '%m/%d/%Y');


SELECT YEAR (Date), SUM(Sales) as totalsale
FROM coffeesales
group by 1 ;
 -- Query for YoY Percentage Change  
SELECT 
    YEAR(Date) AS Year,
    SUM(Sales) AS Total_Sales,
    LAG(SUM(Sales)) OVER (ORDER BY YEAR(Date)) AS Previous_Year_Sales,
    (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR(Date))) / 
    LAG(SUM(Sales)) OVER (ORDER BY YEAR(Date)) * 100 AS YoY_Percentage_Change
FROM coffeesales
GROUP BY 1
ORDER BY Year;

-- monhtly sales

select monthname(Date) as month, sum(Sales) as total_sales
from coffeesales c
group by 1;



-- mid year - spike in sales

SELECT 
    MONTH(Date) AS Month,
    SUM(Sales) AS Total_Sales,
    AVG(SUM(Sales)) OVER () AS Average_Sales,
    SUM(Sales) - AVG(SUM(Sales)) OVER () AS Deviation,
    ((SUM(Sales) - AVG(SUM(Sales)) OVER ()) / AVG(SUM(Sales)) OVER ()) * 100 AS Percent_Deviation
FROM coffeesales
GROUP BY MONTH(Date)
ORDER BY Month;


-- what are the different products
select distinct Product from coffeesales;

-- produuct vs sales
SELECT Product, sum(Sales)
from coffeesales
group by 1
order by 2 desc; 

-- per day sales 
SELECT Date, SUM(Sales) AS Total_Sales_Per_Day
FROM coffeesales
GROUP BY Date
ORDER BY Date;

-- total profit made each year 
select YEAR(Date) as Year, SUM(Profit) as profit_made
from coffeesales
group by 1;

-- % INCREASE OR DECREASE IN PROFIT 


-- TYPES OF PRODUCT 
SELECT DISTINCT Product,  Product_type, Product_line 
from coffeesales;

-- product and type 
select DISTINCT Product, Type 
from coffeesales;


SELECT Date, Product_type, Product, DifferenceBetweenActualandTargetProfit, Margin, Marketing, Profit, Sales, Sales,
 Target_margin, Target_profit, Target_sales, Total_expenses
FROM coffeesales;


-- INVENTORY MARGIN EVERY YEAR 
SELECT YEAR (Date),  sum(`Inventory Margin`) 
FROM coffeesales
group by 1;

SELECT `Inventory Margin` FROM coffeesales;
-- 1.Find the best-performing product lines by total profit
select Product, SUM(Profit) as totalprofit
from coffeesales
group by 1
order by  totalprofit  desc
limit 10;


-- Compare actual vs target sales across different states
select State, sum(Sales), sum(Target_sales), (sum(Sales)-sum(Target_sales)) as sales_diff
from coffeesales
group by 1;


--  Identify areas with the largest gaps between actual and target profits

select State, sum(Sales), sum(Target_sales), (sum(Sales)-sum(Target_sales)) as sales_diff
from coffeesales
group by 1
order by sales_diff asc ;

-- Calculate average margin for each product type 

select Product_type, AVG(Margin) as avg_mrgin
from coffeesales
group by 1
order by avg_mrgin desc ;

--5. Analyze inventory margin vs marketing expenses

select Product_line, AVG(`Inventory Margin`), AVG( Marketing)
from coffeesales
GROUP BY 1;

select * from coffeesales;


-- 6.Rank the states by their market size

select State, Market_Size,
RANK() OVER (ORDER BY  Market_Size DESC) AS RANK_BY_Market_Size
from coffeesales
GROUP BY State, Market_Size
ORDER BY RANK_BY_Market_Size;
;


--- UNBOUNDED AND preceding 
-- cummulative total

	select Date, sales,
	sum(Sales) over (partition by year(Date) order by year(Date) 
	rows between 3 preceding 
	and current row) as cum_sales
	from coffeesales;
