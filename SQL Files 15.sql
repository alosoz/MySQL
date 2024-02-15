SELECT
  s1.source AS source1,
  s2.source AS source2,
  s1.transactionid,
  CASE
    WHEN s1.amount = s2.amount THEN 'Matched'
    ELSE 'Unmatched (Amount discrepancy)'
  END AS match_status
FROM (SELECT source, transactionid,  SUM(amount) AS total_amount
		FROM transactions
		WHERE source = 'web_app'
        JOIN (SELECT source, transactionid,  SUM(amount) AS total_amount
			  FROM transactions
			  WHERE source = 'accounting_system') as b ON a.transactionid = b.transactionid
		group by source, transactionid) AS s1 
LEFT JOIN transactions AS s2 ON s1.transactionid = s2.transactionid
  AND s1.source != s2.source


SELECT source, transactionid,  SUM(amount) AS total_amount
FROM transactions
WHERE source = 'web_app'
GROUP BY transactionid, source;

SELECT source, transactionid,  SUM(amount) AS total_amount
FROM transactions
WHERE source = 'accounting_system'
GROUP BY transactionid, source