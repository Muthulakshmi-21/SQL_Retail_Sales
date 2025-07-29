--- CREATED A DATABASE ---
CREATE DATABASE Retail;

--- CREATED A TABLE ---
CREATE TABLE retail_sale
	(
		transactions_id INT PRIMARY KEY,	
		sale_date DATE,	
		sale_time TIME,	
		customer_id INT,	
		gender VARCHAR(10),	
		age INT,	
		category VARCHAR(15),	
		quantiy INT,	
		price_per_unit FLOAT,	
		cogs FLOAT,	
		total_sale FLOAT
	);

--- SHOW THE TABLE ---
SELECT * 
FROM retail_sale
LIMIT 10;

SELECT 
	COUNT(*) 
FROM retail_sale

--- DATA CLEANING ---
--- Checking Null Values ---
SELECT * FROM retail_sale
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--- Deleted the Null Values ---
DELETE FROM retail_sale
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--- DATA EXPLORATION ---
--- How many sales we have ? ---
SELECT COUNT(*) AS "Total_Sale" FROM retail_sale

--- How many unique customers we have ? ---
SELECT COUNT(DISTINCT(customer_id)) AS "Total_Customer" FROM retail_sale

--- How many unique category we have ? ---
SELECT DISTINCT category AS "Category" FROM retail_sale

--- DATA ANALYSIS & BUSINESS KEY PROBLEMS & ANSWERS ---
--- 1. Retrieve all columns for sales made on '2022-11-05' ---
SELECT * 
FROM retail_sale 
WHERE sale_date = '2022-11-05'

--- 2. Retrieve all transactions where the category is 'Clothing' and quantity sold is more than 4 in the month 0f  Nov-2022 ---
SELECT *
FROM retail_sale
WHERE category = 'Clothing'
  AND 
  	TO_CHAR (sale_date, 'YYYY-MM') = '2022-11'
  AND quantiy >= 4

--- 3. To calculate the total sales(total_sales) for each category ---
SELECT 
		category,
	   	SUM(total_sale) As "Total_sales",
		COUNT(*) As "Total Orders"
FROM retail_sale
GROUP BY category

--- 4. Find the average age of customers who purchased items form the 'Beauty' category ---
SELECT 
	category,
	ROUND(AVG(age),2) "Average_Age"
FROM retail_sale
WHERE category = 'Beauty'
GROUP BY category

--- 5. To find all transactions where the total_sales is greater than 1000 ---
SELECT *
FROM retail_sale
WHERE total_sale > 1000

--- 6. To find the total number of transactions (transactions_id) made by each gender in each category ---
SELECT
	category As "Category",
	gender As "Gender",
	COUNT(transactions_id) As "Total no of Transactions"
FROM retail_sale
GROUP BY 
	category,
	gender
ORDER BY 1

--- 7. To calculate the average sale for each month. Find out best selling month in each year ---
SELECT 
	Year,
	Month,
	Total_sale
FROM
(
	SELECT 
		EXTRACT(year FROM sale_date) As Year,
		EXTRACT(month FROM sale_date) As Month,
		AVG(total_sale) As Total_Sale,
		RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) DESC ) As rank
	FROM retail_sale
	GROUP BY 1,2
) As t1
WHERE rank = 1

--- 8. To find the top 5 customers based on the highest total sales ---
SELECT 
	customer_id,
	SUM(total_sale) As "Maximum Sales"
FROM retail_sale
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

--- 9. To find the number of unique customers who purchased items from each category ---
SELECT 
	category As "Category",
	COUNT(DISTINCT(customer_id)) As "No of Unique Customers"	
FROM retail_sale
GROUP BY category

--- 10. To create each shift and number of orders ( Example Morning < 12, Afternoon Between 12 & 17, Evening > 17 )
WITH hourly_sale
As
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END As Shift
FROM retail_sale
)
SELECT 
	Shift,
	COUNT(*) As "Total Orders"
FROM hourly_sale
GROUP BY Shift