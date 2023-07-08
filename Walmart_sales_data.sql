-- - Title :-        Walmart_sales_data
-- - Created by :-   Sugabharathi S
-- - Date :-         13.06.2023
-- - Tool used:-     Mysql workbench
--DESCRIPTION: 
  -- This project is based on walmart sales data analysis using mysql
  -- In this project, i was given with 28 SQL questions based on generic, product, customer and sales
  -- I created table name as sales and imported data from kaggle data sets from walmart
  -- The sales table consists of 995 rows in the year of 2019
  
-- -creating database in local host in the name of salesdataWalmart
create database if not exists salesdataWalmart;
-- -create table as sales
create table if not exists sales(
invoice_id varchar(30) not null primary key,
Branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time Time not null,
payment_method varchar(15) not null,
cogs decimal (10,2) not null,
gross_margin_percentage float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1) 
);
-- ------------------------'FEATURE ENGINEERING------------------------------------
-- --------------------------------------------------------------------------------
--
-- ---------------------------------------------------------------------------------
-- TIME_OF_DAY 
select time, (case 
        when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
        END) as Time_of_date from sales;
        
Alter table sales add column Time_of_day varchar(20);

update sales
set time_of_day = (case 
        when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
        end);
-- ------------------------------------------------------------------------
-- --day_name we need to add column 
select date, dayname(date) from sales;

alter table sales add column Day_name varchar(10);

update sales
set day_name = dayname(date);
-- ------------------------------------------------------------------------
-- month_name -------------------------------------------------------------
select date, monthname(date) from sales;

alter table sales add column month_name varchar(10);

update sales 
set month_name = monthname(date);
-- ------------------------------------------------------------------------
-- Generic questions:
-- How many unique cities does that have?
select distinct city from sales;
-- How many unique cities does that have?
select distinct branch from sales;
-- In which city is each branch
select distinct city , branch from sales;
-- -----------------PRODUCT------------------------
-- How many unique product lines does the data have?
select count(distinct product_line) from sales;
-- What is the most common payment method
select payment_method, count(payment_method) from sales
group by payment_method
order by count(payment_method) desc;
-- What is the most selling product line?
select product_line, count(product_line) 
from sales
group by product_line
order by count(product_line) desc;
-- What is the total revenue by month? 
select 
month_name as month,
sum(total) as total_revenue 
from sales
group by month_name	
order by total_revenue desc;
-- What month had the largest COGS?
select month_name as month,
sum(cogs) as COGS
 from sales
 group by month_name
 order by COGS DESC;
-- What product line had the largest revenue?
SELECT product_line,
SUM(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;
-- What is the city with the largest revenue?
SELECT city,branch,
SUM(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;
-- What product line had the largest VAT?
select product_line,
avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;
-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
-- Which branch sold more products than average product sold?
select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (Select avg(quantity) from sales);
-- What is the most common product line by gender?
select gender,
product_line,
count(gender) as total_count_gender
from sales
group by gender, product_line
order by total_count_gender desc;
-- What is the average rating of each product line?
select 	round(avg(rating),2) as avg_rating, product_line from sales
group by product_line
order by avg(rating) desc;
-- ----------------------------------------------------------------------------------
-- --------------------------------------SALES---------------------------------------
-- Number of sales made in each time of the day per weekday
select Time_of_day, count(*) as total_sales from sales
where day_name = "Sunday"
group by Time_of_day
order by total_sales desc;
-- Which of the customer types brings the most revenue? 
select customer_type, sum(total) as total_rev  from sales
group by customer_type
order by total_rev desc;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,
avg(VAT) as VAT
from sales
group by city
order by VAT;
-- Which customer type pays the most in VAT?
select customer_type,
avg(VAT) as VAT
from sales
group by customer_type
order by VAT;
-- --------------------------------------------------------------------
-- -------------------CUSTOMERS----------------------------------------
-- How many unique customer types does the data have?
select distinct customer_type from sales;
-- How many unique payment methods does the data have?
select distinct payment_method from sales;
-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;
-- Which customer type buys the most?
select customer_type,
count(*) as customer_count
from sales
group by customer_type;
-- What is the gender of most of the customers?
select gender,
count(*) as gender_count from sales
group by gender;
-- What is the gender distribution per branch? 
select gender,
count(*) as gender_count from sales
where branch = "c"
group by gender;
-- Which time of the day do customers give most ratings?
select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
-- Which time of the day do customers give most ratings per branch?
select time_of_day,
avg(rating) as avg_rating
from sales
where branch = "c"
group by time_of_day
order by avg_rating desc;
-- Which day of the week has the best avg ratings?
select day_name, avg(rating) as avg_rating from sales
group by day_name 
order by avg_rating desc;
-- Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as avg_rating from sales
where branch = "B"
group by day_name 
order by avg_rating desc;	














