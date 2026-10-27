-- ============================================================
-- BANK CUSTOMER CHURN ANALYSIS
-- SQL Analysis Queries
-- Dataset: Bank_Customer_Churn_Cleaned.xlsx
-- Table: customers
-- ============================================================

-- 1. Create database
CREATE DATABASE IF NOT EXISTS bank_churn;
USE bank_churn;

-- NOTE:
-- Import the Excel Customer_Data sheet into MySQL as table: customers.
-- Recommended column names:
-- CustomerId, Surname, CreditScore, Geography, Gender, Age,
-- Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember,
-- EstimatedSalary, Exited


-- ============================================================
-- SECTION A: BASIC DATA CHECKS
-- ============================================================

-- 2. View sample records
SELECT *
FROM customers
LIMIT 10;

-- 3. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 4. Check duplicate Customer IDs
SELECT CustomerId, COUNT(*) AS duplicate_count
FROM customers
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- 5. Check NULL values in important columns
SELECT
    SUM(CustomerId IS NULL) AS null_customer_id,
    SUM(CreditScore IS NULL) AS null_credit_score,
    SUM(Geography IS NULL) AS null_geography,
    SUM(Gender IS NULL) AS null_gender,
    SUM(Age IS NULL) AS null_age,
    SUM(Tenure IS NULL) AS null_tenure,
    SUM(Balance IS NULL) AS null_balance,
    SUM(NumOfProducts IS NULL) AS null_products,
    SUM(EstimatedSalary IS NULL) AS null_salary,
    SUM(Exited IS NULL) AS null_exited
FROM customers;


-- ============================================================
-- SECTION B: KEY BUSINESS KPIs
-- ============================================================

-- 6. Total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 7. Churned customers
SELECT COUNT(*) AS churned_customers
FROM customers
WHERE Exited = 1;

-- 8. Retained customers
SELECT COUNT(*) AS retained_customers
FROM customers
WHERE Exited = 0;

-- 9. Overall churn rate
SELECT
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers;

-- 10. Total and average balance
SELECT
    ROUND(SUM(Balance), 2) AS total_balance,
    ROUND(AVG(Balance), 2) AS average_balance
FROM customers;

-- 11. Average credit score
SELECT ROUND(AVG(CreditScore), 2) AS average_credit_score
FROM customers;

-- 12. Average estimated salary
SELECT ROUND(AVG(EstimatedSalary), 2) AS average_estimated_salary
FROM customers;


-- ============================================================
-- SECTION C: CHURN DISTRIBUTION
-- ============================================================

-- 13. Customers by churn status
SELECT
    Exited,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2)
        AS percentage
FROM customers
GROUP BY Exited
ORDER BY Exited;

-- 14. Churned vs retained with labels
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    COUNT(*) AS customer_count
FROM customers
GROUP BY Exited;


-- ============================================================
-- SECTION D: GEOGRAPHY ANALYSIS
-- ============================================================

-- 15. Customers by country
SELECT
    Geography,
    COUNT(*) AS customer_count
FROM customers
GROUP BY Geography
ORDER BY customer_count DESC;

-- 16. Churn by geography
SELECT
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    COUNT(*) - SUM(Exited) AS retained_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY Geography
ORDER BY churn_rate_percentage DESC;

-- 17. Churned customers by geography
SELECT
    Geography,
    COUNT(*) AS churned_customers
FROM customers
WHERE Exited = 1
GROUP BY Geography
ORDER BY churned_customers DESC;


-- ============================================================
-- SECTION E: GENDER ANALYSIS
-- ============================================================

-- 18. Customers by gender
SELECT
    Gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY Gender;

-- 19. Churn by gender
SELECT
    Gender,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY Gender
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION F: AGE ANALYSIS
-- ============================================================

-- 20. Average age by churn status
SELECT
    Exited,
    ROUND(AVG(Age), 2) AS average_age
FROM customers
GROUP BY Exited;

-- 21. Churn by age group
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY age_group
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION G: CREDIT SCORE ANALYSIS
-- ============================================================

-- 22. Average credit score by churn status
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(CreditScore), 2) AS average_credit_score
FROM customers
GROUP BY Exited;

-- 23. Churn by credit score group
SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Below 500'
        WHEN CreditScore BETWEEN 500 AND 599 THEN '500-599'
        WHEN CreditScore BETWEEN 600 AND 699 THEN '600-699'
        WHEN CreditScore BETWEEN 700 AND 799 THEN '700-799'
        ELSE '800+'
    END AS credit_score_group,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY credit_score_group
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION H: TENURE ANALYSIS
-- ============================================================

-- 24. Churn by tenure
SELECT
    Tenure,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY Tenure
ORDER BY Tenure;

-- 25. Average tenure by churn status
SELECT
    Exited,
    ROUND(AVG(Tenure), 2) AS average_tenure
FROM customers
GROUP BY Exited;


-- ============================================================
-- SECTION I: PRODUCTS ANALYSIS
-- ============================================================

