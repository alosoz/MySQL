USE deneme;
/*
CREATE TABLE transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  source VARCHAR(50) NOT NULL,
  transactionid INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL
);
INSERT INTO transactions (source, transactionid, amount)
VALUES
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
  ('accounting_system', 12347, 2150),
  ('accounting_system', 12345, 2050),
  ('accounting_system', 12346, 2100),
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
  ('payment_service_provider', 12347, 2150),
  ('payment_service_provider', 12348, 2200),
  ('payment_service_provider', 12345, 2050),
  ('payment_service_provider', 12353, 2450),
  ('payment_service_provider', 12358, 2700),
  ('payment_service_provider', 12356, 2600),
  ('payment_service_provider', 12349, 2700),
  ('payment_service_provider', 12357, 2650),
  ('payment_service_provider', 12352, 2400),
  ('payment_service_provider', 12355, 2550),
  ('payment_service_provider', 12357, -2650),
  ('payment_service_provider', 12350, 2300),
  ('payment_service_provider', 12351, 2350);
  
  */
  
  
  # Calculate match and unmatch counts for web_app vs. accounting_system

WITH matched_transactions AS (
  SELECT t1.source AS source_web_app, t2.source AS source_accounting_system,
         t1.transactionid, t1.amount AS amount_web_app, t2.amount AS amount_accounting_system,
         COUNT(*) AS count
  FROM transactions AS t1
  INNER JOIN transactions AS t2 ON t1.transactionid = t2.transactionid
  WHERE t1.source = 'web_app' AND t2.source = 'accounting_system'
  AND t1.amount = t2.amount
  GROUP BY t1.source, t2.source, t1.transactionid, t1.amount, t2.amount
),

unmatched_transactions AS (
  SELECT t1.source AS source_web_app, t2.source AS source_accounting_system,
         t1.transactionid, t1.amount AS amount_web_app, t2.amount AS amount_accounting_system,
         COUNT(*) AS count
  FROM transactions t1
  LEFT JOIN transactions t2 ON t1.transactionid = t2.transactionid
  WHERE t1.source = 'web_app' AND t2.source = 'accounting_system'
  AND (t2.transactionid IS NULL OR t1.amount != t2.amount)
  GROUP BY t1.source, t2.source, t1.transactionid, t1.amount, t2.amount
)

SELECT
  SUM(matched_transactions.count) AS match_count,
  SUM(unmatched_transactions.count) AS unmatch_count
FROM matched_transactions
UNION ALL
SELECT
  0 AS match_count,
  SUM(unmatched_transactions.count) AS unmatch_count
FROM unmatched_transactions;


# Calculate match and unmatch counts for accounting_system vs. payment_service_provider

WITH matched_transactions AS (
  SELECT t1.source AS source_accounting_system, t2.source AS source_payment_service_provider,
         t1.transactionid, t1.amount AS amount_accounting_system, t2.amount AS amount_payment_service_provider,
         COUNT(*) AS count
  FROM transactions t1
  INNER JOIN transactions t2 ON t1.transactionid = t2.transactionid
  WHERE t1.source = 'accounting_system' AND t2.source = 'payment_service_provider'
  AND t1.amount = t2.amount
  GROUP BY t1.source, t2.source, t1.transactionid, t1.amount, t2.amount
),

unmatched_transactions AS (
  SELECT t1.source AS source_accounting_system, t2.source AS source_payment_service_provider,
         t1.transactionid, t1.amount AS amount_accounting_system, t2.amount AS amount_payment_service_provider,
         COUNT(*) AS count
  FROM transactions t1
  LEFT JOIN transactions t2 ON t1.transactionid = t2.transactionid
  WHERE t1.source = 'accounting_system' AND t2.source = 'payment_service_provider'
  AND (t2.transactionid IS NULL OR t1.amount != t2.amount)
  GROUP BY t1.source, t2.source, t1.transactionid, t1.amount, t2.amount
)

SELECT
  SUM(matched_transactions.count) AS match_count,
  SUM(unmatched_transactions.count) AS unmatch_count
FROM matched_transactions
UNION ALL
SELECT
  0 AS match_count,
  SUM(unmatched_transactions.count) AS unmatch_count
FROM unmatched_transactions;


SELECT source, SUM(match_count) AS match_

