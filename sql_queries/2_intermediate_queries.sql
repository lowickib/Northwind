/*
1. Top Customers:
Find the top 5 customers who have spent the most money on orders.
*/

SELECT customer_id, company_name, country, ROUND(SUM(unit_price * (1 - discount) * quantity)) AS total_price
FROM order_details
INNER JOIN orders
USING (order_id)
INNER JOIN customers
USING (customer_id)
GROUP BY customer_id, company_name, country
ORDER BY total_price DESC
LIMIT 5;

/*
2. Quarterly Analysis:
Calculate total sales revenue for each quarter of every year.
*/

SELECT EXTRACT('year' FROM order_date) AS year, EXTRACT('quarter' FROM order_date) AS quarter, ROUND(SUM(unit_price * (1 - discount) * quantity)) AS total_price
FROM order_details
INNER JOIN orders
USING (order_id)
GROUP BY year, quarter
ORDER BY year, quarter

/*
3. Average Order Value:
Compute the average order value for each month over the last two years.
*/

SELECT EXTRACT('year' FROM order_date) AS year, EXTRACT('month' FROM order_date) AS month, AVG(unit_price * (1 - discount) * quantity) AS avg_price
FROM order_details
INNER JOIN orders
USING (order_id)
GROUP BY year, month
ORDER BY year, month

/*
4. Top Suppliers:
Identify suppliers who delivered the largest number of products.
*/

SELECT supplier_id, company_name, SUM(quantity) AS total_products_delivered
FROM order_details
INNER JOIN products
USING (product_id)
INNER JOIN suppliers
USING(supplier_id)
GROUP BY  supplier_id, company_name
ORDER BY total_products_delivered DESC;

/*
5. Delayed Orders:
Find orders that were delivered late (delivery date after the expected delivery date).
*/

SELECT MIN(delay) AS min_delay, MAX(delay) AS max_delay, AVG(delay) AS avg_delay
FROM
  (SELECT shipped_date - required_date AS delay
  FROM orders
  WHERE shipped_date > required_date) AS delays