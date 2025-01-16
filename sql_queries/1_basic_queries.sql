/*
1. Best-Selling Products:
Find the top 10 best-selling products in the company's history (in terms of the number of units sold).
*/

SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details AS od
INNER JOIN products AS p
USING (product_id)
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

/*
2. Order Count:
Calculate the number of orders placed by each customer.
*/

SELECT customer_id, company_name, COUNT(order_id) AS order_count
FROM orders
INNER JOIN customers
USING (customer_id)
GROUP BY customer_id, company_name
ORDER BY order_count DESC;

/*
3. Employees with the Longest Tenure:
Identify employees with the longest tenure at the company.
*/

SELECT CONCAT(last_name, ' ', first_name) AS employee, CONCAT(DATE_PART('year', AGE(NOW(), hire_date)), ' years and ', DATE_PART('month', AGE(NOW(), hire_date)), ' months') AS tenure
FROM employees
ORDER BY NOW()::date - hire_date DESC;



/*
4. Orders from Specific Countries:
Display the number of orders placed by customers from each country.
*/

SELECT country, COUNT(order_id) AS order_count
FROM orders
INNER JOIN customers
USING (customer_id)
GROUP BY country
ORDER BY order_count DESC;



/*
###### RESULTS ######
*/

/*
Task 1 results:
[
  {
    "product_id": 60,
    "product_name": "Camembert Pierrot",
    "total_quantity": "1577"
  },
  {
    "product_id": 59,
    "product_name": "Raclette Courdavault",
    "total_quantity": "1496"
  },
  {
    "product_id": 31,
    "product_name": "Gorgonzola Telino",
    "total_quantity": "1397"
  },
  {
    "product_id": 56,
    "product_name": "Gnocchi di nonna Alice",
    "total_quantity": "1263"
  },
  {
    "product_id": 16,
    "product_name": "Pavlova",
    "total_quantity": "1158"
  },
  {
    "product_id": 75,
    "product_name": "Rhönbräu Klosterbier",
    "total_quantity": "1155"
  },
  {
    "product_id": 24,
    "product_name": "Guaraná Fantástica",
    "total_quantity": "1125"
  },
  {
    "product_id": 40,
    "product_name": "Boston Crab Meat",
    "total_quantity": "1103"
  },
  {
    "product_id": 62,
    "product_name": "Tarte au sucre",
    "total_quantity": "1083"
  },
  {
    "product_id": 2,
    "product_name": "Chang",
    "total_quantity": "1057"
  }
]
*/

