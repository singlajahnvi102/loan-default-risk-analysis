-- Question 3 IS there a relationship between district level unemployment rate and average salary (from the district table) and default rate?
SELECT 
    d.A2 AS district_name,
    d.A11 AS Avg_salary,
    D.A13 AS unemployment_rate,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.is_default) AS default_loans,
    ROUND(SUM(l.is_default) * 100 / COUNT(l.loan_id),
            2) AS default_rate
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id
        JOIN
    district d ON a.district_id = d.district_id
GROUP BY D.A2 , D.A11 , D.A13
HAVING total_loans >= 8
ORDER BY default_rate DESC;

/*
Analysis:

The results do not show a clear relationship between district unemployment, average salary and default rate.

Opava, Kutna Hora and Chrudim have relatively high default rates and lower average salaries.

However, unemployment does not follow the same pattern.
For example, Karvina has the highest unemployment rate at 7.75%, but its default rate is the lowest at 12.50%.

Ostrava-mesto also has a relatively high unemployment rate of 5.44%, but its default rate is only 15.00%.

Therefore, unemployment and salary alone do not appear to fully explain the differences in district default rates. Other factors may also be affecting loan defaults.
*/

/*
Result:

No clear direct relationship was found between unemployment rate, average salary and loan default rate at the district level.

The data suggests that district economic conditions alone may not be enough to explain differences in default rates.
*/

