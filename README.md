# E-Commerce Sales & Customer Analytics Dashboard

An end-to-end data analytics project analyzing over 500,000 transactions across 38 global markets. The transactional data was audited in PostgreSQL, then modeled and visualized in Power BI to analyze revenue streams, customer retention, and purchasing patterns.

---

## Dashboard Overview

![E-Commerce Sales & Customer Analytics Dashboard](dashboard/dashboard_final.png)

---

## Executive Summary & Key Metrics

| Metric | Power BI Dashboard | PostgreSQL Audit | Status |
| :--- | :--- | :--- | :--- |
| **Total Revenue** | £10.67M | £10.67M | Verified |
| **Total Orders** | 19.96K | 19.96K | Verified |
| **Total Customers** | 4,338 | 4,338 | Verified |
| **Active Countries** | 38 | 38 | Verified |

---

## Key Business Insights

1. **Geographic Concentration:** Over 85% of total sales originate from the United Kingdom, followed by secondary European markets including the Netherlands and EIRE (Ireland).
2. **Q4 Demand Spike:** Monthly orders surge significantly in the fourth quarter, peaking in November (rising from ~1,500 monthly orders to over 2,700), highlighting substantial holiday demand.
3. **High-Value B2B Accounts:** A core group of wholesale customers (led by Customer ID 14646 and 18102) generated upwards of £200,000+ each, demonstrating a distinct high-volume B2B cohort.
4. **Merchandise vs. Service Fees:** Non-inventory service entries such as `DOTCOM POSTAGE` and manual adjustments were isolated to prevent distortion of actual physical product demand.

---

## Project Structure

```text
ecommerce-sales-analytics/
├── data/
│   └── (raw transactional dataset)
├── sql/
│   └── audit_queries.sql
├── dashboard/
│   ├── ecommerce_analytics.pbix
│   └── dashboard_final.png
└── README.md