/*
Task 2 results:
[
  {
    "customer_id": "SAVEA",
    "company_name": "Save-a-lot Markets",
    "order_count": "31"
  },
  {
    "customer_id": "ERNSH",
    "company_name": "Ernst Handel",
    "order_count": "30"
  },
  {
    "customer_id": "QUICK",
    "company_name": "QUICK-Stop",
    "order_count": "28"
  },
  {
    "customer_id": "HUNGO",
    "company_name": "Hungry Owl All-Night Grocers",
    "order_count": "19"
  },
  {
    "customer_id": "FOLKO",
    "company_name": "Folk och fä HB",
    "order_count": "19"
  },
  {
    "customer_id": "RATTC",
    "company_name": "Rattlesnake Canyon Grocery",
    "order_count": "18"
  },
  {
    "customer_id": "BERGS",
    "company_name": "Berglunds snabbköp",
    "order_count": "18"
  },
  {
    "customer_id": "HILAA",
    "company_name": "HILARION-Abastos",
    "order_count": "18"
  },
  {
    "customer_id": "BONAP",
    "company_name": "Bon app'",
    "order_count": "17"
  },
  {
    "customer_id": "FRANK",
    "company_name": "Frankenversand",
    "order_count": "15"
  },
  {
    "customer_id": "WARTH",
    "company_name": "Wartian Herkku",
    "order_count": "15"
  },
  {
    "customer_id": "LEHMS",
    "company_name": "Lehmanns Marktstand",
    "order_count": "15"
  },
  {
    "customer_id": "LAMAI",
    "company_name": "La maison d'Asie",
    "order_count": "14"
  },
  {
    "customer_id": "WHITC",
    "company_name": "White Clover Markets",
    "order_count": "14"
  },
  {
    "customer_id": "KOENE",
    "company_name": "Königlich Essen",
    "order_count": "14"
  },
  {
    "customer_id": "HANAR",
    "company_name": "Hanari Carnes",
    "order_count": "14"
  },
  {
    "customer_id": "BOTTM",
    "company_name": "Bottom-Dollar Markets",
    "order_count": "14"
  },
  {
    "customer_id": "LILAS",
    "company_name": "LILA-Supermercado",
    "order_count": "14"
  },
  {
    "customer_id": "AROUT",
    "company_name": "Around the Horn",
    "order_count": "13"
  },
  {
    "customer_id": "QUEEN",
    "company_name": "Queen Cozinha",
    "order_count": "13"
  },
  {
    "customer_id": "MEREP",
    "company_name": "Mère Paillarde",
    "order_count": "13"
  },
  {
    "customer_id": "SUPRD",
    "company_name": "Suprêmes délices",
    "order_count": "12"
  },
  {
    "customer_id": "LINOD",
    "company_name": "LINO-Delicateses",
    "order_count": "12"
  },
  {
    "customer_id": "REGGC",
    "company_name": "Reggiani Caseifici",
    "order_count": "12"
  },
  {
    "customer_id": "GREAL",
    "company_name": "Great Lakes Food Market",
    "order_count": "11"
  },
  {
    "customer_id": "RICAR",
    "company_name": "Ricardo Adocicados",
    "order_count": "11"
  },
  {
    "customer_id": "BLONP",
    "company_name": "Blondesddsl père et fils",
    "order_count": "11"
  },
  {
    "customer_id": "VAFFE",
    "company_name": "Vaffeljernet",
    "order_count": "11"
  },
  {
    "customer_id": "ISLAT",
    "company_name": "Island Trading",
    "order_count": "10"
  },
  {
    "customer_id": "BSBEV",
    "company_name": "B's Beverages",
    "order_count": "10"
  },
  {
    "customer_id": "OLDWO",
    "company_name": "Old World Delicatessen",
    "order_count": "10"
  },
  {
    "customer_id": "RICSU",
    "company_name": "Richter Supermarkt",
    "order_count": "10"
  },
  {
    "customer_id": "TORTU",
    "company_name": "Tortuga Restaurante",
    "order_count": "10"
  },
  {
    "customer_id": "OTTIK",
    "company_name": "Ottilies Käseladen",
    "order_count": "10"
  },
  {
    "customer_id": "GODOS",
    "company_name": "Godos Cocina Típica",
    "order_count": "10"
  },
  {
    "customer_id": "WANDK",
    "company_name": "Die Wandernde Kuh",
    "order_count": "10"
  },
  {
    "customer_id": "VICTE",
    "company_name": "Victuailles en stock",
    "order_count": "10"
  },
  {
    "customer_id": "MAGAA",
    "company_name": "Magazzini Alimentari Riuniti",
    "order_count": "10"
  },
  {
    "customer_id": "PICCO",
    "company_name": "Piccolo und mehr",
    "order_count": "10"
  },
  {
    "customer_id": "WELLI",
    "company_name": "Wellington Importadora",
    "order_count": "9"
  },
  {
    "customer_id": "GOURL",
    "company_name": "Gourmet Lanchonetes",
    "order_count": "9"
  },
  {
    "customer_id": "SPLIR",
    "company_name": "Split Rail Beer & Ale",
    "order_count": "9"
  },
  {
    "customer_id": "QUEDE",
    "company_name": "Que Delícia",
    "order_count": "9"
  },
  {
    "customer_id": "SEVES",
    "company_name": "Seven Seas Imports",
    "order_count": "9"
  },
  {
    "customer_id": "FURIB",
    "company_name": "Furia Bacalhau e Frutos do Mar",
    "order_count": "8"
  },
  {
    "customer_id": "CHOPS",
    "company_name": "Chop-suey Chinese",
    "order_count": "8"
  },
  {
    "customer_id": "EASTC",
    "company_name": "Eastern Connection",
    "order_count": "8"
  },
  {
    "customer_id": "LONEP",
    "company_name": "Lonesome Pine Restaurant",
    "order_count": "8"
  },
  {
    "customer_id": "WOLZA",
    "company_name": "Wolski  Zajazd",
    "order_count": "7"
  },
  {
    "customer_id": "WILMK",
    "company_name": "Wilman Kala",
    "order_count": "7"
  },
  {
    "customer_id": "FAMIA",
    "company_name": "Familia Arquibaldo",
    "order_count": "7"
  },
  {
    "customer_id": "ANTON",
    "company_name": "Antonio Moreno Taquería",
    "order_count": "7"
  },
  {
    "customer_id": "BLAUS",
    "company_name": "Blauer See Delikatessen",
    "order_count": "7"
  },
  {
    "customer_id": "SIMOB",
    "company_name": "Simons bistro",
    "order_count": "7"
  },
  {
    "customer_id": "MAISD",
    "company_name": "Maison Dewey",
    "order_count": "7"
  },
  {
    "customer_id": "TOMSP",
    "company_name": "Toms Spezialitäten",
    "order_count": "6"
  },
  {
    "customer_id": "ALFKI",
    "company_name": "Alfreds Futterkiste",
    "order_count": "6"
  },
  {
    "customer_id": "DRACD",
    "company_name": "Drachenblut Delikatessen",
    "order_count": "6"
  },
  {
    "customer_id": "PERIC",
    "company_name": "Pericles Comidas clásicas",
    "order_count": "6"
  },
  {
    "customer_id": "FRANS",
    "company_name": "Franchi S.p.A.",
    "order_count": "6"
  },
  {
    "customer_id": "CACTU",
    "company_name": "Cactus Comidas para llevar",
    "order_count": "6"
  },
  {
    "customer_id": "SANTG",
    "company_name": "Santé Gourmet",
    "order_count": "6"
  },
  {
    "customer_id": "TRADH",
    "company_name": "Tradição Hipermercados",
    "order_count": "6"
  },
  {
    "customer_id": "OCEAN",
    "company_name": "Océano Atlántico Ltda.",
    "order_count": "5"
  },
  {
    "customer_id": "FOLIG",
    "company_name": "Folies gourmandes",
    "order_count": "5"
  },
  {
    "customer_id": "GALED",
    "company_name": "Galería del gastrónomo",
    "order_count": "5"
  },
  {
    "customer_id": "ROMEY",
    "company_name": "Romero y tomillo",
    "order_count": "5"
  },
  {
    "customer_id": "PRINI",
    "company_name": "Princesa Isabel Vinhos",
    "order_count": "5"
  },
  {
    "customer_id": "MORGK",
    "company_name": "Morgenstern Gesundkost",
    "order_count": "5"
  },
  {
    "customer_id": "COMMI",
    "company_name": "Comércio Mineiro",
    "order_count": "5"
  },
  {
    "customer_id": "HUNGC",
    "company_name": "Hungry Coyote Import Store",
    "order_count": "5"
  },
  {
    "customer_id": "VINET",
    "company_name": "Vins et alcools Chevalier",
    "order_count": "5"
  },
  {
    "customer_id": "RANCH",
    "company_name": "Rancho grande",
    "order_count": "5"
  },
  {
    "customer_id": "LETSS",
    "company_name": "Let's Stop N Shop",
    "order_count": "4"
  },
  {
    "customer_id": "LACOR",
    "company_name": "La corne d'abondance",
    "order_count": "4"
  },
  {
    "customer_id": "DUMON",
    "company_name": "Du monde entier",
    "order_count": "4"
  },
  {
    "customer_id": "SPECD",
    "company_name": "Spécialités du monde",
    "order_count": "4"
  },
  {
    "customer_id": "THEBI",
    "company_name": "The Big Cheese",
    "order_count": "4"
  },
  {
    "customer_id": "ANATR",
    "company_name": "Ana Trujillo Emparedados y helados",
    "order_count": "4"
  },
  {
    "customer_id": "LAUGB",
    "company_name": "Laughing Bacchus Wine Cellars",
    "order_count": "3"
  },
  {
    "customer_id": "FRANR",
    "company_name": "France restauration",
    "order_count": "3"
  },
  {
    "customer_id": "THECR",
    "company_name": "The Cracker Box",
    "order_count": "3"
  },
  {
    "customer_id": "CONSH",
    "company_name": "Consolidated Holdings",
    "order_count": "3"
  },
  {
    "customer_id": "BOLID",
    "company_name": "Bólido Comidas preparadas",
    "order_count": "3"
  },
  {
    "customer_id": "TRAIH",
    "company_name": "Trail's Head Gourmet Provisioners",
    "order_count": "3"
  },
  {
    "customer_id": "NORTS",
    "company_name": "North/South",
    "order_count": "3"
  },
  {
    "customer_id": "GROSR",
    "company_name": "GROSELLA-Restaurante",
    "order_count": "2"
  },
  {
    "customer_id": "LAZYK",
    "company_name": "Lazy K Kountry Store",
    "order_count": "2"
  },
  {
    "customer_id": "CENTC",
    "company_name": "Centro comercial Moctezuma",
    "order_count": "1"
  }
]
*/

