📌 How I Started This Project

I wanted to build this project like a real Data Analyst assignment,
rather than simply downloading a dataset and creating a dashboard.

So I used AI deliberately to simulate a real workplace environment.

I asked Claude to act as my client first, and then as the data
expert / senior analyst who could help me understand the business
context and review my reasoning.

This gave me a realistic workflow:

Business Problem → Data Understanding → SQL Investigation → Validation
→ Power BI Model → DAX → Dashboard → Recommendations

🤝 AI-Assisted Project Setup

1. Claude as My Client

I gave Claude this exact prompt:

“Act as a client from the finance industry . I am a data analyst.
Bring me one realistic business problem your company is facing that I
could solve using data analysis. Explain the problem the way a real
stakeholder would. Then let me ask you questions about it.
I am thinking about making a project using SQL, Power BI. So, suggest
accordingly. Also give me a dataset from the internet (with link to
it) that can be related to this problem, and I can start working on
your needs.”

Claude then acted as Rohan, VP of Collections & Risk, and provided
the business problem, stakeholder expectations and analytical questions.

2. Claude as My Data Expert

After receiving the business problem, I gave Claude this second prompt:

“Paste your column names or attach the files.
You are the data expert from the company. Now explain each column in
business terms, flag anything unusual. Whatever I need to know before
I start working.”

This helped me understand the tables, relationships, business meaning of
columns and potential data-quality issues before starting the analysis.

📁 Supporting documentation: - Business Problem
Brief - Data Dictionary
— Business Terms &
Watch-Outs

🎯 Business Problem

The project was framed around this stakeholder situation:

“Our NPA (default) rate has risen from 3.2% to 5.8% over 18 months.
I need to know which borrower and account segments are driving this,
so my credit team can recalibrate their scorecard and my collections
team can flag at-risk accounts earlier. I need this backed by data,
not gut feeling — and I want a dashboard my team can check regularly,
not a one-time report.”

Business objective

Use loan, account, client, district and transaction data to answer:

Which borrower and loan segments show higher observed default
rates?

Which account characteristics are associated with higher default
rates?

What account behaviour was visible before loan issuance?

Does the historical data actually support the stakeholder’s claim
that default risk increased?

What should the risk and collections teams investigate further?

🗂️ Dataset

This project uses the Berka Financial Dataset (1993–1998) from the
CTU Relational Learning Repository.

The dataset contains banking information across tables such as:

loan

account

client

district

disp

card

trans

order

🔗 Dataset: CTU Relational Financial
Dataset

Loan outcome definition

The original dataset documentation defines:

Original Status

Interpretation in this project

A

Non-default

C

Non-default

B

Default

D

Default

Therefore, the project classifies B + D as defaulted and A + C as
non-defaulted.

Important: The dataset documentation also discusses a
min(trans.balance) rule that can perfectly separate some loan
outcomes. I did not use minimum transaction balance to define
defaults or as a predictive feature. This project is a
descriptive/historical analysis, not a machine-learning prediction
model.

🚧 A Major Technical Challenge — 1 Million+ Transactions

One of the hardest parts of this project was working with the trans
table, which contains approximately 1.06 million transaction
records.

I tried several approaches before finding a reliable solution:

❌ Attempt 1 — MySQL Workbench export

The GUI export was extremely slow and unreliable at this scale.

❌ Attempt 2 — INTO OUTFILE

The public guest account did not have the required file-write
privileges.

❌ Attempt 3 — One large Python query

The remote server lost the connection while retrieving the full dataset
in one request.

✅ Final solution — Batch export

I used Python + pandas and exported the data in 20,000-row
batches.

This successfully produced approximately 1.06 million transaction
records.

📄 Full troubleshooting notes:
EXPORT_NOTES.pdf

💡 What I learned

Real-world data analysis is not only about writing the correct SQL
query. Data access, permissions, connection stability and data
volume also matter.

🧹 Data Understanding & Validation

Before analysing the data, I checked the relationships between the main
tables.

Important data issues I handled

disp can contain both OWNER and DISPONENT relationships, so
careless joins can duplicate loan records.

Client age was calculated at the loan issue date, rather than
using a single static age.

Ages outside the intended adult analysis range were handled
separately.

Districts with very small loan volumes were treated cautiously.

The 1998 default rate was interpreted carefully because later loans
have less time to become observed defaults.

Pre-loan behavioural analysis used transactions occurring before the
loan issue date, avoiding post-loan activity in those measures.

🔍 SQL Analysis

MySQL was used as the main investigation layer.

I analysed:

Area

Business Question

Overall default

