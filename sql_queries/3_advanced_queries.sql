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
Czas realizacji zamówień:

Oblicz średni czas realizacji zamówienia (od daty zamówienia do daty dostawy) dla każdego miesiąca w ciągu ostatnich dwóch lat.
Użyj funkcji okienkowych do obliczenia bieżącej średniej kroczącej (rolling average) dla każdego miesiąca.
Trendy sprzedaży w czasie:

Oblicz procentową zmianę miesięcznej sprzedaży w porównaniu do poprzedniego miesiąca.
Użyj funkcji LAG lub LEAD.
Analiza tekstowa:

Znajdź wszystkie produkty, których nazwy zawierają określony wzorzec (np. "chocolate").
Policz, ile razy dany wzorzec występuje w nazwach produktów.
Segmentacja klientów:

Podziel klientów na grupy na podstawie ich wydatków: małe, średnie i duże (np. za pomocą funkcji NTILE).
Wyświetl listę klientów w każdej grupie.
Sezonowość zamówień:

Wykryj sezonowość w zamówieniach na podstawie dat zamówień.
Oblicz liczbę zamówień dla każdego miesiąca i zidentyfikuj miesiące o największym ruchu.
*/

/*
Advanced Level
Sales Ranking with Window Functions:
Calculate product rankings by total sales value, grouped by category.
*/



/*
Sales Trends Over Time:
Calculate the percentage change in monthly sales compared to the previous month.
*/

/*
Text Analysis:
Find all products whose names contain a specific pattern (e.g., "chocolate").
*/
/*
Customer Segmentation:
Segment customers into groups based on their spending: low, medium, and high.
*/
/*
Order Seasonality:
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