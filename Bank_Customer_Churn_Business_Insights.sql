-- ============================================================
-- BANK CUSTOMER CHURN ANALYSIS
-- SQL BUSINESS INSIGHTS PROJECT
-- Database: MySQL 8+
-- Source: Bank_Customer_Churn_Cleaning_Dataset.xlsx
--
-- Expected table: customers
-- Columns:
-- CustomerID, Surname, CreditScore, Geography, Gender, Age,
-- Tenure, Balance, NumOfProducts, HasCrCard,
-- IsActiveMember, EstimatedSalary, Exited
--
-- IMPORTANT:
-- Run these queries on the CLEANED table, not Raw_Data.
-- Binary fields: HasCrCard, IsActiveMember, Exited -> 0/1
-- Exited = 1 means churned; Exited = 0 means retained.
-- ============================================================

CREATE DATABASE IF NOT EXISTS bank_churn;
USE bank_churn;

-- ============================================================
-- 1. DATA QUALITY / VALIDATION
-- ============================================================

-- Q01. Total rows and unique customers
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CustomerID) AS unique_customers
FROM customers;

-- Q02. Check duplicate CustomerIDs
SELECT CustomerID, COUNT(*) AS duplicate_count
FROM customers
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Q03. Check missing values in important columns
SELECT
    SUM(CustomerID IS NULL) AS missing_customer_id,
    SUM(CreditScore IS NULL) AS missing_credit_score,
    SUM(Geography IS NULL) AS missing_geography,
    SUM(Gender IS NULL) AS missing_gender,
    SUM(Age IS NULL) AS missing_age,
    SUM(Balance IS NULL) AS missing_balance,
    SUM(EstimatedSalary IS NULL) AS missing_salary
FROM customers;

-- ============================================================
-- 2. EXECUTIVE KPI ANALYSIS
-- ============================================================

-- Q04. Overall customer KPIs
SELECT
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    COUNT(*) - SUM(Exited) AS retained_customers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND((COUNT(*) - SUM(Exited)) * 100.0 / COUNT(*), 2) AS retention_rate_pct,
    ROUND(AVG(CreditScore), 2) AS avg_credit_score,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(Balance), 2) AS avg_balance,
    ROUND(AVG(EstimatedSalary), 2) AS avg_salary
FROM customers;

-- Q05. Churned vs retained customer count and percentage
SELECT
    CASE WHEN Exited = 1 THEN 'Churned' ELSE 'Retained' END AS customer_status,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS pct_of_customers
FROM customers
GROUP BY Exited;

-- Q06. Churned customer balance / potential balance at risk
SELECT
    ROUND(SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END), 2) AS churned_balance,
    ROUND(SUM(Balance), 2) AS total_balance,
    ROUND(
        SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END) * 100.0
        / NULLIF(SUM(Balance), 0), 2
    ) AS pct_balance_from_churned_customers
FROM customers;

-- ============================================================
-- 3. GEOGRAPHY & DEMOGRAPHIC INSIGHTS
-- ============================================================

-- Q07. Churn by geography
SELECT
    Geography,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Geography
ORDER BY churn_rate_pct DESC;

-- Q08. Geography contribution to total churn
SELECT
    Geography,
    SUM(Exited) AS churned_customers,
    ROUND(
        SUM(Exited) * 100.0 /
        (SELECT SUM(Exited) FROM customers), 2
    ) AS share_of_total_churn_pct
FROM customers
GROUP BY Geography
ORDER BY churned_customers DESC;

-- Q09. Churn by gender
SELECT
    Gender,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Gender
ORDER BY churn_rate_pct DESC;

-- Q10. Geography + gender churn segmentation
SELECT
    Geography,
    Gender,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Geography, Gender
HAVING COUNT(*) >= 10
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- 4. AGE / CREDIT / TENURE SEGMENTATION
-- ============================================================

-- Q11. Churn by age group
SELECT
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age < 35 THEN '25-34'
        WHEN Age < 45 THEN '35-44'
        WHEN Age < 55 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

-- Q12. Churn by credit score band
SELECT
    CASE
        WHEN CreditScore < 580 THEN 'Poor'
        WHEN CreditScore < 670 THEN 'Fair'
        WHEN CreditScore < 740 THEN 'Good'
        WHEN CreditScore < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END AS credit_band,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY credit_band
