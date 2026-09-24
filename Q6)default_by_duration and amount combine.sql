-- Question 6) Does the combination of loan amount and loan duration show different default rates?
SELECT 
    CASE
        WHEN amount BETWEEN 0 AND 199999 THEN 'small-size-loan'
        WHEN amount BETWEEN 200000 AND 400000 THEN 'Mid-size-loan'
        ELSE 'big-size-loan'
    END AS amount_category,
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
    WHEN amount BETWEEN 0 AND 199999 THEN 'small-size-loan'
    WHEN amount BETWEEN 200000 AND 400000 THEN 'Mid-size-loan'
    ELSE 'big-size-loan'
END , CASE
    WHEN duration < 36 THEN 'Short-Term'
    WHEN duration = 36 THEN 'Medium-Term'
    ELSE 'Long-Term'
END
ORDER BY default_rate DESC;

-- Analysis:
-- The results suggest that loan amount and duration together  may be useful indicators of default risk. 
-- Big-size long-term loans show a relatively high default rate, while some
-- mid-size and medium-term loans also show higher default rates.
-- However, this analysis shows a relationship in the data, not that loan amount or duration directly causes default.

-- Result:
-- The combined analysis shows that default rates differ across  loan amount and duration combinations.
-- Big-size long-term loans show a high default rate of 26.92%.
-- Mid-size loans with medium-term duration also show relatively
-- high default rates compared with other combinations.
