Bank Customer Churn Analysis

📌 Project Overview

This project analyzes bank customer data to identify the key factors that influence customer churn. The objective is to understand why customers leave the bank and provide data-driven recommendations to improve customer retention.

The project uses Python, SQL, Excel, and Power BI to clean, analyze, and visualize customer data.

🎯 Business Objectives

- Analyze the overall customer churn rate.
- Identify customer segments with high churn.
- Understand the relationship between age, geography, balance, and churn.
- Analyze churn based on customer activity and product usage.
- Build an interactive Power BI dashboard.
- Provide actionable recommendations to improve customer retention.

🏦 Business Problem

Customer churn is a major challenge for banks because losing customers can reduce revenue and increase customer acquisition costs.

The bank needs to understand which customers are more likely to leave and what factors may contribute to their decisions. This analysis helps identify churn patterns and supports better customer retention strategies.

🛠️ Tools and Technologies

- Microsoft Excel: Data inspection and preliminary analysis
- Python: Data cleaning, exploratory data analysis (EDA), and visualization
- SQL: Data querying and business analysis
- Power BI: Interactive dashboard and KPI visualization
- Jupyter Notebook: Python development environment
- GitHub: Project documentation and portfolio hosting

📂 Project Structure

Bank-Customer-Churn-Analysis/
│
├── README.md
│
├── data/
│   ├── bank_churn_raw.csv
│   └── bank_churn_cleaned.csv
│
├── sql/
│   └── churn_analysis.sql
│
├── python/
│   ├── data_cleaning.ipynb
│   └── churn_eda.ipynb
│
├── powerbi/
│   └── customer_churn_dashboard.pbix
│
└── images/
    └── dashboard.png

📊 Dataset Description

The dataset contains customer demographic, financial, and account information.

Important columns include:

Column| Description
CustomerId| Unique customer identifier
Surname| Customer surname
CreditScore| Customer credit score
Geography| Customer location
Gender| Customer gender
Age| Customer age
Tenure| Years with the bank
Balance| Account balance
NumOfProducts| Number of bank products used
HasCrCard| Whether the customer has a credit card
IsActiveMember| Whether the customer is an active member
EstimatedSalary| Estimated annual salary
Exited| Whether the customer left the bank

Target variable: "Exited" — 1 indicates a customer who left; 0 indicates a customer who stayed.

Note: Confirm the dataset source and actual column names before publishing. The dataset may use "CustomerID" instead of "CustomerId".

🧹 Data Cleaning

The data-cleaning process may include:

- Checking missing values and duplicate records.
- Reviewing data types and column names.
- Identifying invalid or inconsistent values.
- Checking the distribution of numerical columns.
- Preparing a cleaned dataset for analysis.
- Saving the cleaned data for further analysis.

🗃️ SQL Analysis

SQL is used to answer important business questions, such as:

1. What is the total number of customers?
2. How many customers have left the bank?
3. What is the overall customer churn rate?
4. Which geographical region has the highest churn?
5. How does churn differ by gender?
6. Which age groups have higher churn?
7. Are inactive customers more likely to leave?
8. How does the number of bank products relate to churn?
9. What is the relationship between account balance and churn?
10. Which customer segments should the bank prioritize for retention?

🐍 Python Analysis

Python is used for data cleaning, exploratory data analysis, and visualizations.

Libraries that may be used:

- Pandas
- NumPy
- Matplotlib
- Seaborn

The analysis can include customer distributions, churn comparisons, correlation analysis, and visual exploration of customer behavior.

📈 Power BI Dashboard

The Power BI dashboard is designed to provide an overview of customer churn and help users explore customer segments.

Suggested KPIs:

- Total Customers
- Churned Customers
- Retained Customers
- Customer Churn Rate
- Average Customer Age

Suggested Visualizations:

- Churn by Geography
- Churn by Gender
- Churn by Age Group
- Churn by Activity Status
- Churn by Number of Products
- Customer Churn Distribution

Suggested Slicers:

- Geography
- Gender
- Age Group
- Active Member Status
- Credit Card Status

🔍 Key Insights

The following insights should be added after completing the analysis:

- Overall customer churn rate: [Add calculated percentage]
- Region with the highest churn: [Add result]
- Age group with the highest churn: [Add result]
- Churn among inactive members: [Add result]
- Product category or product count associated with higher churn: [Add result]

Replace these placeholders with findings calculated from your actual dataset. Do not publish unverified results.

💡 Business Recommendations

Based on the actual analysis, the bank may consider:

1. Developing targeted retention campaigns for high-risk customer segments.
2. Improving engagement among inactive customers.
3. Reviewing customer feedback and service quality in high-churn regions.
4. Offering relevant banking products based on customer needs.
5. Monitoring churn KPIs regularly through a Power BI dashboard.

Recommendations should be refined according to the findings.

🚀 How to Run This Project

1. Download the dataset from its original source.
2. Place the raw dataset inside the "data/" folder.
3. Run the Python notebooks to clean and explore the data.
4. Import the dataset into your SQL database.
5. Execute the queries in "sql/churn_analysis.sql".
6. Open the Power BI file to explore the dashboard.
7. Compare the results and document the key business insights.

📌 Project Outcomes

This project demonstrates practical skills in:

- Data cleaning and preparation
- Exploratory data analysis
- SQL querying and aggregation
- Business KPI analysis
- Data visualization
- Interactive dashboard development
- Business insight generation
- Project documentation using GitHub

👩‍💻 Author

Akriti Kumari

Aspiring Data Analyst | BCA Student

Skills: Excel | SQL | Python | Power BI

GitHub: [Add your GitHub profile link]

LinkedIn: [Add your LinkedIn profile li

This project is part of my data analytics portfolio and showcases my practical learning in data analysis and business intelligence.
