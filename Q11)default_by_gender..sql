-- Question11. Does  gender show any default pattern?
SELECT 
    c.gender,
    COUNT(l.loan_id) AS total_loan,
    SUM(l.is_default) AS defaults,
    ROUND(SUM(l.is_default) / COUNT(l.loan_id) * 100,
            2) AS default_rate
FROM
    client c
        JOIN
    disp d ON c.client_id = d.client_id
        JOIN
    account AS a ON d.account_id = a.account_id
        JOIN
    loan l ON l.account_id = a.account_id
WHERE
    d.type = 'owner'
GROUP BY c.gender;

-- Analysis:
-- I compared default rates across male and female clients.
-- The difference in default rates is small, so gender does not show a strong relationship with default risk in this dataset.
-- Therefore, gender should not be used as a standalone factor for making lending decisions.

-- Result:
-- Default rates are broadly similar between male and female clients.
-- Gender does not appear to be a strong predictor of default risk in this dataset.