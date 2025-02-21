CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

select * from retail_sales;

-- see how many rows
select count(*) from retail_sales;


-- dealing with null values
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or  
	sale_time is null
	or
    customer_id is null
	or
    gender is null
	or
    age is null
	or
    category is null
	or
    quantity is null
	or
    price_per_unit is null
	or
    cogs is null
	or
    total_sale is null;
	
-- delect null (expect for age)	
delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or  
	sale_time is null
	or
    customer_id is null
	or
    gender is null
	or
    category is null
	or
    quantity is null
	or
    price_per_unit is null
	or
    cogs is null
	or
    total_sale is null;
	
	-- Data exploration
	
	-- how many sales we have?
	
	Select count(*) as total_sale from retail_sales
	
	-- how many customer do we have: 155
	
	select * from retail_sales
	
	Select count(distinct customer_id) as total_customers from retail_sales;
	
	
	--how many categories do we have:3
	
Select count(distinct category) as total_category from retail_sales;

--what are the categories
Select distinct category from retail_sales;


-- Data anaylsis  & buiness key problems 


--Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:


select * from retail_sales
where sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold 
--is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = 'Clothing' 
and quantity >= 4
and To_char(sale_date, 'yyyy-mm') = '2022-11';

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as SalesTotal, COUNT(*) as total_orders from retail_sales
group by category;



--Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select  AVG(age) as Average_age, category from retail_sales
where category = 'Beauty'
Group by 2;

--or 

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


--Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where total_sale> 1000


-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select count(transactions_id) as total_transaction, gender, category  from retail_sales
group by 2,3
order by 3,1 desc;

--Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select year, month, avg_sales  from 
(
select 
Extract(year from sale_date) as year,
Extract(month from sale_date) as month, 
avg(total_sale) as avg_sales,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ra
from retail_sales
group by 1,2
) as t1
where ra = 1


-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_spent from retail_sales
group by customer_id
order by 2 desc
limit 5


--Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:

select count (distinct customer_id) as  Number_of_customer, category  from retail_sales
group by category


--- Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sales as 
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift

from retail_sales

)
select shift, count(transactions_id) from hourly_sales
group by 1

-- End of project




