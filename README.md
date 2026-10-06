Loan Default Risk Analysis --- SQL + Power BI

How I Started This Project

I wanted to build this project like a real Data Analyst assignment, not
simply take a dataset and make a dashboard.

I asked Claude (Anthropic's AI assistant) to act as both my client and
my senior analyst/expert.

Claude as my client

I gave Claude this prompt:

"Act as a client from the finance industry. I am a data analyst. Bring
me one realistic business problem your company is facing that I could
solve using data analysis. Explain the problem the way a real
stakeholder would. Then let me ask you questions about it.

I am thinking about making a project using SQL, Power BI. So, suggest
accordingly. Also give me a dataset from the internet (with link to
it) that can be related to this problem, and I can start working on
your needs."

Claude then acted as Rohan, VP of Collections & Risk, and gave me
the business problem, business objectives and analytical questions.

Claude as my data expert

I then gave Claude this prompt:

"Paste your column names or attach the files.

You are the data expert from the company. Now explain each column in
business terms, flag anything unusual. Whatever I need to know before
I start working."

This helped me understand the business meaning of the tables and columns
before starting the analysis.

The original business brief and data dictionary are included in the
Documentation folder.

Business Problem

The project was framed around this stakeholder situation:

"Our NPA (default) rate has risen from 3.2% to 5.8% over 18 months. I
need to know which borrower and account segments are driving this, so
my credit team can recalibrate their scorecard and my collections team
can flag at-risk accounts earlier. I need this backed by data, not gut
feeling --- and I want a dashboard my team can check regularly, not a
one-time report."

The goal was to understand which loan, borrower and account segments had
higher observed default rates and whether account behaviour before loan
issuance could provide useful early-warning signals.

Dataset

The project uses the Berka Financial Dataset (1993--1998) from the
CTU Relational Learning Repository.

The dataset contains related banking tables covering loans, accounts,
clients, transactions, cards, districts and other banking relationships.

Dataset source: https://relational.fel.cvut.cz/dataset/Financial

A Major Technical Challenge: 1 Million+ Transactions

One of the hardest parts of this project was working with the trans
table, which contains approximately 1.06 million transaction
records.

I tried several approaches before finding a reliable solution:

MySQL Workbench export --- extremely slow and unreliable for the
full result at this scale.

INTO OUTFILE --- failed because the public guest account did
not have the required file-write privileges.

One large Python query --- the remote server lost the connection
during the query.

Final solution --- exported the data using Python in
20,000-row batches, successfully producing the complete
transaction file.

This taught me that real-world data work is not only about writing the
correct query. The data-access environment and the size of the data also
matter.

The complete troubleshooting process is documented in
Documentation/EXPORT_NOTES.pdf.

Data Understanding and Validation

Before analysis, I worked through the relationships between:

loan

account

client

district

disp

card

trans

order

Important issues included:

disp can contain both OWNER and DISPONENT relationships, so
careless joins can duplicate loan records.

Client age was calculated at the loan issue date.

Ages outside the valid adult analysis range were handled separately.

Districts with very small loan counts were treated cautiously.

The 1998 decline was interpreted carefully because later loans have
less time to become observed defaults.

SQL Analysis

MySQL was used as the main investigation layer.

I analyzed:

Overall default rate

Default rate by district

District unemployment and salary

Loan duration

Loan amount

Loan amount + duration

Pre-loan balance

Pre-loan outgoing transaction activity

Account age

Client age

Gender

Card status

Historical default trends

All SQL analysis is available in the Sql_Files folder.

SQL Views Created for Power BI

I created two dedicated SQL views for the early-warning analysis.

vw_pre_loan_transactions

Connects each loan to transactions that occurred before the loan issue
date.

This supports the Power BI measure:

Average Pre-Loan Balance

vw_pre_loan_outgoing_activity

Summarizes outgoing transaction activity before loan issuance at the
loan level.

This supports:

Average Pre-Loan Outgoing Transactions

Average Total Pre-Loan Outgoing Amount

These views created a direct connection between the SQL investigation
and the Power BI early-warning analysis.

Power BI and DAX

Power BI was used for the interactive analysis and final dashboard.

I created DAX measures and calculated columns including:

Total Loans

Total Defaulted Loans

Default Rate

Average Pre-Loan Balance

Average Pre-Loan Outgoing Transactions

Average Pre-Loan Outgoing Amount

Default Rate with Minimum Loan-Volume Threshold

Default Status

Client Age

Client Age Band

Loan Amount Band

Loan Duration Category

The DAX documentation is stored in
Measures/DAX_Measures_and_Columns.md.

Key Findings

1. Loan amount showed the strongest observed difference

Loan Amount Band     Loans   Default Rate

Small                  497          8.25%
Medium                 159         17.61%
Large                   26         26.92%

Default rates increased from the small to large loan groups. The
large-loan group had the highest observed default rate, although it
contained only 26 loans, so this should be validated on a larger sample.

2. Pre-loan balance was lower for accounts that later defaulted

Average pre-loan balance:

Non-defaulted: 45.2K

Defaulted: 38.6K

Accounts that later defaulted therefore showed lower balances before the
loan was issued, suggesting lower pre-loan financial buffers.

3. Pre-loan outgoing activity was lower, not higher

My initial hypothesis was that customers who later defaulted might show
higher outgoing or withdrawal activity before taking the loan.

The data showed the opposite.

Metric                            Non-Defaulted   Defaulted

Average outgoing transactions             46.96       37.45
Average total outgoing amount            318.4K      289.8K

Future defaulters showed fewer outgoing transactions and lower total
outgoing amounts before loan issuance.

This was an important finding because I allowed the data to challenge my
original assumption rather than forcing the analysis to confirm it.

4. Newer accounts showed higher observed default rates

Account Age       Default Rate

3--9 months             13.62%
10--15 months           11.29%
16--22 months            8.60%

Newer accounts showed higher observed default rates than older accounts.

5. Card ownership showed a strong association

Card Status      Default Rate

Without Card           13.87%
With Card               2.94%

Accounts without a card had a much higher observed default rate.

I did not interpret this as proof that having a card causes lower
default risk. Card ownership may instead reflect an existing or more
established banking relationship or other characteristics associated
with lower risk.

6. District risk was uneven

Several districts showed substantially higher historical default rates,
including Opava, Kutna Hora and Chrudim.

Because some districts had small loan counts, I used minimum-volume
thresholds when highlighting district risk.

7. Client age showed little difference

The valid adult groups were broadly similar:

Young: ~11.7%

Middle: ~10.9%

Older: ~11.5%

The Other category represents records outside the intended adult
analysis range and was not used to interpret adult age risk.

8. Gender showed no meaningful difference

Gender was investigated but did not show a meaningful difference in
observed default rates, so it was not kept as a major dashboard visual.

Stakeholder Hypothesis vs. What the Data Showed

The original business scenario suggested that default risk had increased
from 3.2% to 5.8%.

The historical data did not reproduce a sustained increase.

Observed annual default rates were approximately:

Year     Default Rate

1993           20.00%
1994           13.86%
1995           13.68%
1996           13.33%
1997           13.27%
1998            2.53%

The sharp decline in 1998 must be interpreted cautiously because later
loans have less time to become observed defaults.

I therefore treated the stakeholder's 3.2% → 5.8% statement as the
business hypothesis, not as something the historical dataset had to
prove.

The more useful finding was:

Portfolio-level default trends can look stable or declining while
individual segments still carry significantly higher observed risk.

Dashboard

Page 1 --- Default Risk Overview

Focuses on:

Total Loans

Total Defaulted Loans

Overall Default Rate

Default Rate by District

Default Rate by Year

Default Rate by Account Age

Loan Amount + Duration segmentation

Screenshot: Dashboard_Pages/Default_Risk_Overview.png

Page 2 --- Early Warning Signals

Focuses on:

Average Pre-Loan Balance

Pre-Loan Outgoing Activity

Client Age

Card Status

Screenshot: Dashboard_Pages/Early_Warning_Signals.png

The Power BI file is stored in Dashboard/Berka_finance_project.pbix.

Recommendations

1. Review larger loan applications more carefully

Large loans showed higher observed default rates. Because the sample is
small, this should be validated with a larger and more recent portfolio
before changing lending policy.

2. Pay closer attention to newer accounts

Newer accounts showed higher observed default rates. The bank could
investigate whether limited account history should lead to additional
verification or monitoring.

3. Explore pre-loan balance as an early-warning feature

Lower pre-loan balances were associated with accounts that later
defaulted. This could be investigated further as part of a future
risk-monitoring framework.

4. Investigate lower financial activity

The analysis did not support the initial assumption that future
defaulters simply withdrew more money. Instead, they showed lower
outgoing activity and lower balances.

This suggests that lower financial activity combined with lower
financial buffers may deserve further investigation.

5. Investigate high-risk districts with sufficient volume

District-level differences should be reviewed alongside loan volume,
economic conditions, customer mix and branch-level lending practices.

6. Do not overemphasize age or gender

Age and gender did not show strong or consistent differences in observed
default rates in this analysis.

7. Validate findings on newer data

The dataset is historical. Before applying these findings operationally,
they should be tested on a larger and more recent portfolio.

Limitations

Historical data from 1993--1998

Small samples in some segments

Right-censoring in the latest period

Observational analysis rather than causal analysis

No current customer or economic information

Some segment differences require validation on larger samples

The findings should therefore be treated as analytical signals and
hypotheses for further investigation, not automatic lending rules.

AI-Assisted Workflow --- Responsible Use of AI

AI was used as a learning, business-simulation and review tool, not
as a replacement for my analytical work.

I deliberately gave Claude two roles:

Client

Claude acted as Rohan, VP of Collections & Risk, providing the
business problem, stakeholder expectations and analytical questions.

Senior Analyst / Expert

Claude helped me understand the data, review my thinking, identify
possible mistakes, explain concepts and challenge weak conclusions.

I still performed and owned the actual analytical work:

SQL writing and debugging

Data validation

Analytical decisions

Power BI data modelling

DAX measures

Calculated columns

Dashboard design

Interpretation of findings

Recommendations

I also documented the business brief, data dictionary, technical
troubleshooting and analytical work in this repository.

For me, the purpose of AI was to learn faster, simulate a real
stakeholder and receive feedback on my reasoning, not to outsource the
project.

Project Structure

loan-default-risk-analysis/
│
├── Dashboard/
│   └── Berka_finance_project.pbix
│
├── Dashboard_Pages/
│   ├── Default_Risk_Overview.png
│   └── Early_Warning_Signals.png
│
├── Documentation/
│   ├── Loan_Default_Analysis_Brief.pdf
│   ├── Data_Dictionary_Business_Terms.pdf
│   └── EXPORT_NOTES.pdf
│
├── Measures/
│   └── DAX_Measures_and_Columns.md
│
├── Schema/
│   └── Schema.png
│
├── Sql_Files/
│   ├── Q1_Overall_Default_Rate.sql
│   ├── Q2_Default_by_District.sql
│   ├── Q3_Unemployment_Salary_vs_Default.sql
│   ├── Q4_Default_by_Loan_Duration.sql
│   ├── Q5_Default_by_Loan_Amount.sql
│   ├── Q6_Default_by_Duration_and_Amount.sql
│   ├── Q7_Default_by_Balance.sql
│   ├── Q8_Default_by_Outgoing_Activity.sql
│   ├── Q9_Default_by_Account_Age.sql
│   ├── Q10_Default_by_Client_Age.sql
│   ├── Q11_Default_by_Gender.sql
│   ├── Q12_Default_by_Card_Status.sql
│   ├── Q13_Default_by_Time_Period.sql
│   ├── Table_Structure_and_Loading.sql
│   ├── vw_pre_loan_transactions.sql
│   └── vw_pre_loan_outgoing_activity.sql
│
├── dataset/
│
└── README.md

Tools Used

MySQL --- SQL investigation and analysis

Power BI --- data modelling, interactive analysis and dashboard

DAX --- measures and calculated columns

Power Query --- data preparation and transformation

Python --- large transaction-data export

GitHub --- version control and project documentation

Claude --- stakeholder simulation, data understanding, learning
and analytical review

Final Takeaway

The main lesson from this project was not simply how to write SQL or
build a Power BI dashboard.

It was learning how to move from:

Business Problem → Data Understanding → SQL Investigation → Validation
→ Power BI Model → DAX → Dashboard → Business Recommendation

The stakeholder started with one assumption: default risk was
increasing.

The historical data told a more nuanced story.

The overall trend did not consistently support that assumption, but
deeper analysis showed that risk was not evenly distributed across the
portfolio.

That led me to focus on the segments and account behaviours that
actually showed meaningful differences in observed default rates.

For me, this project demonstrated an important Data Analyst principle:

Do not make the data fit the stakeholder's assumption. Investigate
the evidence, communicate what the data does and does not show, and
turn the findings into useful business actions.
