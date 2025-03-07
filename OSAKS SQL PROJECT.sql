---create aisle table
CREATE TABLE aisle(
aisle_id INT PRIMARY KEY,
aisle VARCHAR (50)
);


----create department table
CREATE TABLE departments(
department_id INT PRIMARY KEY,
department VARCHAR (50)
);


---create products table  
CREATE TABLE products(
product_id INT PRIMARY KEY,
product_name VARCHAR (250),
aisle_id INT REFERENCES aisle (aisle_id),
department_id INT REFERENCES departments (department_id),
unit_cost NUMERIC (10,3),
unit_price NUMERIC (10,3)
);



---create orders table
CREATE TABLE orders(
order_id INT,
user_id INT,
product_id INT REFERENCES products (product_id),
quantity INT,
order_date DATE,
order_dow VARCHAR (20),
order_hour_of_day INT,
days_since_prior_order INT,
order_status VARCHAR (20)
);


SELECT*
FROM orders;


SELECT*
FROM products;


SELECT*
FROM departments;


SELECT*
FROM aisle;



---Q1 WHAT ARE THE TOP SELLING PRODUCTS BY REVENUE 
---AND HOW MUCH REVENUE HAVE THEY GENERATED?
SELECT product_name,
       '$'||SUM(p.unit_price * o.quantity) AS total_revenue
FROM products AS p
JOIN orders AS o USING (product_id)
GROUP BY p.product_name
ORDER BY  SUM(p.unit_price* o.quantity) DESC;





---Q2 ON WHICH DAY OF THE WEEK ARE CHOCOLATES MOSTLY SOLD
SELECT p.product_name,
       o.order_dow,
	   SUM (o.quantity) AS total_quantity,
	   CASE
	        WHEN (o.order_dow) = '0' THEN 'Sunday'
			WHEN (o.order_dow) = '1'THEN 'Monday'
			WHEN (o.order_dow) = '2'THEN 'Tuesday'
			WHEN (o.order_dow) = '3'THEN 'Wednesday'
			WHEN (o.order_dow) = '4'THEN 'Thursday'
			WHEN (o.order_dow) = '5'THEN 'Friday'
			ELSE 'Saturday'
		END AS day_of_the_week
FROM products AS p
JOIN orders AS o USING (product_id)
WHERE product_name LIKE 'Chocolate'
GROUP BY o.order_dow,
         p.product_name
ORDER BY SUM (o.quantity) DESC
LIMIT 1;





---Q3 DO WE HAVE ANY DEPARTMENT WHERE WE HAVE MADE OVER $15MILLION IN 
---REVENUE AND WHAT IS THE PROFIT
SELECT d.department,
       '$'|| SUM (p.unit_price * o.quantity) AS total_revenue,
	   '$'|| SUM ((p.unit_price -p.unit_cost)* o.quantity) AS total_profit
FROM orders AS o 
INNER JOIN products AS p USING (product_id)
INNER JOIN departments AS d USING (department_id)
GROUP BY d.department
HAVING SUM(p.unit_price * o.quantity) > 15000000;





---Q4 IS IT TRUE THAT CUSTOMERS BOUGHT MORE ALCOHOLIC PRODUCTS ON XMAS DAY 2019
SELECT d.department,
       o.order_date,
	   SUM(o.quantity) AS number_of_orders
FROM departments AS d
INNER JOIN products AS p USING (department_id)
INNER JOIN orders AS o USING (product_id)
WHERE o.order_date = '2019-12-25'
GROUP BY d.department,
         o.order_date
ORDER BY number_of_orders DESC;
---ITS FALSE




---Q5 WHICH YEAR DID INSTACART GENERATE THE MOST PROFIT
SELECT EXTRACT(YEAR FROM o.order_date) AS year,
      '$' || SUM((p.unit_price-p.unit_cost) *o.quantity) total_profit
FROM products AS p
JOIN orders AS o USING (product_id)
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY SUM((p.unit_price-p.unit_cost) *o.quantity) DESC
LIMIT 1;




---Q6 HOW LONG HAS IT BEEN SINCE THE LAST CHEESE ORDER
SELECT MAX(o.days_since_prior_order),
       a.aisle
FROM aisle AS a
INNER JOIN products AS p USING (aisle_id)
INNER JOIN orders AS o USING (product_id)
WHERE a.aisle ILIKE '%cheese'
GROUP BY a.aisle;




---Q7 WHAT TIME OF THE DAY DO WE SELL ALCOHOL THE MOST
SELECT o.order_hour_of_day || 'GMT' AS time_of_day,
       SUM(o.quantity) AS no_of_orders,
	   d.department
FROM orders AS o
INNER JOIN products AS p USING (product_id)
INNER JOIN departments AS d USING (department_id)
WHERE d.department ILIKE '%Alcohol%'
GROUP BY o.order_hour_of_day,
         d.department
ORDER BY no_of_orders DESC
LIMIT 1;



---Q8 WHAT IS THE TOTALREVENUE GENERATED
---IN QTR 2 AND 3 OF 2016 FROM BREAD
SELECT '$' || SUM(p.unit_price*o.quantity) AS total_revenue,
        a.aisle AS Bread
FROM aisle AS a
INNER JOIN products AS p USING (aisle_id)
INNER JOIN orders AS o USING (product_id)
WHERE a.aisle = 'Bread' AND o.order_date BETWEEN '2016-04-01' AND '2016-09-30'
GROUP BY a.aisle
ORDER BY total_revenue;



----Q9 WHICH 3 PRODUCTS DO PEOPLE BUY AT NIGHT (2020-2022)
SELECT p.product_name,
       	SUM(o.quantity) total_quantity
FROM products AS p
JOIN orders AS o USING (product_id)
WHERE o.order_hour_of_day >= 20 AND order_date BETWEEN '2020-01-01' AND '2022-12-31'
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 3;



---Q10 WHAT IS THE TOTAL REVENUE GENERATED FROM JUICE PRODUCTS?
SELECT '$'||SUM(p.unit_price*o.quantity)AS total_revenue
FROM orders AS o
JOIN products AS p USING (product_id)
WHERE product_name ILIKE '%juice%';