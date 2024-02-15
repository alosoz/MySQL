# Calculate match and unmatch counts for web_app vs. accounting_system

WITH matched_transactions AS (
  SELECT t1.source AS source_web_app, t2.source AS source_accounting_system,
         t1.transactionid, t1.amount AS amount_web_app, t2.amount AS amount_accounting_system,
         COUNT(*) AS count
  FROM transactions t1
  INNER JOIN transactions t2 ON t1.transactionid = t2.transactionid
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