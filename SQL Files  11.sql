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
UNION ALL
SELECT
  s1.source AS source1,
  NULL AS source2,
  s1.transactionid,
  'Unmatched (Missing record)' AS match_status
FROM transactions AS s1
LEFT JOIN transactions AS s2 ON s1.transactionid = s2.transactionid
  AND s1.source != s2.source
WHERE s2.amount IS NULL