/*
Task 3 results:
[
  {
    "employee": "Leverling Janet",
    "tenure": "32 years and 9 months"
  },
  {
    "employee": "Davolio Nancy",
    "tenure": "32 years and 8 months"
  },
  {
    "employee": "Fuller Andrew",
    "tenure": "32 years and 5 months"
  },
  {
    "employee": "Peacock Margaret",
    "tenure": "31 years and 8 months"
  },
  {
    "employee": "Buchanan Steven",
    "tenure": "31 years and 2 months"
  },
  {
    "employee": "Suyama Michael",
    "tenure": "31 years and 2 months"
  },
  {
    "employee": "King Robert",
    "tenure": "31 years and 0 months"
  },
  {
    "employee": "Callahan Laura",
    "tenure": "30 years and 10 months"
  },
  {
    "employee": "Dodsworth Anne",
    "tenure": "30 years and 2 months"
  }
]
*/

/*
Task 4 results:
[
  {
    "country": "Germany",
    "order_count": "122"
  },
  {
    "country": "USA",
    "order_count": "122"
  },
  {
    "country": "Brazil",
    "order_count": "83"
  },
  {
    "country": "France",
    "order_count": "77"
  },
  {
    "country": "UK",
    "order_count": "56"
  },
  {
    "country": "Venezuela",
    "order_count": "46"
  },
  {
    "country": "Austria",
    "order_count": "40"
  },
  {
    "country": "Sweden",
    "order_count": "37"
  },
  {
    "country": "Canada",
    "order_count": "30"
  },
  {
    "country": "Italy",
    "order_count": "28"
  },
  {
    "country": "Mexico",
    "order_count": "28"
  },
  {
    "country": "Spain",
    "order_count": "23"
  },
  {
    "country": "Finland",
    "order_count": "22"
  },
  {
    "country": "Ireland",
    "order_count": "19"
  },
  {
    "country": "Belgium",
    "order_count": "19"
  },
  {
    "country": "Denmark",
    "order_count": "18"
  },
  {
    "country": "Switzerland",
    "order_count": "18"
  },
  {
    "country": "Argentina",
    "order_count": "16"
  },
  {
    "country": "Portugal",
    "order_count": "13"
  },
  {
    "country": "Poland",
    "order_count": "7"
  },
  {
    "country": "Norway",
    "order_count": "6"
  }
]
*/