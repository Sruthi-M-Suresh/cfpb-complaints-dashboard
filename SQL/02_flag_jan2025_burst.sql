-- 02_flag_jan2025_burst.sql
-- Flags (never deletes) the January 2025 complaint burst in money transfer /
-- checking-savings products so the dashboard can show trends with and without it.
ALTER TABLE complaints_clean ADD COLUMN is_jan2025_event BOOLEAN DEFAULT false;

UPDATE complaints_clean
SET is_jan2025_event = true
WHERE date_received BETWEEN '2025-01-14' AND '2025-01-31'
  AND company IN ('Block, Inc.', 'Early Warning Services, LLC',
                  'NAVY FEDERAL CREDIT UNION',
                  'CAPITAL ONE FINANCIAL CORPORATION')
  AND product_group IN ('Money transfer, virtual currency, or money service',
                        'Checking or savings account');

UPDATE complaints_clean
SET is_jan2025_event = true
WHERE date_received BETWEEN '2025-01-14' AND '2025-01-31'
  AND company = 'JPMORGAN CHASE & CO.'
  AND product_group = 'Money transfer, virtual currency, or money service';
