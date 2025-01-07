use modelcarsdb;
-- Task  1 Customer Data Analysis
-- Task 1(1) Top 10 customers by credit limit
select * from customers order by creditLimit desc limit 10;
-- Interpretation : Customers with customer number 141,124,298,151,187,146,286,386,227,259 has highest credit limit.

-- Task 1(2) Query to find the average credit limit for customers in each country
select country, avg(creditLimit) as Avg_CreditLimit from customers group by country;
-- Interpretation: The average credit limit for few countries France-77691.666667,USA-77071.428571,Australia-86060.000000,Norway-91200.000000,Poland-0.000000,
-- Germany-19776.923077

-- Task 1(3) Query to find number of customers in each state
select state,count(customerNumber) as No_of_Customers from customers C group by state order by No_of_Customers;
-- Interpretation: This query gives the count of customers in each state like NV-1 Osaka-1,Québec-1,Isle of Wight-1,NJ-1,Queensland-1

-- Task 1(4) Query to find the customers who haven't placed any orders
select C.* from customers C left join orders O on C.customerNumber=O.customerNumber WHERE o.customerNumber IS NULL;
-- Interpretation: This query gives the output of the customers who haven't placed any orders like customernumber 125,168,169,206,223

-- Task 1(5) Query to calculate total sales for each customer
SELECT c.customerNumber,c.contactFirstName,c.customerName,sum(od.quantityOrdered) 
AS total_sales 
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber 
GROUP BY c.customerNumber;
-- Interpretation : This query gives the total sales for each customer 
-- like 103-Carine Atelier graphique-270 ,112-Jean Signal Gift Stores-929,114-Peter Australian Collectors,
-- Co.-1926119-Janine La Rochelle Gifts-1832,121-Jonas Baane Mini Imports-1082


-- Task 1(6) Query to list the customers with their sales representatives
select customerNumber,customerName,salesRepEmployeeNumber from customers where salesRepEmployeeNumber is not null; 
-- Interpretation: This query gives the output of the customers and  their sales representatives like 103-Atelier graphique-1370,112-Signal Gift Stores-1166

--  Task 1(7) Query to retrive the customers information with their most recent payments
SELECT c.customerNumber, c.customerName, c.contactLastName, c.contactFirstName,p2.paymentDate, p2.amount
FROM customers c INNER JOIN (SELECT customerNumber, MAX(paymentDate) AS max_payment_date
FROM payments p GROUP BY customerNumber) AS p ON c.customerNumber = p.customerNumber
INNER JOIN payments p2 ON c.customerNumber = p2.customerNumber AND p2.paymentDate = p.max_payment_date;
-- Interpretation: This query gives the output of the customers information with their most recent payments like 
-- 103-Atelier graphique-Schmitt-Carine - 2004-12-18 - 1676.14,112-Signal Gift Stores- King	-Jean- 2004-12-17 - 14191.12


-- Task 1(8) Query to identify the customers who have exceeded creditlimit
SELECT * FROM customers c WHERE creditLimit < (SELECT SUM(amount) FROM payments p WHERE p.customerNumber = c.customerNumber 
GROUP BY p.customerNumber);
-- Interpretation: This query gives the output of the customers who have exceeded creditlimit like 
-- 103- Atelier graphique- Schmitt	Carine- 40.32.2555-54,rue Royale- Nantes- 44000- France- 1370- 21000.00

-- Task 1(9) Query to find the names of all customers who have
-- placed an order for a product from a specific product line
SELECT c.customerNumber,c.contactFirstName,c.customerName
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p ON od.productCode = p.productCode
WHERE p.productLine = 'Ships';
-- Interpretation : This query gives the output of all customers who have placed an order
-- for a product from a specific product line like 
-- 278- Giovanni- Rovelli Gifts

-- Task 1(10) Query to find the names of all customers who have placed an order for the most expensive product
SELECT c.customerNumber,c.contactFirstName,c.contactFirstName,od.priceEach FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber
-- INNER JOIN products p ON od.productCode = p.productCode
WHERE od.priceEach = (SELECT MAX(priceEach) FROM orderDetails);
-- Interpretation : This query gives the output of all customers who have placed an order for the most expensive product like 
-- 121- Jonas - Jonas - 214.30


