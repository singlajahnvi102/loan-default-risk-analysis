-- Question10) Does client age  show any default pattern?
SELECT 
    MIN(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS min_client_age,
    MAX(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS max_client_age,
    AVG(TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date)) AS avg_client_age
FROM
    client c
        JOIN
    disp d ON c.client_id = d.client_id
        JOIN
    account AS a ON d.account_id = a.account_id
        JOIN
    loan l ON l.account_id = a.account_id
WHERE
    d.type = 'OWNER'
        AND TIMESTAMPDIFF(YEAR,
        c.birth_date,
        l.date) >= 18;


with clients_age as(select l.loan_id,l.is_default,timestampdiff(year,a.date,l.date) as account_age,
case when timestampdiff(year,c.birth_date,l.date) between 18  and 33 Then 'young_age_people'
when timestampdiff(year,c.birth_date,l.date) between 34 and 49  Then 'Middle_age_people' else 'old_age_people' end as client_age_group
from client c 
join disp d
on c.client_id=d.client_id
join account as a 
on d.account_id=a.account_id
join loan l
on l.account_id=a.account_id
where timestampdiff(year, c.birth_date, l.date) >= 18 and type='owner')
select client_age_group,count(loan_id) as total_loan,sum(is_default) as defaults,
Round(sum(is_default)/count(loan_id)*100,2) as default_rate from clients_age group by client_age_group
order by default_rate desc;

-- Analysis:
-- I filtered the data to clients aged 18 and above because the dataset contained some ages below 18, which are not realistic for this loan analysis.
-- After this filter, client age does not show a strong difference in default rates. The rates across the age groups are very similar, ranging from 10.93% to 11.65%.
-- Therefore, age alone does not appear to be a strong indicator of default risk in this dataset.

-- Result:
-- After filtering clients aged 18 and above, default rates remain very similar across age groups. Client age shows only a weak relationship with default risk in this dataset.





 



    
    
