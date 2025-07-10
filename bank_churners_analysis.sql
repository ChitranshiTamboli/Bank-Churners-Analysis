CREATE DATABASE bank_churn;
USE bank_churn;

CREATE TABLE customer_data (
customer_id INT PRIMARY KEY,
vintage INT,
age INT,
gender VARCHAR(10),
dependents INT,
occupation VARCHAR(50),
city INT,
customer_nw_category INT, 
branch_code INT,
current_balance FLOAT,
previous_month_end_balance FLOAT,
average_monthly_balance_prevQ FLOAT,
average_monthly_balance_prevQ2 FLOAT,	
current_month_credit FLOAT,
previous_month_credit FLOAT,
current_month_debit FLOAT,
previous_month_debit FLOAT,
current_month_balance FLOAT,
previous_month_balance FLOAT,
churn TINYINT,
last_transaction DATE
);

/*Retrieving the data from the database*/
SELECT * from customer_data;


/*Overall churn rate among all customers*/
SELECT 
	COUNT(*) AS total_customers,
    SUM(churn) AS total_churned,
    ROUND((SUM(churn) / COUNT(*))*100,2) AS churn_rate_percentage
FROM customer_data;
/* Out of 28,382 total customers, 5,260 have churned, resulting in an overall churn rate of 18.53% */



/*Distribution of churn rate across different age range*/
SELECT 
  CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    WHEN age BETWEEN 50 AND 59 THEN '50-59'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY age_group
ORDER BY churn_rate DESC;
/* Churn rate is highest among customers aged 30-39 (19.69%), followed by those under 30 (19.08%), 
indicating younger age groups are more likely to leave the bank */


/*Gender-wise distribution of total and churned customers*/
SELECT 
  gender,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
WHERE gender IS NOT NULL
GROUP BY gender
ORDER BY churn_rate DESC;
/*Churn rate is slightly higher among male customers (19.15%) compared to female customers (17.55%). 
   This indicates that male customers are marginally more prone to churn than female customers.*/


/*Distribution of churn rate across different occupations*/
SELECT 
  occupation,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY occupation
ORDER BY churn_rate DESC;
/*Self-employed customers show the highest churn rate (19.84%), while company employees have the lowest (10%).*/


/*Churn rate distribution based on number of dependents*/
SELECT 
  dependents,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn) / COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY dependents
ORDER BY churn_rate DESC;
/*Customers with 6 dependents show a 50% churn rate,but this group may be small, 
while those with 0 dependents form the largest group but have a lower churn rate of 17.42%.*/
 
 

/*Churn rate based on current month credit utilization*/
SELECT 
  CASE
    WHEN current_month_credit <= 0.2 THEN 'Low (<=0.2)'
    WHEN current_month_credit <= 0.5 THEN 'Moderate (0.2-0.5)'
    WHEN current_month_credit <= 1 THEN 'High (0.5-1.0)'
    ELSE 'Very High (>1.0)'
  END AS credit_utilization_group,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY credit_utilization_group
ORDER BY churn_rate DESC;
/*customers with very high credit utilization (>1.0) have the highest churn rate of 19.93%*/


/*Churn by Average Monthly Balance Buckets*/
SELECT 
  ROUND(average_monthly_balance_prevQ, -2) AS avg_balance_bucket,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY avg_balance_bucket
ORDER BY churn_rate DESC;
/*Customers with extremely high or low average monthly balances show the highest churn rates, indicating instability at both ends of the spectrum.*/



/*Churn rate analysis based on customer tenure (vintage)*/
SELECT 
  CASE 
    WHEN vintage < 1800 THEN 'Low Tenure (<1800)'
    WHEN vintage BETWEEN 1800 AND 2200 THEN 'Mid Tenure (1800-2200)'
    ELSE 'High Tenure (>2200)'
  END AS tenure_group,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY tenure_group
ORDER BY churn_rate DESC;
/*Customers with low tenure (<1800) show the highest churn rate at 19.36% */


/*Churn rate based on customer last transaction activity status*/
SELECT 
  CASE
    WHEN last_transaction IS NULL THEN 'No Activity'
    WHEN last_transaction < '2019-06-01' THEN 'Inactive (>1 month ago)'
    ELSE 'Recently Active'
  END AS activity_status,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY activity_status;
/*Customers who were recently active have the highest churn rate of 20.41% */



/*Churn rate by customer net worth category*/
SELECT 
  customer_nw_category,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY customer_nw_category
ORDER BY churn_rate DESC;
/*Customers in High Net Worth Categoryhave the highest churn rate at 19.22%*/


/*Branch-wise Churn */
SELECT 
  branch_code,
  COUNT(*) AS total_customers,
  SUM(churn) AS total_churned,
  ROUND(SUM(churn)/COUNT(*) * 100, 2) AS churn_rate
FROM customer_data
GROUP BY branch_code
ORDER BY churn_rate DESC
LIMIT 10;
/*These branches have 100% churn rate, indicating all customers from these branches have left*/






