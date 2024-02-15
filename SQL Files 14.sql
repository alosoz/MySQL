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
