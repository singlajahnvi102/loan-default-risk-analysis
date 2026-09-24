
-- Question 2 Which districts have the highest and lowest loan default rates?
SELECT 
    d.A2 AS distict_name,
    COUNT(l.loan_id) AS total_loan,
    sum(l.is_default) as default_loan,
    ROUND(SUM(l.is_default) * 100 / COUNT(l.loan_id),
            2) AS default_rate
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    district d ON a.district_id = d.district_id
GROUP BY d.A2
HAVING total_loan >= 8
ORDER BY default_rate DESC;

/*
Analysis:

I filtered the districts based on the minimum number of loans to avoid very small groups affecting the default rate.

Opava has the highest default rate at 37.50%, with 3 defaults out of 8 loans.

Kutna Hora follows with a default rate of 33.33%, with 3 defaults out of 9 loans.

Karvina has the lowest default rate at 12.50%, with 3 defaults out of 24 loans.

Overall, the default rate varies across districts. The minimum loan threshold was used so that districts with very few loans do not distort the comparison.
*/