What is the portfolio default rate?

District

Which districts show higher observed default rates?

Economic conditions

Do unemployment and salary vary with district default rates?

Loan duration

Are short-, medium- or long-term loans riskier?

Loan amount

Does loan size relate to default rate?

Amount + duration

Which combinations show higher observed risk?

Pre-loan balance

Did future defaulters have lower balances before borrowing?

Outgoing activity

Did future defaulters show different pre-loan activity?

Account age

Are newer accounts riskier?

Client age

Does age show a meaningful default pattern?

Gender

Is there a meaningful difference?

Card status

Does card ownership correlate with default rate?

Time

Did default rates change over the historical period?

📁 View all SQL analysis

🧩 SQL Views Built for Power BI

I created two SQL views specifically to connect the transaction-level
investigation with the Power BI dashboard.

vw_pre_loan_transactions

Links each loan to transactions that occurred before the loan issue
date.

Used for:

Average Pre-Loan Balance

vw_pre_loan_outgoing_activity

Summarises outgoing transaction activity before loan issuance at the
loan level.

Used for:

Average Pre-Loan Outgoing Transactions

Average Total Pre-Loan Outgoing Amount

📁 View SQL views

📊 Power BI Dashboard

The final Power BI report contains two pages, each answering a
different part of the business problem.

Page 1 — Default Risk Overview

Focus:

Total Loans

Total Defaulted Loans

Overall Default Rate

Default Rate by District

Default Rate by Year

Default Rate by Account Age

Loan Amount + Duration segmentation

🖼️ Dashboard Preview

<figure>
<img src="Dashboard_Pages/Default_Risk_Overview.png"
alt="Default Risk Overview" />
<figcaption aria-hidden="true">Default Risk Overview</figcaption>
</figure>

Page 2 — Early Warning Signals

Focus:

Average Pre-Loan Balance

Pre-Loan Outgoing Activity

Client Age

Card Status

🖼️ Dashboard Preview

<figure>
<img src="Dashboard_Pages/Early_Warning_Signals.png"
alt="Early Warning Signals" />
<figcaption aria-hidden="true">Early Warning Signals</figcaption>
</figure>

Note: The dashboard screenshots are stored in Dashboard_Pages/
so the report can be reviewed directly from GitHub without opening
Power BI.

📁 Open Dashboard Pages
📁 Open Power BI File

📈 Key Findings

1. Loan amount showed the strongest observed difference

Loan Amount

Loans

Default Rate

Small

497

8.25%

Mid

159

17.61%

Big

26

26.92%

Default rates increased from the small to large loan groups.

However, the big-loan group contains only 26 loans, so this finding
should be validated using a larger and more recent portfolio.

2. Future defaulters had lower pre-loan balances

Default Status

Average Pre-Loan Balance

Non-defaulted

45.2K

Defaulted

38.6K

Accounts that later defaulted showed lower balances before the loan
was issued, suggesting lower pre-loan financial buffers.

This is an association, not proof that lower balance causes default.

3. Future defaulters showed lower outgoing activity

My initial expectation was that future defaulters might show higher
outgoing or withdrawal activity before taking the loan.

The data showed the opposite:

Metric

Non-Defaulted

Defaulted

Average outgoing transactions

46.96

37.45

Average total outgoing amount

318.4K

289.8K

So the data did not support the original assumption of higher
pre-loan outgoing activity.

4. Newer accounts showed higher observed default rates

Account Age

Default Rate

3–9 months

13.62%

10–15 months

11.29%

16–22 months

8.60%

Newer accounts showed higher observed default rates than older accounts.

This could justify further investigation into whether limited account
history is associated with higher risk.

5. Card ownership showed a strong association

Card Status

Default Rate

Without Card

13.87%

With Card

2.94%

Accounts without a card had a much higher observed default rate.

I did not interpret this as proof that having a card reduces default
risk. Card ownership may reflect an existing or more established
banking relationship or other characteristics associated with lower
risk.

6. District risk was uneven

Several districts showed higher historical default rates, including:

Opava

Kutna Hora

Chrudim

Because some districts had small loan counts, I used a minimum-volume
threshold when highlighting district risk.

7. Age and gender did not show meaningful differences

The adult age groups were broadly similar:

Young: ~11.7%

Middle: ~10.9%

Older: ~11.5%

Gender was also investigated but did not show a meaningful difference in
observed default rates.

Therefore, neither age nor gender was treated as a major risk driver in
the final dashboard.

⚠️ Stakeholder Hypothesis vs. What the Data Actually Showed

The business scenario started with the statement:

Default rate increased from 3.2% to 5.8% over 18 months.

