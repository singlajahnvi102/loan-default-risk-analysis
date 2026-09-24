-- Question 12. Does having a credit card linked to the account correlate with better or worse repayment?
SELECT 
    CASE
        WHEN ca.type IS NOT NULL THEN 'with card'
        ELSE 'without card'
    END card_status,
    COUNT(l.loan_id) AS total_loan,
    SUM(l.is_default) AS defaults,
    ROUND(SUM(l.is_default) / COUNT(l.loan_id) * 100,
            2) AS default_rate
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    disp d ON a.account_id = d.account_id
        LEFT JOIN
    card ca ON ca.disp_id = d.disp_id
WHERE
    d.type = 'owner'
GROUP BY CASE
    WHEN ca.type IS NOT NULL THEN 'with card'
    ELSE 'without card'
END
ORDER BY default_rate DESC;

-- Analysis:
-- Customers with a linked credit card have a much lower default rate than customers without a credit card.
-- The default rate is 2.94% for customers with a card, compared with 13.87% for customers without a card.
-- This is a strong association and makes credit card ownership a useful risk signal in this dataset.
--
-- However, we cannot say that having a credit card causes better repayment.
-- One possible explanation is that the bank may have issued cards mainly to customers who were already considered lower-risk.
-- Another possibility is that card ownership reflects a stronger relationship with the bank.
-- From this data alone, we cannot determine which explanation is correct.