-- 26. Customers by number of products
SELECT
    NumOfProducts,
    COUNT(*) AS customer_count
FROM customers
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- 27. Churn by number of products
SELECT
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY NumOfProducts
ORDER BY NumOfProducts;


-- ============================================================
-- SECTION J: CREDIT CARD ANALYSIS
-- ============================================================

-- 28. Credit card ownership
SELECT
    HasCrCard,
    COUNT(*) AS customer_count
FROM customers
GROUP BY HasCrCard;

-- 29. Churn by credit card ownership
SELECT
    CASE
        WHEN HasCrCard = 1 THEN 'Has Credit Card'
        ELSE 'No Credit Card'
    END AS credit_card_status,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY HasCrCard;


-- ============================================================
-- SECTION K: ACTIVE MEMBER ANALYSIS
-- ============================================================

-- 30. Active vs inactive customers
SELECT
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS membership_status,
    COUNT(*) AS customer_count
FROM customers
GROUP BY IsActiveMember;

-- 31. Churn by active membership
SELECT
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS membership_status,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY IsActiveMember
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION L: BALANCE ANALYSIS
-- ============================================================

-- 32. Average balance by churn status
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(Balance), 2) AS average_balance
FROM customers
GROUP BY Exited;

-- 33. Balance groups and churn
SELECT
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 50000 THEN 'Below 50K'
        WHEN Balance < 100000 THEN '50K-99K'
        WHEN Balance < 150000 THEN '100K-149K'
        WHEN Balance < 250000 THEN '150K-249K'
        ELSE '250K+'
    END AS balance_group,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY balance_group
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION M: SALARY ANALYSIS
-- ============================================================

-- 34. Average salary by churn status
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(EstimatedSalary), 2) AS average_salary
FROM customers
GROUP BY Exited;

-- 35. Salary groups and churn
SELECT
    CASE
        WHEN EstimatedSalary < 50000 THEN 'Below 50K'
        WHEN EstimatedSalary < 100000 THEN '50K-99K'
        WHEN EstimatedSalary < 150000 THEN '100K-149K'
        ELSE '150K+'
    END AS salary_group,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY salary_group
ORDER BY churn_rate_percentage DESC;


-- ============================================================
-- SECTION N: MULTI-DIMENSIONAL ANALYSIS
-- ============================================================

-- 36. Geography + gender churn
SELECT
    Geography,
    Gender,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY Geography, Gender
ORDER BY churn_rate_percentage DESC;

-- 37. Geography + active membership
SELECT
    Geography,
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY Geography, IsActiveMember
ORDER BY Geography, churn_rate_percentage DESC;

-- 38. Age group + active membership
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY age_group, IsActiveMember
ORDER BY age_group, churn_rate_percentage DESC;


-- ============================================================
-- SECTION O: CUSTOMER SEGMENTATION
-- ============================================================

-- 39. Create an analytical review segment
-- This is a segmentation rule for portfolio analysis,
-- not proof that these characteristics cause churn.
SELECT
    CustomerId,
    Geography,
    Age,
    Balance,
    NumOfProducts,
    IsActiveMember,
    Exited,
    CASE
        WHEN IsActiveMember = 0
             AND Age >= 40
             AND NumOfProducts = 1
        THEN 'Review Segment'
        ELSE 'Other'
    END AS segment
FROM customers;

-- 40. Count customers and churn rate by segment
SELECT
    CASE
        WHEN IsActiveMember = 0
             AND Age >= 40
             AND NumOfProducts = 1
        THEN 'Review Segment'
        ELSE 'Other'
    END AS segment,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * AVG(Exited), 2) AS churn_rate_percentage
FROM customers
GROUP BY segment;


-- ============================================================
-- SECTION P: TOP CHURNED CUSTOMER RECORDS
-- ============================================================

-- 41. View churned customers with selected attributes
SELECT
    CustomerId,
    Geography,
    Gender,
    Age,
    CreditScore,
    Tenure,
    Balance,
    NumOfProducts,
    IsActiveMember,
    EstimatedSalary
FROM customers
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 20;


-- ============================================================
-- SECTION Q: POWER BI / DASHBOARD DATA
-- ============================================================

-- 42. One summary table for dashboard geography analysis
SELECT
    Geography,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    COUNT(*) - SUM(Exited) AS Retained_Customers,
    ROUND(100.0 * AVG(Exited), 2) AS Churn_Rate
FROM customers
GROUP BY Geography;

-- 43. One summary table for dashboard age analysis
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS Age_Group,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(100.0 * AVG(Exited), 2) AS Churn_Rate
FROM customers
GROUP BY Age_Group;

-- 44. One summary table for dashboard product analysis
SELECT
    NumOfProducts,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(100.0 * AVG(Exited), 2) AS Churn_Rate
FROM customers
GROUP BY NumOfProducts
ORDER BY NumOfProducts;


-- ============================================================
-- END OF PROJECT
-- ============================================================
