SELECT
  source1,
  SUM(CASE WHEN match_status = 'Matched' THEN 1 ELSE 0 END) AS matched_rows,
  SUM(CASE WHEN match_status = 'Unmatched (Amount discrepancy)' THEN 1 ELSE 0 END) AS unmatched_rows
FROM (
  SELECT
  s1.source AS source1,
  s2.source AS source2,
  s1.transactionid,
  CASE
    WHEN s1.amount = s2.amount THEN 'Matched'
    ELSE 'Unmatched (Amount discrepancy)'
  END AS match_status
FROM transactions AS s1
LEFT JOIN transactions AS s2 ON s1.transactionid = s2.transactionid
  AND s1.source != s2.source
) AS combined_data
WHERE source1 = 'payment_service_provider' or   source1 = 'accounting_system'
GROUP BY source1;