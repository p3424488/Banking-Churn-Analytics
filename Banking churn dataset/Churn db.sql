CREATE SCHEMA IF NOT EXISTS churn_db;

USE churn_db;
SHOW TABLES;

SELECT 'customers'    AS table_name, COUNT(*) AS row_count FROM customers    UNION ALL
SELECT 'accounts'     AS table_name, COUNT(*) AS row_count FROM accounts     UNION ALL
SELECT 'transactions' AS table_name, COUNT(*) AS row_count FROM transactions UNION ALL
SELECT 'interactions' AS table_name, COUNT(*) AS row_count FROM interactions;

select * from accounts;

select count(*) from customers where txn_frequency_90d>0;

select * from customers;

select * from interactions;

select * from transactions;

select count(*) from accounts where close_date is not null;

select count(*) from customers where churn_date is null;

USE churn_db;

SELECT
    'customers' AS table_name,
    SUM(CASE WHEN customer_id  IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN age          IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN gender       IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN region       IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN segment      IS NULL THEN 1 ELSE 0 END) AS null_segment,
    SUM(CASE WHEN churn_label  IS NULL THEN 1 ELSE 0 END) AS null_churn_label
FROM customers;

SELECT customer_id, COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING occurrences > 1
LIMIT 10;

-- Check distinct values in text columns
SELECT DISTINCT region   FROM customers ORDER BY region;
SELECT DISTINCT segment  FROM customers ORDER BY segment;
SELECT DISTINCT gender   FROM customers ORDER BY gender;

-- Fill nulls with the most frequently appearing segment
UPDATE customers
SET segment = (
    SELECT seg FROM (
        SELECT segment AS seg
        FROM customers
        WHERE segment IS NOT NULL
        GROUP BY segment
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS temp
)
WHERE segment IS NULL;

select * from customers;

select count(*) from customers where days_since_last_txn is  not null;
 
select count(*) from customers where churn_date < signup_date;

SELECT 
    MIN(txn_date) AS earliest_transaction,
    MAX(txn_date) AS latest_transaction
FROM transactions;

ALTER TABLE customers
ADD COLUMN txn_frequency_90d INT DEFAULT 0;

SET SESSION innodb_lock_wait_timeout = 600;
SET SESSION net_read_timeout = 600;
SET SESSION net_write_timeout = 600;

SELECT COUNT(*) FROM temp_txn_freq;

USE churn_db;

SELECT 
    MIN(txn_frequency_90d) AS min_freq,
    MAX(txn_frequency_90d) AS max_freq,
    ROUND(AVG(txn_frequency_90d), 2) AS avg_freq,
    SUM(CASE WHEN txn_frequency_90d = 0 THEN 1 ELSE 0 END) AS zero_count
FROM customers;
-- Churned customers with no churn date (real problem)
SELECT COUNT(*) AS churned_no_date
FROM customers
WHERE churn_label = 1 
AND churn_date IS NULL;

-- Active customers with a churn date (real problem)
SELECT COUNT(*) AS active_with_date
FROM customers
WHERE churn_label = 0 
AND churn_date IS NOT NULL;

DELETE FROM customers
WHERE churn_label = 1
AND churn_date IS NULL;

select * from accounts;

select count(*) from accounts where open_date> close_date;

select count(*) from accounts where account_type is not null;

UPDATE accounts
SET account_type = (
    SELECT acct_type FROM (
        SELECT account_type AS acct_type
        FROM accounts
        WHERE account_type IS NOT NULL
        GROUP BY account_type
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS temp
)
WHERE account_type IS NULL;

-- Verify
SELECT account_type, COUNT(*) AS count
FROM accounts
GROUP BY account_type
ORDER BY count DESC;

UPDATE accounts
SET account_type = 'Unknown'
WHERE account_type IS NULL;

-- Verify
SELECT account_type, COUNT(*) AS count
FROM accounts
GROUP BY account_type
ORDER BY count DESC;

select * from transactions;

select count(*) from transactions where txn_type is null;
select count(*) from transactions where channel is null;

-- Fix channel nulls
UPDATE transactions
SET channel = 'Unknown'
WHERE channel IS NULL;

-- Fix txn_type nulls
UPDATE transactions
SET txn_type = 'Unknown'
WHERE txn_type IS NULL;

select * from interactions;

select count(*) from interactions where channel is not null;


UPDATE interactions
SET channel = 'Unknown'
WHERE channel IS NULL;

UPDATE customers
SET avg_monthly_balance = ROUND(avg_monthly_balance, 2);