But the historical dataset did not reproduce a sustained increase.

Observed annual default rates were approximately:

Year

Default Rate

1993

20.00%

1994

13.86%

1995

13.68%

1996

13.33%

1997

13.27%

1998

2.53%

The sharp decline in 1998 should be interpreted cautiously because later
loans have less time to become observed defaults (right-censoring).

🎯 What I did instead

I treated the 3.2% → 5.8% statement as the stakeholder’s business
hypothesis, rather than forcing the historical data to confirm it.

The more useful conclusion was:

Portfolio-level default trends can look stable or declining while
individual segments still show substantially higher observed default
rates.

That changed the direction of the analysis from “prove default rates
are increasing” to “identify where observed risk is concentrated.”

💡 Business Recommendations

1. Review larger loan applications more carefully

Large loans showed higher observed default rates.

Because the sample is small, this should be validated with a larger and
more recent portfolio before changing lending policy.

2. Pay closer attention to newer accounts

Newer accounts showed higher observed default rates.

The bank could investigate whether limited account history should lead
to additional verification or monitoring.

3. Explore pre-loan balance as a potential early-warning signal

Lower pre-loan balances were associated with accounts that later
defaulted.

This could be investigated further in a future risk-monitoring
framework.

4. Investigate lower financial activity

The analysis did not support the initial assumption that future
defaulters simply withdrew more money.

Instead, they showed lower outgoing activity and lower balances.

This combination deserves further investigation.

5. Investigate high-risk districts with sufficient volume

District differences should be reviewed alongside:

loan volume

economic conditions

customer mix

branch-level lending practices

6. Do not overemphasize age or gender

Neither age nor gender showed strong or consistent differences in
observed default rates in this analysis.

7. Validate the findings on newer data

The dataset is historical. Before applying any finding operationally, it
should be tested on a larger and more recent portfolio.

🛠️ DAX & Power BI Logic

I created measures and calculated columns including:

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

📁 View DAX Measures & Calculated
Columns

🧠 Responsible Use of AI

AI was used as a learning, business-simulation and review tool, not
as a replacement for my analytical work.

Claude helped me with:

Simulating a realistic finance stakeholder

Creating the initial business problem

Explaining the dataset and business meaning of columns

Challenging my assumptions

Reviewing analytical reasoning

Explaining technical concepts

I personally performed and owned:

SQL writing and debugging

Data validation

Analytical decisions

Power BI data modelling

DAX measures

Calculated columns

Dashboard design

Interpretation of findings

Business recommendations

My goal was to use AI to learn faster, simulate a real workplace
environment and improve my reasoning — not to outsource the project.

The exact prompts I used are included above so the AI-assisted workflow
is transparent.

📁 Project Structure

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

🔧 Tools Used

Tool

Purpose

MySQL

SQL investigation and analysis

Power BI

Data modelling, interactive analysis and dashboard

DAX

Measures and calculated columns

Power Query

Data cleaning and transformation

Python / pandas

Large transaction-data export

GitHub

Version control and project documentation

Claude

Stakeholder simulation, learning and analytical review

📚 Project Resources

📊 Power BI Dashboard

🖼️ Dashboard Screenshots

🧮 DAX Measures & Columns

🗃️ SQL Analysis

🧱 Data Model / Schema

📖 Business Problem
Brief

📘 Data Dictionary

🚧 Large Data Export Notes

🌐 Original Dataset — CTU Relational Learning
Repository

⚠️ Limitations

This project should be interpreted as a historical analytical study,
not as a production credit-risk model.

Key limitations include:

Historical data from 1993–1998

Small samples in some segments

Right-censoring in the latest period

Observational analysis rather than causal analysis

No current customer or economic information

Some segment differences require validation on larger samples

The findings should not automatically become lending or collections
rules

The results are analytical signals and hypotheses for further
investigation — not automatic credit decisions.

🎓 What I Learned

This project taught me much more than SQL syntax or Power BI formatting.

I learned how to:

Start with a business question, not a chart.

Understand a relational dataset before analysing it.

Think carefully about grain and joins.

Avoid duplicate records caused by relationship tables.

Work with 1M+ transaction records.

Build SQL views specifically for analytical reporting.

Connect SQL investigation to a Power BI data model.

Use DAX for business measures and categories.

Question stakeholder assumptions instead of blindly confirming them.

Distinguish association from causation.

Communicate limitations honestly.

⭐ Final takeaway

Good data analysis is not about proving what someone expects to be
true. It is about investigating the evidence, communicating what the
data does and does not show, and turning reliable findings into useful
business actions.
