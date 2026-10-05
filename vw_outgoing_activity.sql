USE berka_financial;


CREATE OR REPLACE VIEW vw_pre_loan_outgoing_activity AS
SELECT
    a.account_id,
    l.loan_id,
    l.is_default,
    COUNT(*) AS outgoing_transaction_count,
    SUM(t.amount) AS outgoing_transaction_amount
FROM loan l
JOIN account a
    ON a.account_id = l.account_id
JOIN trans t
    ON t.account_id = a.account_id
WHERE t.type = 'VYDAJ'
  AND t.date < l.date
GROUP BY
    a.account_id,
    l.loan_id,
    l.is_default;
    
    