-- Task 2 Office Data Analysis

-- Task2(1) Query to count the no.of employees in office
select o.officeCode,count(e.employeeNumber) as No_OfEmp_offices from offices o right join employees e 
on o.officeCode=e.officeCode group by o.officeCode;
-- Interpretation : This query gives the output as the number of employees in each office like 1 (officecode)-6 employees

-- Task2(2) Query to identify the offices with less than a certain number of employees 
SELECT o.officeCode, o.city FROM offices o
LEFT JOIN employees e ON o.officeCode = e.officeCode
GROUP BY o.officeCode HAVING COUNT(e.employeeNumber) < 3;
-- Interpretation : This query gives the output as the offices which has less than 3 employees 
-- and city of the office like 2(officecode)-Boston city

-- Task2(3) Query to list the offices along with assigned territories
select officeCode,city,territory from offices where territory != 'NA';
-- Interpretation : This query gives the output of the offices for which territories are assigned 
-- like 4(officecode)-Paris(city)-EMEA(territory)

-- Task2(4) Query to find the offices that have no employees assigned 
SELECT o.officeCode, COUNT(e.employeeNumber) as Count_Emp FROM offices o
LEFT JOIN employees e ON o.officeCode = e.officeCode
WHERE e.employeeNumber IS NULL GROUP BY o.officeCode
HAVING COUNT(e.employeeNumber) = 0;
-- Interpretation: This query gives the output of offices that has no employees assigned 
-- which gives officecode and count of employees in each office

-- Task2(5) Query to retrive the most profitable office based on total sales
SELECT o.officeCode, o.city, o.country, SUM(od.quantityOrdered ) AS totalSales
FROM offices o JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord ON c.customerNumber = ord.customerNumber
JOIN orderdetails od ON ord.orderNumber = od.orderNumber
GROUP BY o.officeCode ORDER BY totalSales DESC LIMIT 1;
-- Interpretation: This query gives the output of totalsales based on office 
-- and it retrives the office which has highest totalsales comparitively
-- like 4(officecode)-	Paris(cty)-	France(country)- 33887(totalsales)

-- Task2(6) Query to find the office with highest no.of employees 
select o.officeCode,count(e.employeeNumber) as No_OfEmp_offices from offices o right join employees e 
on o.officeCode=e.officeCode group by o.officeCode order by No_OfEmp_offices desc ;
-- Interpretation: This query gives the output of highest number of employees in each office in descending order like 1(officecode)-6(no.of.emp)
-- 4(officecode)-5(no.of.emp)

-- Task2(7) Query to find the average credit limit for customers in each office
SELECT o.officeCode,AVG(c.creditLimit) AS averageCreditLimit
FROM offices o JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY o.officeCode;
-- Interpretation: This query gives the output of averagecreditlimit based on officecode like 1(officecode)- 82850.000000(averagecreditlimit)

-- Task2(8) Query to find number of offices in each country
select country,count(officeCode) as NO_Of_Offices from offices group by country;
-- Interpretation: This query gives the output of no.of.offices based on country which retrives number of offices in each country 
-- like USA(country)- 3(no.of.emp)

-- Task 3 Product Data Analysis

-- Task3(1) Query to count the number of products in each productline
select productline,count(productCode) as No_Of_Products from products group by productLine;
-- Interpretation: This query gives the output of productline and no.of products in each productline 
-- like Classic Cars(Productline)-38(no.of products)

-- Task3(2) Query to find productline with the highest average product price
SELECT productLine, AVG(MSRP) AS average_price FROM products
GROUP BY productLine ORDER BY average_price DESC ;
-- LIMIT 1;
-- Interpretation: This query gives the output that calculates the averageprice for each productline and sorted in decending order
-- For Eg: Classic Cars(productline)-118.021053(averageprice)

-- task3(3) A Query to find all products with a price above 
-- or below a certain amount(MSRP should be between 50 and 100)

SELECT * FROM products WHERE MSRP > 50 AND MSRP < 100;
-- Interpretation: This query gives the output details of product
-- which has MSRP between 50 to 100 

