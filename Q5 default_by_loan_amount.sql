-- Question 5)Does default rate vary by loan amount?

SELECT 
    CASE
        WHEN amount BETWEEN 0 AND 199999 THEN 'small-size-loan'
        WHEN amount BETWEEN 200000 AND 400000 THEN 'Mid-size-loan'
        ELSE 'big-size-loan'
    END AS amount_category,
    COUNT(*) AS total_loan,
    SUM(is_default) AS default_loan,
    ROUND(SUM(is_default) * 100 / COUNT(loan_id),
            2) AS default_rate
FROM
    loan
GROUP BY CASE
    WHEN amount BETWEEN 0 AND 199999 THEN 'small-size-loan'
    WHEN amount BETWEEN 200000 AND 400000 THEN 'Mid-size-loan'
    ELSE 'big-size-loan'
END
ORDER BY default_rate DESC;

/*
Analysis:

The default rate increases as the loan amount increases.
Big-size loans have the highest default rate at 26.92%,
followed by mid-size loans at 17.61%.

Small-size loans have the lowest default rate at 8.25%.

This shows a clear difference in default rates across the loan amount categories. However, the big-size loan group has only 26 loans, so the result should be
interpreted carefully.

Further analysis is needed to check whether loan duration also affects the default rate within each loan amount category.
*/

/*
Result:

Big-size loans have the highest observed default rate at 26.92%, while small-size loans have the lowest at 8.25%.

The default rate increases from 8.25% for small loans to 17.61% for mid-size loans and 26.92% for big-size loans.

Loan amount therefore shows a noticeable relationship with default rate in this dataset.
*/

