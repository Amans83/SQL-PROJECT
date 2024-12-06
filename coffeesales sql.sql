use aman;
select * from coffee_sales;

-- objective - to find insights related to sales of different products for this company

-- 1. year-on-year sales 

select year(Date) as year, sum(Sales) as total_sales
from coffeesales c
group by 1
order by 1;

-- the company has seen increase in sales till 2014 and then it declined in 2015

select date,str_to_date(Date,"%m/%d/%Y")
from coffeesales;

-- str_to_date --> converts text to date type 

-- clean date column
 
SET SQL_SAFE_UPDATES = 0; -- disabling the safe mode
 
UPDATE coffeesales 
SET Date = STR_TO_DATE(Date, '%m/%d/%Y');

select * from coffeesales;

-- Query for YoY Percentage Change 

WITH yearly_sales AS (
    SELECT 
        YEAR(STR_TO_DATE(Date, '%m/%d/%Y')) AS year, 
        SUM(Sales) AS total_sales
    FROM 
        coffeesales
    GROUP BY 
        YEAR(STR_TO_DATE(Date, '%m/%d/%Y'))
)
SELECT 
    year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY year) AS previous_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year)) 
        / LAG(total_sales) OVER (ORDER BY year) * 100, 
        2
    ) AS yoy_percentage_change
FROM 
    yearly_sales
ORDER BY 
    year;


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
FROM 
    coffeesales
GROUP BY 
    MONTH(Date)
ORDER BY 
    Month;

-- what are the different products 

select distinct Product from  coffeesales;

-- produuct vs sales

select Product, sum(Sales) as total_sales
 from coffeesales
 group by 1
 order by 2 desc;



-- 1.Find the best-performing product lines by total profit
-- 2.Compare actual vs target sales across different states
-- 3. Identify areas with the largest gaps between actual and target profits
-- 4. Calculate average margin for each product type
-- 5. Analyze inventory margin vs marketing expenses
-- 6. Rank the states by their market size

-- 1.Find the best-performing product lines by total profit
SELECT 
    Product_line,
    SUM(Profit) AS Total_Profit
FROM 
    coffeesales
GROUP BY 
    Product_line
ORDER BY  2 desc;
-- Beans is the best performing product line with total profit of 35365 

-- 2.Compare actual vs target sales across different states
with s as (select State,
sum(Sales) as actual_sales, sum(Target_sales) as target_sales
from coffeesales
group by 1)

select State, actual_sales,Target_sales,
case when actual_sales >=  target_sales then 'Profitable'
when actual_sales < target_sales then 'Loss'
else null end as Target_status
from s;

-- 3. Identify areas with the largest gaps between actual and target profits

select count(distinct `Area Code`)
from coffeesales;
-- top 5 areas

select `Area Code`, sum(DifferenceBetweenActualandTargetProfit) as diff
from coffeesales
group by 1
order by 2 desc
limit 5;

-- 4. Calculate average margin for each product type

SELECT 
    Product_type,
    AVG(Margin) AS Average_Margin
FROM 
    coffeesales
GROUP BY 
    Product_type
ORDER BY 
    Average_Margin DESC;
    
    
-- 5. Analyze inventory margin vs marketing expenses

SELECT 
    Product_line,
    AVG(`Inventory Margin`) AS Avg_Inventory_Margin,
    AVG(Marketing) AS Avg_Marketing
FROM 
    coffeesales
GROUP BY 
    Product_line
ORDER BY 
    Avg_Inventory_Margin DESC;

-- 6. Rank the states by their market size

SELECT 
    State,
    Market_size,
    RANK() OVER (ORDER BY Market_size DESC) AS Rank_by_Market_Size
FROM 
    coffeesales
GROUP BY 
    State, Market_size
ORDER BY 
    Rank_by_Market_Size;
    

