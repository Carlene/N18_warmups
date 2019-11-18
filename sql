-- Return to Window Functions!
-- BASIC SYNTAX
-- SELECT <aggregator> OVER(PARTITION BY <col1> ORDER BY <col2>)
-- PARTITION BY (like GROUP BY) a column to do the aggregation within particular category in <col1>
-- Choose what order to apply the aggregator over (if it's a type of RANK)
-- Example SELECT SUM(sales) OVER(PARTITION BY department)
-- Feel free to google RANK examples too.



-- Return a list of all customers, RANKED in order from highest to lowest total spendings
-- WITHIN the country they live in.
-- HINT: find a way to join the order_details, products, and customers tables


WITH price_per_order AS
(SELECT
	contactname
	,country
	,SUM(od.unitprice * od.quantity) AS price_per_product

FROM 
	customers AS cust 
JOIN 
	orders AS o
	ON cust.customerid = o.customerid
JOIN orderdetails AS od
	ON o.orderid = od.orderid

GROUP BY
	1, 2

ORDER BY 
	1)

SELECT
	contactname
	,country
	,SUM(price_per_product)
	,RANK() OVER (PARTITION BY country ORDER BY price_per_product DESC)

FROM
	price_per_order

GROUP BY
	2, 1, price_per_product



-- Return the same list as before, but with only the top 3 customers in each country.

WITH price_per_order AS
(SELECT
	contactname
	,country
	,SUM(od.unitprice * od.quantity) AS price_per_product

FROM 
	customers AS cust 
JOIN 
	orders AS o
	ON cust.customerid = o.customerid
JOIN orderdetails AS od
	ON o.orderid = od.orderid

GROUP BY
	1, 2

ORDER BY 
	1)

SELECT *

FROM
	(SELECT
	contactname
	,country
	,SUM(price_per_product)
	,RANK() OVER (PARTITION BY country ORDER BY price_per_product DESC)
	,ROW_NUMBER() OVER (PARTITION BY country) AS top_3

FROM
	price_per_order

GROUP BY
	2, 1, price_per_product) as top3_list

WHERE
	top_3 < 4

