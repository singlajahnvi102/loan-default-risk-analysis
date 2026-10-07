🎯 How I Started the Project

I wanted to build this as a realistic Data Analyst assignment,
rather than simply download a dataset and create a dashboard.

I therefore used Claude as a simulated client and data expert.

The workflow was:

***Stakeholder Problem → Data Understanding → SQL Investigation →
Validation → SQL Views → Power BI Model → DAX → Dashboard → Business
Recommendations***

## 🤝 AI-Assisted Project Setup

### 1. Claude as My Client

I first asked **Claude to act as a finance-industry stakeholder**.

**Exact prompt I used**

> “Act as a client from the finance industry . I am a data analyst.
Bring me one realistic business problem your company is facing that I
could solve using data analysis. Explain the problem the way a real
stakeholder would. Then let me ask you questions about it.
>
> `I am thinking about making a project using SQL, Power BI. So, suggest
accordingly. Also give me a dataset from the internet (with link to
it) that can be related to this problem, and I can start working on
your needs.”

Claude then acted as **Rohan, VP of Collections & Risk**, and gave me
the **business problem, stakeholder expectations and analytical questions**.
**[View the Business Problem & Analytical Questions](Documentation/Loan_Default_Analysis_Brief.pdf)**

### 2. Claude as My Data Expert

After receiving the **business problem**, I gave Claude this second prompt:

> “Paste your column names or attach the files.
>
>You are the data expert from the company. Now explain each column in
business terms, flag anything unusual. Whatever I need to know before
I start working.”

This helped me understand the **business meaning of the tables and
columns, relationships between tables, and potential data-quality
issues** before beginning the analysis.
📘 **[View the Data Dictionary](Documentation/Data_Dictionary_Business_Terms.pdf)**

## 🎯 Business Problem

The project was framed around this stakeholder situation:

“Our NPA (default) rate has risen from 3.2% to 5.8% over 18 months.
I need to know which borrower and account segments are driving this,
so my credit team can recalibrate their scorecard and my collections
team can flag at-risk accounts earlier. I need this backed by data,
not gut feeling — and I want a dashboard my team can check regularly,
not a one-time report.”

### What the stakeholder wanted to know

The analysis was designed to answer:

***Which loan and borrower segments have higher observed default
rates?***

2.**Which districts show higher observed risk?**

3.**Do loan amount and loan duration relate to default rate?**

4.**Do account characteristics and pre-loan behaviour differ between
defaulted and non-defaulted loans?**

5.**Are newer accounts riskier?**

6.**Does card ownership show an association with default rate?**

7.**Do age or gender show a meaningful pattern?**

8.**Has default rate actually increased over time?**

## 🧪 Project Hypothesis

The stakeholder gave me an initial hypothesis:

**“Our NPA (default) rate has risen from 3.2% to 5.8% over 18
months.”**

**This created an important analytical question:** Does the historical data support the stakeholder’s assumption?

Instead of assuming the statement was true, I tested it using the loan
issue date.

**The historical data did not reproduce a sustained increase.**

Observed annual default rates were approximately:

Year

Observed Default Rate

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

The sharp decline in 1998 was treated cautiously because later loans
have less time to become observed defaults (**right-censoring**).

### What this changed in my analysis

I did **not** try to force the dashboard to prove that default risk was
increasing.

Instead, I shifted the investigation toward:

**Where is observed default risk concentrated, and what
borrower/account characteristics are associated with it?**

That became the **central analytical story of the project.**

## 🗂️ Dataset

This project uses the Berka Financial Dataset (1993–1998) from the
CTU Relational Learning Repository.

The dataset contains banking information across tables including:

loan

account

client

district

disp

card

trans

order

🌐 Original Dataset — CTU Relational Learning
Repository

⚠️ Loan Default Definition

The original dataset documentation defines loan outcomes using the
original loan.status values.

For this project:

Original Status

Project Classification

A

Non-default

C

Non-default

B

Default

D

Default

Therefore:

Defaulted = B + D
Non-defaulted = A + C

Important dataset note

The dataset documentation also discusses a minimum transaction
balance rule that can perfectly separate some loan outcomes.

I did not use minimum transaction balance to define
default/non-default, and I did not build a machine-learning prediction
model around it.

This project is a historical descriptive analysis, not a predictive
credit-scoring model.

🚧 Major Technical Challenge — 1 Million+ Transactions

One of the most challenging parts of this project was the trans table,
which contains approximately 1.06 million transaction records.

I tried several approaches:

❌ MySQL Workbench Export

The GUI export was extremely slow and unreliable for the full
dataset.

❌ INTO OUTFILE

The public guest account did not have the required file-write
privileges.

❌ One Large Python Query

The remote server lost the connection while retrieving the full
table in one request.

✅ Final Solution — Batched Python Export

I used Python + pandas and retrieved the data in 20,000-row
batches.

This successfully exported approximately 1.06 million transaction
records.

📄 Read the complete export troubleshooting
notes

What I learned

Real-world data analysis is not only about writing the correct SQL.
Data volume, permissions, connection stability and the data-access
environment also matter.

🧹 Data Understanding & Validation

Before starting the analysis, I worked through the relationships between
the main banking tables.

Important issues I identified

disp can contain both OWNER and DISPONENT relationships, so
careless joins can duplicate loan records.

Client age was calculated at the loan issue date, rather than
treating age as a permanent customer attribute.

Ages outside the intended adult analysis range were handled
separately.

Districts with very small loan volumes were treated cautiously.

The 1998 decline was interpreted carefully because of
right-censoring.

Pre-loan behavioural analysis used transactions occurring before the
loan issue date.

📄 View the Data
Dictionary

🔍 SQL Investigation

I used MySQL as the main investigation layer.

The analysis covered:

Analysis Area

Business Question

Overall default

What is the overall portfolio default rate?

District

Which districts show higher observed default rates?

Economic conditions

Do unemployment and salary vary with district default rates?

Loan duration

Are short-, medium- or long-term loans riskier?

Loan amount

Does loan size relate to default rate?

Amount + duration

Which loan-size/duration combinations show higher observed risk?

Pre-loan balance

Did future defaulters have lower balances before borrowing?

Outgoing activity

Did future defaulters show different activity before loan issuance?

Account age

Are newer accounts riskier?

Client age

Does age show a meaningful default pattern?

Gender

Is there a meaningful difference?

Card status

Does card ownership correlate with default rate?

Time trends

Did default rates change over the historical period?

📁 Open the SQL
Files

🧩 Why I Created SQL Views

A major part of the project was connecting the SQL investigation to
the Power BI dashboard.

Instead of importing raw transaction-level data directly into Power BI
for every analysis, I created dedicated SQL views for the behavioural
analysis.

This gave me a cleaner and more controlled analytical layer.

vw_pre_loan_transactions

This view connects each loan with transactions that occurred before
the loan issue date.

Why?

I wanted to answer:

Did accounts that later default have lower balances before taking
the loan?

The view supports the Power BI calculation:

Average Pre-Loan Balance

vw_pre_loan_outgoing_activity

This view summarises outgoing transaction activity before loan
issuance at the loan level.

Why?

I wanted to test the stakeholder-style question:

Did future defaulters show more outgoing activity before the loan
went bad?

The SQL analysis actually showed the opposite — future defaulters had
lower outgoing activity.

The view supports:

Average Pre-Loan Outgoing Transactions

Average Total Pre-Loan Outgoing Amount

Why this approach was useful

The SQL views created a clear bridge between:

Raw transaction data → business-level metrics → Power BI visuals

They also ensured that the Power BI calculations were based on the
correct pre-loan time window rather than mixing pre-loan and
post-loan activity.

📁 Open SQL Views and
Analysis

📊 Power BI Dashboard

I used Power BI as the presentation and interactive analysis layer.

The dashboard is divided into two pages, because each page answers a
different part of the business problem.

📄 Page 1 — Default Risk Overview

Purpose

The first page answers:

Where is observed default risk concentrated across the loan
portfolio?

It contains:

Total Loans

Total Defaulted Loans

Overall Default Rate

Default Rate by District

Default Rate by Year

Default Rate by Account Age

Default Rate by Loan Amount + Duration

🖼️ Dashboard Preview

<figure>
<img
src="https://raw.githubusercontent.com/singlajahnvi102/loan-default-risk-analysis/main/Dashboard_Pages/Overview.png"
alt="Default Risk Overview" />
<figcaption aria-hidden="true">Default Risk Overview</figcaption>
</figure>

🔗 Open Page 1 —
Overview.png

📄 Page 2 — Early Warning Signals

Purpose

The second page focuses on:

What borrower/account characteristics and pre-loan behaviours were
associated with future defaults?

It contains:

Average Pre-Loan Balance

Pre-Loan Outgoing Activity

Client Age Group

Card Status

🖼️ Dashboard Preview

<figure>
<img
src="https://raw.githubusercontent.com/singlajahnvi102/loan-default-risk-analysis/main/Dashboard_Pages/Earning_Warning_signal.png"
alt="Early Warning Signals" />
<figcaption aria-hidden="true">Early Warning Signals</figcaption>
</figure>

🔗 Open Page 2 —
Earning_Warning_signal.png

Note: The file name above follows the exact name currently used in
the GitHub repository.

📊 Power BI File

Open / download the Power BI PBIX
file

📈 Key Findings

1️⃣ Loan Amount Showed the Strongest Observed Difference

Loan Amount Band

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

There was a clear increase in observed default rate as loan size
increased.

However, the Big-loan group contains only 26 loans, so this should
be validated on a larger and more recent portfolio before changing
lending policy.

2️⃣ Future Defaulters Had Lower Pre-Loan Balances

Default Status

Average Pre-Loan Balance

Non-defaulted

45.2K

Defaulted

38.6K

Accounts that later defaulted showed lower balances before the loan
was issued.

This may indicate lower financial buffers, but it is an association
and not proof that lower balances cause default.

3️⃣ Future Defaulters Showed Lower Outgoing Activity

My initial expectation was that customers who later defaulted might show
higher outgoing or withdrawal activity before taking the loan.

The data showed the opposite.

Metric

Non-Defaulted

Defaulted

Average outgoing transactions

46.96

37.45

Average total outgoing amount

318.4K

289.8K

This was an important analytical lesson:

The data did not support my initial assumption.

Future defaulters showed lower outgoing transaction activity and lower
total outgoing amounts before loan issuance.

4️⃣ Newer Accounts Showed Higher Observed Default Rates

Account Age

Default Rate

3–9 months

13.62%

10–15 months

11.29%

16–22 months

8.60%

Newer accounts showed higher observed default rates than older accounts.

This suggests that limited account history may deserve further
investigation.

5️⃣ Card Ownership Showed a Strong Association

Card Status

Default Rate

Without Card

13.87%

With Card

2.94%

Accounts without a card had a much higher observed default rate.

I did not conclude that having a card causes lower default risk.

A more cautious interpretation is that card ownership may reflect an
existing or more established banking relationship or other
characteristics associated with lower risk.

6️⃣ District Risk Was Uneven

Several districts showed substantially higher historical default rates,
including:

Opava

Kutna Hora

Chrudim

Because some districts had small loan counts, I used a minimum-volume
threshold when highlighting district-level risk.

This reduces the chance of overreacting to a very small number of loans.

7️⃣ Client Age Showed Little Difference

The valid adult age groups were broadly similar:

Young: ~11.7%

Middle: ~10.9%

Older: ~11.5%

The differences were small relative to the overall portfolio.

Therefore, age was not treated as a major risk driver in the final
dashboard.

8️⃣ Gender Showed No Meaningful Difference

Gender was investigated but did not show a meaningful difference in
observed default rates.

Therefore, I removed gender from the main dashboard story rather
than adding a visual that did not provide a useful business insight.

The SQL analysis is still documented in the repository.

⚖️ Stakeholder Hypothesis vs. Analysis

This is one of the most important parts of the project.

Stakeholder’s starting assumption

“Default rate has increased from 3.2% to 5.8%.”

What the historical data showed

The dataset did not reproduce a sustained increase.

Instead, the analysis showed that:

Portfolio-level default trends can look stable or declining while
individual segments still show substantially higher observed default
rates.

Why this matters

A Data Analyst should not change the analysis simply because the
stakeholder expects a particular result.

My approach was:

Hypothesis → Test → Validate → Communicate the actual evidence

This is why the project ultimately focused more on risk concentration
and borrower/account characteristics than on proving an overall upward
trend.

💡 Business Recommendations

Based on the analysis, I would recommend that the risk/collections team:

1. Review larger loan applications more carefully

Large loans showed the highest observed default rate, although the
sample is small.

This should be validated on a larger portfolio before changing lending
policy.

2. Pay closer attention to newer accounts

Newer accounts showed higher observed default rates.

The bank could investigate whether limited account history should lead
to additional verification or monitoring.

3. Explore pre-loan balance as a potential early-warning signal

Future defaulters showed lower pre-loan balances.

This could be investigated further as part of a future risk-monitoring
framework.

4. Investigate lower financial activity

The data did not support the initial assumption that future
defaulters simply withdrew more money.

Instead, they showed lower outgoing activity and lower balances.

This combination deserves further investigation.

5. Review high-risk districts carefully

District-level differences should be reviewed alongside:

loan volume

economic conditions

customer mix

branch-level lending practices

6. Avoid overemphasizing age and gender

Neither age nor gender showed strong or consistent differences in
observed default rates.

7. Validate findings on newer data

The dataset is historical.

Before applying any finding operationally, the patterns should be tested
on larger, newer and more representative portfolio data.

🧮 Power BI & DAX

Power BI was used for interactive analysis, modelling and business
communication.

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

Account Age Group

📁 View DAX Measures & Calculated
Columns

🧱 Data Model / Schema

The project uses the loan table as the central loan-level analytical
table, with related account, client, district, card and transaction
information.

The model was designed so that:

Loan-level analysis remains at the correct grain

Transaction-level information is used only where appropriate

OWNER relationships are handled carefully

Pre-loan SQL views connect back to the relevant loan

Power BI measures can analyse the data without unnecessarily
duplicating loan records

🖼️ View the Data Model /
Schema

🧠 Responsible Use of AI

AI was used as a learning, business-simulation and review tool, not
as a replacement for my analytical work.

Claude helped me with:

Simulating a realistic finance stakeholder

Creating the initial business problem

Explaining the dataset and business meaning of columns

Identifying potential data-quality issues

Challenging my assumptions

Reviewing my analytical reasoning

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

I used AI to learn faster, simulate a real workplace environment and
improve my reasoning — not to outsource the project.

The exact prompts are included in this README so the workflow is
transparent and reproducible.

📁 Project Resources

📊 Dashboard

Power BI PBIX
File

Dashboard —
Overview

Dashboard — Early Warning
Signals

Dashboard Pages
Folder

🧮 Analysis & Technical Files

SQL
Files

DAX Measures &
Columns

Data Model /
Schema

📚 Documentation

Business Problem
Brief

Data Dictionary — Business
Terms

Documentation
Folder

🌐 Dataset

Original Berka Financial Dataset —
CTU

⚠️ Limitations

This project should be interpreted as a historical analytical study,
not as a production credit-risk model.

Important limitations include:

Historical data from 1993–1998

Small samples in some segments

Right-censoring in the latest period

Observational analysis rather than causal analysis

No current customer or economic information

Some segment differences require validation on larger samples

The findings should not automatically become lending or collections
rules

These findings are analytical signals and hypotheses for further
investigation — not automatic credit decisions.

🎓 What I Learned

This project taught me much more than SQL syntax or Power BI formatting.

I learned how to:

Start with a business question, not a chart

Understand a relational dataset before analysing it

Think carefully about table grain and joins

Avoid duplicate records caused by relationship tables

Work with 1M+ transaction records

Build SQL views for a specific analytical purpose

Connect SQL investigation to a Power BI model

Use DAX for business measures and categories

Question stakeholder assumptions

Distinguish association from causation

Communicate limitations honestly

Turn analytical findings into business recommendations

⭐ Final Takeaway

Good data analysis is not about proving what someone expects to be
true. It is about investigating the evidence, communicating what the
data does and does not show, and turning reliable findings into useful
business actions.
