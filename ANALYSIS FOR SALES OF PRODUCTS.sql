---ANALYSIS FOR SALES OF PRODUCTS
--create customer table
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR (50),
email VARCHAR(50),
phone VARCHAR(12),
dob DATE,
gender VARCHAR(20),
country VARCHAR(20),
city VARCHAR(50)
);

--create product table
CREATE TABLE products(
product_id VARCHAR (5) PRIMARY KEY,
product_name VARCHAR (50),
description VARCHAR(250),
product_category VARCHAR(20),
unit_price NUMERIC(10,3),
unit_cost NUMERIC(10,3)
);

--create credit cards table
CREATE TABLE credit_cards(
credit_card_id VARCHAR(50)PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
card_number VARCHAR (20),
card_expiry_date DATE,
bank_name VARCHAR (30)
);

--create the order table
CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
order_date DATE,
product_id VARCHAR(5) REFERENCES products(product_id),
quantity NUMERIC (5,0),
delivery_status VARCHAR(10)
);

--create payment table
CREATE TABLE payments(
payment_id VARCHAR (5) PRIMARY KEY,
order_id INT REFERENCES orders(order_id),
payment_date DATE
);

SELECT*
FROM products;

SELECT*
FROM payments;

SELECT*
FROM orders

SELECT*
FROM customers;

SELECT*
FROM credit_cards;



----SQL EXERCISE 3


----Q1 WHAT IS THE TOTAL PROFIT GENERATED FROM LAPTOPS & ACCESSORIES
SELECT SUM((p.unit_price*o.quantity)-(p.unit_cost*o.quantity)) AS total_profit,
           p.product_category
FROM products AS p
INNER JOIN orders AS o ON o.product_id= p.product_id
WHERE p.product_category IN ('Laptop','Accessories')
GROUP BY P.product_category
ORDER BY total_profit;


---Q2 FOR EACH SAMSUNG PRODUCTS,WHAT IS THE PROFIT GENERATED
SELECT SUM((p.unit_price * o.quantity)-(p.unit_cost* o.quantity)) AS profit_generated,
           p.product_name
FROM products AS p
INNER JOIN orders AS o ON o.product_id= p.product_id
WHERE p.product_name LIKE ('Samsung%')
GROUP BY p.product_name
ORDER BY profit_generated;


----Q3 WHAT IS THE TOTAL REVENUE GENERATED FROM EACH CUSTOMER AND ALSO SHOW THE NUMBER OF ORDERS FOR THEM.
SELECT SUM(p.unit_price * o.quantity) AS total_revenue,
        SUM(o.order_id) AS no_of_orders, 
        c.customer_name AS customers
FROM orders AS o
INNER JOIN products AS p ON o.product_id = p.product_id
INNER JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY c.customer_name,
         o.order_id
ORDER BY total_revenue;


---	Q4 DO WE HAVE ANY CITY WHERE WE HAVE NOT DELIVERED LAPTOPS TO?
SELECT c.city,
       o.delivery_status,
	   p.product_category
FROM products AS p
INNER JOIN orders AS o ON o.product_id = p.product_id
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE p.product_category LIKE 'Laptop' AND delivery_status <> 'Delivered'
ORDER BY c.city;


----Q5 WHAT ARE THE TOP 3 CITIES WHERE WE GENERATED THE MOST PROFIT,
----ALSO SHOW THE NUMBER OF ORDERS AND THE TOTAL QUANTITY OF PRODUCTS
----SOLD IN THESE CITIES.
SELECT SUM(o.quantity) AS total_quantiy,
       COUNT(o.order_id) AS no_of_orders,
	   SUM((p.unit_price * o.quantity)-(p.unit_cost * o.quantity)) AS profit,
	   c.city
FROM products AS p
INNER JOIN orders AS o ON p.product_id = o.product_id
INNER JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY profit DESC 
LIMIT 3;
       