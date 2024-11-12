CREATE DATABASE GLOBAL_BANK;
USE GLOBAL_BANK;
CREATE TABLE Account_details(customer_id INTEGER PRIMARY KEY, Credit_score_updated INTEGER, age INTEGER,
 tenure	INTEGER, balance DECIMAL,products_number INTEGER,credit_card INTEGER, active_member INTEGER, 
 estimated_salary DECIMAL, Salary_band VARCHAR(30), churn INTEGER,country_id INT, gender_id INT,
 FOREIGN KEY (country_id) REFERENCES Countries(country_id), 
 FOREIGN KEY (gender_id) REFERENCES Gender(gender_id));
    
CREATE TABLE Countries (country_id INTEGER PRIMARY KEY,
country_name VARCHAR(50));

CREATE TABLE Gender (gender_id INTEGER PRIMARY KEY, gender_name VARCHAR(10));

SELECT *
FROM Account_details;

SELECT *
FROM Gender;

SELECT *
FROM Countries;

DROP Outliers;
DELETE FROM Account_details
WHERE estimated_salary > 297436.585;

DELETE FROM Account_details
WHERE balance >= 319428.375;

DELETE FROM Account_details
WHERE credit_score_updated NOT BETWEEN 383 AND 919;


What factors contribute to churn rate in banks?
churned vs retained
Did Credit score affect churned criteria ?
Did Credit score and age affect churned criteria ?
Did members activity and balance affect churned rate ?
Did average salary affect churned criteria ?
Did gender affect churned rate ?
Did average tenure affect churned criteria ?
Did geographical location affect churned rate ?
Did geographical location and gender affect churned rate ?
Did number of products held affect churned rate ?
number of products contribute
Is there a specific point where churned rate peaked ?;


Total number of customers that churned vs retained;
SELECT 
CASE 
WHEN churn = 1 THEN "churned" ELSE "retained" END AS Retained_customer, 
ROUND(COUNT(customer_id)/(SELECT COUNT(*) FROM Account_details) *100, 1) AS num_of_customers
FROM Account_details
GROUP BY 1;

Did Credit score affect churned criteria ?;
SELECT 
CASE 
WHEN churn = 1 THEN "churned" ELSE "retained" END AS Churned_criteria, avg(Credit_score_updated) AS Avg_credit_score
FROM Account_details
GROUP BY 1;


Did Credit score and age affect churned criteria ?;
SELECT 
CASE 
WHEN age BETWEEN 17 AND 29 THEN "Young Adult"
WHEN age BETWEEN 30 AND 50 THEN "Adult"
WHEN age BETWEEN 51 AND 70 THEN "Middle-Aged" 
ELSE "Old" END AS Age_group, 
avg(Credit_score_updated) AS Avg_credit_score, SUM(churn) AS churned_customers, SUM(CASE 
WHEN churn = 0 THEN 1 ELSE 0 END) AS Retained_customer
FROM Account_details
GROUP BY 1;


Did average salary affect churned criteria ?;
SELECT 
CASE 
WHEN churn = 1 THEN "churned" ELSE "retained" END AS Churned_criteria, AVG(estimated_salary) AS Average_salary, COUNT(churn) AS num_of_customers
FROM Account_details
GROUP BY 1
ORDER BY 3 desc;


did different salary bands affect churn_rate?;
SELECT Salary_band,
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer,
SUM(CASE 
WHEN churn = 0 THEN 1 ELSE 0 END) AS Retained_customer
FROM Account_details
GROUP BY 1
ORDER BY 2 desc;

Did gender affect churned rate ?;
SELECT Gender_name,
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer
FROM Account_details
JOIN Gender ON Account_details.gender_id = Gender.gender_id
GROUP BY 1;



Did credit_card contribute to churn rate;
SELECT Credit_card, 
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer
FROM Account_details
GROUP BY 1;
There where alot more people that stayed that got a credit_card;


Did average tenure affect churned criteria?;
SELECT CASE 
WHEN churn = 1 THEN "churned" ELSE "retained" END AS Churned_criteria, AVG(tenure) AS Average_tenure
FROM Account_details
GROUP BY 1
ORDER BY 2 DESC;



Did members activity and balance affect churned rate ?;
SELECT Active_member, AVG(balance) AS Avg_balance,
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END)/(SELECT COUNT(churn) FROM Account_details WHERE churn = 1) *100 AS Churned_customer
FROM Account_details
GROUP BY 1;


Did geographical location affect churned rate ?;
SELECT country_name, SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer
FROM Account_details
JOIN Countries ON Account_details.country_id = Countries.country_id
GROUP BY 1
ORDER BY 2;


Did number of products held affect churned rate ?;
SELECT products_number, 
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer
FROM Account_details
GROUP BY 1
ORDER BY 2 DESC;



Is there a specific point  where churn rates peak;
SELECT tenure, 
ROUND(SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END)/(SELECT SUM(churn) FROM Account_details)*100, 1) AS Churned_customer_percent
FROM Account_details
GROUP BY 1
ORDER BY 1;


Did geographical location and gender affect churned rate ?;
SELECT country_name, gender_name,
SUM(CASE 
WHEN churn = 1 THEN 1 ELSE 0 END) AS Churned_customer
FROM Account_details
JOIN Countries ON Account_details.country_id = Countries.country_id
JOIN Gender ON Account_details.gender_id = Gender.gender_id
GROUP BY 1,2
ORDER BY 1;