DROP TABLE customer_analytics;

show tables;

CREATE TABLE customer_analytics AS

SELECT 
    c.customer_id,
    c.age,
    c.gender,
    c.region,
    c.segment,
    c.churn_label,

    -- 🏦 Accounts Features
    COUNT(DISTINCT a.account_id) AS product_count,
    ROUND(AVG(a.balance), 2) AS avg_balance,

    -- 💳 Transactions Features (last 90 days)
    COUNT(t.transaction_id) AS txn_count_90d,
    ROUND(SUM(t.amount), 2) AS total_txn_amount_90d,
    MAX(t.txn_date) AS last_txn_date,

    -- 📞 Interaction Features
    SUM(CASE 
        WHEN LOWER(i.reason) LIKE '%complaint%' THEN 1 
        ELSE 0 
    END) AS complaint_count,

    ROUND(AVG(i.sentiment_score), 2) AS avg_sentiment_score,

    -- ⏱ Activity Feature
    DATEDIFF(CURDATE(), MAX(t.txn_date)) AS days_since_last_txn,

    -- 🎯 Derived Features (VERY USEFUL FOR EXCEL)
    CASE 
        WHEN c.age BETWEEN 18 AND 30 THEN '18-30'
        WHEN c.age BETWEEN 31 AND 45 THEN '31-45'
        WHEN c.age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,

    CASE 
        WHEN AVG(a.balance) < 5000 THEN 'Low Balance'
        WHEN AVG(a.balance) < 20000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_category

FROM customers c

LEFT JOIN accounts a 
    ON c.customer_id = a.customer_id

LEFT JOIN transactions t 
    ON a.account_id = t.account_id
    AND t.txn_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)

LEFT JOIN interactions i 
    ON c.customer_id = i.customer_id

GROUP BY 
    c.customer_id,
    c.age,
    c.gender,
    c.region,
    c.segment,
    c.churn_label;
    
select * from customer_analytics;