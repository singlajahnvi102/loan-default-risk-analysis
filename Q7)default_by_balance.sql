-- Question 7) DO defaulted accounts have a lower averager balance compared to good accounts?
use berka_financial;
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

-- TO check Outlier
SELECT 
    MIN(CASE
        WHEN l.is_default = 0 THEN t.balance
    END) AS min_preloan_balance_non_defaulted,
    MIN(CASE
        WHEN l.is_default = 1 THEN t.balance
    END) AS min_preloan_balance_defaulted
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    trans t ON t.account_id = a.account_id
WHERE
    t.date < l.date;
    
-- check median
WITH balance_data AS (
    SELECT
        l.is_default,
        t.balance
    FROM loan l
    JOIN account a
        ON a.account_id = l.account_id
    JOIN trans t
        ON t.account_id = a.account_id
    WHERE t.date < l.date
),

ranked_data AS (
    SELECT
        is_default,
        balance,
        ROW_NUMBER() OVER (
            PARTITION BY is_default
            ORDER BY balance
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY is_default
        ) AS total_rows
    FROM balance_data
)

SELECT
    is_default,
    ROUND(AVG(balance), 2) AS median_preloan_balance
FROM ranked_data
WHERE rn IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
)
GROUP BY is_default;

-- Analysis:
-- The median confirms that the lower balance found in the average is not caused only by a few extreme outliers.
-- The median pre-loan balance of defaulted accounts was 33,186, compared with 40,454 for non-defaulted accounts.
-- This is around an 18% difference, showing that the typical defaulted account had a lower pre-loan balance.
-- The same pattern is also visible in the average balance (38,639 vs 45,171), so the finding is consistent across both average and median.
-- Therefore, lower pre-loan balance appears to be a useful observed risk signal in this dataset.


-- Result:
-- Defaulted accounts had a lower pre-loan balance than non-defaulted accounts.
-- The median balance was 33,186 for defaulted accounts compared with 40,454 for non-defaulted accounts.
-- Since the difference remains even when using the median, the finding is not driven only by extreme outliers.