-- Task3(4) Query to find the total sales amount for each productline 
SELECT p.productLine, SUM(od.priceEach * od.quantityOrdered) 
AS total_sales FROM products p
INNER JOIN orderDetails od ON p.productCode = od.productCode 
GROUP BY p.productLine;
-- Interpretation: This query gives the output as the total sales for 
-- each productline like Classic Cars(productline)-3853922.49(totalsales)

-- Task3(5) Query to identify products with less than a specific threshold value of 10 for quantityInStock
SELECT productCode, productName, quantityInStock FROM products WHERE quantityInStock < 10;
-- Interpretation: This query gives the output of productname,productcode and quantityinstock which is lessthan 10

-- Task3(6) Query to retrive the most expensive product based on MSRP
select productCode,productName,productLine,MSRP from products order by MSRP desc;
-- Interpretation: This query gives the output of products details which has highest MSRP 
-- like S10_1949(productcod)-1952 Alpine Renault 1300(productname)-Classic Cars(productline)-214.30(MSRP)

-- Task3(7) Query to find the total sales amount for each product 
SELECT p.productCode, SUM(od.priceEach * od.quantityOrdered) 
AS total_sales FROM products p
INNER JOIN orderDetails od ON p.productCode = od.productCode 
GROUP BY p.productCode;
-- Interpretation: This query gives the output of productcode & totalsales
-- like S10_1678(productcode)-91343.49(totalsales)

-- Task3(8) Storeprocedure to retrive the top selling product by getting number of products as parameter is created

-- Task3(9) Query to identify products with low inventory levels(less than a specific threshold value of 10 for quantityInStock)within specific product lines
SELECT productCode, productName, quantityInStock FROM products
WHERE quantityInStock < 10 AND productLine IN ('Classic Cars', 'Motorcycles');
-- Interpretation: This query gives the output as productcode,productname,quantityinstock which has lessthan 10 based on productline classiccars& motorcycles

-- Task3(10) Query to find the names of all products that have been
-- ordered by more than 10 customers
SELECT p.productCode,p.productName,COUNT(DISTINCT o.customerNumber) 
as Count_Customer FROM products p
INNER JOIN orderDetails od ON p.productCode = od.productCode
INNER JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY p.productCode, p.productName
HAVING COUNT(DISTINCT o.customerNumber) > 10;
-- Interpretation: This query gives the output as productcode,productname& 
-- count of customer which has count of customer greater than 10
-- like S10_1678(productcode)-1969 Harley Davidson Ultimate Chopper(productname)-27(count_customer)

-- Task3(11) Query to find the names of all products that have been ordered more than average number of orders for their productline
WITH product_order_counts AS (
    SELECT p.productcode, p.productname, p.productline, COUNT(od.ordernumber) AS total_orders
    FROM products p
    JOIN orderdetails od ON p.productcode = od.productcode
    GROUP BY p.productcode, p.productname, p.productline),
average_orders_per_productline AS (
    SELECT productline, AVG(total_orders) AS avg_orders
    FROM product_order_counts
    GROUP BY productline)
SELECT po.productname
FROM product_order_counts po
JOIN average_orders_per_productline ao ON po.productline = ao.productline
WHERE po.total_orders > ao.avg_orders;

-- Sprint 10 
-- Task 1 Employee Data Analysis
-- Task 1(1) Query to return total number of employees
select count(employeeNumber) as Total_No_of_Emp from employees;
-- Interpretation: This query gives the output as count of employeenumber like Total_No_of_Emp -23

-- Task1(2) Query to list all employees with basic informations
select employeeNumber,firstName,lastName,email,jobTitle from employees;
-- Interpretation: This query gives the output of employee details like employeenumber,firstname,lastName,email,jobTitle
-- For Eg: 1002	- Diane - Murphy - dmurphy@classicmodelcars.com	- President 

-- Task1(3) Query to get the number of employees holding each job title
select count(employeeNumber) as Total_No_of_Emp,jobTitle 
from employees group by jobTitle;
-- Interpretation: This query gives the output of count of employees based on jobtitle 
-- For Eg: 1(Total_No_of_Emp) -	President(jobTitle)

