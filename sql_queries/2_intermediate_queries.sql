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
ORDER BY year, quarter;

/*
3. Average Order Value:
Compute the average order value for each month over the last two years.
*/

SELECT EXTRACT('year' FROM order_date) AS year, EXTRACT('month' FROM order_date) AS month, AVG(unit_price * (1 - discount) * quantity) AS avg_price
FROM order_details
INNER JOIN orders
USING (order_id)
GROUP BY year, month
ORDER BY year, month;

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
  WHERE shipped_date > required_date) AS delays;

/*
###### RESULTS ######
*/

/*
Task 1 results:
[
  {
    "customer_id": "QUICK",
    "company_name": "QUICK-Stop",
    "country": "Germany",
    "total_price": 110277
  },
  {
    "customer_id": "ERNSH",
    "company_name": "Ernst Handel",
    "country": "Austria",
    "total_price": 104875
  },
  {
    "customer_id": "SAVEA",
    "company_name": "Save-a-lot Markets",
    "country": "USA",
    "total_price": 104362
  },
  {
    "customer_id": "RATTC",
    "company_name": "Rattlesnake Canyon Grocery",
    "country": "USA",
    "total_price": 51098
  },
  {
    "customer_id": "HUNGO",
    "company_name": "Hungry Owl All-Night Grocers",
    "country": "Ireland",
    "total_price": 49980
  }
]
*/

/*
Task 2 results:
[
  {
    "year": "1996",
    "quarter": "3",
    "total_price": 79729
  },
  {
    "year": "1996",
    "quarter": "4",
    "total_price": 128355
  },
  {
    "year": "1997",
    "quarter": "1",
    "total_price": 138289
  },
  {
    "year": "1997",
    "quarter": "2",
    "total_price": 143177
  },
  {
    "year": "1997",
    "quarter": "3",
    "total_price": 153938
  },
  {
    "year": "1997",
    "quarter": "4",
    "total_price": 181681
  },
  {
    "year": "1998",
    "quarter": "1",
    "total_price": 298492
  },
  {
    "year": "1998",
    "quarter": "2",
    "total_price": 142132
  }
]
*/

/*
Task 3 results:
[
  {
    "year": "1996",
    "month": "7",
    "avg_price": 472.23551067222985
  },
  {
    "year": "1996",
    "month": "8",
    "avg_price": 369.3518126194676
  },
  {
    "year": "1996",
    "month": "9",
    "avg_price": 462.8315812734659
  },
  {
    "year": "1996",
    "month": "10",
    "avg_price": 513.9140403490258
  },
  {
    "year": "1996",
    "month": "11",
    "avg_price": 690.9097759263184
  },
  {
    "year": "1996",
    "month": "12",
    "avg_price": 558.513956706351
  },
  {
    "year": "1997",
    "month": "1",
    "avg_price": 720.6831784468047
  },
  {
    "year": "1997",
    "month": "2",
    "avg_price": 487.1346196243582
  },
  {
    "year": "1997",
    "month": "3",
    "avg_price": 500.6132481782699
  },
  {
    "year": "1997",
    "month": "4",
    "avg_price": 654.7278072708826
  },
  {
    "year": "1997",
    "month": "5",
    "avg_price": 560.2217690118923
  },
  {
    "year": "1997",
    "month": "6",
    "avg_price": 478.457925457927
  },
  {
    "year": "1997",
    "month": "7",
    "avg_price": 662.6085392026599
  },
  {
    "year": "1997",
    "month": "8",
    "avg_price": 562.948448669705
  },
  {
    "year": "1997",
    "month": "9",
    "avg_price": 585.570972649993
  },
  {
    "year": "1997",
    "month": "10",
    "avg_price": 629.7096771295015
  },
  {
    "year": "1997",
    "month": "11",
    "avg_price": 489.143918736687
  },
  {
    "year": "1997",
    "month": "12",
    "avg_price": 626.302004069156
  },
  {
    "year": "1998",
    "month": "1",
    "avg_price": 619.8823039929987
  },
  {
    "year": "1998",
    "month": "2",
    "avg_price": 814.8794047787557
  },
  {
    "year": "1998",
    "month": "3",
    "avg_price": 589.0682865177358
  },
  {
    "year": "1998",
    "month": "4",
    "avg_price": 687.7704569752623
  },
  {
    "year": "1998",
    "month": "5",
    "avg_price": 310.739498850722
  }
]
*/

