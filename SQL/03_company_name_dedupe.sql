-- 03_company_name_dedupe.sql
-- Merge spelling variants of the same company (case, punctuation, spacing)
-- into the most frequent spelling.
-- NOTE: the normalisation rule below is the documented approach; re-run the
-- check at the bottom on your own database and confirm it returns 0 rows.

CREATE OR REPLACE TEMP TABLE company_map AS
WITH counts AS (
  SELECT
    company,
    trim(regexp_replace(regexp_replace(upper(company), '[^A-Z0-9 ]', '', 'g'), '\s+', ' ', 'g')) AS norm,
    count(*) AS n
  FROM complaints_clean
  GROUP BY company
)
SELECT
  company AS company_raw,
  first_value(company) OVER (PARTITION BY norm ORDER BY n DESC, company) AS company_clean
FROM counts;

UPDATE complaints_clean AS c
SET company = m.company_clean
FROM company_map AS m
WHERE c.company = m.company_raw
  AND c.company <> m.company_clean;

-- Check: any normalised name still mapped to more than one spelling? (expect 0 rows)
SELECT norm, count(DISTINCT company) AS spellings
FROM (
  SELECT company,
         trim(regexp_replace(regexp_replace(upper(company), '[^A-Z0-9 ]', '', 'g'), '\s+', ' ', 'g')) AS norm
  FROM complaints_clean
  GROUP BY company
)
GROUP BY norm
HAVING count(DISTINCT company) > 1;
