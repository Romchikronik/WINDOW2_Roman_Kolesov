--Task Description
--Identify the subcategories of products with consistently higher sales from 1998 to 2001 compared to the previous year. Follow the instructions below:
--Determine the sales for each subcategory from 1998 to 2001.
--Calculate the sales for the previous year for each subcategory.
--Identify subcategories where the sales from 1998 to 2001 are consistently higher than the previous year.
--Generate a dataset with a single column containing the identified prod_subcategory values.


-- Select distinct product subcategories with increasing sales
SELECT DISTINCT prod_subcategory
FROM (
    -- Inner query to calculate current and previous year's sales for each subcategory
    SELECT 
        pr.prod_subcategory,
        t.calendar_year, 
        SUM(sl.amount_sold) AS current_sales,
        LAG(SUM(sl.amount_sold)) OVER (PARTITION BY pr.prod_subcategory ORDER BY t.calendar_year) AS previous_sales
    FROM 
        sh.products pr
        JOIN sh.sales sl ON pr.prod_id = sl.prod_id 
        JOIN sh.times t ON sl.time_id = t.time_id
    WHERE 
        t.calendar_year BETWEEN 1998 AND 2001  -- Focus on the years 1998 to 2001
    GROUP BY 
        pr.prod_subcategory, t.calendar_year  -- Group by subcategory and year
) subquery
WHERE 
    current_sales > previous_sales;  -- Select subcategories with increasing sales year-over-year

