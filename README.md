# Banking-Churn-Analytics

# 🏦 Banking Customer Churn Analytics

> **End-to-End Data Analytics Project** | Predict & Understand Customer Churn

![Python](https://img.shields.io/badge/Python-3.10-blue)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange)
![PowerBI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![Excel](https://img.shields.io/badge/Excel-Analysis-green)

---

## Project Overview

A mid-sized retail bank is losing customers at an alarming rate and leadership cannot explain why. As a junior data analyst, I was tasked with building a complete end-to-end analytics solution that answers two critical business questions:

> **Question 1:** Which customers are most likely to close their accounts in the next 90 days?

> **Question 2:** What are the strongest behavioural and demographic drivers of churn?

To answer both questions, I built a full data pipeline — running an ETL pipeline in Python, loading clean data into MySQL, analysing in Excel, and delivering an interactive Power BI dashboard that a non-technical executive can use.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| **Python (pandas, SQLAlchemy)** | ETL pipeline — extract, clean, load data |
| **MySQL + MySQL Workbench** | Structured data storage and SQL analysis |
| **Microsoft Excel** | Pivot tables, charts, data quality report |
| **Power BI Desktop** | Interactive executive dashboard |
| **GitHub** | Version control and portfolio presentation |

---

##  Dataset

Four interrelated CSV files simulating a retail bank's customer data. The files were intentionally messy — containing nulls, duplicates, inconsistent formatting, outliers, and referential integrity issues.

| File | Rows | Key Columns |
|---|---|---|
| customers.csv | ~40,000 | customer_id, age, gender, region, segment, churn_label |
| accounts.csv | ~55,000 | account_id, customer_id, account_type, balance, status |
| transactions.csv | ~500,000 | transaction_id, account_id, txn_date, txn_type, amount |
| interactions.csv | ~90,000 | interaction_id, customer_id, reason, sentiment_score |

> `churn_label = 1` means the customer churned. This is the target variable throughout the project.

---

##  Pipeline Architecture

```
Raw CSV Files (messy)
        ↓
ETL Pipeline (Python + pandas)
        ↓
Clean CSV Files (backup)
        ↓
MySQL Database (churn_db)
        ↓
SQL Analysis (MySQL Workbench)
        ↓
Excel Report (pivot tables + charts)
        ↓
Power BI Dashboard (executive facing)
```

## 🔑 Key Findings

### Finding 1 — Overall Churn Rate
```
18.85% of customers have churned
1,823 customers lost
Total revenue at risk → ₹176.27 million
```

### Finding 2 — The Bank is Losing its Best Customers
```
Premium segment   → highest churn at 20.31%
Churned customers → avg balance ₹75,105
Retained customers→ avg balance ₹4,800

High value customers are leaving faster
This points to a SERVICE QUALITY problem
not a financial problem
```

### Finding 3 — Geography and Demographics
```
West region    → highest churn at 21.71%
Age 31-45      → highest churn at 19.92%
Gender         → not a significant predictor (0.29% difference)
```

### Finding 4 — Silent Churners Are Most Dangerous
```
Customers with NO complaints → 18.77% churn rate
Customers with 1 complaint  → 19.42% churn rate
Customers with 2+ complaints→ 17.23% churn rate

Customers who complain multiple times are fighting
to stay. Silent customers just leave quietly.
The bank needs PROACTIVE outreach not just
reactive complaint resolution.
```

### Finding 5 — Inactivity is a Strong Signal
```
7,565 customers had zero transactions in last 90 days
These dormant customers represent significant churn risk
Days since last transaction is one of the strongest
predictors of upcoming churn
```

---

## ▶️ How to Reproduce This Project

### Prerequisites
```
Python 3.10+
MySQL 8.0+
Microsoft Excel
Power BI Desktop (free)
Jupyter Lab (via Anaconda)
```

### Step 1 — Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/banking-churn-analytics.git
cd banking-churn-analytics
```

### Step 2 — Install Python Dependencies
```bash
pip install -r requirements.txt
```

### Step 3 — Set Up MySQL
```sql
CREATE SCHEMA IF NOT EXISTS churn_db;
```

### Step 4 — Run the ETL Pipeline
```
Open Jupyter Lab
→ Navigate to scripts/etl_pipeline.ipynb
→ Update MySQL password in the connection cell
→ Run all cells top to bottom
```

### Step 5 — Run SQL Analysis
```
Open MySQL Workbench
→ Connect to churn_db
→ Open sql/churn_analysis.sql
→ Run all queries
```

### Step 6 — Open Power BI Dashboard
```
Open Power BI Desktop
→ File → Open → powerbi/churn_dashboard.pbix
→ Refresh data if prompted
```

---

## 📦 Requirements

```
pandas
numpy
sqlalchemy
mysql-connector-python
matplotlib
seaborn
jupyter
```

---

## 👤 Author

**Pavan**
Data Analyst | Python | SQL | Excel | Power BI