ORDER BY churn_rate_pct DESC;

-- Q13. Churn by tenure
SELECT
    Tenure,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Tenure
ORDER BY Tenure;

-- Q14. Early-tenure vs established customers
SELECT
    CASE
        WHEN Tenure <= 2 THEN '0-2 Years'
        WHEN Tenure <= 5 THEN '3-5 Years'
        ELSE '6-10 Years'
    END AS tenure_group,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- 5. PRODUCT & CUSTOMER ENGAGEMENT INSIGHTS
-- ============================================================

-- Q15. Churn by number of products
SELECT
    NumOfProducts,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY NumOfProducts
ORDER BY churn_rate_pct DESC;

-- Q16. Credit card ownership vs churn
SELECT
    CASE WHEN HasCrCard = 1 THEN 'Has Credit Card'
         ELSE 'No Credit Card' END AS credit_card_status,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY HasCrCard
ORDER BY churn_rate_pct DESC;

-- Q17. Active member vs inactive member churn
SELECT
    CASE WHEN IsActiveMember = 1 THEN 'Active'
         ELSE 'Inactive' END AS membership_status,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY IsActiveMember
ORDER BY churn_rate_pct DESC;

-- Q18. Products + activity: identify high-risk combinations
SELECT
    NumOfProducts,
    CASE WHEN IsActiveMember = 1 THEN 'Active' ELSE 'Inactive' END AS activity,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY NumOfProducts, IsActiveMember
HAVING COUNT(*) >= 10
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- 6. FINANCIAL / CUSTOMER VALUE INSIGHTS
-- ============================================================

-- Q19. Average financial profile: churned vs retained
SELECT
    CASE WHEN Exited = 1 THEN 'Churned' ELSE 'Retained' END AS status,
    COUNT(*) AS customers,
    ROUND(AVG(Balance), 2) AS avg_balance,
    ROUND(AVG(EstimatedSalary), 2) AS avg_salary,
    ROUND(AVG(CreditScore), 2) AS avg_credit_score,
    ROUND(AVG(Age), 2) AS avg_age
FROM customers
GROUP BY Exited;

-- Q20. Churn by balance band
SELECT
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        WHEN Balance < 50000 THEN '< 50K'
        WHEN Balance < 100000 THEN '50K-100K'
        WHEN Balance < 150000 THEN '100K-150K'
        ELSE '150K+'
    END AS balance_band,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY balance_band
ORDER BY churn_rate_pct DESC;

-- Q21. Salary band vs churn
SELECT
    CASE
        WHEN EstimatedSalary < 50000 THEN '< 50K'
        WHEN EstimatedSalary < 100000 THEN '50K-100K'
        WHEN EstimatedSalary < 150000 THEN '100K-150K'
        ELSE '150K+'
    END AS salary_band,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY salary_band
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- 7. HIGH-RISK CUSTOMER SEGMENTS
-- ============================================================

-- Q22. High-risk segment: older + inactive
SELECT
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
WHERE Age >= 45
  AND IsActiveMember = 0;

-- Q23. High-risk segment: inactive + high balance
SELECT
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(Balance), 2) AS avg_balance
FROM customers
WHERE IsActiveMember = 0
  AND Balance >= 100000;

-- Q24. High-risk segment: inactive + multiple products
SELECT
    NumOfProducts,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
WHERE IsActiveMember = 0
  AND NumOfProducts >= 2
GROUP BY NumOfProducts
ORDER BY churn_rate_pct DESC;

-- Q25. High-value churned customers
SELECT
    CustomerID,
    Surname,
    Geography,
    Age,
    CreditScore,
    Balance,
    NumOfProducts,
    IsActiveMember,
    EstimatedSalary
FROM customers
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 25;

-- Q26. Customers matching multiple risk factors
SELECT
    CustomerID,
    Geography,
    Age,
    CreditScore,
    Balance,
    NumOfProducts,
    IsActiveMember,
    EstimatedSalary,
    (
        (Age >= 45) +
        (CreditScore < 600) +
        (Balance >= 100000) +
        (NumOfProducts >= 2) +
        (IsActiveMember = 0)
    ) AS risk_factor_count
