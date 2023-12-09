--Task Description
--Identify the subcategories of products with consistently higher sales from 1998 to 2001 compared to the previous year. Follow the instructions below:
--Determine the sales for each subcategory from 1998 to 2001.
--Calculate the sales for the previous year for each subcategory.
--Identify subcategories where the sales from 1998 to 2001 are consistently higher than the previous year.
--Generate a dataset with a single column containing the identified prod_subcategory values.


WITH yearly_sales AS (
    SELECT
        p.prod_subcategory,
        t.calendar_year,
        SUM(s.amount_sold) as total_sales
    FROM
        sh.sales s
    JOIN sh.products p ON s.prod_id = p.prod_id
    JOIN sh.times t ON s.time_id = t.time_id
    WHERE
        t.calendar_year BETWEEN 1997 AND 2001
    GROUP BY
        p.prod_subcategory, t.calendar_year
),
sales_with_previous_year AS (
    SELECT
        prod_subcategory,
        calendar_year,
        total_sales,
        LAG(total_sales, 1) OVER (PARTITION BY prod_subcategory ORDER BY calendar_year) AS previous_year_sales
    FROM
        yearly_sales
)
SELECT
    prod_subcategory,
    calendar_year,
    total_sales,
    previous_year_sales
FROM
    sales_with_previous_year
WHERE
    calendar_year BETWEEN 1998 AND 2001


-- CTE: yearly_sales
-- To calculate the total sales for each product subcategory in each calendar year from 1997 to 2001.
-- SELECT p.prod_subcategory, t.calendar_year, SUM(s.amount_sold) AS total_sales:
--     Selects product subcategory, calendar year, and sums up the sales amount for each subcategory per year.
-- FROM sh.sales s JOIN sh.products p ON s.prod_id = p.prod_id JOIN sh.times t ON s.time_id = t.time_id:
--     Joins the sales, products, and times tables to consolidate data from these tables.
-- WHERE t.calendar_year BETWEEN 1997 AND 2001:
--     Filters records for the years between 1997 and 2001.
-- GROUP BY p.prod_subcategory, t.calendar_year:
--     Groups the results by product subcategory and calendar year.

-- CTE: sales_with_previous_year
-- To calculate the total sales for each product subcategory in each year and its previous year's sales.
-- SELECT prod_subcategory, calendar_year, total_sales, LAG(total_sales, 1) OVER (PARTITION BY prod_subcategory ORDER BY calendar_year) AS previous_year_sales:
--     Selects product subcategory, calendar year, total sales for the year, and the total sales of the previous year.
--     The LAG function is used to get the previous year's sales for each subcategory.
-- FROM yearly_sales:
--     Retrieves data from the 'yearly_sales' CTE.

-- Final SELECT Query
-- To retrieve product subcategory, calendar year, total sales for the year, and previous year's sales for each year between 1998 and 2001.
-- SELECT prod_subcategory, calendar_year, total_sales, previous_year_sales:
--     Selects the required columns from the 'sales_with_previous_year' CTE.
-- FROM sales_with_previous_year:
--     Retrieves data from the 'sales_with_previous_year' CTE.
-- WHERE calendar_year BETWEEN 1998 AND 2001:
--     Filters records for the years between 1998 and 2001.