-- Task1(4) Query to find the employees who don't have a manager assigned
select employeeNumber,firstName,lastName,email,jobTitle 
from employees where reportsTo is null ;
-- Interpretation: This query gives the output employeeNumber,firstName,lastName,email,
-- jobTitle for employees those aren't assigned to manager
-- For Eg: 1002	- Diane	- Murphy - dmurphy@classicmodelcars.com	- President

-- Task1(5) Query to calculate total sales generated by each sales representative
SELECT c.salesRepEmployeeNumber, SUM(od.priceEach * od.quantityOrdered) AS total_sales FROM customers c
INNER JOIN orders o on c.customerNumber=o.customerNumber
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber GROUP BY c.salesRepEmployeeNumber;
-- Interpretation:  This query gives the calculated output of totalsales for each sales representative 
-- For Eg: 1370(salesRepEmployeeNumber) - 1258577.81(totalsales)

-- Task1(6) Query to get the most profitable sales representative based on total sales
SELECT c.salesRepEmployeeNumber, SUM(od.priceEach * od.quantityOrdered) 
AS total_sales FROM customers c
INNER JOIN orders o on c.customerNumber=o.customerNumber
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber 
GROUP BY c.salesRepEmployeeNumber order by total_sales desc limit 5;
-- Interpretation: This query gives the calculated output of highest 5 totalsales for 
-- each sales representative sorted in descending order 
-- For Eg: 1370(salesRepEmployeeNumber) - 1258577.81(totalsales)

-- Task1(7) Query to find the names of all employees who have sold more than the 
-- average sales amount for their office
SELECT e.firstName, e.lastName,e.officeCode FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeenumber,e.officeCode
HAVING SUM(od.quantityOrdered * od.priceEach) > (SELECT AVG(total_sales) FROM 
(SELECT e2.officeCode, SUM(od2.quantityOrdered * od2.priceEach) AS total_sales
FROM employees e2 JOIN customers c2 ON e2.employeeNumber = c2.salesRepEmployeeNumber
JOIN orders o2 ON c2.customerNumber = o2.customerNumber
JOIN orderdetails od2 ON o2.orderNumber = od2.orderNumber
GROUP BY e2.employeeNumber, e2.officeCode ) office_sales 
WHERE office_sales.officeCode = e.officeCode);
-- Interpretation: This query gives the output of employee names's and officecode for which the totalsales 
-- is greater than averagesalesbased on officecode
-- for Eg: Gerard - Hernandez -	4

-- Task 2 Order Analysis 

-- Task2(1) Query to find the average order amount for each customer
SELECT c.customerNumber, AVG(od.priceEach * od.quantityOrdered) 
AS avg_order_amount FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber 
GROUP BY c.customerNumber;
-- Interpretation: This query gives the calculated average amount 
-- based on customernumber 
-- for Eg: 103(Customernumber) - 3187.765714(avg_order_amount)

-- Task2(2) Query to find the number of orders placed in each month
SELECT YEAR(orderDate) AS year, MONTH(orderDate) AS month, COUNT(*)
 AS number_of_orders FROM orders
GROUP BY YEAR(orderDate), MONTH(orderDate) ORDER BY year, month;
-- Interpretation: This query gives the output of number of orders 
-- placed based on month of a year 
-- Foe Eg: 2003(Year) -	1(Month) -	5(number_of_orders)

-- Task2(3) Query to find that are in pending status
select * from orders where status in ('Pending','On Hold','Disputed','In Process') ;
-- Interpretation: This query gives the output of orders and it's details which has status as Pending,On Hold,Disputed,In Process
-- For Eg: 10414(ordernumber) -	2005-05-06(orderdate) -	2005-05-13	(requireddate) -On Hold(status)	- 
-- Customer credit limit exceeded. Will ship when a payment is received.(comment) -	362(customernumber)

-- Task2(4) Query to list the orders along with customer details
SELECT c.customerNumber,c.contactFirstName,c.contactLastName, c.phone,c.addressline1,c.addressLine2,c.city,c.state,c.country,o.orderNumber, o.orderDate FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber ORDER BY o.orderNumber;
-- Interpretation: This query returns the output of customer details based on orders by joining orders and orderdetails table with customers table
-- For Eg: 363(customernumber) - Dorothy(contactfirstname) -	Young(contactlastname) - 6035558647(phone) - 2304 Long Airport Avenue(addressline1) -
-- Nashua(city) - NH(state) - USA(country) - 10100(ordernumber) - 2003-01-06(orderdate)