FROM customers
WHERE Exited = 0
ORDER BY risk_factor_count DESC, Balance DESC
LIMIT 50;

-- ============================================================
-- 8. COMBINED BUSINESS SEGMENTS
-- ============================================================

-- Q27. Geography + activity: where is churn concentrated?
SELECT
    Geography,
    CASE WHEN IsActiveMember = 1 THEN 'Active' ELSE 'Inactive' END AS activity,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Geography, IsActiveMember
HAVING COUNT(*) >= 10
ORDER BY churn_rate_pct DESC;

-- Q28. Geography + age group: highest-risk demographic segment
SELECT
    Geography,
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age < 35 THEN '25-34'
        WHEN Age < 45 THEN '35-44'
        WHEN Age < 55 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Geography, age_group
HAVING COUNT(*) >= 10
ORDER BY churn_rate_pct DESC;

-- Q29. Gender + activity + churn
SELECT
    Gender,
    CASE WHEN IsActiveMember = 1 THEN 'Active' ELSE 'Inactive' END AS activity,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Gender, IsActiveMember
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- 9. MANAGEMENT / ACTIONABLE INSIGHTS
-- ============================================================

-- Q30. Top segments by churn rate with minimum sample size
WITH segments AS (
    SELECT
        Geography,
        Gender,
        CASE
            WHEN Age < 35 THEN 'Under 35'
            WHEN Age < 50 THEN '35-49'
            ELSE '50+'
        END AS age_segment,
        IsActiveMember,
        COUNT(*) AS customers,
        SUM(Exited) AS churned
    FROM customers
    GROUP BY Geography, Gender, age_segment, IsActiveMember
)
SELECT
    Geography,
    Gender,
    age_segment,
    CASE WHEN IsActiveMember = 1 THEN 'Active' ELSE 'Inactive' END AS activity,
    customers,
    churned,
    ROUND(churned * 100.0 / customers, 2) AS churn_rate_pct
FROM segments
WHERE customers >= 15
ORDER BY churn_rate_pct DESC, churned DESC;

-- Q31. Estimated balance at risk by geography
SELECT
    Geography,
    ROUND(SUM(Balance), 2) AS total_balance,
    ROUND(SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END), 2) AS churned_balance,
    ROUND(
        SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END) * 100.0
        / NULLIF(SUM(Balance), 0), 2
    ) AS balance_at_risk_pct
FROM customers
GROUP BY Geography
ORDER BY balance_at_risk_pct DESC;

-- Q32. Retention opportunity: retained customers with multiple risk factors
SELECT
    COUNT(*) AS potential_retention_targets,
    ROUND(SUM(Balance), 2) AS target_customer_balance,
    ROUND(AVG(Balance), 2) AS avg_target_balance
FROM customers
WHERE Exited = 0
  AND (
        (Age >= 45) +
        (CreditScore < 600) +
        (Balance >= 100000) +
        (NumOfProducts >= 2) +
        (IsActiveMember = 0)
      ) >= 3;

-- Q33. Churn rate by combined risk score
WITH risk AS (
    SELECT
        CustomerID,
        Exited,
        (
            (Age >= 45) +
            (CreditScore < 600) +
            (Balance >= 100000) +
            (NumOfProducts >= 2) +
            (IsActiveMember = 0)
        ) AS risk_score
    FROM customers
)
SELECT
    risk_score,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM risk
GROUP BY risk_score
ORDER BY risk_score;

-- Q34. Top 20 churned customers by combined financial value
SELECT
    CustomerID,
    Geography,
    Age,
    CreditScore,
    Balance,
    EstimatedSalary,
    NumOfProducts,
    IsActiveMember,
    ROUND(Balance + EstimatedSalary * 0.10, 2) AS priority_value
FROM customers
WHERE Exited = 1
ORDER BY priority_value DESC
LIMIT 20;

-- Q35. Executive summary table for Power BI / reporting
SELECT
    'Overall' AS metric_group,
    COUNT(*) AS customers,
    SUM(Exited) AS churned,
    COUNT(*) - SUM(Exited) AS retained,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(CASE WHEN Exited = 1 THEN Balance ELSE 0 END), 2) AS churned_balance
FROM customers;

-- ============================================================
-- END OF BANK CUSTOMER CHURN BUSINESS INSIGHTS
-- ============================================================
