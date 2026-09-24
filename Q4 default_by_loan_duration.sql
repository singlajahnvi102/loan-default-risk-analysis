-- Question 4) Does Default Rate vary by Loan Duration?
SELECT 
    CASE
        WHEN duration < 36 THEN 'Short-Term'
        WHEN duration = 36 THEN 'Medium-Term'
        ELSE 'Long-Term'
    END AS Duration_category,
    COUNT(*) AS total_loan,
    SUM(is_default) AS default_loan,
    ROUND(SUM(is_default) * 100 / COUNT(loan_id),
            2) AS default_rate
FROM
    loan
GROUP BY CASE
    WHEN duration < 36 THEN 'Short-Term'
    WHEN duration = 36 THEN 'Medium-Term'
    ELSE 'Long-Term'
END
ORDER BY default_rate DESC;

/*
Analysis:

The default rate is quite similar across all three loan-duration categories.

Long-term loans have the highest default rate at 11.66%, followed by medium-term loans at 11.54%.

Short-term loans have the lowest default rate at 10.41%.

The difference between the categories is small, so loan duration does not show a clear relationship with default rate in this dataset.
*/
/*
Result:

No clear relationship was found between loan duration and default rate.

The default rates range from 10.41% to 11.66%, showing only a small difference between short-, medium-, and long-term loans.
*/