-- Task2(5) Query to retrive the most recent orders
SELECT * FROM orders ORDER BY orderDate DESC limit 5;
-- Interpretation: This query gives the output of top 5 most recent orders using orders table sorting by orderdate in decending order
-- For Eg: 10426(ordernumber) -	2005-08-06(orderdate) -	2005-08-13(requireddate) -	2005-08-10(shippeddate) - Shipped(status) -	363(customernumber)

-- Task2(6) Query to calculate the total sales for each order
SELECT od.ordernumber, SUM(od.priceEach * od.quantityOrdered) AS total_sales FROM orders o 
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber GROUP BY od.ordernumber;
-- Interpretation: THis query gives the output by calculating the totalsales based on ordernumber using orders table joining with orderdetails table
-- For Eg: 10100(ordernumber) -	10223.83(total_sales)

-- Task2(7) Query to find the highest value orders based on total sales
SELECT od.ordernumber, SUM(od.priceEach * od.quantityOrdered) AS total_sales,COUNT(od.ordernumber) AS number_of_orders FROM orders o 
INNER JOIN orderDetails od ON o.orderNumber = od.orderNumber GROUP BY od.ordernumber order by total_sales desc;
-- Interpretation: This query gives the highest of  calculated totalsales, ordernumber and no.of orders based on total sales using orders table joining with 
-- orderdetails table. For Eg: 10165(ordernumber) -	67392.85(total_sales) -	18(number_of_orders)

-- Task2(8) Query to list all orders with corresponding order details
SELECT od.orderNumber,od.productCode,od.quantityOrdered,od.priceEach,od.orderLineNumber,o.orderDate,o.requiredDate,o.shippedDate,o.status,
o.comments,o.customerNumber FROM orders o Inner Join orderDetails od ON o.orderNumber = od.orderNumber;
-- Interpretation: This query gives the output of order and it'd order details using orders table joining with orderdetails table
-- for Eg: 10100 - S18_1749 - 30 - 136.00 -	3 -	2003-01-06 - 2003-01-13 - 2003-01-10 - Shipped	- 363

-- Task2(9) Query to list the most frequently ordered products
SELECT p.productName, COUNT(*) AS Count_productordered FROM products p
INNER JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName ORDER BY Count_productordered DESC;
-- Interpretation: This query return the output of most frequently ordered products 
-- using products table joining with orderdetails table 
-- For Eg: 1992 Ferrari 360 Spider red(productname) - 53(Count_productordered)

-- Task2(10) Query to calculate total revenue for each order 
SELECT o.ordernumber, SUM((od.priceEach- p.buyprice) * od.quantityOrdered) AS total_Revenue FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber 
JOIN products p on od.productcode=p.productcode GROUP BY o.ordernumber ;
-- Interpretation: This query returns the output by calculating the total_Revenue based on ordernumber 
-- using orderdetails table joining with orders and products table.
-- For Eg:10100(ordernumber) -	3940.36(total_Revenue)

-- Task2(11) Query to find most profitable orders based on total revenue
SELECT o.ordernumber, SUM((od.priceEach- p.buyprice) * od.quantityOrdered) 
AS total_Revenue FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber 
JOIN products p on od.productcode=p.productcode GROUP BY o.ordernumber 
order by total_Revenue desc limit 5;
-- Interpretation: This query gives the top 5 output of ordernumber,total_Revenue 
-- using orderdetails table joining with orders and products table 
-- sorting by total_revenue in decending order.
-- Foe Eg:10165(ordernumber) -	26465.57(total_Revenue)

-- Task2(12) Query to list all orders with detailed product information
SELECT o.orderNumber, o.orderDate, p.productCode, p.productName, p.productLine, p.MSRP,
od.quantityOrdered, od.priceEach FROM orders o INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p ON od.productCode = p.productCode;
-- Interpretation: This query gives the output of orderNumber, orderDate, productCode, productName, productLine, MSRP,
-- quantityOrdered, priceEach using orders table and inner joining with orderdetails and products tables.
-- For Eg: 10100(ordernumber) - 2003-01-06(orderdate) -	S18_1749(productcode) -	1917 Grand Touring Sedan(productname) 
-- 	Vintage Cars(productline) -	170.00(MSRP) -	30(quantityordered) -	136.00(priceEach)

