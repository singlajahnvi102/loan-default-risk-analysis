-- Question 9. Does the account's age (how long it existed before the loan was taken) affect default risk?
SELECT 
    MIN(TIMESTAMPDIFF(MONTH, a.date, l.date)) AS min_account_age,
    MAX(TIMESTAMPDIFF(MONTH, a.date, l.date)) AS max_account_age,
    AVG(TIMESTAMPDIFF(MONTH, a.date, l.date)) AS avg_account_age
FROM
    loan l
        JOIN
    account a ON a.account_id = l.account_id;


with accounts_age as(select l.loan_id,l.is_default,timestampdiff(month,a.date,l.date) as account_age,
case when timestampdiff(month,a.date,l.date) between 3 and 9  Then '3- 9 months'
when timestampdiff(month,a.date,l.date) between 10 and 15  Then '10- 15 months' else '15-22 months' end as account_age_group
from loan l 
join account a 
on a.account_id=l.account_id)
select account_age_group,count(loan_id) as total_loan,sum(is_default) as defaults,
Round(sum(is_default)/count(loan_id)*100,2) as default_rate from accounts_age group by account_age_group
order by default_rate desc;

/*
Analysis:

There is a clear downward pattern in default rate as account age increases.
Newer accounts (3–9 months old) have the highest default rate at 13.62%. The rate decreases to 11.29% for accounts
accounts aged 16–22 months.

This suggests that newer accounts may carry somewhat higher default risk than more established accounts.

However, the difference is moderate, so account age should not be used alone to reject a loan. It can be treated as a secondary risk factor along with other factors such as
loan amount, loan duration and borrower characteristics.

Even in the highest-risk group, most accounts did not
default.
*/

/*
Result:

Newer accounts show a higher observed default rate than older accounts.

The default rate falls from 13.62% for accounts aged 3–9 months to 8.60% for accounts aged 16–22 months.

This makes account age a useful secondary risk indicator, but not a standalone reason to reject a loan.
*/
