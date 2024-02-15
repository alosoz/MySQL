
SELECT source, transactionid,  SUM(amount) AS total_amount
FROM transactions
WHERE source = 'accounting_system'
GROUP BY transactionid, source




SELECT source, transactionid,  SUM(amount) AS total_amount
FROM transactions
WHERE source = 'payment_sevice_provider'
GROUP BY transactionid;




select source, Transactionid, SUM(amount) AS amount
		from transactions
		where Source = 'accounting_system'  or Source = 'payment_sevice_provider'
		group by source, transactionid