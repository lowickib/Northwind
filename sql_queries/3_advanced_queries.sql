/*
1. Sales Ranking with Window Functions:
Calculate product rankings by total sales value, grouped by category.
*/

WITH total_sales_rank AS (
SELECT 
  category_name, 
  product_name,
  SUM(order_details.unit_price * (1 - discount) * quantity) AS total_sale,
  RANK() OVER(PARTITION BY category_name ORDER BY SUM(order_details.unit_price * (1 - discount) * quantity) DESC) as category_rank
FROM order_details
INNER JOIN products
USING (product_id)
INNER JOIN categories
USING (category_id)
GROUP BY category_name, product_name)

SELECT category_name, product_name, total_sale, category_rank
FROM total_sales_rank
WHERE category_rank BETWEEN 1 AND 3;

/*
2. Order Fulfillment Time:
Calculate the average order fulfillment time (from order date to delivery date) for each month over the past two years.
Use window functions to calculate the rolling average for each month.
*/

WITH avg_time_month AS (
SELECT 
  date_trunc('month', order_date) AS order_month, 
  AVG(shipped_date - order_date) AS avg_fulfillment_time
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY date_trunc('month', order_date)
ORDER BY order_month
)

SELECT 
  TO_CHAR(order_month, 'YYYY-MM') AS year_and_month, avg_fulfillment_time,
  AVG(avg_fulfillment_time) OVER(ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_months_rolling_avg
FROM avg_time_month;


/*
3. Sales Trends Over Time:
Calculate the percentage change in monthly sales compared to the previous month.
*/

WITH total_sales AS (
  SELECT 
  order_id, 
  SUM(unit_price * (1 - discount) * quantity) AS total_sale
  FROM order_details
  GROUP BY order_id
), sales_by_month AS (
  SELECT 
  order_id, 
  TO_CHAR(date_trunc('month', order_date), 'YYYY-MM') as order_date, 
  total_sale
  FROM total_sales
  INNER JOIN orders
  USING(order_id)
), sales_comparison AS (
SELECT 
  order_date, 
  SUM(total_sale) AS total_sale,
  LAG(SUM(total_sale)) OVER(ORDER BY order_date) AS total_sale_prev_month
FROM sales_by_month
GROUP BY order_date
ORDER BY order_date
)

SELECT 
  order_date, 
  total_sale, 
  total_sale_prev_month,
  ROUND(CAST((total_sale - total_sale_prev_month) / total_sale_prev_month * 100 AS numeric), 2) AS percentage_change 
FROM sales_comparison
WHERE total_sale_prev_month IS NOT NULL 
AND order_date <> '1998-05'

/*
4. Text Analysis:
Find all products whose names contain a specific pattern (e.g., "chocolate").
*/

WITH chocolade_products AS(
SELECT product_id
FROM products
WHERE product_name ILIKE ANY (ARRAY['%chocolate%', '%chocolade%', '%schokolade%'])
),
total_sales AS (
  SELECT product_id, product_name, SUM(order_details.unit_price * (1 - discount) * quantity) AS total_sale
  FROM order_details
  INNER JOIN products
  USING(product_id)
  GROUP BY product_id, product_name
  ORDER BY total_sale DESC
)
SELECT
  ROUND(SUM(CASE WHEN product_id IN (SELECT product_id FROM chocolade_products) THEN total_sale ELSE 0 END)) AS total_sale_chocolade,
  ROUND(SUM(CASE WHEN product_id NOT IN (SELECT product_id FROM chocolade_products) THEN total_sale ELSE 0 END)) AS total_sale_non_chocolade
FROM total_sales

/*
5. Customer Segmentation:
Segment customers into groups based on their spending: low, medium, and high.
*/

WITH customers_spending AS (
SELECT 
  company_name, 
  ROUND(SUM(unit_price * (1 - discount) * quantity)) AS total_spending
FROM order_details
INNER JOIN orders
USING (order_id)
INNER JOIN customers
USING (customer_id)
GROUP BY company_name
ORDER BY total_spending DESC
), customers_ntiles AS (
SELECT 
  company_name, 
  total_spending,
  NTILE(3) OVER(ORDER BY total_spending DESC) AS ntile
FROM customers_spending
)

SELECT 
  company_name,
  total_spending,
  CASE
    WHEN ntile = 1 THEN 'high'
    WHEN ntile = 2 THEN 'medium'
    ELSE 'low'
  END AS customer_group
FROM customers_ntiles

/*
6. Order Seasonality:
Detect seasonality in orders based on order dates.
*/


/*
###### RESULTS ######
*/

/*
Task 1 results:
[
  {
    "category_name": "Beverages",
    "product_name": "Côte de Blaye",
    "total_sale": 141396.7356273254,
    "category_rank": "1"
  },
  {
    "category_name": "Beverages",
    "product_name": "Ipoh Coffee",
    "total_sale": 23526.699842727183,
    "category_rank": "2"
  },
  {
    "category_name": "Beverages",
    "product_name": "Chang",
    "total_sale": 16355.959905386866,
    "category_rank": "3"
  },
  {
    "category_name": "Condiments",
    "product_name": "Vegie-spread",
    "total_sale": 16701.095047264098,
    "category_rank": "1"
  },
  {
    "category_name": "Condiments",
    "product_name": "Sirop d'érable",
    "total_sale": 14352.599874171614,
    "category_rank": "2"
  },
  {
    "category_name": "Condiments",
    "product_name": "Louisiana Fiery Hot Pepper Sauce",
    "total_sale": 13869.8894459071,
    "category_rank": "3"
  },
  {
    "category_name": "Confections",
    "product_name": "Tarte au sucre",
    "total_sale": 47234.969978504174,
    "category_rank": "1"
  },
  {
    "category_name": "Confections",
    "product_name": "Sir Rodney's Marmalade",
    "total_sale": 22563.36029526442,
    "category_rank": "2"
  },
  {
    "category_name": "Confections",
    "product_name": "Gumbär Gummibärchen",
    "total_sale": 19849.14417082793,
    "category_rank": "3"
  },
  {
    "category_name": "Dairy Products",
    "product_name": "Raclette Courdavault",
    "total_sale": 71155.69990943,
    "category_rank": "1"
  },
  {
    "category_name": "Dairy Products",
    "product_name": "Camembert Pierrot",
    "total_sale": 46825.48029542655,
    "category_rank": "2"
  },
  {
    "category_name": "Dairy Products",
    "product_name": "Mozzarella di Giovanni",
    "total_sale": 24900.12939154029,
    "category_rank": "3"
  },
  {
    "category_name": "Grains/Cereals",
    "product_name": "Gnocchi di nonna Alice",
    "total_sale": 42593.0598222503,
    "category_rank": "1"
  },
  {
    "category_name": "Grains/Cereals",
    "product_name": "Wimmers gute Semmelknödel",
    "total_sale": 21957.96757586673,
    "category_rank": "2"
  },
  {
    "category_name": "Grains/Cereals",
    "product_name": "Singaporean Hokkien Fried Mee",
    "total_sale": 8574.999964818358,
    "category_rank": "3"
  },
  {
    "category_name": "Meat/Poultry",
    "product_name": "Thüringer Rostbratwurst",
    "total_sale": 80368.6724385033,
    "category_rank": "1"
  },
  {
    "category_name": "Meat/Poultry",
    "product_name": "Alice Mutton",
    "total_sale": 32698.380216373203,
    "category_rank": "2"
  },
  {
    "category_name": "Meat/Poultry",
    "product_name": "Perth Pasties",
    "total_sale": 20574.169932212233,
    "category_rank": "3"
  },
  {
    "category_name": "Produce",
    "product_name": "Manjimup Dried Apples",
    "total_sale": 41819.65024582073,
    "category_rank": "1"
  },
  {
    "category_name": "Produce",
    "product_name": "Rössle Sauerkraut",
    "total_sale": 25696.63978933155,
    "category_rank": "2"
  },
  {
    "category_name": "Produce",
    "product_name": "Uncle Bob's Organic Dried Pears",
    "total_sale": 22044.29998782277,
    "category_rank": "3"
  },
  {
    "category_name": "Seafood",
    "product_name": "Carnarvon Tigers",
    "total_sale": 29171.874963399023,
    "category_rank": "1"
  },
  {
    "category_name": "Seafood",
    "product_name": "Ikura",
    "total_sale": 20867.339869279265,
    "category_rank": "2"
  },
  {
    "category_name": "Seafood",
    "product_name": "Boston Crab Meat",
    "total_sale": 17910.62964561701,
    "category_rank": "3"
  }
]
*/

/*
Task 2 results:
[
  {
    "year_and_month": "1996-07",
    "avg_fulfillment_time": "8.0454545454545455",
    "three_months_rolling_avg": "8.0454545454545455"
  },
  {
    "year_and_month": "1996-08",
    "avg_fulfillment_time": "8.0000000000000000",
    "three_months_rolling_avg": "8.0227272727272728"
  },
  {
    "year_and_month": "1996-09",
    "avg_fulfillment_time": "10.6086956521739130",
    "three_months_rolling_avg": "8.8847167325428195"
  },
  {
    "year_and_month": "1996-10",
    "avg_fulfillment_time": "6.5000000000000000",
    "three_months_rolling_avg": "8.3695652173913043"
  },
  {
    "year_and_month": "1996-11",
    "avg_fulfillment_time": "8.3600000000000000",
    "three_months_rolling_avg": "8.4895652173913043"
  },
  {
    "year_and_month": "1996-12",
    "avg_fulfillment_time": "7.5161290322580645",
    "three_months_rolling_avg": "7.4587096774193548"
  },
  {
    "year_and_month": "1997-01",
    "avg_fulfillment_time": "9.9696969696969697",
    "three_months_rolling_avg": "8.6152753339850114"
  },
  {
    "year_and_month": "1997-02",
    "avg_fulfillment_time": "9.3103448275862069",
    "three_months_rolling_avg": "8.9320569431804137"
  },
  {
    "year_and_month": "1997-03",
    "avg_fulfillment_time": "8.3000000000000000",
    "three_months_rolling_avg": "9.1933472657610589"
  },
  {
    "year_and_month": "1997-04",
    "avg_fulfillment_time": "9.0000000000000000",
    "three_months_rolling_avg": "8.8701149425287356"
  },
  {
    "year_and_month": "1997-05",
    "avg_fulfillment_time": "9.1562500000000000",
    "three_months_rolling_avg": "8.8187500000000000"
  },
  {
    "year_and_month": "1997-06",
    "avg_fulfillment_time": "8.8333333333333333",
    "three_months_rolling_avg": "8.9965277777777778"
  },
  {
    "year_and_month": "1997-07",
    "avg_fulfillment_time": "8.6969696969696970",
    "three_months_rolling_avg": "8.8955176767676768"
  },
  {
    "year_and_month": "1997-08",
    "avg_fulfillment_time": "6.7878787878787879",
    "three_months_rolling_avg": "8.1060606060606061"
  },
  {
    "year_and_month": "1997-09",
    "avg_fulfillment_time": "9.1351351351351351",
    "three_months_rolling_avg": "8.2066612066612067"
  },
  {
    "year_and_month": "1997-10",
    "avg_fulfillment_time": "8.7105263157894737",
    "three_months_rolling_avg": "8.2111800796011322"
  },
  {
    "year_and_month": "1997-11",
    "avg_fulfillment_time": "8.7352941176470588",
    "three_months_rolling_avg": "8.8603185228572225"
  },
  {
    "year_and_month": "1997-12",
    "avg_fulfillment_time": "9.8541666666666667",
    "three_months_rolling_avg": "9.0999957000343997"
  },
  {
    "year_and_month": "1998-01",
    "avg_fulfillment_time": "9.0545454545454545",
    "three_months_rolling_avg": "9.2146687462863933"
  },
  {
    "year_and_month": "1998-02",
    "avg_fulfillment_time": "7.2222222222222222",
    "three_months_rolling_avg": "8.7103114478114478"
  },
  {
    "year_and_month": "1998-03",
    "avg_fulfillment_time": "9.3972602739726027",
    "three_months_rolling_avg": "8.5580093169134265"
  },
  {
    "year_and_month": "1998-04",
    "avg_fulfillment_time": "6.6507936507936508",
    "three_months_rolling_avg": "7.7567587156628252"
  },
  {
    "year_and_month": "1998-05",
    "avg_fulfillment_time": "2.5000000000000000",
    "three_months_rolling_avg": "6.1826846415887512"
  }
]
*/


/*
Task 3 results:
[
  {
    "order_date": "1996-08",
    "total_sale": 25485.275070743264,
    "total_sale_prev_month": 27861.89512966156,
    "percentage_change": "-8.53"
  },
  {
    "order_date": "1996-09",
    "total_sale": 26381.400132587554,
    "total_sale_prev_month": 25485.275070743264,
    "percentage_change": "3.52"
  },
  {
    "order_date": "1996-10",
    "total_sale": 37515.72494547888,
    "total_sale_prev_month": 26381.400132587554,
    "percentage_change": "42.21"
  },
  {
    "order_date": "1996-11",
    "total_sale": 45600.04521113702,
    "total_sale_prev_month": 37515.72494547888,
    "percentage_change": "21.55"
  },
  {
    "order_date": "1996-12",
    "total_sale": 45239.63049321443,
    "total_sale_prev_month": 45600.04521113702,
    "percentage_change": "-0.79"
  },
  {
    "order_date": "1997-01",
    "total_sale": 61258.07016797841,
    "total_sale_prev_month": 45239.63049321443,
    "percentage_change": "35.41"
  },
  {
    "order_date": "1997-02",
    "total_sale": 38483.6349503243,
    "total_sale_prev_month": 61258.07016797841,
    "percentage_change": "-37.18"
  },
  {
    "order_date": "1997-03",
    "total_sale": 38547.22010972678,
    "total_sale_prev_month": 38483.6349503243,
    "percentage_change": "0.17"
  },
  {
    "order_date": "1997-04",
    "total_sale": 53032.95238894149,
    "total_sale_prev_month": 38547.22010972678,
    "percentage_change": "37.58"
  },
  {
    "order_date": "1997-05",
    "total_sale": 53781.289825141655,
    "total_sale_prev_month": 53032.95238894149,
    "percentage_change": "1.41"
  },
  {
    "order_date": "1997-06",
    "total_sale": 36362.80233480245,
    "total_sale_prev_month": 53781.289825141655,
    "percentage_change": "-32.39"
  },
  {
    "order_date": "1997-07",
    "total_sale": 51020.85751860481,
    "total_sale_prev_month": 36362.80233480245,
    "percentage_change": "40.31"
  },
  {
    "order_date": "1997-08",
    "total_sale": 47287.66968825523,
    "total_sale_prev_month": 51020.85751860481,
    "percentage_change": "-7.32"
  },
  {
    "order_date": "1997-09",
    "total_sale": 55629.24240174934,
    "total_sale_prev_month": 47287.66968825523,
    "percentage_change": "17.64"
  },
  {
    "order_date": "1997-10",
    "total_sale": 66749.22577572716,
    "total_sale_prev_month": 55629.24240174934,
    "percentage_change": "19.99"
  },
  {
    "order_date": "1997-11",
    "total_sale": 43533.80876756514,
    "total_sale_prev_month": 66749.22577572716,
    "percentage_change": "-34.78"
  },
  {
    "order_date": "1997-12",
    "total_sale": 71398.42846388379,
    "total_sale_prev_month": 43533.80876756514,
    "percentage_change": "64.01"
  },
  {
    "order_date": "1998-01",
    "total_sale": 94222.11020693583,
    "total_sale_prev_month": 71398.42846388379,
    "percentage_change": "31.97"
  },
  {
    "order_date": "1998-02",
    "total_sale": 99415.2873830082,
    "total_sale_prev_month": 94222.11020693583,
    "percentage_change": "5.51"
  },
  {
    "order_date": "1998-03",
    "total_sale": 104854.15500015698,
    "total_sale_prev_month": 99415.2873830082,
    "percentage_change": "5.47"
  },
  {
    "order_date": "1998-04",
    "total_sale": 123798.6822555472,
    "total_sale_prev_month": 104854.15500015698,
    "percentage_change": "18.07"
  }
]
*/


/*
Task 4 results:
[
  {
    "total_sale_chocolade": 22331,
    "total_sale_non_chocolade": 1243462
  }
]
*/

/*
Task 5 results:
[
  {
    "company_name": "QUICK-Stop",
    "total_spending": 110277,
    "customer_group": "high"
  },
  {
    "company_name": "Ernst Handel",
    "total_spending": 104875,
    "customer_group": "high"
  },
  {
    "company_name": "Save-a-lot Markets",
    "total_spending": 104362,
    "customer_group": "high"
  },
  {
    "company_name": "Rattlesnake Canyon Grocery",
    "total_spending": 51098,
    "customer_group": "high"
  },
  {
    "company_name": "Hungry Owl All-Night Grocers",
    "total_spending": 49980,
    "customer_group": "high"
  },
  {
    "company_name": "Hanari Carnes",
    "total_spending": 32841,
    "customer_group": "high"
  },
  {
    "company_name": "Königlich Essen",
    "total_spending": 30908,
    "customer_group": "high"
  },
  {
    "company_name": "Folk och fä HB",
    "total_spending": 29568,
    "customer_group": "high"
  },
  {
    "company_name": "Mère Paillarde",
    "total_spending": 28872,
    "customer_group": "high"
  },
  {
    "company_name": "White Clover Markets",
    "total_spending": 27364,
    "customer_group": "high"
  },
  {
    "company_name": "Frankenversand",
    "total_spending": 26657,
    "customer_group": "high"
  },
  {
    "company_name": "Queen Cozinha",
    "total_spending": 25717,
    "customer_group": "high"
  },
  {
    "company_name": "Berglunds snabbköp",
    "total_spending": 24928,
    "customer_group": "high"
  },
  {
    "company_name": "Suprêmes délices",
    "total_spending": 24089,
    "customer_group": "high"
  },
  {
    "company_name": "Piccolo und mehr",
    "total_spending": 23129,
    "customer_group": "high"
  },
  {
    "company_name": "HILARION-Abastos",
    "total_spending": 22769,
    "customer_group": "high"
  },
  {
    "company_name": "Bon app'",
    "total_spending": 21963,
    "customer_group": "high"
  },
  {
    "company_name": "Bottom-Dollar Markets",
    "total_spending": 20802,
    "customer_group": "high"
  },
  {
    "company_name": "Richter Supermarkt",
    "total_spending": 19344,
    "customer_group": "high"
  },
  {
    "company_name": "Lehmanns Marktstand",
    "total_spending": 19261,
    "customer_group": "high"
  },
  {
    "company_name": "Blondesddsl père et fils",
    "total_spending": 18534,
    "customer_group": "high"
  },
  {
    "company_name": "Great Lakes Food Market",
    "total_spending": 18507,
    "customer_group": "high"
  },
  {
    "company_name": "Simons bistro",
    "total_spending": 16817,
    "customer_group": "high"
  },
  {
    "company_name": "LINO-Delicateses",
    "total_spending": 16477,
    "customer_group": "high"
  },
  {
    "company_name": "Seven Seas Imports",
    "total_spending": 16215,
    "customer_group": "high"
  },
  {
    "company_name": "LILA-Supermercado",
    "total_spending": 16077,
    "customer_group": "high"
  },
  {
    "company_name": "Vaffeljernet",
    "total_spending": 15844,
    "customer_group": "high"
  },
  {
    "company_name": "Wartian Herkku",
    "total_spending": 15649,
    "customer_group": "high"
  },
  {
    "company_name": "Old World Delicatessen",
    "total_spending": 15177,
    "customer_group": "high"
  },
  {
    "company_name": "Eastern Connection",
    "total_spending": 14761,
    "customer_group": "high"
  },
  {
    "company_name": "Around the Horn",
    "total_spending": 13391,
    "customer_group": "medium"
  },
  {
    "company_name": "Ottilies Käseladen",
    "total_spending": 12496,
    "customer_group": "medium"
  },
  {
    "company_name": "Ricardo Adocicados",
    "total_spending": 12451,
    "customer_group": "medium"
  },
  {
    "company_name": "Chop-suey Chinese",
    "total_spending": 12349,
    "customer_group": "medium"
  },
  {
    "company_name": "Folies gourmandes",
    "total_spending": 11667,
    "customer_group": "medium"
  },
  {
    "company_name": "Godos Cocina Típica",
    "total_spending": 11446,
    "customer_group": "medium"
  },
  {
    "company_name": "Split Rail Beer & Ale",
    "total_spending": 11442,
    "customer_group": "medium"
  },
  {
    "company_name": "Tortuga Restaurante",
    "total_spending": 10812,
    "customer_group": "medium"
  },
  {
    "company_name": "Maison Dewey",
    "total_spending": 9736,
    "customer_group": "medium"
  },
  {
    "company_name": "Die Wandernde Kuh",
    "total_spending": 9588,
    "customer_group": "medium"
  },
  {
    "company_name": "La maison d'Asie",
    "total_spending": 9328,
    "customer_group": "medium"
  },
  {
    "company_name": "Victuailles en stock",
    "total_spending": 9182,
    "customer_group": "medium"
  },
  {
    "company_name": "Gourmet Lanchonetes",
    "total_spending": 8414,
    "customer_group": "medium"
  },
  {
    "company_name": "Magazzini Alimentari Riuniti",
    "total_spending": 7176,
    "customer_group": "medium"
  },
  {
    "company_name": "Reggiani Caseifici",
    "total_spending": 7048,
    "customer_group": "medium"
  },
  {
    "company_name": "Antonio Moreno Taquería",
    "total_spending": 7024,
    "customer_group": "medium"
  },
  {
    "company_name": "Tradição Hipermercados",
    "total_spending": 6851,
    "customer_group": "medium"
  },
  {
    "company_name": "Que Delícia",
    "total_spending": 6665,
    "customer_group": "medium"
  },
  {
    "company_name": "Furia Bacalhau e Frutos do Mar",
    "total_spending": 6427,
    "customer_group": "medium"
  },
  {
    "company_name": "Island Trading",
    "total_spending": 6146,
    "customer_group": "medium"
  },
  {
    "company_name": "B's Beverages",
    "total_spending": 6090,
    "customer_group": "medium"
  },
  {
    "company_name": "Wellington Importadora",
    "total_spending": 6068,
    "customer_group": "medium"
  },
  {
    "company_name": "Santé Gourmet",
    "total_spending": 5735,
    "customer_group": "medium"
  },
  {
    "company_name": "Princesa Isabel Vinhos",
    "total_spending": 5045,
    "customer_group": "medium"
  },
  {
    "company_name": "Morgenstern Gesundkost",
    "total_spending": 5042,
    "customer_group": "medium"
  },
  {
    "company_name": "Toms Spezialitäten",
    "total_spending": 4778,
    "customer_group": "medium"
  },
  {
    "company_name": "Alfreds Futterkiste",
    "total_spending": 4273,
    "customer_group": "medium"
  },
  {
    "company_name": "Lonesome Pine Restaurant",
    "total_spending": 4259,
    "customer_group": "medium"
  },
  {
    "company_name": "Pericles Comidas clásicas",
    "total_spending": 4242,
    "customer_group": "medium"
  },
  {
    "company_name": "Bólido Comidas preparadas",
    "total_spending": 4233,
    "customer_group": "medium"
  },
  {
    "company_name": "Familia Arquibaldo",
    "total_spending": 4108,
    "customer_group": "low"
  },
  {
    "company_name": "Comércio Mineiro",
    "total_spending": 3811,
    "customer_group": "low"
  },
  {
    "company_name": "Drachenblut Delikatessen",
    "total_spending": 3763,
    "customer_group": "low"
  },
  {
    "company_name": "Wolski  Zajazd",
    "total_spending": 3532,
    "customer_group": "low"
  },
  {
    "company_name": "Océano Atlántico Ltda.",
    "total_spending": 3460,
    "customer_group": "low"
  },
  {
    "company_name": "The Big Cheese",
    "total_spending": 3361,
    "customer_group": "low"
  },
  {
    "company_name": "Blauer See Delikatessen",
    "total_spending": 3240,
    "customer_group": "low"
  },
  {
    "company_name": "France restauration",
    "total_spending": 3172,
    "customer_group": "low"
  },
  {
    "company_name": "Wilman Kala",
    "total_spending": 3161,
    "customer_group": "low"
  },
  {
    "company_name": "Let's Stop N Shop",
    "total_spending": 3076,
    "customer_group": "low"
  },
  {
    "company_name": "Hungry Coyote Import Store",
    "total_spending": 3063,
    "customer_group": "low"
  },
  {
    "company_name": "Rancho grande",
    "total_spending": 2844,
    "customer_group": "low"
  },
  {
    "company_name": "Spécialités du monde",
    "total_spending": 2423,
    "customer_group": "low"
  },
  {
    "company_name": "La corne d'abondance",
    "total_spending": 1992,
    "customer_group": "low"
  },
  {
    "company_name": "The Cracker Box",
    "total_spending": 1947,
    "customer_group": "low"
  },
  {
    "company_name": "Cactus Comidas para llevar",
    "total_spending": 1815,
    "customer_group": "low"
  },
  {
    "company_name": "Consolidated Holdings",
    "total_spending": 1719,
    "customer_group": "low"
  },
  {
    "company_name": "Du monde entier",
    "total_spending": 1616,
    "customer_group": "low"
  },
  {
    "company_name": "Trail's Head Gourmet Provisioners",
    "total_spending": 1571,
    "customer_group": "low"
  },
  {
    "company_name": "Franchi S.p.A.",
    "total_spending": 1546,
    "customer_group": "low"
  },
  {
    "company_name": "GROSELLA-Restaurante",
    "total_spending": 1489,
    "customer_group": "low"
  },
  {
    "company_name": "Vins et alcools Chevalier",
    "total_spending": 1480,
    "customer_group": "low"
  },
  {
    "company_name": "Romero y tomillo",
    "total_spending": 1467,
    "customer_group": "low"
  },
  {
    "company_name": "Ana Trujillo Emparedados y helados",
    "total_spending": 1403,
    "customer_group": "low"
  },
  {
    "company_name": "Galería del gastrónomo",
    "total_spending": 837,
    "customer_group": "low"
  },
  {
    "company_name": "North/South",
    "total_spending": 649,
    "customer_group": "low"
  },
  {
    "company_name": "Laughing Bacchus Wine Cellars",
    "total_spending": 522,
    "customer_group": "low"
  },
  {
    "company_name": "Lazy K Kountry Store",
    "total_spending": 357,
    "customer_group": "low"
  },
  {
    "company_name": "Centro comercial Moctezuma",
    "total_spending": 101,
    "customer_group": "low"
  }
]
*/