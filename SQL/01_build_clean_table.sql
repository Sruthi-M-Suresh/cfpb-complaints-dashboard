-- 01_build_clean_table.sql
-- Run inside a file-backed DB:  duckdb complaints.duckdb
-- Input: complaints.csv (full CFPB Consumer Complaint Database download, ~18.6M rows)

CREATE OR REPLACE TABLE complaints_clean AS
SELECT
  "Complaint ID"                          AS complaint_id,
  "Date received"                         AS date_received,
  year("Date received")                   AS yr,
  date_trunc('month', "Date received")    AS month,
  CASE
    WHEN Product ILIKE 'Credit reporting%' THEN 'Credit reporting'
    WHEN Product IN ('Credit card','Credit card or prepaid card') THEN 'Credit card'
    WHEN Product ILIKE 'Payday loan%' THEN 'Payday / personal loan'
    WHEN Product = 'Bank account or service' THEN 'Checking or savings account'
    ELSE Product
  END                                     AS product_group,
  Product                                 AS product_raw,
  "Sub-product"                           AS sub_product,
  Issue                                   AS issue,
  "Sub-issue"                             AS sub_issue,
  trim(Company)                           AS company,
  CASE
    WHEN State IS NULL THEN 'Unknown'
    WHEN State IN ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY') THEN 'State'
    WHEN State = 'DC' THEN 'DC'
    WHEN State IN ('PR','VI','GU','AS','MP','UNITED STATES MINOR OUTLYING ISLANDS') THEN 'Territory'
    WHEN State IN ('FM','PW','MH') THEN 'Freely associated state'
    WHEN State IN ('AA','AE','AP') THEN 'Military'
    ELSE 'Other/Invalid'
  END                                     AS state_type,
  CASE WHEN State = 'UNITED STATES MINOR OUTLYING ISLANDS' THEN 'UM' ELSE State END AS state_code,
  "ZIP code"                              AS zip,
  coalesce(Tags ILIKE '%Servicemember%', false)   AS servicemember,
  coalesce(Tags ILIKE '%Older American%', false)  AS older_american,
  "Submitted via"                         AS submitted_via,
  "Date sent to company"                  AS date_sent,
  date_diff('day', "Date received", "Date sent to company") AS days_to_send,
  "Company response to consumer"          AS response,
  "Company response to consumer" <> 'In progress' AS is_closed,
  "Timely response?"                      AS timely
FROM 'complaints.csv'
WHERE "Complaint ID" IS NOT NULL;
