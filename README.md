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

1.***Which loan and borrower segments have higher observed default
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

## 📁 Dataset

This project uses the **Berka Financial Dataset (1993–1998)** from the **CTU Relational Learning Repository**.

The dataset contains banking information across tables including:

- `loan`
- `account`
- `client`
- `district`
- `disp`
- `card`
- `trans`
- `order`

🌐 **[Original Dataset — CTU Relational Learning Repository](https://relational.fel.cvut.cz/dataset/Financial)**


## ⚠️ Loan Default Definition

The original dataset uses four loan status categories: **A, B, C and D**.

For this project, I grouped the original statuses into two business categories:

| Original Status | Project Classification |
|---|---|
| `A` | **Non-default** |
| `C` | **Non-default** |
| `B` | **Default** |
| `D` | **Default** |

Therefore:

**Defaulted = B + D**

**Non-defaulted = A + C**

This classification was used consistently throughout the SQL analysis and Power BI dashboard.

### Important Dataset Note

The dataset documentation also discusses a **minimum transaction balance rule** that can perfectly separate some loan outcomes.

I did **not use minimum transaction balance to define default/non-default**, and I did not build a machine-learning prediction model around it.

This project is a **historical descriptive analysis, not a predictive credit-scoring model**.


## 🚧 Major Technical Challenge — 1M+ Transactions

One of the most challenging parts of this project was the `trans` table, which contains approximately **1.06 million transaction records**.

### Brief Export Approaches

I initially explored several ways to export the large transaction table:

- ❌ **MySQL Workbench Export**  
  The export was extremely slow and unreliable for the full dataset.

- ❌ **`INTO OUTFILE`**  
  The public database environment did not provide the required file-write permissions.

- ❌ **One Large Python Query**  
  The connection was lost while trying to retrieve the full dataset in one request.

- ✅ **Final Solution — Batched Python Export**  
  I exported the transaction data in smaller batches instead of requesting the entire table at once.

This approach successfully exported approximately **1.06 million transaction records**.

### What I Learned

Real-world data analysis is not only about writing the correct SQL.

**Data volume, permissions, connection stability and the data-access environment also matter.**


## 🧹 Data Understanding & Validation

Before starting the analysis, I worked through the **relationships between the main banking tables** and validated how the tables should be joined.

### Important Issues I Identified

- `disp` can contain both **OWNER and DISPONENT** relationships, so careless joins can duplicate loan records.

- Client age was calculated at the **loan issue date**, rather than treating age as a permanent customer attribute.

- Ages outside the intended adult analysis range were handled separately.

- Districts with very small loan volumes were treated cautiously to avoid over-interpreting unstable default rates.

- The **1998 decline** was interpreted carefully because of **right-censoring**.

- Pre-loan behavioural analysis used transactions occurring **before the loan issue date**.
- 
## 🔎 SQL Investigation

I used **MySQL as the main investigation layer**.

The SQL analysis was designed around the stakeholder's business questions rather than simply exploring the dataset without a defined objective.

| **Analysis Area** | Business Question |
|---|---|
| **Overall default** | What is the overall portfolio default rate? |
| **District** | Which districts show higher observed default rates? |
| **Economic conditions** | Do unemployment and salary vary with district default rates? |
| **Loan duration** | Are short-, medium- or long-term loans riskier? |
| **Loan amount** | Does loan size relate to default rate? |
| **Amount + duration** | Which loan-size/duration combinations show higher observed risk? |
| **Pre-loan balance** | Did future defaulters have lower balances before borrowing? |
| **Outgoing activity** | Did future defaulters show different activity before loan issuance? |
| **Account age** | Are newer accounts riskier? |
| **Client age** | Does age show a meaningful default pattern? |
| **Gender** | Is there a meaningful difference? |
| **Card status** | Does card ownership correlate with default rate? |
| **Time trends** | Did default rates change over the historical period? |

📁 **[Open the SQL Files](Sql_Files/)**


## 🧩 Why I Created SQL Views

A major part of the project was connecting the **SQL investigation to the Power BI dashboard**.

Instead of importing raw transaction-level data directly into Power BI for every behavioural analysis, I created **dedicated SQL views** for the specific business questions that required transaction-level calculations.

This gave me a **cleaner and more controlled analytical layer** between the raw database and Power BI.


### `vw_pre_loan_transactions`

This view connects each loan with transactions that occurred **before the loan issue date**.

### Why?

I wanted to answer the stakeholder-style question:

**Did accounts that later default have lower balances before taking the loan?**

The view supports the Power BI calculation:

**Average Pre-Loan Balance**


### `vw_pre_loan_outgoing_activity`

This view summarises **outgoing transaction activity before loan issuance at the loan level**.

### Why?

I wanted to test the stakeholder-style question:

**Did future defaulters show more outgoing activity before the loan went bad?**

The SQL analysis actually showed the **opposite — future defaulters had lower outgoing activity**.

The view supports:

- **Average Pre-Loan Outgoing Transactions**
- **Average Total Pre-Loan Outgoing Amount**


### Why This Approach Was Useful

The SQL views created a clear bridge between:

**Raw transaction data → Business-level metrics → Power BI visuals**

They also ensured that the Power BI calculations were based on the **correct pre-loan time window**, rather than mixing pre-loan and post-loan activity.

📁 **[Open SQL Views and Analysis](Sql_Files/)**


## 📊 Power BI Dashboard

I used Power BI as the presentation and interactive analysis layer.

The dashboard is divided into two pages, because each page answers a different part of the business problem.


### 📄 Page 1 — Default Risk Overview

#### Purpose

The first page answers:

**Where is observed default risk concentrated across the loan portfolio?**

It contains:

- Total Loans
- Total Defaulted Loans
- Overall Default Rate
- Default Rate by District
- Default Rate by Year
- Default Rate by Account Age
- Default Rate by Loan Amount + Duration


### 🖼️ Dashboard Preview

<figure>
<img
src="https://raw.githubusercontent.com/singlajahnvi102/loan-default-risk-analysis/main/Dashboard_Pages/Overview.png"
alt="Default Risk Overview" />
<figcaption aria-hidden="true">Default Risk Overview</figcaption>
</figure>

🔗 **Open Page 1 — Overview.png**


### 📄 Page 2 — Early Warning Signals

#### Purpose

The second page focuses on:

**What borrower/account characteristics and pre-loan behaviours were associated with future defaults?**

It contains:

- Average Pre-Loan Balance
- Pre-Loan Outgoing Activity
- Client Age Group
- Card Status


### 🖼️ Dashboard Preview

<figure>
<img
src="https://raw.githubusercontent.com/singlajahnvi102/loan-default-risk-analysis/main/Dashboard_Pages/Earning_Warning_signal.png"
alt="Early Warning Signals" />
<figcaption aria-hidden="true">Early Warning Signals</figcaption>
</figure>

🔗 **Open Page 2 — Earning_Warning_signal.png**

> **Note:** The file name above follows the exact name currently used in the GitHub repository.

## 💡 Key Findings

### 1️⃣ Loan Amount Showed the Strongest Observed Difference

| Loan Amount Band | Loans | Default Rate |
|---|---:|---:|
| Small | 497 | 8.25% |
| Mid | 159 | 17.61% |
| Big | 26 | 26.92% |

There was a clear increase in observed default rate as loan size increased.

However, the Big-loan group contains only 26 loans, so this should be validated on a larger and more recent portfolio before changing lending policy.


### 2️⃣ Future Defaulters Had Lower Pre-Loan Balances

| Default Status | Average Pre-Loan Balance |
|---|---:|
| Non-defaulted | 45.2K |
| Defaulted | 38.6K |

Accounts that later defaulted showed lower balances before the loan was issued.

This may indicate lower financial buffers, but it is an association and not proof that lower balances cause default.


### 3️⃣ Future Defaulters Showed Lower Outgoing Activity

My initial expectation was that customers who later defaulted might show higher outgoing or withdrawal activity before taking the loan.

The data showed the opposite.

| Metric | Non-Defaulted | Defaulted |
|---|---:|---:|
| Average outgoing transactions | 46.96 | 37.45 |
| Average total outgoing amount | 318.4K | 289.8K |

This was an important analytical lesson:

The data did not support my initial assumption.

Future defaulters showed lower outgoing transaction activity and lower total outgoing amounts before loan issuance.


### 4️⃣ Newer Accounts Showed Higher Observed Default Rates

| Account Age | Default Rate |
|---|---:|
| 3–9 months | 13.62% |
| 10–15 months | 11.29% |
| 16–22 months | 8.60% |

Newer accounts showed higher observed default rates than older accounts.

This suggests that limited account history may deserve further investigation.


### 5️⃣ Card Ownership Showed a Strong Association

| Card Status | Default Rate |
|---|---:|
| Without Card | 13.87% |
| With Card | 2.94% |

Accounts without a card had a much higher observed default rate.

I did not conclude that having a card causes lower default risk.

A more cautious interpretation is that card ownership may reflect an existing or more established banking relationship or other characteristics associated with lower risk.


### 6️⃣ District Risk Was Uneven

Several districts showed substantially higher historical default rates, including:

- Opava
- Kutna Hora
- Chrudim

Because some districts had small loan counts, I used a minimum-volume threshold when highlighting district-level risk.

This reduces the chance of overreacting to a very small number of loans.


### 7️⃣ Client Age Showed Little Difference

The valid adult age groups were broadly similar:

- Young: ~11.7%
- Middle: ~10.9%
- Older: ~11.5%

The differences were small relative to the overall portfolio.

Therefore, age was not treated as a major risk driver in the final dashboard.


### 8️⃣ Gender Showed No Meaningful Difference

Gender was investigated but did not show a meaningful difference in observed default rates.

Therefore, I removed gender from the main dashboard story rather than adding a visual that did not provide a useful business insight.

The SQL analysis is still documented in the repository.


## 🎯 Stakeholder Hypothesis vs. Analysis

This is one of the most important parts of the project.

The stakeholder reported that the NPA/default rate had increased from 3.2% to 5.8% over 18 months.

The dataset did not reproduce a sustained increase.

Instead, the analysis showed that:

- Portfolio-level default trends can look stable or declining while individual segments still show substantially higher observed default rates.
- Risk concentration can exist even when the overall portfolio trend does not show the expected increase.

### Why This Matters

A Data Analyst should not change the analysis simply because the stakeholder expects a particular result.

My approach was:

**Hypothesis → Test → Validate → Communicate the actual evidence**

This is why the project ultimately focused more on risk concentration and borrower/account characteristics than on proving an overall upward trend.

## 💡 Business Recommendations

Based on the analysis, I would recommend that the risk/collections team:

### 1. Review larger loan applications more carefully

Large loans showed the highest observed default rate, although the sample is small.

This should be validated on a larger portfolio before changing lending policy.

### 2. Pay closer attention to newer accounts

Newer accounts showed higher observed default rates.

The bank could investigate whether limited account history should lead to additional verification or monitoring.

### 3. Explore pre-loan balance as a potential early-warning signal

Future defaulters showed lower pre-loan balances.

This could be investigated further as part of a future risk-monitoring framework.

### 4. Investigate lower financial activity

The data did not support the initial assumption that future defaulters simply withdrew more money.

Instead, they showed lower outgoing activity and lower balances.

This combination deserves further investigation.

### 5. Review high-risk districts carefully

District-level differences should be reviewed alongside:

- Loan volume
- Economic conditions
- Customer mix
- Branch-level lending practices

### 6. Avoid overemphasizing age and gender

Neither age nor gender showed strong or consistent differences in observed default rates.

### 7. Validate findings on newer data

The dataset is historical.

Before applying any finding operationally, the patterns should be tested on larger, newer and more representative portfolio data.


## 📊 Power BI & DAX

Power BI was used for interactive analysis, modelling and business communication.

I created DAX measures and calculated columns including:

- Total Loans
- Total Defaulted Loans
- Default Rate
- Average Pre-Loan Balance
- Average Pre-Loan Outgoing Transactions
- Average Pre-Loan Outgoing Amount
- Default Rate with Minimum Loan-Volume Threshold
- Default Status
- Client Age
- Client Age Band
- Loan Amount Band
- Loan Duration Category
- Account Age Group


## 🗂️ Data Model / Schema

The project uses the loan table as the central loan-level analytical table, with related account, client, district, card and transaction information.

The model was designed so that:

- Loan-level analysis remains at the correct grain
- Transaction-level information is used only where appropriate
- OWNER relationships are handled carefully
- Pre-loan SQL views connect back to the relevant loan
- Power BI measures can analyse the data without unnecessarily duplicating loan records

## ⚠️ Limitations

This project should be interpreted as a historical analytical study, not as a production credit-risk model.

Important limitations include:

- Historical data from 1993–1998
- Small sample sizes for some segments
- Right-censoring in the later years
- Some district-level differences may be influenced by loan volume
- Observed relationships do not prove causation
- Findings should be validated on newer and larger portfolio data

The stakeholder's reported increase in NPA rate was treated as the business context and hypothesis. The historical dataset did not independently reproduce that exact trend, so I did not force the analysis to support the original assumption.

The findings should therefore be used for further investigation rather than immediate changes to lending or collections policy.


## 🤖 Responsible Use of AI

AI was used as a learning, business-simulation and review tool, not as a replacement for my analytical work.

Claude helped me with:

- Simulating a realistic finance stakeholder
- Creating the initial business problem
- Explaining the business context
- Reviewing my approach
- Challenging assumptions and interpretations
- Helping me understand unfamiliar concepts

My own work included:

- SQL writing and debugging
- Data validation
- Analytical decisions
- Power BI data modelling
- DAX measures
- Calculated columns
- Dashboard design
- Interpretation of findings
- Business recommendations

I used AI to learn faster, simulate a real workplace environment and improve my reasoning — not to outsource the project.

The exact prompts used during the project are included in this README so that the workflow is transparent and reproducible.


## 🎯 Final Takeaway

This project helped me understand how a data analyst can move from a business problem to data investigation, SQL analysis, Power BI modelling, dashboard development and business recommendations.

The most important lesson was that analysis should follow the data rather than trying to prove the stakeholder's initial assumption.

Where the data showed a pattern, I investigated it. Where it did not, I reported that honestly and identified what would need to be validated with better or newer data.



