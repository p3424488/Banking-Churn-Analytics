-- EDA 
-- BANKING CUSTOMER CHURN ANALYSIS

use churn_db;

-- Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned_customers,
    COUNT(*) - SUM(churn_label) AS active_customers,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers;

-- churn per month
SELECT 
    DATE_FORMAT(churn_date, '%Y-%m') AS churn_month,
    COUNT(*) AS churned_customers
FROM customers
WHERE churn_label = 1
AND churn_date IS NOT NULL
GROUP BY churn_month
ORDER BY churn_month;

-- churn by region
SELECT 
    region,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY region
ORDER BY churn_rate_pct DESC;

-- churn by age
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_band,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY age_band
ORDER BY churn_rate_pct DESC;

-- churn by segment
SELECT 
    segment,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY segment
ORDER BY churn_rate_pct DESC;

-- churn by gender
SELECT 
    gender,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY gender
ORDER BY churn_rate_pct DESC;

-- churn by balance
SELECT 
    c.churn_label,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(AVG(a.balance), 2) AS avg_balance,
    ROUND(MIN(a.balance), 2) AS min_balance,
    ROUND(MAX(a.balance), 2) AS max_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.churn_label;

-- churn by complaint
SELECT 
    CASE
        WHEN complaint_count = 0 THEN 'No Complaints'
        WHEN complaint_count = 1 THEN '1 Complaint'
        ELSE '2+ Complaints'
    END AS complaint_band,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY complaint_band
ORDER BY churn_rate_pct DESC;

-- checking revenue
SELECT 
    ROUND(SUM(a.balance), 2) AS total_revenue_at_risk,
    COUNT(DISTINCT c.customer_id) AS churned_customers,
    ROUND(AVG(a.balance), 2) AS avg_balance_per_churner
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.churn_label = 1;

-- churn by dormant 
SELECT 
    COUNT(*) AS dormant_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
WHERE days_since_last_txn >= 90;

SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_id) AS churned_customers,
    ROUND(SUM(a.balance), 2) AS revenue_at_risk,
    ROUND(AVG(a.balance), 2) AS avg_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.churn_label = 1
GROUP BY c.segment
ORDER BY revenue_at_risk DESC;

-- churn by revenue risk by segment
SELECT 
    CASE
        WHEN txn_frequency_90d = 0 THEN 'No Transactions'
        WHEN txn_frequency_90d BETWEEN 1 AND 2 THEN 'Low (1-2)'
        WHEN txn_frequency_90d BETWEEN 3 AND 4 THEN 'Medium (3-4)'
        ELSE 'High (5+)'
    END AS txn_band,
    COUNT(*) AS total_customers,
    SUM(churn_label) AS churned,
    ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY txn_band
ORDER BY churn_rate_pct DESC; 

-- window function risk ranking
SELECT 
    customer_id,
    region,
    segment,
    complaint_count,
    days_since_last_txn,
    avg_monthly_balance,
    RANK() OVER (
        PARTITION BY region
        ORDER BY complaint_count DESC, 
                 days_since_last_txn DESC
    ) AS risk_rank_in_region
FROM customers
WHERE churn_label = 0
ORDER BY region, risk_rank_in_region
LIMIT 20;

-- stored procedures
DELIMITER //

CREATE PROCEDURE sp_churn_summary(IN p_segment VARCHAR(50))
BEGIN
    SELECT
        segment,
        COUNT(*) AS total_customers,
        SUM(churn_label) AS churned,
        ROUND(SUM(churn_label) / COUNT(*) * 100, 2) AS churn_rate_pct,
        ROUND(AVG(avg_monthly_balance), 2) AS avg_balance
    FROM customers
    WHERE segment = p_segment
    GROUP BY segment;
END //

DELIMITER ;
CALL sp_churn_summary('Premium');
CALL sp_churn_summary('Corporate');
CALL sp_churn_summary('Sme');
CALL sp_churn_summary('Retail');