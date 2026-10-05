-- --Question 1) what is the overall default across all loans

SELECT count(*) as Total_loans,SUM(is_default) as default_loans,
    ROUND(SUM(is_default) / COUNT(*) * 100, 2) AS default_rate
FROM
    loan;
     
 -- Result: Overall default rate=11.14%
 
 
 
