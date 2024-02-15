
-- Create databse
CREATE DATABASE task;

-- Use Database
USE task;


-- Create the transactions table
CREATE TABLE transactions (
    source VARCHAR(50),
    transactionid INT,
    amount INT
);

-- Insert the new data into the transactions table
INSERT INTO transactions (source, transactionid, amount) VALUES 
('web_app', 12345, 2050),
('web_app', 12346, 2100),
('web_app', 12347, 2150),
('web_app', 12348, 2200),
('web_app', 12349, 2250),
('web_app', 12350, 2300),
('web_app', 12353, 2450),
('web_app', 12354, 2500),
('web_app', 12355, 2550),
('web_app', 12356, 2600),
('web_app', 12357, 2650),
('web_app', 12358, 2700),
('accounting_system', 12347, 2150),
('accounting_system', 12345, 2050),
('accounting_system', 12352, 2400),
('accounting_system', 12353, 2450),
('accounting_system', 12354, 2500),
('accounting_system', 12351, 2350),
('accounting_system', 12355, 2550),
('accounting_system', 12355, -2550),
('accounting_system', 12356, 2600),
('accounting_system', 12357, 2650),
('accounting_system', 12357, -2650),
('accounting_system', 12358, 2700),
('accounting_system', 12350, 2300),
('accounting_system', 12349, 2250),
('accounting_system', 12346, 2100),
('payment_service_provider', 12347, 2150),
('payment_service_provider', 12348, 2200),
('payment_service_provider', 12345, 2050),
('payment_service_provider', 12353, 2500),
('payment_service_provider', 12358, 2700),
('payment_service_provider', 12356, 2600),
('payment_service_provider', 12349, 2700),
('payment_service_provider', 12357, 2650),
('payment_service_provider', 12352, 2400),
('payment_service_provider', 12355, 2550),
('payment_service_provider', 12357, -2650),
('payment_service_provider', 12350, 2300),
('payment_service_provider', 12351, 2350);


-- Add a new column 'total_amount' by grouping 'source' and 'transactionid' and summing 'amount'
CREATE TABLE temp_table AS
SELECT 
    source,
    transactionid,
    SUM(amount) AS total_amount,
    COUNT(*) AS count
FROM transactions
GROUP BY source, transactionid;

-- Create table for each sources
CREATE TABLE web_app_df AS
SELECT *
FROM temp_table
WHERE source = 'web_app';

CREATE TABLE accounting_system_df AS
SELECT *
FROM temp_table
WHERE source = 'accounting_system';

CREATE TABLE payment_service_provider_df AS
SELECT *
FROM temp_table
WHERE source = 'payment_service_provider';


-- web_app vs accounting_system 
-- Calculate match and unmatch for web_app
SELECT 
    'web_app' AS Source,
    SUM(CASE 
            WHEN w.transactionid = a.transactionid AND w.total_amount = a.total_amount THEN 1*w.count
            ELSE 0
        END) AS Match1,
    SUM(CASE 
            WHEN COALESCE(a.transactionid, 0) = 0 THEN 1 * w.count  -- Check if the join result is null
                 WHEN w.transactionid IS NOT NULL AND NOT (w.total_amount = a.total_amount) AND w.total_amount != a.total_amount THEN 1 * w.count
            ELSE 0
        END) AS Unmatch
FROM 
    web_app_df w
LEFT JOIN 
    accounting_system_df a ON w.transactionid = a.transactionid

UNION ALL
-- Calculate match and unmatch for accounting_system
SELECT 
    'accounting_system' AS Source,
    SUM(CASE 
            WHEN w.transactionid = a.transactionid AND a.total_amount = w.total_amount THEN 1*a.count
            ELSE 0
        END) AS Match1,
    SUM(CASE 
            WHEN COALESCE(w.transactionid, 0) = 0 THEN 1 * a.count  -- Check if the join result is null
                 WHEN a.transactionid IS NOT NULL AND NOT (a.total_amount = w.total_amount) AND a.total_amount != w.total_amount THEN 1 * a.count
            ELSE 0
        END) AS Unmatch
FROM 
    accounting_system_df a
LEFT JOIN 
    web_app_df w ON a.transactionid = w.transactionid;


-- accounting_system vs payment_service_provider
-- Calculate match and unmatch for accounting_system
SELECT 
    'accounting_system' AS Source,
    SUM(CASE 
            WHEN a.transactionid = p.transactionid AND a.total_amount = p.total_amount THEN 1*a.count
            ELSE 0
        END) AS Match1,
    SUM(CASE 
            WHEN COALESCE(p.transactionid, 0) = 0 THEN 1 * a.count  -- Check if the join result is null
                 WHEN a.transactionid IS NOT NULL AND NOT (a.total_amount = p.total_amount) AND a.total_amount != p.total_amount THEN 1 * a.count
            ELSE 0
        END) AS Unmatch
FROM 
    accounting_system_df a
LEFT JOIN 
    payment_service_provider_df p ON a.transactionid = p.transactionid
UNION ALL
SELECT 
    'payment_service_provider' AS Source,
    SUM(CASE 
            WHEN a.transactionid = p.transactionid AND a.total_amount = p.total_amount THEN 1*p.count
            ELSE 0
        END) AS Match1,
    SUM(CASE 
            WHEN COALESCE(a.transactionid, 0) = 0 THEN 1 * p.count  -- Check if the join result is null
                 WHEN p.transactionid IS NOT NULL AND NOT (a.total_amount = p.total_amount) AND a.total_amount != p.total_amount THEN 1 * p.count
            ELSE 0
        END) AS Unmatch
FROM 
    payment_service_provider_df p
LEFT JOIN 
    accounting_system_df a ON a.transactionid = p.transactionid
    
    
    
    
    