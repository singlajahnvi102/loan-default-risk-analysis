-- Question 13) Has the default rate changed over time based on the loan issue date?
SELECT
    YEAR(date) AS Year,
    COUNT(loan_id) AS total_loan,
    SUM(is_default) AS defaults,
    ROUND(
        SUM(is_default) / COUNT(loan_id) * 100,
        2
    ) AS default_rate
FROM loan
GROUP BY YEAR(date)
ORDER BY default_rate DESC;

-- Analysis:
-- Default rates were relatively stable from 1994 to 1997,staying around 13% to 14%.
-- However, the rate drops sharply to 2.53% in 1998.
--
-- I would not interpret the 1998 decline as a genuine improvement in loan quality. Loans issued in the later years had less timeto potentially default because the dataset ends shortly after
-- those loans were issued. This is a time-related limitation known as right-censoring.
--
-- Therefore, the lower default rate in 1998 may partly be because these loans have not been observed for long enough to show defaults.
-- The 1993 result should also be interpreted cautiously because it is based on only 20 loans.

-- Result:
-- Default rates remained fairly stable at around 13%–14% from 1994 to 1997, but dropped sharply to 2.53% in 1998.
-- However, the 1998 rate may be artificially low because recent loans had less time to default.
-- Therefore, the yearly trend should be treated as an observed pattern rather than proof that loan quality improved over time.