# Challenge 8
/*You have three tables in your database: customers, orders and order_items.
The customers table contains information about customers such as their CustomerID, CustomerName, and RegistrationDate.
The orders table contains information about orders including OrderID, CustomerID, OrderDate, OrderStatus.
and The order_items contains information about which product they ordered including OrderItemID, OrderID, ProductID, Quantity, UnitPrice.

Now write a SQL query to find top 5 customers with the highest potential Customer Lifetime Value (CLV), representing the projected total revenue each customer is expected
to generate for the company over their entire engagement?
To estimate CLV, use the formula: Potential CLV = Total Spending * 1.5, where Total Spending is the sum of a customer's spending across completed orders.
Additionally, explore how the frequency of customer orders, indicated by the number of completed orders, reflects their loyalty to the business.
So finally your query will show CustomerName, RegistrationDate, ordercount and PotentialCLV.

Note: You have to submit the SQL queries not the image. If the image will be submitted, it will be rejected and you will be graded as 0.
*/

CREATE DATABASE customer_orders_db;

USE customer_orders_db;

SELECT * FROM customers;

SELECT * FROM order_items;

SELECT * FROM orders;

ALTER TABLE customers
ADD COLUMN new_RegistrationDate DATE;

ALTER TABLE orders
ADD COLUMN new_OrderDate DATE;

SET SQL_SAFE_UPDATES = 0;

/* https://www.w3schools.com/sql/func_mysql_str_to_date.asp */

UPDATE customers
SET new_RegistrationDate = STR_TO_DATE(RegistrationDate, "%Y-%m-%d");

UPDATE orders
SET new_OrderDate = STR_TO_DATE(OrderDate, "%d-%m-%Y");
    
ALTER TABLE customers
DROP COLUMN RegistrationDate;

ALTER TABLE orders
DROP COLUMN OrderDate;

ALTER TABLE customers
RENAME COLUMN new_RegistrationDate TO RegistrationDate;

ALTER TABLE orders
RENAME COLUMN new_OrderDate TO OrderDate;

SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;

 /*Now write a SQL query to find top 5 customers with the highest potential Customer Lifetime Value (CLV), representing the projected total revenue each customer 
is expected to generate for the company over their entire engagement?
To estimate CLV, use the formula: Potential CLV = Total Spending * 1.5, where Total Spending is the sum of a customer's spending across completed orders.
Additionally, explore how the frequency of customer orders, indicated by the number of completed orders, reflects their loyalty to the business.
So finally your query will show CustomerName, RegistrationDate, ordercount and PotentialCLV. */
 
-- Challange 08 Solution 

SELECT
    c.CustomerName,
    c.RegistrationDate,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    ROUND(SUM(oi.Quantity * oi.UnitPrice) * 1.5, 2) AS PotentialCLV
FROM customers c
INNER JOIN orders o ON c.CustomerID = o.CustomerID
INNER JOIN order_items oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Completed'
GROUP BY c.CustomerName, c.RegistrationDate
ORDER BY PotentialCLV DESC
LIMIT 5;