-- Task2(13) Query to find the orders with delayed shipping
select * from orders where shippeddate>requireddate;
-- Interpretation: This query returns the output of the orders details from orders table for which the shippeddate is delayed than requireddate
-- For Eg: 10165(ordernumber) - 2003-10-22(orderdate) -	2003-10-31(requireddate) -	2003-12-26(shippeddate)	
-- Shipped	This order was on hold because customers's credit limit had been exceeded. Order will ship when payment is received(comment) -	148(customernumber)

-- Task2(14) Query to find most popular product combinations within orders 
SELECT p1.productCode AS productCode1, p2.productCode AS productCode2, COUNT(*) AS Count_order FROM orderdetails od1
INNER JOIN orders o ON od1.orderNumber = o.orderNumber -- link orderdetail's based on ordernumber
INNER JOIN orderdetails od2 ON o.orderNumber = od2.orderNumber -- to get other products in the same order.
INNER JOIN products p1 ON od1.productCode = p1.productCode -- get details of the first product in the pair.
INNER JOIN products p2 ON od2.productCode = p2.productCode -- get details of the second product in the pair.
WHERE od1.orderLineNumber < od2.orderLineNumber  -- to check each pair is considered only once per order based 
-- on two different instances of orderdetails table
GROUP BY p1.productCode, p2.productCode -- grouping the data based on productcode of two different instances of products table
HAVING COUNT(*) > 1  -- Filters out product pairs that appear together only once
ORDER BY Count_order DESC;
-- Interpretation: This query gives the output by analyzing product combinations within orders 
-- and identifies pairs of products that are frequently ordered together using orderdetails table joining with orders, another 
-- instance of orderdetails,products with two different instances 
-- For Eg: S50_1341	- S700_1691	- 28


-- Task2(15) Query to calculate revenue for each order and top 10
SELECT o.ordernumber, SUM((od.priceEach- p.buyprice) * od.quantityOrdered)
 AS total_Revenue FROM orderdetails od
JOIN orders o ON od.orderNumber = o.orderNumber 
JOIN products p on od.productcode=p.productcode GROUP BY o.ordernumber
 order by total_Revenue desc limit 10;
-- Interpretation: This Query returns the top 10 calculated output as total_revenue 
-- and ordernumber using orderdetails tables joining with orders and 
-- products tables and sorting by total_Revenue in decending order.
-- For Eg: 10165(ordernumber) -	26465.57(total_Revenue)

-- Task2(16) Trigger to automatically updates a customer's credit limit after a new order is placed has been created
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `update_credit_limit` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
 DECLARE total_order_amount DECIMAL(10,2);
-- Calculate the total order amount for the new order
    SELECT SUM(od.quantityOrdered * od.priceEach)
    INTO total_order_amount
    FROM orderdetails od
    WHERE od.orderNumber = NEW.orderNumber;
    
    -- Update the customer's credit limit
    UPDATE customers
    SET creditLimit = creditLimit - total_order_amount
    WHERE customerNumber = NEW.customerNumber;
END //

-- Task2(17) Trigger to log product quantity changes when a orderdetail is inserted or updated
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `log_quantity_changes` AFTER INSERT ON `orderdetails` FOR EACH ROW BEGIN
    DECLARE action VARCHAR(10);
    DECLARE l_message VARCHAR(255);
    -- Determine the action (INSERT or UPDATE)
    IF INSERTING THEN
        SET action = 'INSERT';
    ELSE
        SET action = 'UPDATE';
    END IF;
    -- Prepare log message
    SET l_message = CONCAT(action, ' Order Number: ', NEW.orderNumber,
                             ' Product Code: ', NEW.productCode,' Quantity: ', NEW.quantityOrdered);
    -- Insert log entry into a temporary log table
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_product_quantity_logs (
        log_id INT AUTO_INCREMENT PRIMARY KEY,
        log_message VARCHAR(255),
        log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
    INSERT INTO temp_product_quantity_logs (l_message)
    VALUES (l_message);
END //

