
# 📊 CFPB Consumer Complaints Dashboard – 18.6M Records, DuckDB + SQL + Tableau

_An interactive Tableau dashboard built on the full CFPB Consumer Complaint Database
(18.6 million complaints), cleaned and aggregated with DuckDB and SQL.._

**🔗 Live dashboard:** [Open on Tableau Public](https://public.tableau.com/views/CFPBConsumerComplaints2011-2026/CFPBComplaintsDashboard)

---

## 📌 Table of Contents
- <a href="#overview">Overview</a>
- <a href="#business-problem">Business Problem</a>
- <a href="#dataset">Dataset</a>
- <a href="#tools--technologies">Tools & Technologies</a>
- <a href="#project-structure">Project Structure</a>
- <a href="#data-cleaning--preparation">Data Cleaning & Preparation</a>
- <a href="#exploratory-data-analysis-eda">Exploratory Data Analysis (EDA)</a>
- <a href="#research-questions--key-findings">Research Questions & Key Findings</a>
- <a href="#dashboard">Dashboard</a>
- <a href="#how-to-run-this-project">How to Run This Project</a>
- <a href="#final-recommendations">Final Recommendations</a>
- <a href="#author--contact">Author & Contact</a>

---
<h2><a class="anchor" id="overview"></a>Overview</h2>

## Overview

An end-to-end data analytics project built on the CFPB Consumer Complaint Database, comprising **18.6 million records** spanning 2011–2026.
The project demonstrates the application of **SQL and DuckDB** for large-scale data processing, data quality checks, standardization, anomaly identification, and aggregation. The processed data is then visualized in **Tableau Public** through an interactive dashboard highlighting complaint trends, product distribution, company performance, response timeliness, and resolution outcomes.
The dashboard transforms millions of records into meaningful, interactive insights, enabling users to investigate consumer complaint trends, compare financial institutions, analyze geographical patterns, and evaluate complaint resolution outcomes.

---
<h2><a class="anchor" id="business-problem"></a>Business Problem</h2>

The CFPB Consumer Complaint Database contains millions of records across multiple financial products, companies, and geographical locations. However, its large volume, inconsistent categories, variations in company names, and unusual complaint spikes make it challenging to derive reliable insights directly from the raw data.
This project aims to address the following business challenges:

- **Complaint Distribution:** Identify which financial products, companies, and states account for the highest complaint volumes.
- **Trend Analysis:** Understand how complaint volumes change over time and identify unusual spikes or anomalies.
- **Data Segmentation:** Analyze credit reporting separately from other financial products to avoid skewed comparisons.
- **Company Response Analysis:** Compare financial institutions based on complaint volumes, timely response rates, and resolution outcomes.
- **Resolution Analysis:** Evaluate how complaints are addressed, including monetary relief, non-monetary relief, and explanations.
- **Geographical Analysis:** Identify states with the highest complaint volumes and explore regional patterns.

---
<h2><a class="anchor" id="dataset"></a>Dataset</h2>

- Source: [CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/) (publicly available)
- 18,590,360 complaints, 2011 to 2026 (2011 and 2026 are partial years)
- Key fields: date received, product, issue, company, state, company response, timely response
- The raw CSV and the DuckDB database are not in this repo because of their size

---
<h2><a class="anchor" id="tools--technologies"></a>Tools & Technologies</h2>

- **DuckDB:** Large-scale data querying and processing of 18.6M records.
- **SQL:** Data cleaning, transformation, standardization, anomaly flagging, deduplication, and aggregation.
- **Tableau Public:** Interactive dashboard development using calculated fields, table calculations, Level of Detail (LOD) expressions, parameters, and filters.
- **Git & GitHub:** Version control, project documentation, and repository management.

---
<h2><a class="anchor" id="project-structure"></a>Project Structure</h2>

```
cfpb-complaints-dashboard/
│
├── README.md
│
├── CFPBConsumerComplaints2011-2026.twbx
│
├── SQL/
│   ├── 01_build_clean_table.sql
│   ├── 02_flag_jan2025_burst.sql
│   ├── 03_company_name_dedupe.sql
│   └── 04_export_dashboard_cube.sql
│
└── images/
    ├── dashboard.png
    ├── dashboard_2.png
    └── dashboard_3.png
```

---
    
---
<h2><a class="anchor" id="data-cleaning--preparation"></a>Data Cleaning & Preparation</h2>

Processed 18.6M CFPB complaint records using DuckDB and SQL, involving:
Data type conversion, product category standardization, and state grouping.
Identification and flagging of the January 2025 complaint spike while retaining original records.
Company name standardization to ensure consistent reporting.
Aggregation into a dashboard-ready dataset of approximately 796K records.
Data validation through record count reconciliation and duplicate ID checks.
All 18,590,360 source records were retained throughout the pipeline.

---
<h2><a class="anchor" id="exploratory-data-analysis-eda"></a>Exploratory Data Analysis (EDA)</h2>

**Product Distribution**: Credit reporting accounts for 82.1% of total complaints, increasing from 3% in 2012 to 91% in 2026 (partial year).
**Complaint Trends**: September 2026 recorded the highest monthly complaint volume, with 678,922 complaints.
**Anomaly Analysis**: January 2025 recorded 109,916 non-credit-reporting complaints, reducing to approximately 49,800 after excluding the flagged complaint burst.
**Company Analysis**: Identified variations in complaint volumes, timely response rates, and resolution outcomes across financial institutions.
**Geographical Analysis**: Texas, Florida, and California recorded the highest complaint volumes.

---
<h2><a class="anchor" id="research-questions--key-findings"></a>Research Questions & Key Findings</h2>

1. **Where Complaints Concentrate**: Credit reporting is 82.1% of 18,590,360 complaints, so it gets its own charts
2. **Which Companies Receive the Most Complaints**: The three credit bureaus lead; TransUnion has about 5.15M complaints (relief rate 58.7%), Equifax 47.4%, Experian 13.3%
3. **Are Complaint Spikes Part of a Larger Trend**: Credit reporting climbs steadily; January 2025 shows a burst of about 60K complaints in two weeks, concentrated at Block, Early Warning, Navy Federal, Capital One, and JPMorgan Chase (the cause is not in the data)
4. **Are Companies Responding to Complaints**: 99.4% of complaints received a timely response, while 96.6% were recorded as closed.
5. **How Are Complaints Resolved?**:
   - Credit reporting: about 60.2% closed with explanation, 39.7% with non-monetary relief
   - Other products: about 79.1% with explanation, 12.3% non-monetary relief, 6.5% monetary relief
6. **Which States Report the Most Complaints**: Texas (2.58M), Florida (2.55M), California (1.83M), Georgia (1.37M), New York (1.07M); raw counts, not per capita

---
<h2><a class="anchor" id="dashboard"></a>Dashboard</h2>

- Dashboard Features:
  - KPIs: Total complaints, credit reporting share, timely response rate, and busiest month.
  - Complaint Trends: Monthly trends for credit reporting and other financial products, with a toggle to exclude the January 2025 complaint burst.
  - Product Analysis: Year-wise credit reporting share and complaint distribution across products.
  - Company Analysis: Top 12 companies ranked by complaint volume, with relief and timely response rates.
  - Resolution Analysis: Breakdown of complaint resolution outcomes and geographical distribution through an interactive state map.
- Filters: Year, Product, Company, State, Hide burst
- Caveats: 2011 and 2026 are partial years, the latest month is undercounted, counts are not per capita, and relief rate is not a company quality score

<img width="1572" height="675" alt="Dashboard_image_1" src="https://github.com/user-attachments/assets/a9f29a38-af7f-437e-bc61-0721111b4179" />
<img width="1572" height="815" alt="Dashboard_image_2" src="https://github.com/user-attachments/assets/2fa14a49-28da-41a6-8dfa-335751dc04ed" />
<img width="1577" height="607" alt="Dashboard_image_3" src="https://github.com/user-attachments/assets/143a2548-6cdd-4113-a394-be3bcbf38aa8" />


🔗 [View the live dashboard](https://public.tableau.com/views/CFPBConsumerComplaints2011-2026/CFPBComplaintsDashboard)

---
<h2><a class="anchor" id="how-to-run-this-project"></a>How to Run This Project</h2>

1. Clone the repository:
```bash
git clone https://github.com/Sruthi-M-Suresh/cfpb-complaints-dashboard.git
```
2. Download the full CSV from the [CFPB database](https://www.consumerfinance.gov/data-research/consumer-complaints/) and save it as `complaints.csv` in the project folder
3. Start DuckDB in that folder:
```bash
duckdb complaints.duckdb
```
4. Run the SQL scripts in order:
```sql
.read sql/01_build_clean_table.sql
.read sql/02_flag_jan2025_burst.sql
.read sql/03_company_name_dedupe.sql
.read sql/04_export_dashboard_cube.sql
```
5. Open Tableau and connect to the exported `dash_cube.csv`, or open `CFPBConsumerComplaints2011-2026.twbx`

---
<h2><a class="anchor" id="final-recommendations"></a>Final Recommendations</h2>

- Analyze credit reporting separately from other financial products to avoid skewed comparisons.
- Investigate the January 2025 complaint spike further, as its underlying cause remains unknown.
- Interpret relief rates alongside complaint volumes and timely response rates rather than as standalone performance indicators.
- Use population or customer-base normalization for fairer geographical and company comparisons.
- Explore issue and sub-issue categories to understand the specific problems reported by consumers.
---
<h2><a class="anchor" id="author--contact"></a>Author & Contact</h2>

**Sruthi Suresh**  
SQL | DuckDB | Tableau 
📧 Email: thesruthisuresh@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/sruthi-suresh-724b231ba/)
🔗 [GitHub](https://github.com/Sruthi-M-Suresh)
