-- Question 8)Do defaulted accounts show more withdrawal activity or irregular transaction patterns before the loan went bad?
use berka_financial;
with wthdrawl as(select a.account_id,l.is_default,count(*) as withdrawal_transaction,sum(t.amount)as total_amount from trans t
join account a 
on a.account_id=t.account_id
join loan l 
on l.account_id=a.account_id
where type='VYDAJ' and t.date<l.date
group by a.account_id,l.is_default)
select is_default,round(avg(withdrawal_transaction),2) as avg_withdrawal_transaction,round(avg(total_amount),2) as total_amount
from wthdrawl
 group by is_default
 
-- Analysis:
-- I expected defaulted accounts to show more withdrawal activity before the loan, indicating aggressive spending or money leaving the account quickly.
-- However, the result shows the opposite pattern.
-- Defaulted accounts had fewer outgoing transactions on average (37.45) compared with non-defaulted accounts (46.96).
-- They also had a lower average outgoing transaction amount (289,805.08) compared with non-defaulted accounts (318,437.17).
-- This suggests that the accounts that later defaulted were generally less financially active before the loan rather than showing unusually high outgoing activity.
-- However, this analysis only measures outgoing transactions.

-- Result:

-- Defaulted accounts showed lower outgoing activity before the loan.
-- They averaged 37.45 outgoing transactions compared with 46.96 for non-defaulted accounts, and their average outgoing amount was also lower (289,805.08 vs 318,437.17).
-- Therefore, high withdrawal activity was not a clear warning signal for default in this dataset. Lower overall outgoing activity
-- appears to be the more noticeable pattern.