/*
Task 4 results:
[
  {
    "supplier_id": 12,
    "company_name": "Plutzer Lebensmittelgroßmärkte AG",
    "total_products_delivered": "4072"
  },
  {
    "supplier_id": 7,
    "company_name": "Pavlova, Ltd.",
    "total_products_delivered": "3937"
  },
  {
    "supplier_id": 8,
    "company_name": "Specialty Biscuits, Ltd.",
    "total_products_delivered": "3679"
  },
  {
    "supplier_id": 28,
    "company_name": "Gai pâturage",
    "total_products_delivered": "3073"
  },
  {
    "supplier_id": 15,
    "company_name": "Norske Meierier",
    "total_products_delivered": "2526"
  },
  {
    "supplier_id": 14,
    "company_name": "Formaggi Fortini s.r.l.",
    "total_products_delivered": "2500"
  },
  {
    "supplier_id": 24,
    "company_name": "G'day, Mate",
    "total_products_delivered": "2108"
  },
  {
    "supplier_id": 19,
    "company_name": "New England Seafood Cannery",
    "total_products_delivered": "2084"
  },
  {
    "supplier_id": 20,
    "company_name": "Leka Trading",
    "total_products_delivered": "1878"
  },
  {
    "supplier_id": 23,
    "company_name": "Karkki Oy",
    "total_products_delivered": "1736"
  },
  {
    "supplier_id": 2,
    "company_name": "New Orleans Cajun Delights",
    "total_products_delivered": "1735"
  },
  {
    "supplier_id": 26,
    "company_name": "Pasta Buttini s.r.l.",
    "total_products_delivered": "1697"
  },
  {
    "supplier_id": 29,
    "company_name": "Forêts d'érables",
    "total_products_delivered": "1686"
  },
  {
    "supplier_id": 25,
    "company_name": "Ma Maison",
    "total_products_delivered": "1658"
  },
  {
    "supplier_id": 16,
    "company_name": "Bigfoot Breweries",
    "total_products_delivered": "1573"
  },
  {
    "supplier_id": 3,
    "company_name": "Grandma Kelly's Homestead",
    "total_products_delivered": "1436"
  },
  {
    "supplier_id": 11,
    "company_name": "Heli Süßwaren GmbH & Co. KG",
    "total_products_delivered": "1436"
  },
  {
    "supplier_id": 6,
    "company_name": "Mayumi's",
    "total_products_delivered": "1417"
  },
  {
    "supplier_id": 18,
    "company_name": "Aux joyeux ecclésiastiques",
    "total_products_delivered": "1416"
  },
  {
    "supplier_id": 1,
    "company_name": "Exotic Liquids",
    "total_products_delivered": "1385"
  },
  {
    "supplier_id": 17,
    "company_name": "Svensk Sjöföda AB",
    "total_products_delivered": "1223"
  },
  {
    "supplier_id": 4,
    "company_name": "Tokyo Traders",
    "total_products_delivered": "1134"
  },
  {
    "supplier_id": 10,
    "company_name": "Refrescos Americanas LTDA",
    "total_products_delivered": "1125"
  },
  {
    "supplier_id": 21,
    "company_name": "Lyngbysild",
    "total_products_delivered": "1056"
  },
  {
    "supplier_id": 5,
    "company_name": "Cooperativa de Quesos 'Las Cabras'",
    "total_products_delivered": "1050"
  },
  {
    "supplier_id": 9,
    "company_name": "PB Knäckebröd AB",
    "total_products_delivered": "928"
  },
  {
    "supplier_id": 22,
    "company_name": "Zaanse Snoepfabriek",
    "total_products_delivered": "623"
  },
  {
    "supplier_id": 13,
    "company_name": "Nord-Ost-Fisch Handelsgesellschaft mbH",
    "total_products_delivered": "612"
  },
  {
    "supplier_id": 27,
    "company_name": "Escargots Nouveaux",
    "total_products_delivered": "534"
  }
]
*/

/*
Task 5 results:
[
  {
    "min_delay": 1,
    "max_delay": 23,
    "avg_delay": "6.3783783783783784"
  }
]
*/