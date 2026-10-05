USE berka_financial;

CREATE OR REPLACE VIEW vw_pre_loan_transactions AS
SELECT
    l.loan_id,
    l.account_id,
    l.date AS loan_date,
    l.is_default,
    t.date AS transaction_date,
    t.balance
FROM loan l
JOIN account a
    ON a.account_id = l.account_id
JOIN trans t
    ON t.account_id = a.account_id
WHERE t.date < l.date;

