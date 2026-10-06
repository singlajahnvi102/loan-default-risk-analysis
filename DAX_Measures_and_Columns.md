# DAX Measures and Calculated Columns

This file documents the DAX logic used in the Power BI dashboard for the Loan Default Risk Analysis project.

## DAX Measures

### Total Loans
```DAX
Total Loans =
COUNT('berka_financial loan'[loan_id])
```

### Total Defaulted Loans
```DAX
Total Defaulted Loans =
CALCULATE(
    COUNT('berka_financial loan'[loan_id]),
    'berka_financial loan'[is_default] = 1
)
```

### Default Rate
```DAX
Default Rate =
DIVIDE(
    [Total Defaulted Loans],
    [Total Loans]
)
```

### Default Rate (Minimum 8 Loans)
```DAX
Default Rate (Minimum 8 Loans) =
IF(
    COUNT('berka_financial loan'[loan_id]) >= 8,
    [Default Rate],
    BLANK()
)
```

### Average Pre-Loan Balance
```DAX
Average Pre-Loan Balance =
AVERAGE(
    vw_pre_loan_transactions[balance]
)
```

### Avg Pre-Loan Outgoing Transactions
```DAX
Avg Pre-Loan Outgoing Transactions =
AVERAGE(
    vw_pre_loan_outgoing_activity[outgoing_transaction_count]
)
```

### Avg Pre-Loan Outgoing Amount
```DAX
Avg Pre-Loan Outgoing Amount =
AVERAGE(
    vw_pre_loan_outgoing_activity[outgoing_transaction_amount]
)
```

---

# Calculated Columns

## Default Status
```DAX
Default Status =
IF(
    'berka_financial loan'[is_default] = 1,
    "Defaulted",
    "Non-Defaulted"
)
```

**Purpose:** Converts the numeric default flag into a readable category for dashboard visuals.

## Client Age Group
```DAX
Client Age Group =
SWITCH(
    TRUE(),
    [Client Age] >= 18 && [Client Age] <= 33, "Young",
    [Client Age] >= 34 && [Client Age] <= 49, "Middle",
    [Client Age] >= 50, "Older",
    "Other"
)
```

**Purpose:** Groups clients into adult age bands for default-rate analysis. Records outside the 18+ analysis range are classified as Other.

## Loan Amount Band
Loan amounts are grouped into:
- Small: below 2 lakh
- Mid: 2–4 lakh
- Big: above 4 lakh

**Purpose:** Enables default-rate comparison across different loan-size segments.

## Duration Category
Loan duration is grouped as:
- Short-Term: 12 and 24 months
- Medium-Term: 36 months
- Long-Term: 48 and 72 months

**Purpose:** Enables default-rate comparison across loan-duration segments.

## Account Age Group
Account age is grouped into:
- 3–9 months
- 10–15 months
- 16–22 months

**Purpose:** Enables comparison of default rates based on how long the account had existed before the loan.
