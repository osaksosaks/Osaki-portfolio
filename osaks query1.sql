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

--Q1 show all the delivery and shipped orders between the 2nd and 3rd week of march 2023
SELECT *
FROM orders
WHERE order_date BETWEEN '2023-03-06' AND '2023-03-19' AND delivery_status IN ('Delivered','Shipped');




--Q2 show the 3 cheapest accessory
SELECT *
FROM products
WHERE product_category = 'Accessories'
ORDER BY unit_price ASC
LIMIT 3;



--Q3 show the top 2 banks used by customers
SELECT bank_name,
        COUNT (customer_id) AS no_of_customers
FROM credit_cards
GROUP BY bank_name
ORDER BY no_of_customers DESC
LIMIT 2;
---THE TOP 2 BANKS ARE ZENITH(20 CUSTOMERS) AND ACCESS (16 CUSTOMERS)


--Q4 show customer who has jack as his last_name
SELECT customer_name
FROM customers
WHERE customer_name LIKE '%Jack';
--NO ONE


---Q5 TOP 5 customers by total price in 2022
SELECT c.customer_name,
       o.order_date,
	   (p.unit_price*o.quantity)AS
	   total_price
FROM customers AS c
INNER JOIN orders AS o
ON o.customer_id = c.customer_id
INNER JOIN products AS p
ON p.product_id = o.product_id
WHERE o.order_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY c.customer_name,
         o.order_id,
         p.unit_price,
	     o.quantity
ORDER BY total_price DESC
LIMIT 5;
 
----method 2

---Q5 top 5 customers by total number of orders in 2022
SELECT c.customer_name,
       COUNT(o.order_id) AS total_no_of_order
FROM customers AS c 
JOIN orders AS o ON c.customer_id = o.customer_id
WHERE order_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY c.customer_name
ORDER BY total_no_of_order DESC
LIMIT 5;

--top 5 customers
---Lessie Eckman (10 orders)
---Gregory Gilbert (9)
---Norene Garett (9)
---Barbara Costa (9)
---Josephine Paylor(8)