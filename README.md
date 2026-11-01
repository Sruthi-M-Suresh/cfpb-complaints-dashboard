
# 📊 CFPB Consumer Complaints Dashboard – 18.6M Records, DuckDB + SQL + Tableau

_Cleaning and analyzing 18.6 million consumer complaints to show where they come from, who they are about, and how they are resolved, using DuckDB, SQL, and Tableau._

**🔗 Live dashboard:** [Open on Tableau Public](https://public.tableau.com/views/CFPBConsumerComplaints2011-2026/CFPBComplaintsDashboard)

![CFPB Consumer Complaints Dashboard](images/dashboard.png)

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

This project turns the full CFPB Consumer Complaint Database (18,590,360 complaints, 2011 to 2026) into an interactive dashboard. A complete pipeline was built using DuckDB and SQL for cleaning and aggregation, and Tableau for visualization. One aggregated table of about 796K rows feeds every chart, so each filter drives the whole dashboard.

---
<h2><a class="anchor" id="business-problem"></a>Business Problem</h2>

The raw file is too large and uneven to read directly. This project aims to:
- Show where complaints are concentrated by product, company, and state
- Separate credit reporting from every other product, since one product dominates the data
- Tell real trends apart from one-off events such as the January 2025 burst
- Place each company's complaint volume next to its timely-response and relief rates
- Check whether complaints are answered on time and closed

---
<h2><a class="anchor" id="dataset"></a>Dataset</h2>

- Source: [CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/) (publicly available)
- 18,590,360 complaints, 2011 to 2026 (2011 and 2026 are partial years)
- Key fields: date received, product, issue, company, state, company response, timely response
- The raw CSV and the DuckDB database are not in this repo because of their size

---
<h2><a class="anchor" id="tools--technologies"></a>Tools & Technologies</h2>

- DuckDB (querying 18.6M rows locally)
- SQL (cleaning, categorizing, flagging, deduplicating, aggregating)
- Tableau Public (calculated fields, table calculations, LOD expressions, parameters)
- GitHub

---
<h2><a class="anchor" id="project-structure"></a>Project Structure</h2>

```
cfpb-complaints-dashboard/
│
├── README.md
├── .gitignore
├── CFPBConsumerComplaints2011-2026.twbx   # Tableau packaged workbook
│
├── sql/                                   # DuckDB SQL pipeline (run in order)
│   ├── 01_build_clean_table.sql
│   ├── 02_flag_jan2025_burst.sql
│   ├── 03_company_name_dedupe.sql
│   └── 04_export_dashboard_cube.sql
│
├── docs/                                  # Cleaning log and checks
│   └── cleaning_and_analysis_notes.txt
│
├── images/                                # Dashboard screenshot
│   └── dashboard.png
```

---
<h2><a class="anchor" id="data-cleaning--preparation"></a>Data Cleaning & Preparation</h2>

- Built a clean table with converted data types, merged product categories (the CFPB renamed them over time), grouped states, and added flags
- Flagged the January 2025 burst (14 to 31 January) instead of deleting it, so the dashboard can show trends with and without it
- Standardized company names by mapping spelling variants to the most frequent spelling
- Exported one summary table (about 796K rows) by month, product, company, state, and outcome
- Checks: all 18,590,360 rows kept with no duplicate IDs, and the exported table sums to the same total

---
<h2><a class="anchor" id="exploratory-data-analysis-eda"></a>Exploratory Data Analysis (EDA)</h2>

**One Product Dominates:**
- Credit reporting is 82.1% of all complaints
- Its share grew from 3% (2012) to 91% (2026, partial year)

**Volume and Outliers:**
- Busiest full month: September 2026 (678,922 complaints)
- January 2025 (non-credit-reporting): 109,916 complaints, dropping to about 49,800 once the burst rows are excluded

**Data Quality Issues Found:**
- Company names appeared with different spellings
- Product categories changed over time

---
<h2><a class="anchor" id="research-questions--key-findings"></a>Research Questions & Key Findings</h2>

1. **Where Complaints Concentrate**: Credit reporting is 82.1% of 18,590,360 complaints, so it gets its own charts
2. **Top Companies**: The three credit bureaus lead; TransUnion has about 5.15M complaints (relief rate 58.7%), Equifax 47.4%, Experian 13.3%
3. **Real Trend or One-off?**: Credit reporting climbs steadily; January 2025 shows a burst of about 60K complaints in two weeks, concentrated at Block, Early Warning, Navy Federal, Capital One, and JPMorgan Chase (the cause is not in the data)
4. **Timely and Closed**: 99.4% get a timely response, 96.6% are closed
5. **How They Close**:
   - Credit reporting: about 60.2% closed with explanation, 39.7% with non-monetary relief
   - Other products: about 79.1% with explanation, 12.3% non-monetary relief, 6.5% monetary relief
6. **Where They Come From**: Texas (2.58M), Florida (2.55M), California (1.83M), Georgia (1.37M), New York (1.07M); raw counts, not per capita

---
<h2><a class="anchor" id="dashboard"></a>Dashboard</h2>

- Tableau Public dashboard shows:
  - KPIs: total complaints, credit reporting share, timely rate, busiest month
  - Monthly trends for credit reporting and for all other products (with a Hide burst toggle)
  - Credit reporting share by year and complaints by product
  - Top 12 companies with relief and timely rates
  - Resolution outcomes and a state map
- Filters: Year, Product, Company, State, Hide burst
- Caveats: 2011 and 2026 are partial years, the latest month is undercounted, counts are not per capita, and relief rate is not a company quality score

![CFPB Consumer Complaints Dashboard](images/dashboard.png)

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

- Always analyze credit reporting separately from other products
- Investigate the January 2025 burst further; the data does not explain its cause
- Read relief rates with volume and timely response, not as a quality score
- Normalize by population or customer base for fairer state and company comparisons
- Use the issue and sub-issue fields to see what customers actually complain about

---
<h2><a class="anchor" id="author--contact"></a>Author & Contact</h2>

**Sruthi Suresh**  
Data Analyst  
📧 Email: thesruthisuresh@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/your-profile/)  
🔗 [GitHub](https://github.com/Sruthi-M-Suresh)
