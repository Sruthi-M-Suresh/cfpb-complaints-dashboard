-- 04_export_dashboard_cube.sql
-- One aggregated table (~796K rows, 18,590,360 complaints) so that every Tableau
-- sheet shares one data source and the dashboard filters apply everywhere.
COPY (
  WITH top_co AS (
    SELECT company FROM complaints_clean GROUP BY company ORDER BY count(*) DESC LIMIT 40
  )
  SELECT
    CAST(month AS DATE) AS month,
    yr,
    CASE
      WHEN product_group = 'Checking or savings account' THEN 'Checking or savings'
      WHEN product_group ILIKE 'Money transfer%' OR product_group = 'Virtual currency' THEN 'Money transfer'
      WHEN product_group IN ('Credit reporting','Debt collection','Credit card','Mortgage','Student loan','Vehicle loan or lease') THEN product_group
      ELSE 'Everything else'
    END AS product_display,
    CASE WHEN product_group = 'Credit reporting' THEN 'Credit reporting' ELSE 'Other products' END AS segment,
    CASE WHEN company IN (SELECT company FROM top_co) THEN company ELSE 'All other companies' END AS company,
    CASE WHEN state_type IN ('State','DC') THEN state_code ELSE 'Other' END AS state_code,
    CASE WHEN response IN ('Closed with explanation','Closed with non-monetary relief','Closed with monetary relief','Untimely response','In progress')
         THEN response ELSE 'Other closed outcomes' END AS outcome,
    is_jan2025_event AS jan2025_event,
    count(*) AS complaints,
    count(*) FILTER (WHERE timely) AS timely_complaints
  FROM complaints_clean
  GROUP BY ALL
) TO 'dash_cube.csv' (HEADER, DELIMITER ',');

-- Check: expect total_complaints = 18590360
SELECT count(*) AS rows, sum(complaints) AS total_complaints FROM 'dash_cube.csv';
