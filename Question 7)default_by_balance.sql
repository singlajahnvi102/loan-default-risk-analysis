-- Question 7) DO defaulted accounts have a lower averager balance compared to good accounts?
SELECT 
    AVG(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS avg_balance_good_loans,
    AVG(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS avg_balance_default_loans
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id;


SELECT 
    AVG(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS avg_preloan_balance_non_defaulted,
    AVG(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS avg_preloan_balance_defaulted
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id
WHERE
    t.date < l.date;

SELECT 
    MIN(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS avg_preloan_balance_non_defaulted,
    MIN(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS avg_preloan_balance_defaulted
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id
WHERE
    t.date < l.date;





SELECT 
    MIN(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS min_client_age,
    MAX(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS max_client_age,
    AVG(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS avg_client_age
FROM
    client c
        JOIN
    disp d ON c.client_id = d.client_id
        JOIN
    account AS a ON d.account_id = a.account_id
        JOIN
    loan l ON l.account_id = a.account_id
WHERE
    d.type = 'OWNER'
        AND TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date) >= 18;






SELECT 
    *
FROM
    trans;

SELECT 
    AVG(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS avg_preloan_balance_non_defaulted,
    AVG(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS avg_preloan_balance_defaulted
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id
WHERE
    t.date < l.date;

SELECT 
    MIN(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS avg_preloan_balance_non_defaulted,
    MIN(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS avg_preloan_balance_defaulted
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id
WHERE
    t.date < l.date;